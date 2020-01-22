
getGameDirection <- function(directionList = GAME$directionList, currentDirection = GAME$direction){
  if(length(directionList) == 0){
    return(currentDirection)
  }else{
    return(directionList[1]) 
  }
} 
