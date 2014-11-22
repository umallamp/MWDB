prompt = 'Input the folder for input data files: ';
directory = input(prompt,'s');

% Reading file numbers from user
prompt = 'Please enter a epidemic simulation file number:';
f1 = input(prompt,'s');
prompt = 'Please enter a epidemic simulation file number:';
f2 = input(prompt,'s');
fileName1 = strcat(directory,'\',f1,'.csv');
fileName2 = strcat(directory,'\',f2,'.csv');

% Calling a function to compute the similarity between the two files 
similarityVal = getDTWSimilarity(fileName1,fileName2);
str = strcat('The similarity between epidemic simulation files',' ',f1,' and',' ',f2,' -->',' ',num2str(similarityVal));
disp(str);