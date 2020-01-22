createField <- function(n = height, m = width, pointWidth = pointWidth){
  pointCount <- n * m -  1 
  points <- paste("<div id = '", 0:pointCount, 
                  sprintf("' class = 'point' style = 'width: %spx; height: %spx;'>", pointWidth, pointWidth), 
                  "</div>", sep = "", collapse = "") 
  return(HTML(points)) 
} 
