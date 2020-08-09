function senal = text_to_signal(symbol_duration, sampling_period, text, df)
    
    frectext = zeros(1, 257);
    senal = [];
    t = 0:sampling_period:symbol_duration;

    for i = 1:257
        frectext(i) = 50 + df*i;
    end    

    ftext = zeros(1, length(text));
    
    for i=1:length(text)
        k = double(text(i));
        ftext(i) = frectext(k);
        senal = [senal 0.33*(sin(2*pi*ftext(i).*t))];
    end
end