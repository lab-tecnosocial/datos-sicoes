library(tidyverse)

# Exportar a CSV y JSON
export_csv_json <- function(df, path = "todo/covid/") {
  name_df <- deparse(substitute(df))
  write_csv(df, paste0(path, name_df, ".csv" ), na = "")
  write(jsonlite::toJSON(df, pretty = T), paste0(path, name_df, ".json"))
}

# Homegeneizar uso de puntos y comas en numeros
parsear_numero_diverso <- function(n) {
  punto_decimal <- ".*,.*\\..*"
  coma_decimal <- ".*\\..*,.*"
  if_else(str_detect(n, punto_decimal), parse_number(n), parse_number(n, locale = locale(decimal_mark = ",", grouping_mark = ".")))
}