function valor=checksum(data)

while mod(length(data),4)>0
    data(end+1)=0;
end
c=0;
i=1;
while i<=(length(data)-1)
    fragmento=data(i:i+3)';
    numero=bi2de(fragmento);
    %disp(numero)
    c=c+numero;
    i=i+4;
end 
valor=c;


end
