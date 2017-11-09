#Obtener directorio de trabajo
getwd()

#crear nuevo diretorio de trabajo
if(!file.exists("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts//"))
{dir.create("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts")}

#Establecer nuevo directorio de trabajo
setwd("C:/Users/Antonio/Documents/Master-BigData/ActCol3-scripts")

#Limpiamos directorio de trabajo
rm(list=ls())

#creamos carpetas para los datos
if(!file.exists("..//ActCol3-messydataset")){dir.create("..//ActCol3-messydataset")}
if(!file.exists("..//ActCol3-tidydataset")){dir.create("..//ActCol3-tidydataset")}

#Descarga dataset 5,000 de IMDB en messydataset y guardado de la fecha de descarga
fileurl <-"https://raw.githubusercontent.com/sundeepblue/movie_rating_prediction/master/movie_metadata.csv"
download.file(fileurl,destfile="..//ActCol3-messydataset//movies.csv")
fechaDescarga <- date()

#Cargamos messydataset movies
messymovies <-read.csv("..//ActCol3-messydataset/movies.csv", header=TRUE, stringsAsFactors = FALSE)

#Cargamos tidydataset movies conviertiendo todos los caracteres no alfa-numericos
tidymovies <-read.csv("..//ActCol3-messydataset/movies.csv", header=TRUE, stringsAsFactors = FALSE, encoding = "UTF-8", strip.white=TRUE)

#Omitimos todass las filas que contengan algun valor NA
tidymovies<-na.omit(tidymovies)

#Eliminamos posibles espacios en blanco a ambos lados
library(stringr)
tidymovies[,sapply(tidymovies,str_trim)]

#Eliminamos columnas no relevantes 
tidymovies <- tidymovies[,!grepl("face", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("num", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("plot", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("link", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("actor_2", colnames(tidymovies))]
tidymovies <- tidymovies[,!grepl("actor_3", colnames(tidymovies))]

#Normalizamos variables "title" a string y "budget", "gross" y "duration" a entero
tidymovies$budget <- as.integer(tidymovies$budget )
tidymovies$gross <- as.integer(tidymovies$gross )
tidymovies$duration <- as.integer(tidymovies$duration )
tidymovies$title_year <- as.character(tidymovies$title_year )

# Renombramos columnas
new_names <- c("color","director", "duration", "gross", "genres", "protagonist",
               "title", "language", "country", "content","budget", "release", "score", "ratio")
names(tidymovies) <- new_names

# Ordernar columnas
tidymovies<- tidymovies[,c("color","duration","release","title","director","protagonist","country","language","genres","content","budget","gross","score","ratio")]

# Ordenamos valores por score and rario descendente
tidymovies <- tidymovies[with(tidymovies, order(score, ratio )),]
#tidymovies <- tidymovies[order(tidymovies[,13],tidymovies[,14]),]
