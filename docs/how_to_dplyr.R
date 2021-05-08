# How to dplyr

# 0) Intro --------------
library(dplyr)
library(magrittr)

# Pra fazer essa análise, vamos usar a base de dados de Ames, sobre venda de imóveis na cidade de Ames, nos Estados Unidos

remotes::install_github("cienciadedatos/dados")
casas <- dados::casas
glimpse(casas)

# As 5 funções básicas que já conhecemos
filter()
select()
mutate()
group_by()
summarise()

# O que vamos ver
across()
rowwise()
select()
rename()
relocate()


# 1) across() -----------------
# O across substitui três familias de at(), if() e all().

# 1A) Como o across() substitui o summarise_at() ? -------------
# Do jeito mais bruto, a gente faria o seguinte

casas %>%
  group_by(geral_qualidade) %>%
  summarise(
    lote_area_media = mean(lote_area, na.rm = TRUE),
    venda_valor_medio = mean(venda_valor, na.rm = TRUE)
  )

# De um jeito mais sofistificado, a gente usaria

casas %>%
  group_by(geral_qualidade) %>%
  summarise_at(
  # sumarisar onde
    # quais variáveis eu quero aplicar a função
    .vars = vars(lote_area, venda_valor),
    # a função que eu vou aplicar para todas as variáveis
    .funs = ~mean(.x, na.rm = TRUE)
          # Essa forma de escrever é uma função do tipo lambda
  )

# Agora com o across(), a gente faria o seguinte

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    # .cols substitui o .vars; mas antes a gente precisava aplicar a função dplyr:::vars(). Agora podemos fazer isso só com um vetor
    .cols = c(lote_area, venda_valor), # variaveis
    .fns = mean, # funcao
    na.rm = TRUE # qualquer outro argumento "..."
  ))

# E eu posso usar esse .fns com várias funções a aplicar pra todas as colunas

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns = list(mean, median),
    na.rm = TRUE
  ))

# mas ele nomeia de um jeito feio, nos resultados. Pra superar isso, podemos fazer uma lista nomeada

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns = list(media = mean, mediana = median),
    na.rm = TRUE
  ))

# mas eu posso renomear usando um argumento .names

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns = list(media = mean, mediana = median),
    na.rm = TRUE,
    .names = "{.fn}_{.col}"
  ))

# 1B) Como o across() substitui o summarise_all() ? -------------
# Se eu tirar o parâmetro .cols, eu vou replicar um "summarise_all"

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .fns = list(media = mean, mediana = median),
    na.rm = TRUE,
    .names = "{.fn}_{.col}"
  ))

# 1C) Como o across() substitui o summarise_if() ? -------------
# E agora eu posso ver com replicar o summarise_if()

# Como a gente fazia
casas %>%
  group_by(geral_qualidade) %>%
  summarise_if(
    .predicate = is.numeric,
    .funs = ~mean(.x, na.rm = TRUE)
  )

# Como a gente vai fazer com o across()
casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    # eu substituo o c() para where()
    .cols = where(is.numeric),
    .fns = mean, na.rm = TRUE
  ))


# 1D) Misturando summarise_if() e summarise_at() --------
casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    where(is.numeric) & ends_with("_area"),
    # where é o que faz o across se funcionar como summarise_if()
      # É importante notar que o where vai testar se cada coluna respeita a regra. Então são funções que retornam TRUE ou FALSE
    # ends_with("_area") é o que faz o across funcionar como summarise_at()
      # O ends_with não retorna TRUE ou FALSE, ele está selecionando colunas. Virtualmente, ele está retornando um conjunto de colunas que respeitam a essa regra.
      # É um pouco errado dizer que o ends_with retorna um vetor, porque isso não acontece de fato. Mas da para ler desta forma; o comportamento dele é as if se ele retornasse isso.
    na.rm = TRUE
  ))

# 1E) Aplicando .fns diferentes para .cols diferentes -------------
casas %>%
  group_by(geral_qualidade) %>%
  summarise(
    across(
      contains("area"),
      mean, na.rm = TRUE
    ),
    across(
      where(is.character),
      ~sum(is.na(.x))
      # Por que nessa especificação eu tive que usar o lambda?
      # O argumento me exige que eu coloque APENAS UMA função, mas nesse caso, eu to aplicando duas funções (a) is.na() e (b) sum()
      # O lambda é sempre lido como uma função única. Então quando eu faço is.na() e sum() juntos dentro de um lambda, o R não entende como duas funções diferentes, mas como uma única
    ),
      n_obs = n()
  ) %>%
  select(1:4, n_obs)

# 1F) E para substituir funções que não são summarise() ?

select(where())
filter(where())

# 2) rowwise() ---------------

# 3) select() ---------------

# 4) rename() ---------------

# 5) relocate() ---------------


# Exercício ------------

# Ex 1
ex1a <- casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    c(acima_solo_area, garagem_area, venda_valor),
    mean,
    na.rm = TRUE,
    .names = "{.col}_media"
  ))

ex1b <- casas %>%
  filter(across(
    c(porao_qualidade, varanda_fechada_area, cerca_qualidade),
    ~!is.na(.x)
  ))

ex1c <- casas %>%
  mutate(across(
    where(is.character),
    ~tidyr::replace_na(.x, replace = "Não possui")
  ))

# Ex 2

ex2a <- casas %>%
  mutate(venda_valor_categorias = case_when(
    venda_valor <= 12950 ~ "barata",
    (venda_valor > 12950) & (venda_valor <= 180796) ~ "preço mediano",
    (venda_valor > 180796) & (venda_valor <= 213500) ~ "cara",
    venda_valor > 213500 ~ "muito cara"
  ))

ex2b <- ex2a %>%
  group_by(venda_valor_categorias) %>%
  summarise(across(
    contains("area"),
    list(media = mean),
    na.rm = TRUE
  ))

# Ex 3
# Aqui no exercício 3, eu fiquei em dúvida sobre o que colocar em cada filter()? Qual é a função que eu quero? Eu não quero só selecionar aquilo que contém "garagem"
ex3a <- casas %>%
  filter(across(
    contains("garagem"),
    ~!is.na(.x)
  ))

ex3b <- casas %>%
  filter(across(
    where(is.character),
    ~!is.na(.x)
  ))
