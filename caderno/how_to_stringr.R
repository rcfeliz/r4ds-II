# How to stringr

library(stringr)
library(magrittr)

# 0) Uma breve introdução a textos em geral ----------------
# Uma string é uma "cadeia" literalmente, uma sequência de caracteres.

# A) Como escapar caracteres
# Escapar caractere é usar um caracter NÃO no usuário padrão dele
# Para escapar um caractere, a gente coloca uma barra oblíqua para a esquerda \

print("Ele disse \"tal coisa\" e não gostei")

# Para não ver os caracteres escapados, a gente usa cat()

cat("Ele disse \"tal coisa\" e não gostei")

# A aspa é uma função que cria strings normalmente
# O que a gente quer fazer é usar o caractere aspa e não a função que indica string

# Outra escapada legal é o \u. O "u" normalmente é usado como o caractere u
# Mas o u pode significa unicode. Se a gente quiser que o u signifique unicode, a gente precisa escapar da sua função normal
# Sempre depois de um unicode, vem um código de 4 dígitos (sejam números ou letras, ou símbolos, seila)

print("Está 10\u00BAC lá fora")

# Outra forma de escapar caracter é usando aspas opostas para iniciar string e para printar
print("Ele disse 'tal coisa' e não gostei")
print('Ele disse "tal coisa" e não gostei')

# Quando a gente NÃO estiver no regex, vamos optar por essas duas formas de escape
# Não vamos usar o escape de \ em situações normais

# vamos começar a ver o stringr. Todas as funções dele são str_ALGO

# 1) Funções principais ----------------
# A) str_c
# o str_c() cola, em vetor textos
abc <- c("a", "b", "c")
str_c("prefixo-", abc, "-sufixo")

# B) str_length
# Contagem de caracteres na string (é muito parecido do length normal)
str_length("Contagem de Strings")
# Retorna o número de caracteres (e não palavras), incluindo espaços
# Então retorna um Integer

# C) str_detect
# O padrão existe na string?
str_detect("colando Strings", pattern = "ando")
# Retorna TRUE or FALSE

# D) str_extract[_all]
# Extrai um padrão da string. Extrai no sentido de retirar
str_extract("Colando Strings", pattern = "ando")
# Retorna só o padrão

# E) str_replace[_all]
# Substitui um padrão da string
str_replace("Colando Strings", pattern = "ando", replacement = "ei")
# Troca o pattern pelo replacement e retorna o texto novo

# F) str_remove[_all]
# Tira um padrão da string
str_remove("Colando Strings", pattern = " Strings")
# É importante colocar o espaço no pattern, porque senão vai ficar com o espaço na String e isso pode dar algum problema
# Retorna a String sem o padrão

# G) str_split
# Quebra a string em pedaços
str_split("Colando Strings", pattern = " ")
# o pattern determina onde vai ser quebrado
# Retorna um vetor de string e não uma lista
# Se ele retornasse uma lista, ele retornaria uma resposta para cada parte que foi quebrada
# Mas ele não retorna várias respostas, mas uma única

# H) str_squish
# Remove spaços extras da string
str_squish("          Colando      Strings  ")
# Ele não recebe parâmetro pattern
# Ele só tira espaços extras
# Com "espaços extras" quero dizer que fica preservado 1 espaço

# I) str_sub
# Extrair (subtract) um pedaço da string
str_sub("Colando String", start = 1, end = 7)
# Ao invés de patter, temos start e end
# Esses dois parâmetros recebem números
# Os números indicam a posição do caractere
# Então, juntos, eles indicam o intervalo dentro do qual

cep <- "04086-002"
bairro <- str_sub(cep, start = 1, end = 5)
loco <- str_sub(cep, start = 7, end = 9)
loco <- str_sub(cep, start=-3, end=-1)

# J) str_to_[lower/upper]
# Converte todos os caracteres para baixa baixa/alta
str_to_lower("ColAndo STRINgs")
# Retorna exatamente a mesma string, mas com tudo em caps baixo
# não recebe outros argumentos

# K) str_to[sentence/title]
# Converte a string para o formato frase ou título
# Ninguém nunca usa

# L) all ?
# A diferença das variações _all é que as funções pegam só a PRIMEIRA sequência
# Em alguns casos a gente talvez queira pegar TODAS AS VEZES que determinada sequência aparecer
# Então se a gente quiser todas as vezes em uma frase, e não só a primeira vez, a gente usa as variantes _all

# 2) Regex --------------
# Regex são REGular EXpressions, ou expressões regulares
# Expressões regulares são "programação para strings", permitindo extrair padrões complexos
# Os regex giram em torno de padrões "normais" de texto, mas com alguns símbolos especiais com significados específicos

# Um exemplo de um padrão normal
frutas <- c("banana", "TANGERINA", "maçã", "lima")
str_detect(frutas, pattern = "na")
# Ele faz distinição entre minúsculo e maiúsculo

# Um exemplo de um padrão com regex
str_detect(frutas, pattern = "^ma")
# Esse ^ significa início da string.
# Ou seja, esse pattern que eu coloquei foi "palavras que começam com ma"

# A) .
# Significa "qualquer caracter"
str_detect(frutas, pattern = ".m")
# Repare, nesse exemplo que "maçã" não se enquadra aqui
# Isso acontece porque maçã não tem "qualquer caractere" antes de m
# A posição do ponto indica onde deve estar o qualquer caractere

# B) ^
# Significa "começa com" e ele vai ANTES do padrão
str_detect(frutas, pattern = "^ma")

# C) $
# Significa "termina com" e ele vai NO FIM do pattern
str_detect(frutas, pattern = "a$")

# D) Escapando caracteres especiais
# Esses caracteres especiais são lidos sempre como caracteres especiais
# Mas então e se eu quiser buscar literalmente pelo caractere "$" ?
# Para escapar caracteres especiais, eu preciso usar o \\
ponto <- c("Teste", "Teste.")
str_detect(ponto, ".")
# Nesse caso, eu to detectando o pattern "qualquer caractere"
str_detect(ponto, "\\.")
# Nesse segundo caso, eu to detectando o pattern "."

# A regra de bolso é SEMPRE que estivermos dentro do regex, a gente usa duplas barras
# o que acontece é que a \ é um caracter especial do R, que significa escapar
# O que a gente precisa fazer então é escapar da barra de escape
# Por isso fica \\.

# E) Regex com quantidades + * ? {m,n}
# + = 1 ou mais vezes
# * = 0 ou mais vezes
# ? = 0 ou 1 vez
# {m,n} = entre duas quantidades
ois <- c("o", "i", "oi", "oii", "oiii!", "oioioi!")

# +
str_extract(ois, pattern = "oi+")
# Esses caracteres só se aplicam para o último caracter, e não para toda a sequência
# Neste caso em específico do exemplo, ele se aplica só para o "i", e não para o conjunto "oi"

# * e ?
str_extract(ois, "1+!?")
# Quando eu vou querer usar 0 ou mais? Isso é o caso do "ou não"
str_extract(ois, "i*")
# Nesse caso, ele sempre me retorna O MÍNIMO, por isso tem tantos "" (vazios)

# {m,n}
str_extract(ois, "oi{2,3}") # Entre 2 e 3 "i"s

# F) Conjuntos
# () Conjunto inquebrável
str_extract(ois, pattern = "(i!)$")
# Caso a gente queira verificar um conjunto de caracteres em bloco, e não eles individualmente, a gente precisa colocar entre parenteses o padrão

# [] Conjunto
str_extract(ois, pattern = "[i!]$")
# Conjunto é diferente de conjunto inquebrável.
# No conjunto, o que a gente está buscando é se ALGUM desses caracteres está no fim

# Tem alguns conjuntos especiais
frutas <- c("banana", "TANGERINA", "maçã", "lima")
str_extract(frutas, "[a-z]") # conjunto de qualquer letra minúscula
str_extract(frutas, "[A-Z]") # conjunto de qualquer letra maiúscula
str_extract(frutas, "[0-9]") # conjunto de qualquer número

# 3) Stringr com Regex ---------------
str_subset(c("ghion", "Guion", "Gxion"), pattern = "[Gg][hu]ion")
# Primeiro eu coloquei um vetor, com 3 strings diferentes
# Depois eu identifiquei um padrão nele
# O padrão é 1º caracter pode ser G ou g
# O 2º caractere pode ser h ou u
# Depois disso, é sempre "ion"

str_replace("Bom dia.", pattern = ".", replacement = "!")
str_replace("Bom. dia.", pattern = "\\.", replacement = "!")
str_replace_all("Bom. dia.", pattern = "\\.", replacement = "!")


# 4) Como lidar com acentos?
# Vamos usar o irmão do stringr, que é o stringi
library(stringi)

# A melhor opção é que a gente RETIRE os acentos de tudo
stringi::stri_trans_general("Váriös àçêntós", "Latin-ASCII")
# O "Latin-ASCII" é o que diz que são acentos da língua latina (aka o português)
stringr::str_extract("Número de telefone: (11) 99111-2059", "[a-z]+") # Olha o resultado disso
stringr::str_extract("Número de telefone: (11) 99111-2059", "[:alpha:]+") # E compara com isso
# No primeiro caso, o resultado foi "mero", porque a sequência Nú tem dois problemas: (a) N é maisúculo e (b) ú tem acento
# Se a gente quiser pegar qualquer caracter alpha, o que incluem acentos e maiúscula e minúscula, usamos o :alpha:

# 5) Para mais informações...
?stringi::about_search_regex()
