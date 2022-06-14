library(tidyverse)

# igualar nombres de columnas
data_ajena <- read_csv("data/conv/03_07-2020.csv")
data_propia <- read_csv("data/conv/01-2021.csv")

nombres_columnas <- list(ajena = names(data_ajena), propia = names(data_propia))

data_ajena <- data_ajena %>%
  mutate(subasta = NA, .after = estado)
names(data_ajena) <- names(data_propia)

write_csv(data_ajena, "data/conv/03_07-2020_alt.csv")

# unir datos
archivos <- list.files("meses/", full.names = T)
tipos_col <- "cccccccDDcccccccTDcc"
data <- archivos %>%
  map_dfr(read_csv, col_types = "cccccccccccccccccccc")
write_csv(data, "todo/todo.csv")
  
# filtrar convocatorias de salud
data <- read_csv("todo/todo.csv")
objetos_1 <- "covid|coronavirus|bioseguridad|cuarentena|oxigeno|alcohol|gel|pandemia|barbijo|respirador|sanitizador|vacuna|dioxido|ivermectina|pruebas covid|antigeno|PCR"
objetos_2 <- "salud|hospital|medicamentos|medico|médico|medicos|médicos|laboratorio|farmacia|enfermeria|pacientes|reactivos|farmaceuticos|clinico|insumos médicos|desinfectante|medicinal|enfermería"

kw <- str_c(objetos_1, objetos_2, sep = "|")

salud <- data %>%
  filter(str_detect(objeto, regex(kw, ignore_case = T)))
write_csv(salud, "data/conv/salud.csv")

salud_contratado <- salud %>%
  filter(estado == "Contratado")

salud_contratado %>%
  filter(ficha_proceso == "Ver Ficha") %>%
  nrow() -> fichas_hay

# Dividir salud

salud <- read_csv("temas/salud_contratado.csv")

identify_kw <- function(df, kw){
  df %>% filter(str_detect(objeto, regex(kw, ignore_case = T)))
}
vector_kw <- str_split(objetos_1, fixed("|")) %>% unlist()

list_salud <- map(vector_kw, ~identify_kw(salud, .x)) %>% set_names(vector_kw)

walk2(list_salud, vector_kw, ~write_csv(.x, paste0("temas/", .y, ".csv")))
