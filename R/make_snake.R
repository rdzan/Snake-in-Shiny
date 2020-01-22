
make_snake <- function(length, n = height, m = width){
  vec <- 0:(start_length - 1) 
  start_rows <- ceiling(n/2) 
  start_column <- ceiling(m/2) 
  snake <- sapply(vec, function(x){
    cartesian2numeric(row = start_rows, column = start_column + x, n = n, m = m)
  }) 
  return(snake) 
} 
