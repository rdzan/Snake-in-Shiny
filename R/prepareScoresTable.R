
prepareScoresTable <- function(currentScore = GAME$score, file = game_scores_files){
  # zapisujemy wynik do pliku 
  write(x = currentScore, file = file, append = T) 
  allScores <- read.csv(file = file, header = T) 
  setDT(allScores) 
  n_scores <- nrow(allScores) 
  allScores[, Game := paste("Game", 1:n_scores)] 
  setcolorder(allScores, c("Game", "score")) 
  allScores[, lp := 1:n_scores] 
  setorder(allScores, - score) 
  allScores[, score := as.character(score)] 
  position <- allScores[, which(lp == n_scores)] 
  
  if(position <= 5){
    allScores <- allScores[1:min(5, n_scores), ] 
    allScores[position, Game := paste("<font color = 'black'><strong>", Game, "</strong></font>", sep = "")]  
    allScores[position, score := paste("<font color = 'black'><strong>", score, "</strong></font>", sep = "")] 
    allScores[, Position := as.character(1:.N)] 
    allScores[position, Position := paste("<font color = 'black'><strong>", Position, "</strong></font>", sep = "")]
  }else{
    allScores <- allScores[c(1:4, position),] 
    allScores[5, Game := paste("<font color = 'black'><strong color = 'black'>", Game, "</strong></font>", sep = "")]  
    allScores[5, score := paste("<font color = 'black'><strong color = 'black'>", score, "</strong></font>", sep = "")] 
    allScores[4, Game := "..."] 
    allScores[4, score := "..."] 
    allScores[, Position := c(1:3, "...", paste("<strong>", position, "</strong>", sep = ""))] 
  } 
  
  allScores[, lp := NULL] 
  setcolorder(allScores, c("Position", "Game", "score")) 
  allScoresTable <- kable(allScores, format = "html", escape = F, row.names = F, 
                          caption = "Your position",  padding = 2, 
                          align = c("c", "l", "r")) 
  
  allScoresTable <- kableExtra::column_spec(allScoresTable, column = 3 , width = "5em") 
  # allScoresTable <- kableExtra::column_spec(allScoresTable, column = 1 , width = "2em") 
  return(allScoresTable) 
}
