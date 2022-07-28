library(tidyverse)
library(stringi)
library(kableExtra)
source("scripts/R/mis-funciones.R")

# Unir fichas
fichas_antiguas <- read_csv("fichas/fichas_antiguas.csv", col_types = "ccccccdddcdddddcc")
nombres_oficiales <- stri_trans_general(names(fichas_antiguas), id ="Latin-ASCII")
fichas_antiguas <- fichas_antiguas %>% set_names(nombres_oficiales)
fichas_nuevas <- read_csv("fichas/fichas_nuevas.csv",  col_types = "c-cccccccccccccccc")  %>% set_names(nombres_oficiales)

fichas_nuevas_clean <- fichas_nuevas %>%
  mutate(
    cantidad = parsear_numero_diverso(cantidad),
    precio_referencial_unitario = parsear_numero_diverso(precio_referencial_unitario),
    precio_referencial_total = parsear_numero_diverso(precio_referencial_total),
    precio_unitario_adjudicado = parsear_numero_diverso(precio_unitario_adjudicado),
    total_adjudicado = parsear_numero_diverso(total_adjudicado),
    cantidad_recepcionada = parsear_numero_diverso(cantidad_recepcionada),
    precio_unitario_real = parsear_numero_diverso(precio_unitario_real),
    monto_real_ejecutado = parsear_numero_diverso(monto_real_ejecutado)
  )

all(names(fichas_antiguas) == names(fichas_nuevas))

fichas_todo <- bind_rows(fichas_antiguas, fichas_nuevas_clean)
write_csv(fichas_todo, "fichas/fichas_todo.csv")

# Unir datos con fichas
lista_temas <- readRDS("temas/lista_temas.Rds")
fichas_todo <- read_csv("fichas/fichas_todo.csv")

lista_temas_fichas <- lista_temas %>%
  map(~left_join(.x, fichas_todo, by = "cuce")) %>%
  map(~filter(.x, !is.na(descripcion_del_bien_o_servicio)))

saveRDS(lista_temas_fichas, "temas/lista_temas_fichas.Rds")

walk2(lista_temas_fichas, names(lista_temas_fichas), ~write_csv(.x, paste0("temas/", .y, ".csv"), na = ""))

