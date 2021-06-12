function datos = funcion_principal(num_dir)

    %% Function to process the three CT scans of all patients
    
    %Create the datos table
    datos = table('Size',[(length(num_dir)-2) 4], 'VariableTypes',{'string','double','double','double'},'VariableNames',{'Name' 'Basal' 'Semana' 'Mes'});

    %Loop for data processing
    for k = 3:length(num_dir)
    
        datos.Name(k-2) = convertCharsToStrings(num_dir(k).name);
    
        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/BASAL.dcm');
        datos.Basal(k-2) = lung_funcion(path_in)

        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/SEMANA.dcm');
        datos.Semana(k-2) = lung_funcion(path_in)

        path_in=strcat('C:/Users/lucia/Desktop/TFG/datos_todos/', num_dir(k).name,'/MES.dcm');
        if exist(path_in) ~= 0
            datos.Mes(k-2) = lung_funcion(path_in)
        else
            datos.Mes(k-2) = NaN
        end

    end
end



