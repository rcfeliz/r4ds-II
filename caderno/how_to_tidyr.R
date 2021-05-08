# How to tidyr
library(tidyr)
library(magrittr)
library(dplyr)

imdb <- readr::read_rds("data/imdb.rds")

# 1) separate() -----------

imdb %>%
  separate(
    # O que a gente vai quebrar?
    col = generos,
    # Aqui precisa estar em aspas, porque não são colunas que existem ainda, mas são colunas que serão criadas
    into = c("genero1", "genero2", "genero3"),
    # Qual é o indicador do que a gente quer separar?
    sep = "\\|"
  )

# 2) unite() -----------

imdb %>%
  unite(
    col = "elenco",
    starts_with("ator"),
    sep = " - "
  )

# 3) pivotagem -----------
# a pivotagem é transformar dados longos em dados largos; e dados largos em dados longos.
# antigamente, a gente usava gather() e spread()

# 3A) pivot_longer() -----------
a <- imdb %>%
  pivot_longer(
    cols = starts_with("ator"),
    names_to = "protagonismo",
    values_to = "ator_atriz"
  ) %>%
  dplyr::select(titulo, ator_atriz, protagonismo)

# 3B) pivot_wider() -----------
b <- a %>%
  pivot_wider(
    names_from = "protagonismo",
    values_from = "ator_atriz"
  ) %>%
  dplyr::select(1:3, starts_with("ator"))

# 4) List columns ----------------
# 4A) nest() ------------
imdb_nest <- imdb %>%
  group_by(ano) %>%
  nest() %>%
  arrange(ano)

imdb_nest

imdb_nest$data[[1]]

# Isso é muito útil quando a gente estiver usando o purrr::map()

# 4B) unnest() ------------
# O unnest() pega a coluna aninhada e expande

imdb_nest
