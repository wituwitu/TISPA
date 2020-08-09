function enviar_pkt(pkt, filename)
load('variables.mat');


audiowrite(filename,pkt,frec);

%sound(pkt, frec);

end
