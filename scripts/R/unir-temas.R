library(tidyverse)
library(jsonlite)

# Cargar archivos y contar
archivos <- list.files("temas/datos-drive/", full.names = T) %>%
  set_names(tools::file_path_sans_ext(basename(.)))

pdfs <- list.files("scripts/python/fichas_simp/", recursive = T) %>% 
  basename() %>%
  unique()

# Unir temas
df_temas <- map_dfr(archivos, read_csv, .id = "tema") %>%
  arrange(fecha_publicacion) %>%
  relocate(tema)

# Funcion para exportar a CSV y JSON

export_csv_json <- function(df, path = "todo/covid/") {
  name_df <- deparse(substitute(df))
  write_csv(df, paste0(path, name_df, ".csv" ), na = "")
  write(toJSON(df, pretty = T), paste0(path, name_df, ".json"))
}

# Exportar cuces unicos (3632)
conv_cuces <- df_temas %>% distinct(cuce, .keep_all = T) %>%
  select(cuce:normativa) %>%
  rename(estado = estado.x)
# Exportar temas (4716)
conv_temas <- df_temas %>%
  distinct(tema, cuce, .keep_all = T) %>%
  select(tema:normativa) %>%
  rename(estado = estado.x)
export_csv_json(conv_temas)

# Temas en convocatorias
cuces_temas <- conv_temas %>%
  group_by(cuce) %>%
  summarize(temas = paste(tema, collapse = ", "))
export_csv_json(cuces_temas)

# Añadir temas a cuces unicos
conv_cuces <- conv_cuces %>%
  left_join(cuces_temas) %>%
  relocate(temas)
export_csv_json(conv_cuces)

# Exportar items
fichas_todo <- read_csv("fichas/fichas_todo.csv")
fichas <- fichas_todo %>%
  filter(cuce %in% conv_cuces$cuce)
export_csv_json(fichas)

# Exportar adjudicados
adjudicados_todo <- read_csv("scripts/python/out/v1/tablas_adjudicado.csv")
adjudicados <- adjudicados_todo %>%
  filter(cuce %in% conv_cuces$cuce) %>%
  select(-list_n)
export_csv_json(adjudicados)

# Joins conv y fichas

# Totales convocatorias
totales_conv <- read_csv("scripts/python/out/v2/tablas_totales.csv") %>%
  filter(cuce %in% conv_cuces$cuce) %>%
  distinct(cuce, .keep_all = T)
export_csv_json(totales_conv)

## Graficos -------
library(lubridate)

conv_cuces <- read_csv("todo/covid/conv_cuces.csv")

serie_tiempo <- conv_cuces %>%
  group_by(fecha = floor_date(fecha_publicacion, "month")) %>%
  summarize(n_conv = n()) %>%
  mutate(mes = paste0(month(fecha), "-", year(fecha)), .after = fecha)

export_csv_json(serie_tiempo)

ggplot(serie_tiempo) +
  geom_line(aes(x = fecha, y = n_conv))

conv_temas <- read_csv("todo/covid/conv_temas.csv")
frec_temas <- conv_temas %>%
  count(tema, sort = T)

export_csv_json(frec_temas)
