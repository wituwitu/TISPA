function v_binario=ToBinario(data)
data_binario=data;
data_binario(data_binario<= -0.5)=1;
data_binario(-0.5<=data_binario & data_binario<=0)=0;
data_binario(0.5>data_binario & data_binario>0)=1;
data_binario(data_binario>= 0.5 & data_binario<0.9999999)=0;
v_binario=data_binario;
end
