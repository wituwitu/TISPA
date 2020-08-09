function senal = image_to_signal(symbol_duration, sampling_period, img, df)
    t = 0:sampling_period:symbol_duration;   %muestras de tiempo de simbolo 
                    %time periodo de muestreo
                    %T Duración de cada símbolo
    
    dato = size(img); 
    ancho = dato(1);
    alto = dato(2);
    
    frojo = 100;      %Frecuencia color rojo     
    fverde = 100 + 256*10;    %Frecuencia color verde
    fazul = 100 + 256*20;     %Frecuencia color azul  

    
    R = uint16(reshape(img(:,:,1),alto*ancho,1));
    G = uint16(reshape(img(:,:,2),alto*ancho,1));
    B = uint16(reshape(img(:,:,3),alto*ancho,1));
    
    senal = [];

    for i = 1:1:length(R)
        Frecuencias = [R(i)*df +  frojo, G(i)*df +  fverde, B(i)*df +  fazul];
        Frecuencias = double(Frecuencias);
        senal = [senal 0.33*(sin(2*pi*Frecuencias(1).*t) +  sin(2*pi*Frecuencias(2).*t) +  sin(2*pi*Frecuencias(3).*t))];
    end

end
