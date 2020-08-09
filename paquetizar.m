function paquetes = paquetizar(imagen, dest_port)

load('variables.mat', 'alto', 'ancho', 'T', 'time', 'df', 'frec', 'Th');

[img, alto, ancho] = load_image(imagen);


senal = image_to_signal(T, time, img, df);

largo = length(senal);

ventana = largo/14;

pkt1 = senal(1:ventana);
audiowrite('pkt01.wav', pkt1, frec)
%pkt1_file = fopen('pkt01.txt', 'w');
%fprintf(pkt1_file, '%f\n', pkt1);
%disp(inv(pkt1));

pkt2 = senal(ventana+1:2*ventana);
audiowrite('pkt02.wav', pkt2, frec)
%pkt2_file = fopen('pkt02.txt', 'w');
%fprintf(pkt2_file, '%f\n', pkt2);

pkt3 = senal(2*ventana+1:3*ventana);
audiowrite('pkt03.wav', pkt3, frec)
%pkt3_file = fopen('pkt03.txt', 'w');
%fprintf(pkt3_file, '%f\n', pkt3);

pkt4 = senal(3*ventana+1:4*ventana);
audiowrite('pkt04.wav', pkt4, frec)
%pkt4_file = fopen('pkt04.txt', 'w');
%fprintf(pkt4_file, '%f\n', pkt4);

pkt5 = senal(4*ventana+1:5*ventana);
audiowrite('pkt05.wav', pkt5, frec)
%pkt5_file = fopen('pkt05.txt', 'w');
%fprintf(pkt5_file, '%f\n', pkt5);

pkt6 = senal(5*ventana+1:6*ventana);
audiowrite('pkt06.wav', pkt6, frec)
%pkt6_file = fopen('pkt06.txt', 'w');
%fprintf(pkt6_file, '%f\n', pkt6);

pkt7 = senal(6*ventana+1:7*ventana);
audiowrite('pkt07.wav', pkt7, frec)
%pkt7_file = fopen('pkt07.txt', 'w');
%fprintf(pkt7_file, '%f\n', pkt7);

pkt8 = senal(7*ventana+1:8*ventana);
audiowrite('pkt08.wav', pkt8, frec)
%pkt8_file = fopen('pkt08.txt', 'w');
%fprintf(pkt8_file, '%f\n', pkt8);

pkt9 = senal(8*ventana+1:9*ventana);
audiowrite('pkt09.wav', pkt9, frec)
%pkt9_file = fopen('pkt09.txt', 'w');
%fprintf(pkt9_file, '%f\n', pkt9);

pkt10 = senal(9*ventana+1:10*ventana);
audiowrite('pkt10.wav', pkt10, frec)
%pkt10_file = fopen('pkt10.txt', 'w');
%fprintf(pkt10_file, '%f\n', pkt10);

pkt11 = senal(10*ventana+1:11*ventana);
audiowrite('pkt11.wav', pkt11, frec)
%pkt11_file = fopen('pkt11.txt', 'w');
%fprintf(pkt11_file, '%f\n', pkt11);

pkt12 = senal(11*ventana+1:12*ventana);
audiowrite('pkt12.wav', pkt12, frec)
%pkt12_file = fopen('pkt12.txt', 'w');
%fprintf(pkt12_file, '%f\n', pkt12);

pkt13 = senal(12*ventana+1:13*ventana);
audiowrite('pkt13.wav', pkt13, frec)
%pkt13_file = fopen('pkt13.txt', 'w');
%fprintf(pkt13_file, '%f\n', pkt13);

pkt14 = senal(13*ventana+1:end);
audiowrite('pkt14.wav', pkt14, frec)
%pkt14_file = fopen('pkt14.txt', 'w');
%fprintf(pkt14_file, '%f\n', pkt14);

pkt = [pkt1; pkt2; pkt3; pkt4; pkt5; pkt6; pkt7; pkt8; pkt9; pkt10; pkt11; pkt12; pkt13; pkt14];
checksum_pkt= [checksum(ToBinario(pkt1')); checksum(ToBinario(pkt2')); checksum(ToBinario(pkt3')); checksum(ToBinario(pkt4')); checksum(ToBinario(pkt5')); checksum(ToBinario(pkt6')); checksum(ToBinario(pkt7')); checksum(ToBinario(pkt8')); checksum(ToBinario(pkt9')); checksum(ToBinario(pkt10')); checksum(ToBinario(pkt11')); checksum(ToBinario(pkt12')); checksum(ToBinario(pkt13')); checksum(ToBinario(pkt14'))];

%% Header (inicio del paquete)

th = 0:time:Th;

h1 = sin(2*pi*1000*th);   %tono 1 del header
h2 = sin(2*pi*2000*th);   %tono 2 del header
h3 = sin(2*pi*3000*th);   %tono 3 del header 
header = [h1, h2, h3];         %header completo

%% Header (identificador de nodo de destino)

header = [header text_to_signal(T, time, dest_port, df)];

%% Header (Número de secuencia)

seq_num = ['0001'; '0002'; '0003'; '0004'; '0005'; '0006'; '0007'; '0008'; '0009'; '0010'; '0011'; '0012'; '0013'; '0014'];

%% Header (Campo de detección de errores)

headers = zeros(14, length([header text_to_signal(T, time, seq_num(1, :), df) text_to_signal(T, time, num2str(checksum_pkt(1,:)), df)]));
paquetes = zeros(14, length([headers(1, :) pkt(1, :)])); %largo de la señal completa

for i = 1:14
    check_pkt=checksum_pkt(i,:);
%     crcs_suma=sum(crcs(:, i));
%     crcs_suma=num2str(crcs_suma);
    headers(i, :) = [header text_to_signal(T, time, seq_num(i, :), df) text_to_signal(T, time, num2str(checksum_pkt(i,:)), df)];
    paquetes(i, :) = [headers(i, :) pkt(i, :)];
end


end

