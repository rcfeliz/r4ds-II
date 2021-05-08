# How to Purrr

library(purrr)

# 0) Introdução ----------------
# O purrr trabalha com (a) listas e (b) iterações
# É estranho falar de listas, porque no R, normalmente a gente fala de data frames e de vetores
# Mas na verdade, todas as datas frames são, no fundo, listas com características específicas

# Depois que você entende purrr, isso pode mudar para sempre como você programa no geral
# Porque o purrr vai ensinar um padrão muito robusto de programação, que vai evitar efeitos colaterais e repetição de código
# Isso porque o purrr traz muito de sua sintaxe da programação funcional, que é uma programação muito interessante, mas pouco ensinada


# O que é uma lista? É uma sequência de elementos, assim como os vetores, mas as listas não precisam ser uma sequência de elementos homogêneos
# A lista pode ser uma sequência de elementos heterogêneos, ou seja, elementos de tipos/classes diferentes

# Vamos começar criando uma lista
l <- list(
  um_numero = 123,
  um_vetor = c(TRUE, FALSE, TRUE),
  uma_string = "abc",
  uma_lista = list(1,2,3)
)

l2 <- list("a", "b", 8, l3)
l3 <- list(1,8,"oba", l)
# A primeira função que vamos ver a função str()
# str() significa structure. O que essa função retorna é a caracterização da lista
str(l)

# 1) Indexação ---------------
# A questão principal da lista é: como a gente acessa elementos dentro de uma lista?
# Para isso, a gente tem que aprender a diferença entre colchete [] e colchete duplo [[]]
# O colchete acessa uma posição da lista, enquanto o colchete duplo acessa um elemento
# Podemos pensar no primeiro colchete dando o número da rua (casa 25), enquanto o colchete duplo diz respeito às pessoas que moram ali dentro, ou seja, o conteúdo daquele elemento
# vamos ver uns exemplos

l[3]
# Aqui eu to pegando a 3º posição da lista, no caso, uma_string

l[[3]]
# Neste segundo caso, eu não to pegando a 3ª posição, mas o próprio elemento dentro dela, no caso, "abc"

# 2) Indexação profunda ---------------
# E ai eu posso fazer uma indexação profunda
pluck(l, 4, 2)
# No caso do pluck, a gente ta pegando a 4ª posição, no caso, uma_lista.
# A posição uma_lista possui mais 3 posições (1, 2 e 3). No caso, eu estou pegando a 2ª posição.

# Brincando com o pluck
l1 <- list(
  um_numero = 123,
  um_vetor = c(TRUE, FALSE, TRUE),
  uma_string = "abc",
  uma_lista = list(1,
                   2,
                   3,
                   l2)
)

l2 <- list(c(1,2,3), "a", "b", 8, l3)
l3 <- list(1,8,"oba")
# Para acessar o "oba", eu faço assim:
pluck(l1, 4, 4, 5, 3)


# Se os elementos possuem nomes, fica mais fácil... Porque o tab ajuda

# 3) Iterações -----------------
# Iteração é a repetição de um trecho do código várias vezes
# Normalmente, a gente associa a iteração a um loop ou um laço (ou seja, um for ou while)

# Vamos começar com um vetor simples
vec <- 1:5
for (i in seq_along(vec)) {
  vec[i] <- vec[i] + 10
}
# Aqui a gente usou a função seq_along()
# Isso é diferente de...
for (i in vec) {
  print(i)
}
# Se eu quero ALTERAR os números do vetor original, a forma "i in vec" não funciona
# para isso, eu preciso trocar o vec para seq_along(vec)
# seq_along() significa "sequência ao longo do vetor"

# A) map()
# O PROBLEMA: Mas se a gente tentar aplicar um for() pra list, não funciona
# Pra arrumar isso, a gente tem que fazer uma função
soma_dez <- function(x) {
  x + 10
}
# e depois de criar uma função, a gente usa, não o for(), mas o map()
l <- map(vec, soma_dez)
# O map recebe dois argumentos, a entrada, no caso, o vec; e a função que a gente quer aplicar
# Mas o map SEMPRE retorna uma lista
str(l)

# B) achatamento
# A map() não pode assumir nada sobre o resultado, então ele sempre retorna list()
# E como a gente transforma isso em algo que não seja list() ?
# Para isso, a gente vai usar a família map_***(), em que *** é a abreviação de qualquer tipo de objeto que deve ser retornado
# Então o que a gente faz é:
map_dbl(vec, soma_dez)
# Os tipos possíveis são
  # dbl (números),
  # chr (strings),
  # dfc (data frame columns),
  # dfr (data frame rows), --> Antigamente, a gente usava map_df, mas vamo usar o map_dfr no lugar do map_df
  # int (inteiros)
  # lgl (lógicos).
  # raw. E tem também o raw para caracteres binários

# C) FUnções
# Agora a gente já sabe achatar, como a gente comprime para não sair sempre uma lista
# No exemplo passado, a gente criou a função soma_dez por fora, e a função não tinha argumentos
# e se a função for
soma_n <- function(x, n) {
  x + n
}
map(vec, soma_dez, n = 3)
# Então veja, a função soma_n() foi definida com dois argumentos, x e n.
# Na função anterior não tinha n, porque era um valor fixo, 10
# e o que a gente faz é definir o n = ? na própria função map()

# Mas e se eu não tivesse criado a função soma_n() antes?
# Nesse caso, eu precisaria criar uma função lambda
# Se a gente lembrar da aula sobre dplyr1.0, a gente viu lambda lá.
# Ao invés de eu passar a função para o map, eu iria passar a DEFINIÇÃO da função para o map()
# Acompanhemos essa sequência. Vamos passar do método com definição da função global para uma função lambda

# 1 - começamos assim
f <- function(x) {
  x + 3
}
map_dbl(1:10, f)

# 2 - podemos, ao invés de CHAMAR, o f para dentro da função, construir a própria função dentro do map()
map_dbl(1:10, f <- function(x) {
  x + 3
})

# 3 - mas no R, quando a função só tem uma linha, não precisamos das chaves {}
map_dbl(1:10, f <- function(x) x + 3)

# 4 - E se a gente quiser tirar o function(x), a gente faz a função lambda
map_dbl(1:10, ~ .x + 3)
# ~ indica uma função
# . indica um argumento, no caso, o argumento x, por isso .x
# Isso só pode ser usado nas funções em que podem ser usadas funções arbitrárias
# Para saber se uma função pode receber um lambda, você tem que ver a documentação

# D) map2()
strings <- c("oiii", "como vai", "tchau")
padroes <- c("i+", "(.o){2}", "[au]+$")
map2_chr(strings, padroes, stringr::str_extract)
# A notação lambda aqui funciona extamente do mesmo modo que no map(),
# a única diferença é que a gente acrescenta o .y
# em que .y representa o segundo argumento
# muito importante é: todos os argumentos que a gente usa devem ter o mesmo tamanho, ou seja, os dois vetores devem ter a mesma length()

# Se a gente olhar para o exemplo acima, a gente tem que chamar a atenção para o seguinte fato:
# a função str_extract() é definida, EM ORDEM, por dois argumentos: string e pattern
# Então quando a gente usou a função map2_chr(), a gente teve que apresentar na mesma ordem a string e os padroes
# Se a gente tentar inverter a ordem das coisas, vai dar ruim
map2_chr(padroes, strings, stringr::str_extract)

stringr::str_extract()

# 4) list-columns
# Uma lista-column são colunas em que cada elemento é uma lista, ou uma tabela completa
# a função str_split(), por exemplo, retorna uma lista contendo os pedações da string original quebrada com regex
imdb <- readr::read_rds("C://Users/ABJ/Documents/curso-r/r4ds-II/data/imdb.rds")

imdb %>%
  dplyr::mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  dplyr::select(titulo, generos, split_generos)
# Isso aqui criou a coluna split_generos, em que o tipo é lista

# A) unnest()
imdb %>%
  dplyr::mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  dplyr::select(titulo, generos, split_generos) %>%
  unnest(split_generos)
# Isso aqui faz com que cada elemento da lista se repita, então por exemplo, um filme que aparecia 1 vez e tinha 4 gêneros, se torna 4 linhas, cada uma com gênero único

imdb %>%
  dplyr::mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  dplyr::select(titulo, generos, split_generos)
