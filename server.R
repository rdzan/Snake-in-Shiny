function(input, output, session) {
  # ważne parametry 
  GAME <- pryr::where("session") 
  GAME$snake <- start_snake 
  GAME$direction <- start_direction 
  GAME$directionList <- character(0) 
  GAME$snake_length <- start_length 
  GAME$playing <- FALSE 
  GAME$counter <- 0 
  GAME$start_stop <- 0 
  GAME$score <- 0 
  GAME$loose <- FALSE 
  GAME$alertShow <- FALSE
  
  gameLevel <- reactive(level[[input$level]]) 
  
  # inicjalizuję snake'a
  food <- initializeSnake(snake = start_snake, n = height, m = width) 
  GAME$food <- food 
  
  observeEvent(input$start_stop, {
    # jeśli input$start_stop == 0 to znaczy że kliknąłem reset i nic nie robię
    if(GAME$start_stop == -1){
      GAME$playing <- FALSE 
      runjs("$('#start_stop').html('start');")
    }else if(GAME$start_stop %% 2 == 0){
      GAME$playing <- TRUE 
      runjs("$('#start_stop').html('pause');") 
    }else{
      GAME$playing <- FALSE 
      runjs("$('#start_stop').html('start');") 
    }
    GAME$start_stop <- GAME$start_stop + 1 
  }) 
  
  observeEvent(input$reset, {
    GAME$snake <- start_snake 
    GAME$direction <- start_direction 
    GAME$directionList <- character(0)  
    GAME$snake_length <- start_length 
    GAME$counter <- 0 
    GAME$score <- 0
    
    # inicjalizuję snake'a
    food <- initializeSnake(snake = start_snake, n = height, m = width) 
    GAME$food <- food 
    GAME$start_stop <- -1 
    runjs("Shiny.setInputValue('start_stop', Math.random());")
  })
  
  # co jaki czas snake ma się poruszać
  autoInvalidate <- reactiveTimer(intervalMs = snakeSpeedMs) 
  
  observeEvent(autoInvalidate(), {
    # ruch robię po pierwsze kiedy gram 
    if(GAME$playing){
      GAME$counter <- GAME$counter + 1 
      # po drugie w zależności od prędkości
      if(GAME$counter %% gameLevel() == 0){
        # no i ruszam snake'iem 
        
        # wyznaczam kierunek poruszania się snaka 
        GAME$direction <- getGameDirection(directionList = GAME$directionList, currentDirection = GAME$direction) 
        if(length(GAME$directionList) > 0){
          GAME$directionList <- GAME$directionList[-c(1)] 
        }
        
        # wyznaczam wsp. kartezjańskie głowy i ogona
        snakeHead <- numeric2cartesian(nm = GAME$snake[1], n = height, m = width) 
        
        # w zależności od kierunku poruszania się zmieniam pozycję głowy węża
        newSnakeHead <- switch(GAME$direction,
                               `up` = snakeHead + c(-1, 0),
                               `left` = snakeHead + c(0, -1),
                               `down` = snakeHead + c(1, 0),
                               `right` = snakeHead + c(0, 1) 
        )
        
        # jeśli wąż chce zjeść siebie bądź wychodzi poza pole gry to przegrywamy 
        if(newSnakeHead[1] < 1 | newSnakeHead[1] > height | newSnakeHead[2] < 1 | newSnakeHead[2] > width){
          # stopuje grę 
          GAME$playing <- FALSE 
          GAME$loose <- TRUE 
        } 
        
        # wracam z nową głową do numerica
        newSnakeHead <- cartesian2numeric(row = newSnakeHead[1], column = newSnakeHead[2], n = height, m = width)
        # jeśli zjadam siebie to przegrywam 
        if(newSnakeHead %in% GAME$snake){
          # stopuje grę 
          GAME$playing <- FALSE 
          GAME$loose <- TRUE 
        }
        
        if(GAME$loose){
          GAME$alertShow <- TRUE 
          scoresTable <- prepareScoresTable(currentScore = GAME$score, file = game_scores_files)
          
          GAME$loose <- FALSE
          shinyalert(title = sprintf("Your score: %s", GAME$score), 
                     text = scoresTable, html = TRUE,
                     closeOnEsc = TRUE,
                     closeOnClickOutside = TRUE,  
                     showCancelButton = FALSE,
                     showConfirmButton = FALSE,
                     callbackR = function(x){
                       shinyjs::click(id = "reset") 
                       GAME$alertShow <- FALSE}
                     ) 
          
          return(NULL) 
        }
        
        
        # jeśli nowa głowa węża jest na pozycji jedzenia to sporo się zmienia
        if(GAME$food == newSnakeHead){
          # karmię węża
          GAME$snake <- c(newSnakeHead, GAME$snake)
          GAME$snake_length <- GAME$snake_length + 1
          # losuję żarcie wężowi ale tak aby nie wpadło na samego siebie
          food <- sample(setdiff(0:(width * height - 1), GAME$snake), size = 1)
          GAME$food <- food 
          # dodaję punkty 
          score <- switch(gameLevel() , `1` = 20, `2` = 15, `3` = 10) 
          GAME$score <- GAME$score + score 
          runjs(sprintf("$('#punctation').html('Score: %s');", GAME$score)) 
          # i rozświetlam jedzonko
          addClass(as.character(food), class = "point-lights")
        }else{
          # zapalam nową głowę snake'a
          addClass(id = as.character(newSnakeHead), class = "point-lights")
          # i gaszę ogon snake'a
          removeClass(id = as.character(snake[GAME$snake_length]), class = "point-lights")
          # i uaktualniam snake'a
          GAME$snake <- c(newSnakeHead, GAME$snake[-c(GAME$snake_length)])
        }

      }
    }


  })
  
  observeEvent(input$changeDirection, {
    if(!GAME$alertShow){
      if(GAME$playing){
        n <- length(GAME$directionList) 
        lastDirection <- ifelse(n == 0, GAME$direction, GAME$directionList[n]) 
        
        if(lastDirection %in% c("left", "right") && input$userDirection %in% c("up", "down")){
          GAME$directionList <- c(GAME$directionList, input$userDirection) 
        }else if(lastDirection %in% c("up", "down") && input$userDirection %in% c("left", "right")){
          GAME$directionList <- c(GAME$directionList, input$userDirection) 
        }
      }else if((!GAME$playing)){
        if(length(GAME$directionList) == 0){
          # to oznacza że gra się nie zaczęła a user kliknął na strzałkę - wówczas rozpoczynam grę 
          var1 <- GAME$direction == "left" & input$userDirection != "right" 
          var2 <- GAME$direction == "right" & input$userDirection != "left" 
          var3 <- GAME$direction == "up" & input$userDirection != "down" 
          var4 <- GAME$direction == "down" & input$userDirection != "up" 
          if(var1 | var2 | var3 | var4){
            GAME$playing <- TRUE 
            GAME$start_stop <- GAME$start_stop + 1 
            runjs("$('#start_stop').html('pause');") 
            GAME$direction <- input$userDirection 
          }
        }else{
          # a to oznacza że gra się zaczęła ale ktoś kliknął pauzę
          GAME$playing <- TRUE 
          GAME$start_stop <- GAME$start_stop + 1 
          runjs("$('#start_stop').html('pause');") 
          
          n <- length(GAME$directionList) 
          lastDirection <- GAME$directionList[n] 
          
          if(lastDirection %in% c("left", "right") && input$userDirection %in% c("up", "down")){
            GAME$directionList <- c(GAME$directionList, input$userDirection) 
          }else if(lastDirection %in% c("up", "down") && input$userDirection %in% c("left", "right")){
            GAME$directionList <- c(GAME$directionList, input$userDirection) 
          }
        }
      }
    }
  })
} 
