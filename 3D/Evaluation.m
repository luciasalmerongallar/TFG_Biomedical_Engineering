%% EVALUACION DE RESULTADOS

filename = 'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus_modified.xlsx';
T = readtable(filename); 

%% GRAFICO PARA TODAS LAS VARIABLES

C=T{1:height(T),2:4};
% C(C == 0) = NaN;

figure
boxplot(C,'Labels',{'Basal','Week', 'Months'},'Whisker',1,'Notch','on');
title('Specific Evalution');
ylabel('Lung volume');
xlabel('Days since treatment');


for i=1:height(IPA.HistoriaClinica)
    num2str(IPA.HistoriaClinica(i)) = {strrep(char(num2str(IPA.HistoriaClinica(i))),' ','')};

end

PEPE=table2array(IPA);

P = find(IPA.HistoriaClinica==A.Name{(8)});