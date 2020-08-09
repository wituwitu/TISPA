function Mensajef = decode_txt(text, largtex)

load('variables.mat', 'time', 'Tsim', 'frec', 'fverde', 'frojo', 'df');

t = 0:time:Tsim;
Largo = length(t);

finterv = frec*(0:Largo/2)/Largo; %intervalo para realizar trasformada de fourier

iRojo = ( (fverde - 10>finterv) & finterv>(frojo - 10) );

Rojof = finterv(iRojo);

for i = 1:largtex
        muestratex = text((i - 1)*Largo + 1:i*Largo);
        ventanatex = hamming(Largo);
        muestratex = muestratex.*ventanatex;
        Ytex = fft(muestratex);
        Y1tex = Ytex(1:round(Largo/2) + 1);        
        Y1tex = abs(Y1tex);
        
        Y1rtex = Y1tex(iRojo);
        Y1rtex = abs(Y1rtex); 
        [~,indt]=max(Y1rtex); 
        Textofinal(i) = round((Rojof(indt) - frojo)/df); 
end

Mensajef=char(Textofinal+5);