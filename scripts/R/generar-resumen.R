library(tidyverse)
library(kableExtra)

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
  "alcohol" = "https://drive.google.com/drive/folders/1Wr_wafNf7fzEoZNVZDbL_NW8zfxI7nvI?usp=sharing",
  "antigeno" = "https://drive.google.com/drive/folders/1LXwZ3LrOkKK1GseiYkUz93tPQBy19_Hw?usp=sharing",
  "barbijo" = "https://drive.google.com/drive/folders/1jim5vKXkuaijUqICU7z33_MOcS_0FvhJ?usp=sharing",
  "congelador" = "https://drive.google.com/drive/folders/1pI41Ad_MU0uiswLK1bsQVAh8-coAVwCy?usp=sharing",
  "coronavirus" = "https://drive.google.com/drive/folders/1_7s5NNNSp3pbG1EwdMR7LA-CjlTkzjYD?usp=sharing",
  "covid" = "https://drive.google.com/drive/folders/1mI4ncZ9Wp6KHocpxAnFnfglJpf2m9se1?usp=sharing",
  "cuarentena" = "https://drive.google.com/drive/folders/1rb8-H2pNgOvYa5dJOFJ9m56FqrYkCFIZ?usp=sharing",
  "dioxido de cloro" = "https://drive.google.com/drive/folders/1Y2P3Ep39S6q1IDfa1du3mQPgQ2TgZnL2?usp=sharing",
  "gel" = "https://drive.google.com/drive/folders/1YMga6f7XWMZDCiT-YdeDbfsu2OfsfFIo?usp=sharing",
  "ivermectina" = "https://drive.google.com/drive/folders/1kxLIKHj_Sa765WsuQ88qHSmooD188UCD?usp=sharing",
  "oxigeno" = "https://drive.google.com/drive/folders/1l9cn8voGE_ZatlgsUHCEQbYwPzlBy5N0?usp=sharing",
  "pandemia" = "https://drive.google.com/drive/folders/1IZa15HPPtwsJOHt7VXnJ0vw4zysK2cBW?usp=sharing",
  "PCR" = "https://drive.google.com/drive/folders/1goXSePiY3zq4Nbw7y-P8OPUvytZ67Anp?usp=sharing",
  "plasma" = "https://drive.google.com/drive/folders/1TFHa5ycXFFcmHc3xPvmTSnNU_EpKf-mI?usp=sharing",
  "pruebas covid" = "https://drive.google.com/drive/folders/1vwGHA9cOWc58b5TKq5Z96l2TjLc_JTpn?usp=sharing",
  "respirador" = "https://drive.google.com/drive/folders/1N1vYqImz-cRtZiLS8lHdX_vp0vRKA3gM?usp=sharing",
  "sanitizador" = "https://drive.google.com/drive/folders/19GWAbDxJh2i-dq1D4rAVZxIIZwlnH_u0?usp=sharing",
  "vacuna" = "https://drive.google.com/drive/folders/1GavIvVJUukSbepbNwyIA2gHwEDXnyCsV?usp=sharing"

)

# generar tablas

conteo_temas <- conteo_temas %>%
  mutate(
    datos = text_spec("Ver", link = links_datos),
    fichas = text_spec("Ver", link = links_fichas)
    )

conteo_temas %>%
  kbl(escape = F) %>%
  kable_material("hover") %>%
  save_kable("temas/tabla_resumen.html", bs_theme = "paper", self_contained = F)
