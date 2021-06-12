
%% MAIN 

clc;
close all;
clear all;

%Read the files
num_dir = dir('C:/Users/lucia/Desktop/TFG/datos_todos');

%Processing
data = PRINCIPAL(num_dir);

%Read IPACOVID data
filename = 'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus_New.xlsx';
IPA = readtable(filename); 

%We put both tables together and save
T = join(data,IPA);

writetable(T,'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus_modified_2D.xlsx','Sheet',1);


