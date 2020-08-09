clear
fclose('all');

%% Datos pollito

[img, alto, ancho] = load_image('pollito.png');
[img2, alto2, ancho2] = load_image('pokebola.png');

%% Aspectos de la transmisión

load('variables.mat')

senal = [];


paquetes_pollo = paquetizar('pollito.png', '1');
paquetes_pokebola = paquetizar('pokebola.png', '2');
%% Codificación

i = 1;
filenames = ['poyo01.wav'; 'poyo02.wav'; 'poyo03.wav'; 'poyo04.wav'; 'poyo05.wav'; 'poyo06.wav'; 'poyo07.wav'; 'poyo08.wav'; 'poyo09.wav'; 'poyo10.wav'; 'poyo11.wav'; 'poyo12.wav'; 'poyo13.wav'; 'poyo14.wav'];

while i <= 14
    senal = paquetes_pollo(i, :);
    
    enviar_pkt(senal, filenames(i, :));
   
    sound(senal, 44100)
    
    pause(5)
    
    % Grabación (Recepción de ACK)

     timeg = 4;                             %tiempo de grabacion

     tg = 0:time:timeg - time;               %muestras de toda la grabacion
     grabacion = audiorecorder(frec,16,1);   %Vector donde se guardara la informacion
     disp('Grabando...')
     recordblocking(grabacion,timeg);        %Graba
     disp('Fin de la grabacion')
    
     ack = getaudiodata(grabacion);        %Llena el vector grabacion con la informacion grabada
     fs = 44100;
    

    [ack,fs]=audioread('ack.wav'); %Esto carga el audio directamente

    N = length(ack);
    datafft=fft(ack);
    datafft_abs=abs(datafft/N);
    y=datafft_abs(1:N/2+1);
    x=fs*(0:N/2)/N;
    %figure;
    %plot(x, y)
    
    index = find(y==max(y));
    fundamental = x(index);
    disp(fundamental)
    %sound(ack, frec);

    if fundamental < 4000+100 && fundamental > 4000-100
        disp('ack!');
        i = i+1;
    end
end


i=1;
filenames = ['poke01.wav'; 'poke02.wav'; 'poke03.wav'; 'poke04.wav'; 'poke05.wav'; 'poke06.wav'; 'poke07.wav'; 'poke08.wav'; 'poke09.wav'; 'poke10.wav'; 'poke11.wav'; 'poke12.wav'; 'poke13.wav'; 'poke14.wav'];

while i <= 14
    senal = paquetes_pokebola(i, :);
    enviar_pkt(senal, filenames(i, :));
    
    pause(3)
    
    sound(senal, 44100)
    
    % Grabación (Recepción de ACK)

    timeg = 8;                             %tiempo de grabacion

     tg = 0:time:timeg - time;               %muestras de toda la grabacion
     grabacion = audiorecorder(frec,16,1);   %Vector donde se guardara la informacion
     disp('Grabando...')
     recordblocking(grabacion,timeg);        %Graba
     disp('Fin de la grabacion')
    
     ack = getaudiodata(grabacion);        %Llena el vector grabacion con la informacion grabada
     fs = 44100;

    %[ack,fs]=audioread('ack.wav'); %Esto carga el audio directamente

    N = length(ack);
    datafft=fft(ack);
    datafft_abs=abs(datafft/N);
    y=datafft_abs(1:N/2+1);
    x=fs*(0:N/2)/N;
    %figure;
    %plot(x, y)
    
    index = find(y==max(y));
    fundamental = x(index);
    disp(fundamental)
    %sound(ack, frec);

    if fundamental < 4000+100 && fundamental > 4000-100
        disp('ack!');
        i = i+1;
    else
        disp('No hubo ack. Enviando el paquete de nuevo...')
    end
end

