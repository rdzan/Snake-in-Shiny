
# biblioteki 
library(shiny) 
library(shinyjs) 
library(shinyBS) 
library(shinyWidgets) 
library(shinyalert) 
library(knitr) 
# library(kableExtra) 
library(data.table) 

# source funkcji pomocniczych 
sapply(list.files("R"), function(x){source(paste("R", x, sep = "/"), local = F)})
# source(file = "R/convertFunction.R", local = F) 
# source(file = "R/createField.R", local = F) 
# source(file = "R/initializeSnake.R", local = F) 
# source(file = "R/make_snake.R", local = F) 
# source(file = "R/getGameDirection.R", local = F) 
# source(file = "R/prepareScoresTable.R", local = F) 

# parametry pola gry 
width <<- 20 
height <<- 13 
pointWidth <<- 15 

# parametry węża ( 1 <= start_length <= width/2 ) 
start_length <<- 3  
start_direction <<- "left" 
snakeSpeedMs <<- 75 

# parametry gry - ruch co x milisekund
level <<- list(`low` = 3, `medium` = 2, `height` = 1) 

game_scores_files <<- "scores.csv" 
if(!file.exists(game_scores_files)){
  write.csv(data.frame(score = numeric(0)), file = game_scores_files, row.names = F, col.names = T) 
}

# początkowy wąż 
start_snake <<- make_snake(length = start_length, n = height, m = width) 
