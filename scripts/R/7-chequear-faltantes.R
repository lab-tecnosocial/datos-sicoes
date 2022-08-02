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

## analisis de fichas faltantes
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
  mutate(falta_fichas = if_else(paginas_ficha >= 4, "Prob. Si", "Prob. No"))

convocatorias %>% count(falta_fichas)

export_csv_json(convocatorias)

# Tabla de resumen de faltantes
faltantes <- convocatorias %>%
  summarize(
    falta_total = sum(falta_total == "Si"),
    falta_adjudicado = sum(falta_adjudicado == "Si"),
    prob_falta_fichas = sum(falta_fichas == "Prob. Si")
    ) %>%
  pivot_longer(everything(), names_to = "tipo", values_to = "perdido")

write_csv(faltantes, "scripts/R/faltantes.csv")
