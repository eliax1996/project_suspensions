clear all, close all, pack

% prova di trovare i residui di una funzione
% che è il prodotto di due funzioni
prodotto = conv([1 2],[1 3])
residue([1 4],prodotto)


% prova di simulazione di un sistema, i dati inseriti sono casuali


% imposto condizioni iniziali e matrici di trasferimento
% occhio che devono essere matrici quadrate (VEDI A)
A = [ 0 , 0.1 ; 1.4 , 0.5 ]
B = [ 1.13 ; 0 ]
C = [ 1 , 0 ]
D = [ 0 ]

x0 = [ 0 ; 0 ]

% creo l'oggetto sistema
sistema=ss(A,B,C,D);

% imposto la funzione di trasferimento sin(5t) e gli istanti temporali di
% calcolo della funzione di trasferimento tra 0 e 10 sec
t=0:0.001:10;
u=sin(5*t);

% avvio simulazione del sistema con: sistema, ingressi, vettore tempo, stato iniziale
[y,tsim,x]=lsim(sistema,u,t,x0);

% ottengo la funzione di trasferimento del sistema complessivo
G=tf(sistema)

% la trasformo in numeratore e denominatore
[numG,denG]=ss2tf(A,B,C,D);

% calcolo gli zeri
damp(numG)
damp(denG)

% imposto un ingresso che voglio
U=tf(1,[1,0])

% ne studio l'andamento facendo il prodotto nella frequenza
Y=G*U

% calcolo la funzione di trasferimento in uscita e calcolo:
% prima numeratore e denominatore e poi poli, residui e resto
[numY,denY]=tfdata(Y,'v');
[residui,poli,resto]=residue(numY,denY)








