clear

%% Datos pollito
img = imread('pollito_14x14.png');
dato = size(img); 
alto = dato(1);
ancho = dato(2);
string = '�Examen, Principio de Comunicaciones Primavera 2018 EL4005!';

%% Aspectos de la transmisi�n

frec = 44100;     %Frecuencia de muestreo
time = 1/frec;    %Periodo de muestreo
T = 0.10;         %duracion de cada simbolo
Th = 0.6;         %duraci�n de cada header

frojo = 100;      %Frecuencia color rojo     
fverde = 100 + 256*10;    %Frecuencia color verde
fazul = 100 + 256*20;     %Frecuencia color azul  

df = 10; %%Define intensidad de colores, cada 20 Hz se suma un grado de intensidad hasta llegar a 255

textoascii=double(string);
frectext=zeros(1, 257);

for i = 1:257
   frectext(i) = 50 + df*i;
end

senal = [];

%% Header

th = 0:time:Th;           %muestras de tiempo de header

h1 = sin(2*pi*1000*th);   %tono 1 del header
h2 = sin(2*pi*2000*th);   %tono 2 del header
h3 = sin(2*pi*3000*th);   %tono 3 del header 
h = [h1, h2, h3];           %header completo


senal = [senal, h];

%% Codificaci�n

t = 0:time:T; %muestras de tiempo de simbolo 
            %time periodo de muestreo
            %T Duraci�n de cada s�mbolo

R = uint16(reshape(img(:,:,1),alto*ancho,1));
G = uint16(reshape(img(:,:,2),alto*ancho,1));
B = uint16(reshape(img(:,:,3),alto*ancho,1));

for i = 1:1:length(R)
    Frecuencias = [R(i)*df +  frojo, G(i)*df +  fverde, B(i)*df +  fazul];
    Frecuencias = double(Frecuencias);
    senal = [senal 0.33*(sin(2*pi*Frecuencias(1).*t) +  sin(2*pi*Frecuencias(2).*t) +  sin(2*pi*Frecuencias(3).*t))];
end

%% Segundo header

htext1 = sin(2*pi*300*th);
htext2 = sin(2*pi*400*th);
htext3 = sin(2*pi*500*th);
htext = [htext1, htext2, htext3];
senal = [senal, htext];

%% Codificaci�n del texto

ftext=zeros(1, length(string));
for i=1:length(string)
      k=double(string(i));
      ftext(i)=frectext(k);
      senal = [senal 0.33*(sin(2*pi*ftext(i).*t))];
end


%% Transmisi�n

audiowrite('poyo.wav',senal,frec);
