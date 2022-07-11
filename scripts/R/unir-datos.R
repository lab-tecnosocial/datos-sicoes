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