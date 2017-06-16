function [s_ac, s_ai] = cargarDatos(grupo)

if grupo == 'A'
     load 'scoresA_clientes';
    s_ac = sort(scoresA_clientes,'descend');
    load 'scoresA_impostores';
    s_ai = sort(scoresA_impostores,'descend');
else
    load 'scoresB_clientes';
    s_ac = sort(scoresB_clientes,'descend');
    load 'scoresB_impostores';
    s_ai = sort(scoresB_impostores,'descend');
end

clear scoresA_clientes;
clear scoresA_impostores;
clear scoresB_clientes;
clear scoresB_impostores;

end

