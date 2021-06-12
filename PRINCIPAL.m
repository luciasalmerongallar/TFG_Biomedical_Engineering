function dates = PRINCIPAL(num_dir)

    %% Function to process the three CT scans of all patients

    %Create the datos table
    dates = table('Size',[(length(num_dir)-2) 4], 'VariableTypes',{'string','double','double','double'},'VariableNames',{'Name' 'Basal' 'Week' 'Month'});

    %Loop for data processing
    for k = 3:length(num_dir)

        dates.Name(k-2) = convertCharsToStrings(num_dir(k).name);

        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/BASAL.dcm');
        dates.Basal(k-2) = LUNG(path_in)

        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/SEMANA.dcm');
        dates.Week(k-2) = LUNG(path_in)

        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/MES.dcm');
        if exist(path_in) ~= 0
            dates.Month(k-2) = LUNG(path_in)
        else
            dates.Month(k-2) = NaN
        end

    end
end



