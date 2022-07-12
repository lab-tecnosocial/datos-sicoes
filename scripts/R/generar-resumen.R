library(tidyverse)

# contar datos que existen
lista_temas_fichas <- readRDS("temas/lista_temas_fichas.Rds")
df_temas_fichas <- bind_rows(lista_temas_fichas, .id = "tema") %>%
  arrange(fecha_publicacion)

conteo_items <- df_temas_fichas %>%
  count(tema, name ="items")

conteo_cuces <- df_temas_fichas %>%
  distinct(tema, cuce, .keep_all = T) %>%
  count(tema, name = "convocatorias")

conteo_temas <- left_join(conteo_cuces, conteo_items, by = "tema")  

# links publicos

links_datos <- c(
  "alcohol" = "https://drive.google.com/file/d/1Szqdy03qIGkhK0uuC8YTuZ2M_Bca7zX2/view?usp=sharing",
  "antigeno" = "https://drive.google.com/file/d/1E8IbmJc3yA5M9Z898MtnDqF2TegRaM7d/view?usp=sharing",
  "barbijo" = "https://drive.google.com/file/d/1DG7UdZ4fTVstQcu2xwF4lm3luxd7q72b/view?usp=sharing",
  "congelador" = "https://drive.google.com/file/d/1_1m7MA0tGk_ZMW5B7Qiwu5pQ5pn8MXGF/view?usp=sharing",
  "coronavirus" = "https://drive.google.com/file/d/1jBeCb79YOLbVDmtbnFYdcvxM-xBAEYcJ/view?usp=sharing",
  "covid" = "https://drive.google.com/file/d/1M0Kn_XgOloGbuG3w0CaK_QlHZzsFqZ03/view?usp=sharing",
  "cuarentena" = "https://drive.google.com/file/d/1EXgsDx1NFHAHCvhqCfkKOKREKe31Yp0W/view?usp=sharing",
  "dioxido de cloro" = "https://drive.google.com/file/d/1Lnp6A02bDgzWyYsCx97eqTN9EdoW1VvZ/view?usp=sharing",
  "gel" = "https://drive.google.com/file/d/1jQF04EbOFnobYqyqkzDMvRIsLix9Q0il/view?usp=sharing",
  "ivermectina" = "https://drive.google.com/file/d/1OBkPW9jkFCW4KXkmx0sBGKB7nSCKE4Pz/view?usp=sharing",
  "oxigeno" = "https://drive.google.com/file/d/1ICtAK7HCosFv8Mw_BfNhB_u76E3dLrLv/view?usp=sharing",
  "pandemia" = "https://drive.google.com/file/d/1GWPk5DqdH9JV12-ehuc7I4mvYWO1ht9b/view?usp=sharing",
  "PCR" = "https://drive.google.com/file/d/1StE-txdaivvTUfqZdGFSWpQwWpdscDML/view?usp=sharing",
  "plasma" = "https://drive.google.com/file/d/1Vkpa-L-KJ4JFuSSUDQgqeASZJjxw9Vts/view?usp=sharing",
  "pruebas covid" = "https://drive.google.com/file/d/1zn7zBBGU91qRiaVAyPOH-iTTTSeJayBG/view?usp=sharing",
  "respirador" = "https://drive.google.com/file/d/1op5ulCXYYz_Jaev8LV7JFLzjHx0pOXSa/view?usp=sharing",
  "sanitizador" = "https://drive.google.com/file/d/1ZW9QOj-ODbzECMAo188BD5373QCpcaqu/view?usp=sharing",
  "vacuna" = "https://drive.google.com/file/d/1_llOoUgQDFWwSw4hJy-xRk2Q8HgMUQ-W/view?usp=sharing"
)

links_fichas <- c(
  "alcohol" = "",
  "antigeno" = "",
  "barbijo" = "",
  "congelador" = "",
  "coronavirus" = "",
  "covid" = "",
  "cuarentena" = "",
  "dioxido de cloro" = "",
  "gel" = "",
  "ivermectina" = "",
  "oxigeno" = "",
  "pandemia" = "",
  "PCR" = "",
  "plasma" = "",
  "pruebas covid" = "",
  "respirador" = "",
  "sanitizador" = "",
  "vacuna" = ""
)

# generar tablas

conteo_temas <- conteo_temas %>%
  mutate(enlace = text_spec("Descarga", link = paste0(link_root, tema, ".csv")))

conteo_temas %>%
  kbl() %>%
  kable_material("hover") %>%
  save_kable("temas/tabla_resumen.html", self_contained = F)
