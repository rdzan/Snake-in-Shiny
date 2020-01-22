$(document).on("keydown", function (e) {
  if (event.keyCode === 38) {
    Shiny.onInputChange("userDirection", "up"); 
  }else if(event.keyCode === 37){
    Shiny.onInputChange("userDirection", "left"); 
  }else if(event.keyCode === 40){
    Shiny.onInputChange("userDirection", "down"); 
  }else if(event.keyCode === 39){
    Shiny.onInputChange("userDirection", "right"); 
  } 
  Shiny.onInputChange("changeDirection", Math.random()); 
});
