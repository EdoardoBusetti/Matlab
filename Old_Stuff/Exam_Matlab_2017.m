function [Tabella] = Fn_Tabella_Ammort_Fr(Q,T,i)
%Numero di periodi totale
N = T*12;


%Tasso periodale
j =  i/12;

%Periodo attuale
n = 0;

%Rata
R = Q*(j/(1-1/((1+j)^N)));

%Debito residuo
%D(n)=(R/j)*(1-1/(1+j)^(N-n))


%2) Vettore con scandenza mensili delle date (1x360)
%3) Vettore pagamenti con rate per ogni mese (1x360)
%4) Creare vettore contenente il debito residuo per ogni mese

n = NaN(1,360);
r = (1:360);
D = (1:360);

for k = 1:360;
    n(k)=k;
    r(k)=R;
    D(k) = (R/j)*(1-1/(1+j)^(N-k));


end






% 5) Creare un vettore interessi, dato dagli interessi per ogni
% mese(calcolati sul capitale residuo) N.B. Alla prima scadenza gli
% interessi sono sul capitale inziale
I = (1:360);
I(1) = Q*j;
for x = 2:360;
    I(x) = D(x-1)*(j);
end

% 6) Creare un vettore quota capitale pagata ogni mese(rata - interessi)
C = (1:360);
for x = 1:360;
    C(x) = R - I(x);
end


%Traslo i vettori e li rendo vettori colonna
n = n';
r = r';
D = D';
I = I';
C = C';


% 7) Concatenare i vettori
% A = matrice piano ammortamento

A = [n,r,D,I,C];

%Agiiungo etichette a ciascuna colonna
Indici = {'periodo' 'rata' 'debito residuo' 'Interessi' 'Quota capitale'};
Tabella=[Indici;num2cell(A)]

end