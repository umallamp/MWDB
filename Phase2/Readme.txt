Step 1: Place the sample simulation files,epidemic word files, epidemic word difference files, epidemic word average files and location matrix for testing in the folder.
Step 2: Foolow the sample input input for each task executions as mentioned below

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Task 1a
>> Proj2_1a
Input the folder for input data files: C:\Users\sgaripal\Documents\MATLAB\Input
Please enter a epidemic simulation file number:1
Please enter a epidemic simulation file number:2
The similarity between epidemic simulation files1 and2 -->1.9432e-05

Task 1b
>> Proj2_1b
Input the folder for input data files: C:\Users\sgaripal\Documents\MATLAB\Input
Please enter a epidemic simulation file number:1
Please enter a epidemic simulation file number:2
Elapsed time is 5.636364 seconds.
The similarity between epidemic simulation files1 and2 -->2.2472e-09

Task 1c
>> Proj2_1c
Input the folder for input data files: C:\Users\sgaripal\Documents\MATLAB\Input
Please enter a epidemic word file number:1
Please enter a epidemic word file number:2
The similarity between epidemic word files1 and2 -->11

Task 1d
>> Proj2_1d
Input the folder for input data files: C:\Users\sgaripal\Documents\MATLAB\Input
Please enter a average file number:1
Please enter a average file number:2
The similarity between epidemic average files1 and2 -->5

Task 1e
>> Proj2_1e
Input the folder for input data files: C:\Users\sgaripal\Documents\MATLAB\Input
Please enter a difference file number:1
Please enter a difference file number:2
The similarity between epidemic difference files1 and2 -->5

Task 1f
>> Proj2_1f
Input the folder for input data files: C:\Users\pdadi\Downloads\SampleData_P2\SampleData_P2\Set_of_Simulation_Files\word
Enter the input for File - 1 15.csv
Enter the input for File - 2 11.csv
Enter the connectivity Graph location C:\Users\pdadi\Downloads\sampledata_P1_F14\sampledata_P1_F14\Graphs\LocationMatrix.xlsx
The final similarity is 297.581493

Task 1g
>> Proj2_1f
Input the folder for input data files: C:\Users\pdadi\Downloads\SampleData_P2\SampleData_P2\Set_of_Simulation_Files\average
Enter the input for File - 1 18.csv
Enter the input for File - 2 19.csv
Enter the connectivity Graph location C:\Users\pdadi\Downloads\sampledata_P1_F14\sampledata_P1_F14\Graphs\LocationMatrix.xlsx
The final similarity is 22551.61811
	
Task 1h
>> Proj2_1f
Input the folder for input data files: C:\Users\pdadi\Downloads\SampleData_P2\SampleData_P2\Set_of_Simulation_Files\difference
Enter the input for File - 1 4.csv
Enter the input for File - 2 4.csv
Enter the connectivity Graph location C:\Users\pdadi\Downloads\sampledata_P1_F14\sampledata_P1_F14\Graphs\LocationMatrix.xlsx
The final similarity is 7981.763769

**************************************************************************************************************************

Task 2

>> Proj2_2
Please enter a query file path:C:\Users\pdadi\Desktop\TestExecution\Query_Simulation_File\query.csv
Please enter a root directory path: C:\Users\pdadi\Desktop\TestExecution\Input
Please enter the number of similar files: 3
Select the similarity measure
Enter a - Euclidean Distance
Enter b - Dynamic Time Warping Distance
Enter c - Word File Similarity without A Function
Enter d - Average File Similarity without A Function
Enter e - Difference File Similarity without A Function
Enter f - Word File Similarity with A Function
Enter g - Average File Similarity with A Function
Enter h - Difference File Similarity with A Function
Enter the choice of your similarity : a
4.31336005283700e-05    18
4.30620579459438e-05    16
4.30484819228808e-05    19


**************************************************************************************************************************

Task 3a
 >> Proj2_3a
Please enter a directory: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word
Please enter the value of r:4

Task 3b
             >> Task3B
Input the folder for input data files: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word
Input the value for r: 4
Importing word document counts from: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word/input.txt
Running LDA Gibbs Sampler Version 1.0
Arguments:
        	Number of words  	W = 37
        	Number of docs   	D = 20
        	Number of topics 	T = 4
        	Number of iterations N = 500
        	Hyperparameter   ALPHA = 12.5000
        	Hyperparameter	BETA = 5.4054
        	Seed number        	= 3
        	Number of tokens   	= 42840
Determining random order update sequence
        	Iteration 0 of 500
        	Iteration 10 of 500
        	……..        	 
        	Iteration 490 of 500

Task 3c           
 >> Proj2_3c
Please enter the directory for epidemic simulation files:C:\Users\pdadi\Desktop\TestExecution\Input
Please enter a value for number of latent semantics (r) :4
Select the similarity measure
Enter a - Ecludean Distance
Enter b - Dynamic Time Wrapping Distance
Enter c - Word File Similarity without A Function
Enter d - Average File Similarity without A Function
Enter e - Difference File Similarity without A Function
Enter f - Word File Similarity with A Function
Enter g - Average File Similarity with A Function
Enter h - Difference File Similarity with A Function
Enter the choice of your similarity : e

Task 3d            
 >> Proj2_3d
Please enter a directory: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word
Please enter the value of r:4
Please enter a directory for query file: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Query_Simulation_File\word
Please enter the value of k(number of nearest neighbors):3

Task 3e
>> Proj2_3e
Input the folder for input data files: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word
Input the value for r: 4
Please enter a directory for query file: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Query_Simulation_File\word
Please enter the value of k(number of nearest neighbors):3

C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Query_Simulation_File\word\*.csv
C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Query_Simulation_File\word\query-word.csv
query-word.csv
Importing word document counts from: C:\Users\sgaripal\Downloads\SampleData_P2_Sampath\Set_of_Simulation_Files\word/input1.txt
Running LDA Gibbs Sampler Version 1.0
Arguments:
	Number of words      W = 51
	Number of docs       D = 21
	Number of topics     T = 4
	Number of iterations N = 500
	Hyperparameter   ALPHA = 12.5000
	Hyperparameter    BETA = 3.9216
	Seed number            = 3
	Number of tokens       = 44982
Internal Memory Allocation
	w,d,z,order indices combined = 719712 bytes
	wp (full) matrix = 816 bytes
	dp (full) matrix = 336 bytes
Starting Random initialization
Determining random order update sequence
	Iteration 0 of 500
	...
	Iteration 490 of 500

Task 3f
> > Proj2_3f
Please enter the directory for epidemic simulation files:C:\Users\pdadi\Desktop\TestExecution\Input
Please enter a value for number of latent semantics (r) :4
Please enter a directory for query file: C:\Users\pdadi\Desktop\TestExecution\Query_Simulation_File
Please enter the value of k(number of nearest neighbors):2
Select the similarity measure
Enter a - Ecludean Distance
Enter b - Dynamic Time Wrapping Distance
Enter c - Word File Similarity without A Function
Enter d - Average File Similarity without A Function
Enter e - Difference File Similarity without A Function
Enter f - Word File Similarity with A Function
Enter g - Average File Similarity with A Function
Enter h - Difference File Similarity with A Function
Enter the choice of your similarity : a


**************************************************************************************************************************

Task 4a

Enter the directory of datasets : C:\Users\pdadi\Desktop\TestExecution\Input\word
Select the similarity measure
Enter a - Ecludean Distance
Enter b - Dynamic Time Wrapping Distance
Enter c - Word File Similarity without A Function
Enter d - Average File Similarity without A Function
Enter e - Difference File Similarity without A Function
Enter f - Word File Similarity with A Function
Enter g - Average File Similarity with A Function
Enter h - Difference File Similarity with A Function
Enter the choice of your similarity : c
Enter the number of dimensions to reduce : 5

Mapping Error is :88.3847

Task 4b

Enter the path of query file : C:\Users\pdadi\Desktop\TestExecution\Query_Simulation_File\word\query-word.csv
Enter the number of dimensions to reduce : 5
Enter the number of similar files required : 3
2.2361e-06->11.csv
2.2361e-06->12.csv
2.2361e-06->13.csv
