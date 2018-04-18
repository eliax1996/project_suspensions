% Esercitazione di laboratorio #1 - Fondamenti di Automatica
% Soluzione dell'esercizio riguardante il sistema elettrico
% Autori: M. Indri, M. Taragna (ultima modifica: 9/XII/2001)

clear all, close all, pack

% Definizione dei parametri del sistema e del tipo di simulazione
es=menu('Simulazione della risposta del sistema elettrico',...
        'caso 1.a: R=10,  L=0.5,  x0=[0;0],   i(t)=1;',...
        'caso 1.b: R=100, L=0.5,  x0=[0;0],   i(t)=1;',...
        'caso 1.c: R=0.1, L=0.05, x0=[0;0],   i(t)=1;',...
        'caso 1.d: R=10,  L=0.5,  x0=[0;0.2], i(t)=1;',...
        'caso 2.a: R=10,  L=0.5,  x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.b: R=100, L=0.5,  x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.c: R=0.1, L=0.05, x0=[0;0],   i(t)=cos(4t);',...
        'caso 2.d: R=10,  L=0.5,  x0=[0;0.2], i(t)=cos(4t)');
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

C=0.2; i0=1;
A=[0, -1/C; 1/L, -R/L];
B=[1/C; 0];
C=[1, 0];
D=0;

sistema=ss(A,B,C,D);

% Simulazione della risposta y(t) del sistema dinamico

t=0:0.01:tmax;
u=i0*cos(w0*t);

[y,tsim,x]=lsim(sistema,u,t,x0);

figure(1), plot(tsim,x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')
figure(2), plot(tsim,x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), 
xlabel('tempo (in s)'), ylabel('corrente i_L (in A)')
figure(3), plot(tsim,y), grid on, zoom on, title('Evoluzione dell''uscita y'), 
xlabel('tempo (in s)'), ylabel('tensione v_C (in V)')

% Calcolo della funzione di trasferimento G(s) del sistema dinamico

fprintf('System G(s)'); G=tf(sistema)

[numG,denG]=ss2tf(A,B,C,D);
fprintf('Zeri di G(s)'); damp(numG); % Calcolo degli zeri di G(s)
fprintf('Poli di G(s)'); damp(denG); % Calcolo dei poli di G(s)

% Calcolo analitico della risposta del sistema dinamico

fprintf('Input U(s)');
ingresso=menu('Tipo d''ingresso del sistema','u(t)=u0;','u(t)=t;','u(t)=u0*cos(4t)');
switch ingresso,
case 1, U=tf(1,[1,0])
case 2, U=tf(1,[1,0,0])
case 3, U=tf([1,0],[1,0,4^2])
end

fprintf('Output Y(s)'); Y=G*U

[numY,denY]=tfdata(Y,'v');
[residui,poli,resto]=residue(numY,denY) % Scomposizione in fratti semplici