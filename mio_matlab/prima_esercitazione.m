clear all, close all, pack

% stampo a schermo le varie possibilità
es=menu('Simulazione della risposta del sistema elettrico',...
        'caso 1.a: R=10,  L=0.5,  x0=[0;0],   i(t)=1;',...
        'caso 1.b: R=100, L=0.5,  x0=[0;0],   i(t)=1;',...
        'caso 1.c: R=0.1, L=0.05, x0=[0;0],   i(t)=1;',...
        'caso 1.d: R=10,  L=0.5,  x0=[0;0.2], i(t)=1;',...
        'caso 2.a: R=10,  L=0.5,  x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.b: R=100, L=0.5,  x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.c: R=0.1, L=0.05, x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.d: R=10,  L=0.5,  x0=[0;0.2], i(t)=cos(4t)');
    
% in base al valore di es da 1 a n dove n sono i bottoni
% decido che valori assegnare alla resistenza, all'induttanza agli ingressi
% al tempo massimo e a w0
switch es,
case 1, R=10;  L=0.5;  x0=[0;0];   w0=0; tmax=20;
case 2, R=100; L=0.5;  x0=[0;0];   w0=0; tmax=200;
case 3, R=0.1; L=0.05; x0=[0;0];   w0=0; tmax=10;
case 4, R=10;  L=0.5;  x0=[0;0.2]; w0=0; tmax=20;
case 5, R=10;  L=0.5;  x0=[0;0];   w0=4; tmax=10;
case 6, R=100; L=0.5;  x0=[0;0];   w0=4; tmax=10;
case 7, R=0.1; L=0.05; x0=[0;0];   w0=4; tmax=10;
case 8, R=10;  L=0.5;  x0=[0;0.2]; w0=4; tmax=10;
end


% imposto i parametri uguali per tutte le simulazioni
% matrice A,B,C,D
C=0.2; i0=1;
A=[0, -1/C; 1/L, -R/L];
B=[1/C; 0];
C=[1, 0];
D=0;


% avvio la simulazione del sistema State Space -- spazio degli stati
% e creo un oggetto rappresentante il sistema a partire
% dalle 4 matrici che riassumono il sistema
sistema=ss(A,B,C,D);


% Simulazione della risposta y(t) del sistema dinamico
% settaggio dei tempi e dell'ingresso
t=0:0.001:tmax;
u=i0*cos(w0*t);

% lsim simulazione sistema avendo in ingresso:
% sistema, input, tempo, valori iniziali degli input
[y,tsim,x]=lsim(sistema,u,t,x0);


y; % vettore delle uscite diviso per colonne
x; % vettore degli ingressi diviso per colonne
tsim; % vettore rappresentante gli istanti temporali


% plot delle varie grandezze
figure(1), plot(tsim,x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')
figure(2), plot(tsim,x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), 
xlabel('tempo (in s)'), ylabel('corrente i_L (in A)')
figure(3), plot(tsim,y), grid on, zoom on, title('Evoluzione dell''uscita y'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')


% Calcolo della funzione di trasferimento G(s) del sistema dinamico
fprintf('System G(s)');
% funzione transfer function per ottenere la funzione di trasferimento in
% formato simbolico
G=tf(sistema)

% state space to transfer function
[numG,denG]=ss2tf(A,B,C,D);
% damping = smorzamento
fprintf('Zeri di G(s)'); damp(numG); % Calcolo degli zeri di G(s)
fprintf('Poli di G(s)'); damp(denG); % Calcolo dei poli di G(s)

% Calcolo analitico della risposta del sistema dinamico

fprintf('Input U(s)');
ingresso=menu('Tipo d''ingresso del sistema','u(t)=u0;','u(t)=t;','u(t)=u0*cos(4t)');


% tf può anche ritornare la funzione di trasferimento a partire dal denominatore e dal numeratore
% della funzione di trasferimento
switch ingresso,
case 1, U=tf(1,[1,0])
case 2, U=tf(1,[1,0,0])
case 3, U=tf([1,0],[1,0,4^2])
end

fprintf('Output Y(s)');
% output simbolico della funzione di trasferimento
Y=G*U

% transfer function data, l'inverso di tf, ritorna numeratore
% e denominatore dato una funzione di trasferimento in input
[numY,denY]=tfdata(Y,'v');
[residui,poli,resto]=residue(numY,denY) % Scomposizione in fratti semplici
