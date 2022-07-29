library(tidyverse)

# filtrar convocatorias de salud -----
data <- read_csv("todo/todo.csv")
objetos_covid <- "covid|coronavirus|bioseguridad|cuarentena|oxigeno|alcohol|gel|pandemia|barbijo|respirador|sanitizador|vacuna|dioxido|ivermectina|pruebas covid|antigeno|PCR|congelador|plasma"
objetos_salud <- "salud|hospital|medicamentos|medico|médico|medicos|médicos|laboratorio|farmacia|enfermeria|pacientes|reactivos|farmaceuticos|clinico|insumos médicos|desinfectante|medicinal|enfermería"
kw <- str_c(objetos_covid, objetos_salud, sep = "|")

salud <- data %>%
  filter(str_detect(objeto, regex(kw, ignore_case = T)))
write_csv(salud, "temas/salud.csv")

salud_contratado <- salud %>%
  filter(estado == "Contratado")
write_csv(salud_contratado, "temas/salud_contratado.csv")

# Filtrar por palabras clave -----

## funcion para filtrar

filtrar_contratos <- function(data, objetos, guardar = F){
  df <- read_csv(data)
  vector_kw <- str_split(objetos, fixed("|")) %>% unlist()
  # helper function
  identify_kw <- function(df, kw){
      df %>% filter(str_detect(objeto, regex(kw, ignore_case = T)))
  }
  
  result <-  map(vector_kw, ~identify_kw(df, .x)) %>% set_names(vector_kw)
  
  if(guardar) walk2(result, vector_kw, ~write_csv(.x, paste0("temas/", .y, ".csv")))
  return(result)
}

## uso de funcion
  
objetos_covid <- "covid|coronavirus|cuarentena|oxigeno|alcohol|gel|pandemia|barbijo|respirador|sanitizador|vacuna|dioxido de cloro|ivermectina|pruebas covid|antigeno|PCR|congelador|plasma"

lista <- filtrar_contratos(
  "temas/salud_contratado.csv", 
  objetos_covid, 
  guardar = T
  )


