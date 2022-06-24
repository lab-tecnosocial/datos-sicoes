library(tidyverse)
library(tidylog)
library(googledrive)

# leer datos

carpetas <- c(javier = "https://drive.google.com/drive/folders/1pximTLJwbXj7YMEux-ic3Pl9aLmo8wu6", abi = "https://drive.google.com/drive/folders/1C0oX55j-_AAP67FBqIbDb9pTM84Zwg5E", vale = "https://drive.google.com/drive/folders/1ukEwIKMyC4iNz_ldaXZRF5hmEyvutcYB")

lista_archivos <- map(carpetas, ~drive_ls(.x, recursive = T))

# filtrar pdfs y extraer sus ids

tabla_archivos <- lista_archivos %>%
  bind_rows(.id = "nombre_recolector") %>%
  select(!drive_resource) %>%
  filter(str_detect(name, ".pdf$")) %>%
  mutate(name = str_remove(name, ".pdf"))

# unir con base principal
objetos_covid <- "covid|coronavirus|bioseguridad|cuarentena|oxigeno|alcohol|gel|pandemia|barbijo|respirador|sanitizador|vacuna|dioxido de cloro|ivermectina|pruebas covid|antigeno|PCR|congelador|plasma"

covid_contratados <- read_csv("temas/salud_contratado.csv") %>%
  filter(str_detect(objeto, regex(objetos_covid, ignore_case = T)))

covid_datos_fichas <- covid_contratados %>%
  left_join(tabla_archivos, by = c(cuce = "name"))
  
# filtrar lo que falta de covid/coronavirus menos lo que ya hay
objetos_covid_2 <- "covid|coronavirus|pandemia|cuarentena"
covid_faltante <- covid_datos_fichas %>%
  filter(str_detect(objeto, regex(objetos_covid_2, ignore_case = T))) %>%
  filter(is.na(nombre_recolector)) %>%
  filter(ficha_proceso != "Ver Ficha")

# asignar

partes <- list(v = 1:509, a = 510:1019, j = 1020:1528)

covid_falt <- covid_faltante %>%
  mutate(encargado = c(rep("v", 509), rep("a", 510), rep("j", 509))) %>%
  relocate(encargado, .before = everything())
