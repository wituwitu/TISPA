function [img, height, width] = load_image(file)
    img = imread(file);
    dato = size(img); 
    height = dato(1);
    width = dato(2);
end