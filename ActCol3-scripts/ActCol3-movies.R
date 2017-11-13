# Obtenemos directorio de trabajo
getwd()

# Creamos nuevo diretorio de trabajo
if(!file.exists("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts//"))
{dir.create("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts")}

# Establecemos nuevo directorio de trabajo
setwd("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts")

# Limpieza directorio de trabajo
rm(list=ls())

# Creación de carpetas para los datos
if(!file.exists("..//ActCol3-messydataset")){dir.create("..//ActCol3-messydataset")}
if(!file.exists("..//ActCol3-tidydataset")){dir.create("..//ActCol3-tidydataset")}

# Descarga dataset con 5,000 películas (movies) de IMDB en messydataset y almacenado de la fecha de descarga
fileurl <-"https://raw.githubusercontent.com/sundeepblue/movie_rating_prediction/master/movie_metadata.csv"
download.file(fileurl,destfile="..//ActCol3-messydataset//movies.csv")
fechaDescarga <- date()

# Carga de messydataset movies y primera visualización de los datos
messymovies <-read.csv("..//ActCol3-messydataset/movies.csv", header=TRUE, stringsAsFactors = FALSE)
library(knitr)
head(messymovies)

# Carga de tidydataset movies eliminando caracteres especiales y espacios a ambos lados
tidymovies <- read.csv("..//ActCol3-messydataset/movies.csv", header=TRUE, 
                       stringsAsFactors = FALSE, encoding = "UTF-8", strip.white=TRUE)

# Convertimos valores de columnas gross y budyet a enteros
tidymovies$budget <- as.integer(tidymovies$budget )
tidymovies$gross <- as.integer(tidymovies$gross )

# Omitimos todas las filas que contengan algún valor NA
tidymovies <- na.omit(tidymovies)

# Eliminamos columnas no relevantes 
tidymovies <- tidymovies[,!grepl("face", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("num", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("plot", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("link", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("actor_2", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("actor_3", colnames(tidymovies))]

# Renombramos columnas
new_names <- c("color","director", "duration", "gross", "genres", "protagonist",
               "title", "language", "country", "content","budget", "release", "score", "ratio")
names(tidymovies) <- new_names

# Ordernamos columnas
tidymovies<- tidymovies[,c("color","duration","release","title","director",
                           "protagonist","country","language","genres","content","budget","gross",
                           "score","ratio")]

# Ordenamos valores por score and rario descendente
tidymovies <- tidymovies[order(tidymovies$score,tidymovies$ratio, decreasing = TRUE),]

# Ecritura del fichero limpiado
write.csv2(tidymovies,file = "../ActCol3-tidydataset/tidymovies.csv", row.names=FALSE)
str(tidymovies)
