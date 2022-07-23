library(tidyverse)

archivos <- list.files("temas/datos-drive/", full.names = T) %>%
  set_names(tools::file_path_sans_ext(basename(.)))

df_temas <- map_dfr(archivos, read_csv, .id = "tema") %>%
  arrange(fecha_publicacion) %>%
  relocate(tema)

df_temas_cuce <- df_temas %>% distinct(cuce, .keep_all = T)

write_csv(df_temas, "temas/datos-drive/temas_cuce.csv")
