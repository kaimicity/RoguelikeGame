abstract class Container {
  String type ;
  PVector position ;
  float width ;
  float height ;
  color textColor ;
  float textSize ;
  float strokeWidth ;
  String containerText ;
  PGraphics graphic ;
  PFont f ;
  boolean focused ;
  boolean chosen ;
  int cursorMark ;
  int cursorRound ;
  String shownNumber ;

  void draw() {
    graphic.noStroke() ;
    if (isChosen()) {
      graphic.stroke(255) ;
      graphic.strokeWeight(strokeWidth) ;
      graphic.fill(#3B3B3B) ;
      graphic.rect(position.x, position.y, width, height- strokeWidth) ;
    } else if (isFocused()) {
      graphic.fill(#3B3B3B) ;
      if (cursorMark < cursorRound / 2) {
        graphic.stroke(255) ;
        graphic.strokeWeight(strokeWidth) ;
      } else
        graphic.noStroke() ;
      cursorMark++ ;
      if (cursorMark == cursorRound)
        cursorMark = 0 ;
      graphic.rect(position.x, position.y, width, height- strokeWidth) ;
    } else {
      graphic.fill(0) ;
      graphic.rect(position.x, position.y, width, height) ;
    }
      graphic.noStroke() ;
      graphic.strokeWeight(1) ;
    graphic.fill(textColor) ;
    graphic.textFont(f) ;
    graphic.textSize(textSize) ;
    if (this.shownNumber == null) {
      graphic.textAlign(CENTER, CENTER) ;
      graphic.text(containerText, position.x + width / 2, position.y + height / 2) ;
    } else {
      graphic.textAlign(LEFT, CENTER) ;
      graphic.text(containerText, position.x + width / 20, position.y + height / 2) ;
      graphic.textAlign(RIGHT, CENTER) ;
      graphic.text(shownNumber, position.x + 19 * width / 20, position.y + height / 2) ;
    }
  }

  float getX() {
    return this.position.x ;
  }

  float getY() {
    return this.position.y ;
  }

  float getWidth() {
    return this.width ;
  }

  float getHeight() {
    return this.height ;
  }

  boolean isFocused() {
    return this.focused ;
  }

  boolean isChosen() {
    return this.chosen ;
  }

  void focus() {
    this.focused = true ;
  }

  void chosen() {
    this.chosen = true ;
    if(!this.focused)
      focus() ;
  }


  void defocus() {
    this.focused = false ;
  }

  void dechosen() {
    this.chosen = false ;
  }

  //abstract void generateText() ;
}
