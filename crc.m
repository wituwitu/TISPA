function codigo=crc(data)
%Transformar el vector a binario, si es mayor a 0 el valor es 1

%data_binario=data;
%data_binario(data_binario>0)=1;
%data_binario(data_binario<=0)=0;

data_binario=abs(data)*10;

%Cálculo de CRC
gen = comm.CRCGenerator([1 0 0 1],'ChecksumsPerFrame',2);
codeword = step(gen,data_binario);
codigo=codeword;
%suma=sum(codigo);

%detect = comm.CRCDetector([1 0 0 1],'ChecksumsPerFrame',2);
%[~, err] = step(detect,codeword)
%error=err;
%suma_errores=sum(err);

end
