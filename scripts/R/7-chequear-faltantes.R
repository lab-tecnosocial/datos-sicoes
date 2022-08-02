library(tidyverse)
source("scripts/R/mis-funciones.R")

# Convocatorias vs montos totales 
convocatorias <- read_csv("todo/covid/conv_cuces.csv")
totales <- read_csv("todo/covid/totales_clean.csv")

faltantes_totales <- convocatorias %>%
  filter(!cuce %in% totales$cuce)

convocatorias <- convocatorias %>%
  mutate(falta_total = if_else(cuce %in% faltantes_totales$cuce, "Si", "No"))

# Convocatorias vs adjudicados
adjudicados <- read_csv("todo/covid/adjudicados_clean.csv")

faltantes_adjudicados <- convocatorias %>%
  filter(!cuce %in% unique(adjudicados$cuce))

convocatorias <- convocatorias %>%
  mutate(falta_adjudicado = if_else(cuce %in% faltantes_adjudicados$cuce, "Si", "No"))

# Convocatorias vs items (proxy: longitud de hojas de PDF)
library(pdftools)
list_pdfs <- list.files("scripts/python/fichas_simp_unique/", full.names = T, recursive = T, pattern = ".pdf$")
nombres_pdf <- tools::file_path_sans_ext(basename(list_pdfs))

pdfs <- map(list_pdfs, pdf_text) %>%
  set_names(nombres_pdf)

pdfs_pag <- tibble(cuce = character(3632), paginas_ficha = numeric(3632))

pdfs_pag <- pdfs_pag %>%
  mutate(
    cuce = nombres_pdf,
    paginas_ficha = map_int(pdfs, ~length(.x))
  )

pdfs_pag %>%
  ggplot() +
  geom_histogram(aes(paginas_ficha), binwidth = 1)

quantile(pdfs_pag$paginas_ficha, probs = seq(.05, .95, .05))

convocatorias <- convocatorias %>%
  left_join(pdfs_pag)

## analisis de items faltantes
contar_faltante_pag <- function(df, pag, col){
  df %>%
    filter(paginas_ficha == pag) %>%
    count(.data[[col]])
}

combina_datos <- expand_grid(pags = 2:5,  cats = c("falta_total", "falta_adjudicado"))

list_conteo <- map2(combina_datos$pags, combina_datos$cats, ~contar_faltante_pag(convocatorias, .x, .y))

convocatorias %>%
  ggplot() +
  geom_bar(aes(x = paginas_ficha, fill = falta_total))

convocatorias <- convocatorias %>%
  mutate(falta_items = if_else(paginas_ficha >= 4, "Prob. Si", "Prob. No"))

convocatorias %>% count(falta_items)

conv_cuces_info <- convocatorias

export_csv_json(conv_cuces_info)

# Tabla de resumen de faltantes
faltantes <- convocatorias %>%
  summarize(
    falta_total = sum(falta_total == "Si"),
    falta_adjudicado = sum(falta_adjudicado == "Si"),
    prob_falta_items = sum(falta_items == "Prob. Si")
    ) %>%
  pivot_longer(everything(), names_to = "tipo", values_to = "perdido")

write_csv(faltantes, "scripts/R/faltantes.csv")

# Identificar y mover fichas

dir_origen <- "scripts/python/fichas_simp_unique/"
dir_miss_totales <- "scripts/python/miss_fichas_totales//"
dir_miss_adjudicados <- "scripts/python/miss_fichas_adjudicados/"
dir_miss_items <- "scripts/python/miss_fichas_items/"

conv_info <- read_csv("todo/covid/conv_cuces_info.csv")

fix_totales <- conv_info %>%
  filter(falta_total == "Si")

fix_adjudicados <- conv_info %>%
  filter(falta_adjudicado == "Si")

fix_items <- conv_info %>%
  filter(falta_items == "Prob. Si")

walk(fix_totales$cuce, ~file.copy(str_c(dir_origen, .x, ".pdf"), str_c(dir_miss_totales, .x, ".pdf")))

walk(fix_adjudicados$cuce, ~file.copy(str_c(dir_origen, .x, ".pdf"), str_c(dir_miss_adjudicados, .x, ".pdf")))

walk(fix_items$cuce, ~file.copy(str_c(dir_origen, .x, ".pdf"), str_c(dir_miss_items, .x, ".pdf")))
