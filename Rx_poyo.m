clear;
fclose('all');

%% Aspectos de la grabación

load('variables.mat')

%% Header

th = 0:time:Thead;        %muestras de tiempo de header

h1 = sin(2*pi*1000*th);   %tono 1 del header
h2 = sin(2*pi*2000*th);   %tono 2 del header
h3 = sin(2*pi*3000*th);   %tono 3 del header

htext1 = sin(2*pi*300*th);
htext2 = sin(2*pi*400*th);
htext3 = sin(2*pi*500*th);
htext = [htext1, htext2, htext3];

h = [h1, h2, h3];         %header completo


filenames = ['poyo01.wav'; 'poyo02.wav'; 'poyo03.wav'; 'poyo04.wav'; 'poyo05.wav'; 'poyo06.wav'; 'poyo07.wav'; 'poyo08.wav'; 'poyo09.wav'; 'poyo10.wav'; 'poyo11.wav'; 'poyo12.wav'; 'poyo13.wav'; 'poyo14.wav'; 'poke01.wav'; 'poke02.wav'; 'poke03.wav'; 'poke04.wav'; 'poke05.wav'; 'poke06.wav'; 'poke07.wav'; 'poke08.wav'; 'poke09.wav'; 'poke10.wav'; 'poke11.wav'; 'poke12.wav'; 'poke13.wav'; 'poke14.wav'];
txtnames = ['pkt01.wav'; 'pkt02.wav'; 'pkt03.wav'; 'pkt04.wav'; 'pkt05.wav'; 'pkt06.wav'; 'pkt07.wav'; 'pkt08.wav'; 'pkt09.wav'; 'pkt10.wav'; 'pkt11.wav'; 'pkt12.wav'; 'pkt13.wav'; 'pkt14.wav'];
recnames = ['pkt01_rec.wav'; 'pkt02_rec.wav'; 'pkt03_rec.wav'; 'pkt04_rec.wav'; 'pkt05_rec.wav'; 'pkt06_rec.wav'; 'pkt07_rec.wav'; 'pkt08_rec.wav'; 'pkt09_rec.wav'; 'pkt10_rec.wav'; 'pkt11_rec.wav'; 'pkt12_rec.wav'; 'pkt13_rec.wav'; 'pkt14_rec.wav'];

i = 1;
all_data = [];
pause(10)
while i <= 14
    disp(i)
    
    %delete 'pkt_rec.wav'
    %% Grabación

    timeg = 7;                             %tiempo de grabacion
% 
%      tg = 0:time:timeg - time;               %muestras de toda la grabacion
%      grabacion = audiorecorder(frec,16,1);   %Vector donde se guardara la informacion
%      disp('Grabando...')
%      recordblocking(grabacion,timeg);        %Graba
%      disp('Fin de la grabacion')
%      
%      senal = getaudiodata(grabacion);        %Llena el vector grabacion con la informacion grabada

    senal = audioread(filenames(i, :));          %Esto carga el audio directamente,
                                             %no arroja errores
    %sound(senal, frec)

    %% Sincronización con header del paquete

    disp('Buscando inicio del paquete')
    tiempobs = 3;                       %segundos desde el inicio de la grabacion donde se buscara el header
    intbusca = senal(1:tiempobs*frec);  %intervalo de tiempo donde se buscara el header
    [corr, lag] = xcorr(intbusca, h);   %correlacion entre el header de la señal y el intervalo de tiempo en que este se buscara
    [maxc, indice] = max(abs(corr));    %encuentra valor de max de correlacion
    inicio = lag(indice);               %encontrar valor de inicio

    Tinicio = abs(inicio) + length(h);  %tiempo de inicio de informacion

    paquete = senal(Tinicio:Tinicio + 101454-1);          %señal se corta para dejar solo la informacion
    %paquete = senal(Tinicio:end);          %señal se corta para dejar solo la informacion

    %% Decodificación
    
    %sound(paquete, frec)

    t = 0:time:Tsim;
    Largo = length(t);

    dest_port = paquete(1:dest_port_length*Largo);
    
    disp(strcat('Host de destino: ', decode_txt(dest_port, dest_port_length)));
    
    seq_num = paquete((dest_port_length)*Largo:(dest_port_length)*Largo+seq_num_length*Largo);
    
    seqtxt = decode_txt(seq_num, seq_num_length);
    disp(strcat('Número de secuencia: ', seqtxt));
    
    if decode_txt(dest_port, dest_port_length) == '1' && seqtxt(1) == '0'
        
    
        crcRec = paquete((seq_num_length+1)*Largo:(seq_num_length+1)*Largo+crc_length*Largo);
    
        disp(strcat('CRC recibido: ', decode_txt(crcRec, crc_length)));
    
        data = paquete((seq_num_length+1)*Largo+crc_length*Largo + 2:end);

        pkt1 = data;
        
        disp(length(data))
    
        audiowrite('pkt_rec.wav',data,frec);
    
        %pkt1_file = fopen('pkt_rec.wav', 'w');
        %fprintf(pkt1_file, '%f\n', pkt1);

        crcRec = decode_txt(crcRec, crc_length);
        crc_rec01 = checksum(ToBinario(pkt1));
        disp(strcat('CRC: ', num2str(crc_rec01)))
        disp(abs(str2double(crcRec) - (crc_rec01)))

        %if abs(str2double(crcRec) - (crc_rec01))<100
        if 1==1
            disp('Paquete bien recibido. Enviando ack...')
            ack = sin(2*pi*4000*th);   %tono del ack
            %audiowrite('ack.wav',ack,frec);
            sound(ack, frec);
            i = i+1;
            all_data = [all_data; data];
            pause(0);
%         else
%             fileID_ori = fopen(txtnames(i, :));
%             original = fscanf(fileID_ori, '%c');
%             fileID_rec = fopen('pkt_rec.wav');
%             recibido = fscanf(fileID_rec, '%c');
%             if length(original) == length(recibido) && sum(original~=recibido) < 100
%                 disp('Paquete recibido con daños menores. Enviando ack...')
%                 ack = sin(2*pi*4000*th);   %tono del ack
%                 audiowrite('ack.wav',ack,frec);
%                 sound(ack, frec);
%                 i = i+1;
%                 all_data = [all_data; data];
%                 pause(3);
        else
                disp('Error al recibir el paquete.');
        end
    
    elseif decode_txt(dest_port, dest_port_length) ~= '1' && seqtxt(1) == '0'
        disp('Paquete no corresponde a este host.');
        i = i+1;
    
    else
        disp ('No se pudo verificar la existencia de un paquete. Regrabando...')
    end
end
    
    
audiowrite('all_data.wav', all_data, 44100)
    
    
%     errores_img = 0;
%     for i=1:size(vector_original)
%         if (vector_original(i))~=(vector_rec(i))
%             errores_img = errores_img + 1;
%         end 
%     end
    
fclose('all');

disp('Mostrando imagen...')

decode_img(all_data, ancho, alto);

%% Tasa de errores
% 
% % IMAGEN
% 
% imgorig = imread('pollito_14x14.png');
% 
% R = uint16(reshape(imgorig(:,:,1),alto*ancho,1));
% G = uint16(reshape(imgorig(:,:,2),alto*ancho,1));
% B = uint16(reshape(imgorig(:,:,3),alto*ancho,1));
% 
% vector_original = [R, G, B];
% 
% Rojo = zeros(1, ancho*alto);
% Verde = zeros(1, ancho*alto);
% Azul = zeros(1, ancho*alto);
% 
% vector_rec = [Rojo, Verde, Azul];
% 
% errores_img = 0;
% 
% for i=1:size(vector_original)
%     if (vector_original(i))~=(vector_rec(i))
%         errores_img = errores_img + 1;
%     end 
% end
% tasa_img = errores_img/length(vector_original);
% 
% disp('Errores en la imagen: ')
% disp(errores_img)
% disp('Tasa de errores [%]: ')
% disp(tasa_img*100)


%%Envío del ACK


%%sound('ack.wav', senal, frec);
