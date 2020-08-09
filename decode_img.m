function img = decode_img(image, ancho, alto)

load('variables.mat', 'frojo', 'fverde', 'fazul', 'df', 'time', 'Tsim', 'frec', 'ancho', 'alto');

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
    
        muestra = image((i - 1)*Largo + 1:i*Largo);
        ventana = hamming(Largo);
        muestra = muestra.*ventana;
        Y = fft(muestra); 
        Y1 = Y(1:round(Largo/2) + 1);        
        Y1 = abs(Y1);
        
        Y1r = Y1(iRojo);
        Y1r = abs(Y1r); 
        [~, indr] = max (Y1r); 
        Rojo(i) = round((Rojof(indr) - frojo)/df); 
        
        Y1g =  Y1(iVerde);
        Y1g = abs(Y1g); 
        [~,indg] = max (Y1g); 
        Verde(i) = round((Verdef(indg) - fverde)/df); 
        
        Y1b =  Y1(iAzul); 
        Y1b = abs(Y1b); 
        [~,indb] = max (Y1b);
        Azul(i) = round((Azulf(indb) - fazul)/df); 
end


DecoRojo = uint8(reshape(Rojo,alto,ancho));     %Transforma el vector de valores (color rojo) en una matriz 
DecoVerde = uint8(reshape(Verde,alto,ancho));   %Transforma el vector de valores (color verde) en una matriz 
DecoAzul = uint8(reshape(Azul,alto,ancho));     %Transforma el vector de valores (color azul) en una matriz 
img(:,:,1) = DecoRojo;                          %posiciona la matriz correspondiente al color rojo de la imagen
img(:,:,2) = DecoVerde;                         %posiciona la matriz correspondiente al color verde de la imagen
img(:,:,3) = DecoAzul;                          %posiciona la matriz correspondiente al color azul de la imagen
imshow(img)                                     %muestra la imagen
