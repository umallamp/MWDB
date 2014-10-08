function [ fileRecords ] = generateEpidemicWordFile( datasetDir, w, h, r )

mue = 0;
sigma = 0.25;
delimiterIn = ',';
headerlinesIn = 1;
tolerance = 0.000000001;
levels = zeros( r + 1, 1 );
levelRepresentatives = zeros( r, 1 );
fun = @(x) exp(-((x - mue).^2)/( 2 * (sigma.^2)));
directoryFiles = dir(strcat(datasetDir,'/*.csv'));

% create output folder if it does not exists in the current path
if(~isequal(exist(strcat(datasetDir,'/output'), 'dir'),7))
    mkdir(strcat(datasetDir,'/output'));
end

% find gaussian levels and level representatives
for index = 1 : r
    num = integral(fun, (index - 1) / r, index / r);
    den = integral(fun, 0, 1);
    currentLength = num / den;
    levels(index + 1) = levels(index) + currentLength;
    levelRepresentatives(index) = levels(index) + (currentLength / 2);
end

for fileId = 1 : length(directoryFiles)
    
    % obtain required fileds from data file
    [~, fname, ext] = fileparts(directoryFiles(fileId, 1).name);
    filename = strcat(datasetDir, '/', fname, ext);
    
    % normalize and quantize the data file
    dataset = importdata(filename, delimiterIn, headerlinesIn);
    minValue = min(dataset.data(:));
    maxValue = max(dataset.data(:));
    [rowSize, colSize] = size(dataset.data);
    quantizedDataset = zeros(rowSize, colSize);
    for row = 1 : rowSize
        for col = 1 : colSize
            for index = 1 : length(levels) - 1
                normalizedValue = (dataset.data(row,col) - minValue)/(maxValue - minValue);
                if((levels(index + 1) + tolerance) >= normalizedValue )
                    quantizedDataset(row,col) = levelRepresentatives(index);
                    break;
                end
            end
        end
    end
    
    % get epidemic words from quantized data file
    fileRecords = [];
    [rowSize, colSize] = size(quantizedDataset);
    for col = 1 : colSize
        row = 1;
        while(((row + w)-1) <= rowSize)
            fileRecord = [str2double(fname), col, row];
            for index = 1 : w
                fileRecord(index + 3) = quantizedDataset(row + (index - 1), col);
            end
            fileRecords = [fileRecords; fileRecord];
            row = row + h;
        end
    end
    
    % write the output to csv file
    filename = strcat(datasetDir, '/output/', fname, '_epidemic_word_file', ext);
    csvwrite(filename, fileRecords);
end
end
