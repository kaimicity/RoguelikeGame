class Chip {
  PVector position ;
  float width ;
  float height ;
  int value ;
  PGraphics graphic ;
  int pickCounter ;
  boolean picked ;
  PFont f = createFont("Chalkduster.ttf", 10) ;

  Chip(float x, float y, float w, float h, PGraphics pg ) {
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.graphic = pg ;
    this.picked = false ;
    this.pickCounter = 0 ;
  }

  void pick() {
    this.picked = true ;
  }

  boolean isPicked() {
    return this.picked ;
  }
  PVector getPosition() {
    return this.position ;
  }

  float getWidth() {
    return this.width ;
  }

  float getHeight() {
    return this.height ;
  }

  void draw() {
    if (!picked){
      graphic.fill(#FFCC00) ;
      graphic.ellipse(position.x, position.y, width, height) ;
    }
  }
  
  void drawPicked(){
    if (pickCounter < 21) {
      color inter = color(#FFCC00,(20 - pickCounter) * 255 / 20) ;
      graphic.fill(inter) ;
      graphic.ellipse(position.x, position.y - pickCounter * (height / 2) / 20, width, height) ;
      //graphic.fill(#FFFFFF, (20 - pickCounter) * 255 / 20) ;
      graphic.textFont(f) ;
      graphic.textSize(width / 2) ;
      graphic.textAlign(LEFT, CENTER) ;
      graphic.text("Score+1", position.x + width / 2 + 5, position.y - pickCounter * (height / 2) / 20) ;
      pickCounter++ ;
    }
  }
}
