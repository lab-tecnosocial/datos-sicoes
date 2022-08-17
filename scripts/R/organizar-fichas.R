library(tidyverse)

# Mover a carpetas especificas

lista_temas_fichas <- readRDS("temas/lista_temas_fichas.Rds")

dir_source <- "scripts/python/todo_fichas/"
dir_target <- "scripts/python/filtro_fichas/"

walk2(lista_temas_fichas, names(lista_temas_fichas),
    ~{
      dir_new <- str_c(dir_target, .y, "/")
      dir.create(dir_new)
      fichas <- str_c(unique(.x[["cuce"]]), ".pdf")
      walk(fichas, ~file.copy(str_c(dir_source, .x), str_c(dir_new, .x)))
    }
  )

# Mover general

dir_source <- "scripts/python/fichas_simp_unique/"
dir_target <- "scripts/python/fichas_falta/"

walk(totales_faltantes$cuce, ~file.copy(str_c(dir_source, .x, ".pdf"), str_c(dir_target, .x, ".pdf")))
