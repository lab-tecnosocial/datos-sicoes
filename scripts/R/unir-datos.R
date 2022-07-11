library(tidyverse)
library(stringi)

# Unir fichas
fichas_antiguas <- read_csv("fichas/fichas_antiguas.csv", col_types = "cdccccdddcdddddcc")
nombres_oficiales <- stri_trans_general(names(fichas_antiguas), id ="Latin-ASCII")
fichas_antiguas <- fichas_antiguas %>% set_names(nombres_oficiales)
fichas_nuevas <- read_csv("fichas/fichas_nuevas.csv",  col_types = "c-dccccdddcdddddcc")  %>% set_names(nombres_oficiales)
all(names(fichas_antiguas) == names(fichas_nuevas))

fichas_todo <- bind_rows(fichas_antiguas, fichas_nuevas)
write_csv(fichas_todo, "fichas/fichas_todo.csv")

# Unir datos con fichas
lista_temas <- readRDS("temas/lista_temas.Rds")
fichas_todo <- read_csv("fichas/fichas_todo.csv")

lista_temas_fichas <- lista_temas %>%
  map(
    ~left_join(.x, fichas_todo, by = "cuce")
  )

walk2(lista_temas_fichas, names(lista_temas_fichas), ~write_csv(.x, paste0("temas/", .y, ".csv")))
