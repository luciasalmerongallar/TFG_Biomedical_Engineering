%% EVALUATION

filename = 'C:/Users/lucia/Desktop/TFG/Prueba/IPACOVID_Reus_modified_2D.xlsx';
T = readtable(filename); 

%% 

C=T{1:height(T),2:4};
figure('Color','white');
boxplot(C,'Labels',{'Basal','Week', 'Months'},'Whisker',1,'Notch','on');
title('Specific Evolution');
ylabel('Lung volume');
xlabel('Days since treatment');





%% Scatter plot PAFI / Volumen - SAFI / Volumen
clear g
dates = {};
for i = 1:30
    dates(i) = {'Basal'};
end
for i = 31:60
    dates(i) = {'Week'};
end
for i = 61:90
    dates(i) = {'Month'};
end
dates = transpose(dates);
NEW_T = table('Size',[(height(T)*3) 5], 'VariableTypes',{'double','double', 'double','string', 'string'},'VariableNames',{'Volume' 'PAFI' 'SAFI' 'Sex' 'Time'});

NEW_T.Volume = [T.Basal; T.Week; T.Month];
NEW_T.PAFI = [T.PAFI_Basal; T.PAFI_Week; T.PAFI_Month];
NEW_T.Sex = [T.Sexo; T.Sexo; T.Sexo];
NEW_T.SAFI = [T.SAFI_Basal; T.SAFI_Week; T.SAFI_Month];
NEW_T.Time = dates;

g=gramm('x',NEW_T.Volume,'y',NEW_T.PAFI, 'color', NEW_T.Time);

%Raw data as scatter plot
g.geom_point();
%Create point cloud with two categories
N=100;
x=randn(1,N);
y=x+randn(1,N);
test=repmat([0 1 0 0],1,N/4);
y(test==0)=y(test==0)+3;

g.set_point_options('base_size',4);
g.stat_ellipse('type','95percentile','geom','area','patch_opts',{'FaceAlpha',0.1,'LineWidth',2});
g.set_title('PAFi / Volumen');
g.set_names('x','Volumen','y','PAFi','color','Day');

figure('Position',[100 100 800 550]);
g.draw();



clear g;
g=gramm('x',NEW_T.Volume,'y',NEW_T.SAFI, 'color', NEW_T.Time);

%Raw data as scatter plot
g.geom_point();
g.set_point_options('base_size',4);
g.stat_ellipse('type','95percentile','geom','area','patch_opts',{'FaceAlpha',0.1,'LineWidth',2});
g.set_title('SAFi / Volumen');
%These functions can be called on arrays of gramm objects
g.set_names('x','Volumen','y','SAFi','color','Day');

figure('Position',[100 100 800 550]);
g.draw();




%% MEAN PERCENTAGES
for i = 1:height(T)
    T.porcentaje_basal(i) = 100;
    T.porcentaje_week(i) = (T.Week(i)*100)/T.Basal(i);
    T.porcentaje_month(i) = (T.Month(i)*100)/T.Basal(i);
end

days = [1 7 30];
figure('Color','white');

plot(days, [T.porcentaje_basal(1) T.porcentaje_week(1) T.porcentaje_month(1)]);
title('Mean Evolution');
ylabel('Lung volume %');
xlabel('Days since treatment');
hold on
for i = 2:height(T)
     plot(days, [T.porcentaje_basal(i) T.porcentaje_week(i) T.porcentaje_month(i)]);
end

%% MEAN LINEAR WITH DESVIATION STANDAR

clear g
g=gramm('x', dates,'y', [T.porcentaje_basal; T.porcentaje_week; T.porcentaje_month]);
% Plot linear fits of the data with associated confidence intervals
g.stat_glm();
%g.geom_point();


g.set_names('x','Days','y','Volume (%)','color','Sex');
g.set_title('Mean Percentage');

figure('Position',[100 100 800 550]);
g.draw();

%% MEAN LINEAR WITH DESVIATION STANDAR BY SEX 
clear g
g=gramm('x', dates,'y', [T.porcentaje_basal; T.porcentaje_week; T.porcentaje_month], 'color', [T.Sexo T.Sexo T.Sexo]);
% Plot linear fits of the data with associated confidence intervals
%g.geom_point();

g.stat_glm();

g.set_names('x','Days','y','Volume (%)','color','Sex');
g.set_title('Mean Percentage');

figure('Position',[100 100 800 550]);
g.draw();

