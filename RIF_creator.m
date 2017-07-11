
function [ RIF ] = RIF_creator( module_filtre, nmb_division )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
mod = module_filtre';
N = length(mod);
RIF = zeros(1,N*2);
div = (N/nmb_division);

for i = 1: nmb_division
    
    if(i == 1)
        debut = 1;
        fin = debut+div+1;
        
    elseif(i == nmb_division)
           fin = length(RIF)/2;
           debut = fin - div -1;
               
    else
        debut = fin+1;
        fin = debut+div;
    end
    
    moy =  mean(module_filtre(debut:fin))
    RIF(debut:fin) =moy;
    
end

% partie mioroir de section similaire

for i = 1: nmb_division
    
    debut = N - div*i+1;
    fin = debut + div-1;
    
    allo =module_filtre(debut:fin);
    moy =  mean(allo);
    
    debut_array = N*2 - div*(nmb_division-i+1) +1;
    RIF(debut_array:debut_array + div) =moy;    
    

end

  
    

    
end