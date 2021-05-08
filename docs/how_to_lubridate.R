# how to lubridate

library(lubridate)
library(magrittr)

# 0) Introdução --------------
# lubridate é a lubrificação das datas
# é um pacote para tentar lidar com datas
# Data é um dos dados mais delicados que a gente vai encontrar
# Texto pode ser difícil de lidar, mas quando um texto da erro, é muito claro
# Em data, o problema pode passar desapercebido
# Alguns problemas:
# - locale (problema do idioma em que está sendo escrito o horário)
# - ano bissexto
# - horário de verão
# - formato da data
# - fuso horário

# A forma de lidar com isso, foi criar um padrão universal de tempo
# Esse horário universal é o Universal Time Coordination
# O UTC é a referência universal
# No ano novo de 1970, começou a Era Unix (Unix Epoch)
# Podemos ver quantos segundos se passaram desde então

now()
as.numeric(now())

# Este segundo, em cada lugar do mundo tem NOMES diferentes, mas ele é o mesmo

# O pacote lubridate tenta padronizar o máximo possível as datas e horários
# Para isso, ele vai usar o ISO 8601
# O padrão ISO 8601 é ano-mês-dia hora:minuto:segundo
# Esse padrão é interessante, porque ele é sempre do maior pro menor

# 1) Como converter horários para o padrão universal ----------------
# Então a primeira coisa que sempre queremos fazer com o lubridate é padronizar a data que temos, com um padrão universal do ISO 8601
# para isso, a gente usa a função:

# função data-hora
dmy_hms("12042021 022500")

# função só data
dmy("12/12/2020")

# essas duas funções recebem uma data e transformam e retornam no padrão ISO 8601
# no caso, elas receberam a data em padrão brasileiro e retornaram padrão ISo

# essa função funciona pra textoooo
dmy("15 abril 2017")

# mas se você quiser especificar qual é o locale, precisa especificar o locale

dmy("15 de abril de 2021", locale = "Portuguese_Brazil.1252") # Esse locale é a sintaxe pra Windows
# o locale para o Linux é locale = "pt_BR.UTF-8"
# Para os EUA o locale é locale = "en_US.UTF-8"

# O Excel salva as datas como o número de dias desde 01/01/1970.
# Isso é diferente do padrão de segundos
# Mas o lubridate supera isso com a função:

as_date(18732)

# 2) Fusos -----------
# Para lidar com fusos, a usa o argumento tzone = "" na função now

now(tzone = "Europe/London")

# Por default, ele usa o padrão locale do seu computador
# no meu caso, o meu default é o horário de Brasília BSB

# 3) Horário de verão
# Para saber se determinado locale está em horário de verão, usamos a função dst()
# Essa função recebe de argumentos só a data que a gente quer ler e o locale dela

dst(now(tzone = "Europe/London"))


# 3) Componentes -----------
# A gente tem uma função para cada componente
month(dmy("04/02/2013"))
year(now())

# 4) Operações -------------
dif <- dmy("15/04/2021") - dmy("24/08/2020")
dif

# Ele retorna por padrão em dias
# Se eu quiser alterar, eu tenho que dizer como eu quero que apareça
as_datetime(dif)

# 5) Casos interessantes -------

# como colocar horários em fuso
dmy_hms("15/03/2021 02:25:30", tz = "Europe/London")
# Essa função não me dá um horário no tempo de Londres
# Ela entende que a data e hora que eu dei foi de Londres

# como retornar dias da semana (retorna integer)
wday("2021-04-15")
# week day, ele retorna o dia da semana em que estamos
# 1 é domingo e 7 é sábado

# List de fusos
a<-OlsonNames()
a<-as.data.frame(a)

# Conversão de um horário UTC para SP (com fuso!)
with_tz(dmy_hms("15/02/2021 02:25:00"), tzone = "America/Sao_Paulo")

# arredondar
celling_date(today(), unit = "month") - 1

# 6) Output
# Como eu converto UTC para outro formato?
# %d --> dia
# %m --> mês
# %Y --> ano
# %H --> hora
# %M --> minuto
# %S --> segundo

format.Date(now(), "%d/%m/%Y")
# Isso pega um horário em UTC e converte para a data horário brasileira

# 7) Clock
# Isso é um pacote nove
library(clock)

# Esse pacote saiu faz 2 semanas (estou falando no dia 15 de abril de 2021)
# Ele resolve alguns problemas do lubridate e foi feito pelas mesmas pessoas
# O que ele muda?

# No lubridate, se você fizer
x <- ymd("2021-01-31")
x + months(1)
# Ele retorna NA, porque não existe 31 de fevereiro
# O problema é que ele não explica o motivo do NA

# Em clocks é diferente
# a gente faz assim
add_months(x, 1)
# é melhor, porque ele explica o motivo do NA

# 8) Contar prazos
# Normalmente pra contar prazos, a gente só usa dias úteis
# Pra isso, a gente precisa do pacote bizdays
library(bizdays)

#Pra usar os bizdays do brasil, a gente tem que se referir a ele como
# "Brazil/ANBIMA"

