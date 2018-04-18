s = ft('s')

H1 = 10/((s+1)*(s-10))

step(H1)
impulse(H1)
% imposto i parametri del grafico
% il tempo da 0 secondi a 1 secondo
% i valori sull'ordinata da 0 a 2
axis([0 1 0 2])

% approssimo il  sistema ponendo un sistema
% del prim'ordine con guadagno uguale al guadagno
% del sistema del secondo, imposto anche la costante
% di tempo trovandola come quel valore dove la funzione
% assume valore val_max*(1-1/e)
% in questo caso al tempo circa 1.11 sec

H2 = 1/(1-s*1.11)


ltiview % visualizza il sistema di analisi 
% dei sistemi LTI

% confronto le due risposte
step(H1,H2)