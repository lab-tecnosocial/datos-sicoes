library(tidyverse)
library(lubridate)
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

new_data <- archivos[-1] %>%
  map_dfr(read_csv, col_types = cols(
    fecha_presentacion = col_date(format = "%d/%m/%Y"),
    fecha_publicacion = col_date(format = "%d/%m/%Y"),
    fecha_adjudicacion_desierta = col_date(format = "%d/%m/%Y"),
    costo_pliego = col_character()
  ))

old_data <- read_csv(archivos[1], col_types = "cccccccDDccccccccDcc")

data <- bind_rows(old_data, new_data) %>%
  arrange(fecha_publicacion)

write_csv(data, "todo/todo.csv")


