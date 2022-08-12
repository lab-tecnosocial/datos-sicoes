library(tidyverse)

# Exportar a CSV y JSON
export_csv_json <- function(df, path = "todo/covid/v3/") {
  name_df <- deparse(substitute(df))
  write_csv(df, paste0(path, name_df, ".csv" ), na = "")
  write(jsonlite::toJSON(df, pretty = T, na = "null"), paste0(path, name_df, ".json"))
}

# Leer archivos
convocatorias <- read_csv("todo/covid/v2/conv_cuces.csv")
totales <- read_csv("todo/covid/v2/totales_wider.csv")
adjudicados <- read_csv("todo/covid/v2/adjudicados_clean.csv")
items <- read_csv("todo/covid/v2/items_clean.csv")


# Join convocatorias y totales
conv_totales <- convocatorias %>%
  left_join(totales, by = "cuce") %>%
  rename(menciones = temas) %>%
  mutate(objeto = str_replace_all(objeto, "ã??N", "on"))
export_csv_json(conv_totales)

# Totales faltantes
totales_faltantes <- convocatorias %>%
  filter(!cuce %in% totales$cuce)

# Join items y convocatorias
items_conv <- items %>%
  left_join(select(convocatorias, cuce, entidad, objeto), by = "cuce") %>%
  relocate(c(entidad, objeto), .after = cuce)

export_csv_json(items_conv)

