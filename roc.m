function [ FP, FN, thrs, VPR, FPR ] = roc( sample )
%ROC Summary of this function goes here
%   Detailed explanation goes here

if sample == 'A'
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






s_ac=s_ac(:,2);
s_ai=s_ai(:,2);

thrs = vertcat(s_ac, s_ai);

thrs = sort(thrs,'descend');

thrs = unique(thrs,'rows');

media_C = mean(s_ac);
varianza_C = var(s_ac);

tm_thr = size(thrs);
tm_cli = size(s_ac);
tm_imp = size(s_ai);

distFNtoFP = 99999999999;

for i=1:tm_thr
    
    tempFN = 0;
    tempFP = 0;
    
    for j=1:tm_cli
        if s_ac(j,1) <= thrs(i,1)
          tempFN = tempFN +1;  
        end
    end
    
    for j=1:tm_imp
        if s_ai(j,1) >= thrs(i,1)
          tempFP = tempFP +1;  
        end
    end
    
    FN = mrdivide(tempFN,tm_cli(1,1));
    FP = mrdivide(tempFP,tm_imp(1,1));
    
    tempDist = (FN-FP) * (FN-FP); 
    if tempDist < distFNtoFP
        distFNtoFP = tempDist;
        FNequalFP(i, 1) = i;
        FNequalFP(i, 2) = i;
    end
    
    VPR(i,1) = 1-FN;
    FPR(i,1) = FP;
    
    
end
    hold on; 
    plot(FPR, VPR);
    xlabel('FPR')
    ylabel('1 - FN')
    title('Cuve de  ROC')
    legend('Datos Grupo A','Datos Grupo B')
end

