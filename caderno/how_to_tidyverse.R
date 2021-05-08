# how to tidyverse
library(tidyverse)

# 0) Introdução ------------
# A) Non Standard Evaluation (NSE)
# O tidyverse tem uma coisa mágica, que se chama standard non evalutation (NSE)
# Non standard evaluation é uma propriedade do R que permite capturar o código sem avaliá-lo.
# Na standard evaluation as coisas são assim: você joga as informações nela, ela processa, mas não sabe o que você escreveu
# O R não... Ele deixa de ser uma caixinha que só recebe programas, sem saber o que está escrito ali, e passa a interpetar e trabalhar os próprios comandos
# Genericamente, isso se chama metaprogramação
# Isso está contido no Advanced R, que foi escrito pelo Hadley
# Esse livro tem toda a parte da ciência da computação por trás do R
# Isso está na parte de Metaprogramação
# O Python não é NSE !
# O NSE do R foi feito para as fórmulas do R

# A.1) delayed evaluation ------------
# A gente observa isso no library()
# Se a gente escreve simplesmente
dplyr
# a gente recebe Erro: objeto 'dplyr' não encontrado
# mas se a gente escreve
library(dplyr)
# funciona !
# Isso significa que a palavra "dplyr" dentro de library() não é um objeto!
# Isso pode parecer banal, mas nem todas linguagens conseguem fazer isso
# Outras linguagens iam tentar buscar o dplyr nos objetos
# E se elas tentassem buscar pelo dplyr, elas não iam encontrar ! E isso ia retornar erro
# Mas no R, essa avaliação (buscar o objeto e retornar algo) é tardia
# Esse fenômeno a gente chama de delayed evaluation
# A delayed evaluation é uma parte da non-standard evaluation

# A.2) tidy evaluation (tidy eval) ------------
# A faceta da NSE que nos interessa é a tidy eval.
# tidy eval é a NSE utilizada pelas funções do tidyverse e outros pacotes feitos para trabalhar no mesmo paradigma
# O mundo sem tidy eval é extremamente verborrágico, pois a tabela precisa ser especificada toda a vez que nos referirmos a uma coluna
# por exemplo, se eu quiser filtrar uma base de dados
starwars[starwars$homeworld == "Naboo" & starwars$species == "Human", ,]
# Para não precisar do $ (cifrão), a nossa única saída é criar objetos com colunas:
homeworld <- starwars$homeworld; species <- starwars$species
starwars[homeworld == "Naboo" & species == "Human"]
# No tidyverse, as coisas ficam mais fácil
tidyverse::filter(starwars, homeworld == "Naboo", species == "Human")
# O tidyverse consegue fazer isso porque ele não avalia o código antes de capturá-lo

# B) O problema do NSE, uma faca de dois legumes:
# O problema de capturar o código sem avaiá-lo é exatamente quando a gente quiser avaliar algo antes que ele seja caputardo
starwars %>%  filter(is.na(birth_year)) %>%  nrow()
filter_na <- function(df, col) {
  filter(df, is.na(col))
}
starwars %>%  filter_na(col = birth_year) %>%  nrow()
# Esse caso acima vai dar problema

# C) curly-curly
# Para resolver, a gente faz um curly-curly, que permite interpolar o código, ou seja, avaliá-lo antes da captura
filter_na <- function(df, col) {
  filter(df, is.na( {{col}} ))
}
starwars %>%  filter_na(col = birth_year) %>%  nrow()

# Essa sintaxe vem da interpolação de strings

col <- "birth_year"
stringr::str_glue("Interpolando '{col}'!")


# 2) Strings ------------
# Como enviamos strings para as funções do tidyverse?
# Se pedirmos o nome de uma coluna para um usuário, a resposta virá como string
summarise_mean <- function(df, nome, col) {
  summarise(df, nome = mean(col, na.rm = TRUE))
}
summarise_mean(starwars, "media", "height")

# Como resolver isso, usando STRINGS na esquerda
# A) Strings na esquerda
# Quando o lado esquerdo (antes de um igual) de uma expressão com tidy eval
# é uma string (ou se tornará uma quando avaliado), precisamos apenas usar o operador walrus (morsa), que é :=
summarise_mean <- function(df, nome, col) {
  summarise(df, {{nome}} := mean(col, na.rm = TRUE))
}
summarise_mean(starwars, "media", "height")
# Com isso, a gente resolve o problema no lado esquerdo, porque a gente recebe o argumento média
# mas ele ainda não conseguiu entender que o height deveria ser o col

# B) Strings na direita
# Quando uma string (ou algo que se tornará uma quando avaliado) está no "lado direito" (depois de um igual, ou quando não há igual)
# precisamos apenas usar o pronome .data
summarise_mean <- function(df, nome, col) {
  summarise(df, {{nome}} := mean(.data[[col]], na.rm = TRUE))
}
summarise_mean(starwars, "media", "height")
# Agora sim funcionou :D :D :D :D
# [[col]] significa receber strings, ao invés de objetos
