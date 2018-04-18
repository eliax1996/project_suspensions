clear all, close all, pack;


% dichiarazione dei parametri

massimo_carico = 350.0;

peso_minimo_automobile = 740.0/4.0;
peso_massimo_automobile = (740.0+massimo_carico)/4.0;

costante_molla = 20000.0; % newton / metro
costante_smorzamento = 500.0; % newton secondo / metro

peso = peso_minimo_automobile;
percentuale_peso_superiore = 93.0;

m1 = (peso/100)*percentuale_peso_superiore
m2 = (peso/100)*(100-percentuale_peso_superiore)

b1 = costante_smorzamento;
k1 = costante_molla;
b2 = b1/12;
k2 = k1/18;


% definizione matrici A B C D

A=[ 0 0 1 0 ; 0 0 0 1 ; -(k1+k2)/m1 k2/m1 -(b1+b2)/m1 b2/m1 ; k2/m2 -k2/m2 b2/m2 -b2/m2 ];
B=[ 0 ; 0 ; k1/m1 ; 0 ];
C=[ 1 1 1 1 ];
D=0;

sistema=ss(A,B,C,D);


%--------------analisi nel dominio della frequenza-------------------------

funzione_trasferimento=tf(sistema);

% inserisco ingresso definito come funzione di trasferimento
num = [ 1 ];
den = [ 1 0 ];
funzione = tf(num,den);

funzione_risultante = funzione_trasferimento*funzione;

% avvio la simulazione della funzione facendo l'uscita
[y,tsim,x]=lsim(funzione_risultante,u,t,x0);


%hold on
%plot(tsim,y(:,1));
%plot(tsim,x(:,2));
%plot(tsim,x(:,3));
%plot(tsim,x(:,4));
%legend('x','y','z','k');
%hold off

% i dati avendo tipologie diverse (in R oppure in C)
% occupano spazio diverso e quindi vengono messi in strutture
% dati chiamate Cell che sono array di dimensione variabile
[num,den] = tfdata(funzione_risultante,'v');
[residui,poli,resto] = residue(num,den)
% ecco come mostrare i dati di una cella
%celldisp(num) come mostrare una cella
%celldisp(den)

% se non si specifica output 'v' cioè vettore
% essendo siso prendendo un solo numeratore e un solo denominatore
% ho tutta l'informazione della risposta del sistema
% num = num{1}
% den = den{1}

% dati caratterizzanti del sistema
zeri = roots(num)
% poli = roots(den) secondo metodo per calcolare gli zeri

