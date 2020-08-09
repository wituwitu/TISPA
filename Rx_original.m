clear

%% Datos

ancho = 14;
alto = 14;
largtex = 59;

%% Grabación

frec = 44100;                           %Frecuencia de muestreo
time = 1/frec;                          %Perdiodo de frecuencia

timeg = 35;                             %tiempo de grabacion

tg = 0:time:timeg - time;               %muestras de toda la grabacion
grabacion = audiorecorder(frec,16,1);   %Vector donde se guardara la informacion
disp('Grabando...')
recordblocking(grabacion,timeg);        %Graba
disp('Fin de la grabacion')

senal = getaudiodata(grabacion);        %Llena el vector grabacion con la informacion grabada
% 
% senal = audioread('poyo.wav');          %Esto carga el audio directamente,
%                                          %no arroja errores

%% Aspectos de la grabación

Tsim = 0.1;            %duracion de cada simbolo
Thead = 0.6;            %duración de cada header

frojo = 100;            %frecuencia base del rojo
fverde = 100 + 256*10;  %frecuencia base del verde
fazul = 100 + 256*20;   %frecuencia base del azul

df = 10;          %Define intensidad de colores, cada 20 Hz se suma un grado de intensidad hasta llegar a 255


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

%% Sincronización con header de la imagen

disp('Buscando inicio de la imagen')
tiempobs = 3;                       %segundos desde el inicio de la grabacion donde se buscara el header
intbusca = senal(1:tiempobs*frec);  %intervalo de tiempo donde se buscara el header
[corr, lag] = xcorr(intbusca, h);   %correlacion entre el header de la señal y el intervalo de tiempo en que este se buscara
[maxc, indice] = max(abs(corr));    %encuentra valor de max de correlacion
inicio = lag(indice);               %encontrar valor de inicio

Tinicio = abs(inicio) + length(h);  %tiempo de inicio de informacion

poyo = senal(Tinicio:end);          %señal se corta para dejar solo la informacion

%% Sincronización con header del texto

disp('Buscando inicio texto')
tiempobstex = 25;                       %segundos desde el inicio de la grabacion donde se buscara el header
intbuscatex = senal(1:tiempobstex*frec);  %intervalo de tiempo donde se buscara el header
[corrtex, lagtex] = xcorr(intbuscatex, htext);   %correlacion entre el header de la señal y el intervalo de tiempo en que este se buscara
[maxctex, indicetex] = max(abs(corrtex));    %encuentra valor de max de correlacion
iniciotex = lagtex(indicetex);               %encontrar valor de inicio

Tiniciotex = abs(iniciotex) + length(htext);  %tiempo de inicio de informacion

texexam = senal(Tiniciotex:end);          %señal se corta para dejar solo la informacion


%% Decodificación

%Matrices vacias para almacenar los valores de cada color
Rojo = zeros(1, ancho*alto);
Verde = zeros(1, ancho*alto);
Azul = zeros(1, ancho*alto);

t = 0:time:Tsim;
Largo = length(t);
finterv = frec*(0:Largo/2)/Largo; %intervalo para realizar trasformada de fourier

% frecuencias de cada canal, si se cumple lo requerido se entrega un 1, sino, 0 
iRojo = ( (fverde - 10>finterv) & finterv>(frojo - 10) );
iVerde = ( (fazul - 10>finterv) & finterv>(fverde - 10) );
iAzul = ( (15600>finterv) & finterv>(fazul - 10) );

Rojof = finterv(iRojo);
Verdef = finterv(iVerde);
Azulf = finterv(iAzul);
for i = 1:(alto*ancho)
        muestra = poyo((i - 1)*Largo + 1:i*Largo);
        ventana = hamming(Largo);
        muestra = muestra.*ventana;
        Y = fft(muestra); 
        Y1 = Y(1:round(Largo/2) + 1);        
        Y1 = abs(Y1);
        
        Y1r = Y1(iRojo);
        Y1r = abs(Y1r); 
        [frecr, indr] = max (Y1r); 
        Rojo(i) = round((Rojof(indr) - frojo)/df); 
        
        Y1g =  Y1(iVerde);
        Y1g = abs(Y1g); 
        [frecg,indg] = max (Y1g); 
        Verde(i) = round((Verdef(indg) - fverde)/df); 
        
        Y1b =  Y1(iAzul); 
        Y1b = abs(Y1b); 
        [frecb,indb] = max (Y1b);
        Azul(i) = round((Azulf(indb) - fazul)/df); 
end

DecoRojo = uint8(reshape(Rojo,alto,ancho));     %Transforma el vector de valores (color rojo) en una matriz 
DecoVerde = uint8(reshape(Verde,alto,ancho));   %Transforma el vector de valores (color verde) en una matriz 
DecoAzul = uint8(reshape(Azul,alto,ancho));     %Transforma el vector de valores (color azul) en una matriz 
img(:,:,1) = DecoRojo;                          %posiciona la matriz correspondiente al color rojo de la imagen
img(:,:,2) = DecoVerde;                         %posiciona la matriz correspondiente al color verde de la imagen
img(:,:,3) = DecoAzul;                          %posiciona la matriz correspondiente al color azul de la imagen
imshow(img)                                     %muestra la imagen

%% Decodificación texto

for i = 1:largtex
        muestratex = texexam((i - 1)*Largo + 1:i*Largo);
        ventanatex = hamming(Largo);
        muestratex = muestratex.*ventanatex;
        Ytex = fft(muestratex);
        Y1tex = Ytex(1:round(Largo/2) + 1);        
        Y1tex = abs(Y1tex);
        
        Y1rtex = Y1tex(iRojo);
        Y1rtex = abs(Y1rtex); 
        [frect,indt]=max(Y1rtex); 
        Textofinal(i) = round((Rojof(indt) - frojo)/df); 
end
Mensajef=char(Textofinal+5);
disp(Mensajef)


%% Tasa de errores

% IMAGEN

imgorig = imread('pollito_14x14.png');

R = uint16(reshape(imgorig(:,:,1),alto*ancho,1));
G = uint16(reshape(imgorig(:,:,2),alto*ancho,1));
B = uint16(reshape(imgorig(:,:,3),alto*ancho,1));

vector_original = [R, G, B];

vector_rec = [Rojo, Verde, Azul];

errores_img = 0;

for i=1:size(vector_original)
    if (vector_original(i))~=(vector_rec(i))
        errores_img = errores_img + 1;
    end 
end
tasa_img = errores_img/length(vector_original);

disp('Errores en la imagen: ')
disp(errores_img)
disp('Tasa de errores [%]: ')
disp(tasa_img*100)
% TEXTO

%se compara mensajef con el string original
msjoriginal='¡Examen,Principio de Comunicaciones Primavera 2018 EL4005!';
errores_txt=0;
for i=1:size(msjoriginal)
    if (msjoriginal(i))~=(Mensajef(i))
        errores_txt=errores_txt+1;
    end 
end
tasa_txt = errores_txt/length(msjoriginal);

disp('Errores en la recepción del texto: ')
disp(errores_txt)
disp('Tasa de errores [%]: ')
disp(tasa_txt*100)