#install.packages(c("imager", "magrittr", "ggplot2"))
library(magrittr)
library(imager)
library(ggplot2)

#install.packages("segmented")
library(segmented)


# Vector de temperaturas e imágenes correspondientes
temps <- c(25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80)
image_files <- paste0("img_", temps, "C.png")

# Visualizar la imagen y Coordenadas aproximadas (ajusta según la imagen)
img <- load.image("img_80C.png")
plot(img)
x1 <- 180; x2 <- 210
y1 <- 450; y2 <- 300
rect(x1, y1, x2, y2, border = "red", lwd = 2)  # Superpone la ROI en rojo
dim(img)

rois <- list(
  list(x1=165, y1=450, x2=195, y2=300),  # para img_25C.png
  list(x1=160, y1=450, x2=190, y2=300),  # para img_30C.png
  list(x1=160, y1=450, x2=190, y2=300),  # para img_35C.png
  list(x1=160, y1=540, x2=190, y2=300),  # para img_40C.png
  list(x1=160, y1=450, x2=190, y2=300),  # para img_45C.png
  list(x1=160, y1=450, x2=190, y2=300),  # para img_50C.png
  list(x1=150, y1=450, x2=180, y2=300),  # para img_55C.png
  list(x1=160, y1=450, x2=190, y2=300),  # para img_60C.png
  list(x1=170, y1=450, x2=200, y2=300),  # para img_65C.png   
  list(x1=190, y1=450, x2=220, y2=300),  # para img_70C.png   
  list(x1=180, y1=450, x2=210, y2=300),  # para img_75C.png
  list(x1=180, y1=450, x2=210, y2=300)  # para img_80C.png   
)

#  Medir intensidad media dentro de la ROI
intensities <- numeric(length(image_files))

for (i in seq_along(image_files)) {
  img <- load.image(image_files[i])
  roi <- rois[[i]]
  
  # recorta usando imsub
  roi_crop <- imsub(img, x >= roi$x1 & x <= roi$x2, y >= roi$y2 & y <= roi$y1)
  
  intensities[i] <- mean(roi_crop)
}

ancho30 <- data.frame(Temperatura = temps, Intensidad = intensities)

#graficar:
ggplot(ancho30,
       aes(x = Temperatura, y = Intensidad)) +
  geom_point(size = 3) +
  geom_line() +
  labs(title = "Turbidez vs. Temperatura",
       x = "Temperatura (°C)", y = "Intensidad media de gris") +
  theme_minimal()


#Regresión Segmentada
# Modelo lineal base
mod_lineal <- lm(Intensidad ~ Temperatura, data = ancho30)

# Ajustar modelo segmentado (requiere valor inicial para el breakpoint)
mod_segmentado <- segmented(mod_lineal, seg.Z = ~Temperatura, psi = list(Temperatura = 62))

# Resumen del modelo
summary(mod_segmentado)

tcp_estimado <- mod_segmentado$psi[2]  # Coordenada x del breakpoint
print(paste("Temperatura de Punto de Nube estimada:", round(tcp_estimado, 2), "°C"))

plot(ancho30$Temperatura, ancho30$Intensidad, pch = 16, xlab = "Temperatura (°C)", ylab = "Intensidad media")
plot(mod_segmentado, add = TRUE, col = "blue", lwd = 2)
abline(v = tcp_estimado, col = "red", lty = 2)
legend("bottomright", legend = paste("TCP estimada:", round(tcp_estimado, 2), "°C"), col = "red", lty = 2, bty = "n")


