install.packages("gitcreds")
library(gitcreds)

gitcreds_set()
gitcreds_get()

install.packages("DBI")
install.packages("RMySQL")

library(DBI)
library(RMySQL)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)

dbListFields(MyDataBase, 'City')

DataDB <- dbGetQuery(MyDataBase, "select * from City")

class(DataDB)
dim(DataDB)
head(DataDB)

pop.mean <- mean(DataDB$Population)  # Media a la variable de población
pop.mean 

pop.3 <- pop.mean *3   # Operaciones aritméticas
pop.3

library(dplyr)
pop50.mex <-  DataDB %>% filter(CountryCode == "MEX" ,  Population > 50000)   # Ciudades del país de México con más de 50,000 habitantes

head(pop50.mex)

unique(DataDB$CountryCode)   # Países que contiene la BDD


# Reto 1
install.packages("DBI")
install.packages("RMySQL")
install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(DBI)
library(RMySQL)
library(ggplot2)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)

dbListFields(MyDataBase, 'CountryLanguage')

DataDB <- dbGetQuery(MyDataBase, "select * from CountryLanguage")
names(DataDB)

SP <- DataDB %>% filter(Language == "Spanish")
SP.df <- as.data.frame(SP) 


SP.df %>% ggplot(aes( x = CountryCode, y=Percentage, fill = IsOfficial )) + 
  geom_bin2d() +
  coord_flip()

# Ejemplo 3

install.packages("pool")
install.packages("dplyr")

library(dplyr)
library(pool)

my_db <- dbPool(
  RMySQL::MySQL(), 
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest"
)

dbListTables(my_db)

# Obtener los primeros 5 registros de Country

my_db %>% tbl("Country") %>% head(5) # library(dplyr)

# Obtener los primeros 5 registros de CountryLanguage

my_db %>% tbl("CountryLanguage") %>% head(5)

library(DBI)
conn <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

rs <- dbSendQuery(conn, "SELECT * FROM City LIMIT 5;")

dbFetch(rs)

dbClearResult(rs)
dbDisconnect(conn)

# Ejemplo 4
install.packages("rjson")   #Siempre usar comillas en el nombre del paquete

library(rjson)            # Quitar comillas del nombre

URL <- "https://tools.learningcontainer.com/sample-json-file.json"
# Asignando el link a una variable

JsonData <- fromJSON(file= URL)     # Se guarda el JSon en un objeto de R

class(JsonData)                     # Vemos que tipo de objeto es JsonData

str(JsonData)                       # Vemos la naturaleza de sus variables

sqrt(JsonData$Mobile)

install.packages("XML")
library(XML)
link <- "http://www-db.deis.unibo.it/courses/TW/DOCS/w3schools/xml/cd_catalog.xml"

# Postwork
# Instalar y cargar la librería mongolite
install.packages("mongolite")
library(mongolite)

# Conectar a la base de datos
con <- mongo("match_games", url = "mongodb://localhost")

# Importar el archivo CSV a la colección "match"
con$insert("match.data.csv")

# Contar el número de registros en la colección
num_registros <- con$count()

# Realizar una consulta para obtener los goles del Real Madrid el 20 de diciembre de 2015
consulta <- con$find('{"HomeTeam": "Real Madrid", "Date": "2015-12-20"}', 
                     fields = '{"HomeTeam": 1, "AwayTeam": 1, "FTHG": 1}')

# Imprimir la consulta
print(consulta)

# Cerrar la conexión
con$disconnect()

# Analizando el XML desde la web
xmlfile <- xmlTreeParse(link)

summary(xmlfile)
head(xmlfile)

#Extraer los valores xml
topxml <- xmlSApply(xmlfile, function(x) xmlSApply(x, xmlValue))

# Colocandolos en un Data Frame
xml_df <- data.frame(t(topxml), row.names= NULL)

str(xml_df) # Observar la naturaleza de las variables del DF

xml_df$PRICE <- as.numeric(xml_df$PRICE) 
xml_df$YEAR <- as.numeric(xml_df$YEAR)

mean(xml_df$PRICE)
mean(xml_df$YEAR)

data_df <- xmlToDataFrame(link)
head(data_df)

install.packages("rvest")
library(rvest)

theurl <- "https://solarviews.com/span/data2.htm"
file <- read_html(theurl)    # Leemos el html

tables <- html_nodes(file, "table")  

table1 <- html_table(tables[4], fill = TRUE)

table <- na.omit(as.data.frame(table1))   # Quitamos NA´s que meten filas extras y convertimos la lista en un data frame para su manipulación con R

# Reto 2
library(rvest)

theurl <- "https://www.glassdoor.com.mx/Sueldos/data-scientist-sueldo-SRCH_KO0,14.htm"

file<-read_html(theurl)

tables<-html_nodes(file, "table")
# Hay que analizar 'tables' para determinar cual es la posición en la lista que contiene la tabla, en este caso es la no. 4 

table1 <- html_table(tables[1], fill = TRUE)


table <- na.omit(as.data.frame(table1))

str(table)

#Removiendo caracteres inncesarios 
a <- gsub("MXN","",table$Sueldo)
a <- gsub("[^[:alnum:][:blank:]?]", "", a)
a <- gsub("mes", "", a)
a <- as.numeric(a)
table$Sueldo <- a

#Removiendo caracteres inncesarios
b <- gsub("Sueldos para Data Scientist en ", "", table$Cargo)
table$Cargo <-b

#Máximo sueldo
max.sueldo <- which.max(table$Sueldo)
table[max.sueldo,]

#Mínimo sueldo
min.sueldo <- which.min(table$Sueldo)
table[min.sueldo,]
str(table)  # Vemos la naturaleza de las variables

table$Albedo <- as.numeric(table$Albedo)
str(table)
