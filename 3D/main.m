
%% MAIN 

clc;
close all;
clear all;

%Read the files
num_dir = dir('C:/Users/lucia/Desktop/TFG/datos_todos');

%Processing
data = funcion_principal(num_dir);

%Read IPACOVID data
filename = 'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus.xlsx';
IPA = readtable(filename); 

%We put both tables together and save
T = join(data,IPA);

writetable(T,'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus_modified_3D.xlsx','Sheet',1);


