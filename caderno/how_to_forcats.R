# How to forcats

library(forcats)

# 0) Introdução ------
# Para entender o forcats, a gente precisa entender o que são factors
# factors são um tipo no R, que significa "categorias".
# A gente poderia ter tudo como String, mas o R faz essa distinção
# Essa distinção é importante porque o R é um software estatístico
# e na estatística existem variáveis categóricas
# então dados categóricos não são strings, mas são factors

# o que o forcats faz é dar um número para as categorias

x <- as_factor(c("baixo", "médio", "baixo", "alto", NA))
# essa é a função básica. Ela transforma factors em números
# se a gente ver o x, vamos ver que ela fala de níveis
# esses níveis
# (a) seguem a ordem que a gente declarou,
# (b) exclui os NAs,
# (c) exclui os repetidos, considerando o primeiro

# Todas as funções começam com fct_

# 1) Principais funções

# remover níveis sem representantes
fct_drop(x[x != "médio"])

fct_relabel(x, stringr::str_to_upper)

fct_c(x, as_factor(c("altíssimo", "perigoso")))

# re-nivelar (trazer níveis para frente)
(x2 <- fct_relevel(x, "alto", "médio"))

# transformar a ordem dos elementos no ordenamento do fator
fct_inorder(x2, ordered = TRUE)

# transformar a ordem dos níveis no ordenamento do fator
as.ordered(x2)

# usar um vetor para reordenar (útil no mutate())
fct_reorder(x, c(2,1,3,10,0), .fun = max)
# no lugar do c() eu poderia colocar um coluna !

# alterar manualmente os níveis
lvls_revalue(x, c("B", "M", "A"))
