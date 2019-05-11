function [] = BS_plot(S,K,r,sigma,tau,prezzo_iniziale_S,Prezzo_finale_S)
for S = prezzo_iniziale_S:Prezzo_finale_S
    if  tau > 0
    d1=(log(S/K) + (r+0.5*sigma^2)*(tau))/(sigma*sqrt(tau));
    d2=d1-sigma*sqrt(tau);
    N1=normcdf(d1);
    N2=normcdf(d2);
    C =S*N1-K*exp(-r*(tau))*N2;
    P =C + K*exp(-r*tau) - S;
    plot(S,P,'--.r')
    plot(S,C,'--.b')
    hold on;
    title('Grafico Variazione prezzo Call e Put a Variare del prezzo del sottostante')
    xlabel('Prezzo del sottostante')
    ylabel('Prezzo Call in Blu       Prezzo Put in Rosso')
else
    C=max(S-k,0);
    P=max(K-S,0);
    plot(S,P,'--.r')
    plot(S,C,'--.b')
    hold on;
    title('Grafico Variazione prezzo Call e Put a Variare del prezzo del sottostante')
    xlabel('Prezzo del sottostante')
    ylabel('Prezzo Call in Blu       Prezzo Put in Rosso')
    end
    end
    
