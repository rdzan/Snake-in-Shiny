
initializeSnake <- function(snake, n = height, m = width){
  # na wszelki wypadek gaszę całego węża 
  sapply(as.character(0:(n * m - 1)), removeClass, class = "point-lights") 
  # rozświetlam węża
  sapply(as.character(snake), addClass, class = "point-lights") 
  # losuję żarcie wężowi ale tak aby nie wpadło na samego siebie 
  food <- sample(setdiff(0:(n * m - 1), snake), size = 1) 
  # i rozświetlam jedzonko 
  addClass(as.character(food), class = "point-lights")
  # kasuje punkty 
  runjs(sprintf("$('#punctation').html('Score: %s');", 0)) 
  return(food) 
} 
