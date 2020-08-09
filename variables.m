frec = 44100;     %Frecuencia de muestreo
time = 1/frec;    %Periodo de muestreo
T = 0.10;         %duracion de cada simbolo
Th = 0.6;         %duración de cada header
t = 0:time:T; %muestras de tiempo de simbolo 

frojo = 100;      %Frecuencia color rojo     
fverde = 100 + 256*10;    %Frecuencia color verde
fazul = 100 + 256*20;     %Frecuencia color azul  

df = 10; %%Define intensidad de colores, cada 20 Hz se suma un grado de intensidad hasta llegar a 255

Tsim = 0.1;            %duracion de cada simbolo
Thead = 0.6;            %duración de cada header

%Duración de cada segmento

dest_port_length = 1;
seq_num_length = 4;
crc_length = 4;
data_length = 128;
raw_data_length = 61754;
packet_length = 1+4+32+128;

ancho = 14;
alto = 14;
largtex = 59;

save('variables.mat')