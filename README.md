# TISPA

Transmisión de Información Sobre Portadoras Audibles

Proyecto realizado para el ramo EL5207 Laboratorio de Tecnologías de Información y Comunicaciones, Universidad de Chile.

## Objetivo general

Se aborda el desafío de transmitir dos imágenes distintas de forma paquetizada a través de sonido desde un computador base hacia otros dos computadores cientes distintos. Cada cliente recibe una imagen e ignora los datos destinados al cliente opuesto. Si los datos no son recibidos correctamente, se retransmiten mediante ARQ.

## Diseño

El computador base se encarga de la paquetización y sincronización de los datos. Los paquetes contienen los siguientes elementos:
* Identificador de nodo de destino
* Número de secuencia
* Campo de detección de errores
* Datos a enviar

Para la revisión de errores de transmisión se aplica ARQ mediante ACKs enviados desde los receptores al nodo base. 

## Autores
* Catalina M. González Inostroza
* Diego S. Wistuba La Torre
