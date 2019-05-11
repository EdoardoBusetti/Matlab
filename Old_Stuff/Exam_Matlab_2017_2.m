clc
clear all
close all


tic


%Capitale
Q = 500000;

%Scadenza
T = 30;

%Numero di periodi totale
N = T*12;

%Tasso di interesse annuo (NOMINALE)
i = 0.08;

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
%4) Creare vettore debito residuo, contenente il debito residuo per ogni
%mese
n = (1:360);
r = (1:360);
D = (1:360);
for k = 1:360;
    r(k)=R;
    n(k)=k;
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
Piano_Ammortamento=[Indici;num2cell(A)]

% 8) Grafico


Sum = (1:360);
Sum(1)= I(1);
for q = 2:360;
    Sum(q) = Sum(q-1) + I(q);

end

for q = 1:360;
    plot(q,Sum(q),'--.r')
    plot(q,D(q),'--.b')
    hold on
    ylabel('In Rosso somma cumulata interessi, in Blu Debito residuo')
    xlabel('Periodo')
end

tocs



