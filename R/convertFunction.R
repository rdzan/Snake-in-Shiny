
numeric2cartesian <- function(nm = 14, n = height, m = width){
  # wiersz 
  row <- (nm %% n) + 1 
  # kolumna 
  column <- (nm %/% n) + 1 
  return(c(row, column)) 
} 

cartesian2numeric <- function(row = 2, column = 3, n = height, m = width){
  nm <- (column - 1) * n + row - 1 
  return(nm) 
}
