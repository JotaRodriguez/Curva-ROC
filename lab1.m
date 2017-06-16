%clear


% load 'scoresB_clientes';
% s_ac = sort(scoresB_clientes,'descend');
% load 'scoresB_impostores';
% s_ai = sort(scoresB_impostores,'descend');

s_ac=s_ac(:,2);
s_ai=s_ai(:,2);
auc = 0.0;

%union de los scores
thrs = vertcat(s_ac, s_ai);

%ordeno de forma descendente y elimino los valores repetidos
thrs = sort(thrs,'descend');
thrs = unique(thrs,'rows');

%variaza y media de los clientes
media_C = mean(s_ac);
varianza_C = var(s_ac);

tm_thr = size(thrs); %tamaño del vector de umbrales
tm_cli = size(s_ac); %tamaño scores clientes
tm_imp = size(s_ai); %tamaño scores impostores

distFNtoFP = 100000;

%para saber la cantidad de error  y porcentaje 
arriesgo  = 30;
valorMin = 0;
valorMin2 = 0;
tt = size(s_ac(1,1));
for i=1:tm_thr
    
    tempFN = 0;
    tempFP = 0;
    
    %busco en los clientes temporalmente cuantos FN son menor en el umbral
    for j=1:tm_cli
        if s_ac(j,1) <= thrs(i,1)
          tempFN = tempFN +1;  
        end
    end
    
    %busco en los clientes temporalmente cuantos FP son menor en el umbral
    for j=1:tm_imp
        if s_ai(j,1) >= thrs(i,1)
          tempFP = tempFP +1;  
        end
    end
    
    FN = (tempFN/tm_cli(1,1));
    FP = (tempFP/tm_imp(1,1));
  
    %calculo la cantidad de error para  FN y  FP

    FNn = (10/tm_cli(1,1));
%     FPn = ((arriesgo/100) * tm_imp);

    if valorMin == 0 
        tm = (FNn/tm_cli(1,1));
        
        if (tm(1,1) < FNn)
            th_cl = thrs(i,1);
            valorMin = valorMin + 1;
        end
    end
    
   
    tempDist = (FN-FP) * (FN-FP); 
    if tempDist < distFNtoFP
        distFNtoFP = tempDist;
        FNequalFP(i, 1) = i;
        FNequalFP(i, 2) = i;
    end
    
    VPR(i,1) = 1-FN;
    FPR(i,1) = FP;
     
end

%calculo el area bajo la curva
for i=1:tm_cli
    for j=1:tm_imp
        if s_ac(i,1) > s_ai(j,1)
            auc = auc +1;
        end
        
    end
end

fac = (tm_cli(1,1)) * (tm_imp(1,1));
auc = mrdivide(auc,fac);
%Fin calculo area bajo la curva



%calcular DPRIME
%media y varianza para clientes e impostores
meanCli = mean(s_ac);
varianCli = var(s_ac);

meanImp = mean(s_ai);
varianImp = var(s_ai);

Dprime = (meanCli - meanImp) / sqrt(varianCli + varianImp );


clc;
X = sprintf('AUC: %d - Dprime: %d',auc, Dprime);
disp(X)


hold on; 

xlabel('FP (1-Especificidad)');
ylabel('1-FN Sensibilidad');

title('Curva Roc');

%legen(FN, FP,Dprime); 


plot(FPR, VPR);



















