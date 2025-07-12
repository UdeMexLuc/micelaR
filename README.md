# Análisis de Punto de Nube (TCP) mediante imágenes y regresión segmentada

Este repositorio contiene el código en R utilizado para estimar la Temperatura de Punto de Nube (TCP) de soluciones de Triton X-100 utilizando análisis de imágenes. Se emplea el paquete `imager` para extraer la intensidad media de gris en una región definida del tubo experimental, y `segmented` para estimar automáticamente el punto de quiebre.

## 📦 Requisitos

Antes de ejecutar el script, asegúrate de instalar las siguientes librerías de R:

```r
install.packages(c("imager", "magrittr", "ggplot2", "segmented"))
```
