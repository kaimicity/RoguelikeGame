class MenuList {
  ArrayList menus ;
  PGraphics listGraphic ;
  float tagWidth ;
  float tagHeight ;
  float tagTextSize ;
  int index ;
  PFont f = createFont("Bradley Hand ITC.ttf", width / 20);
  MenuList(ArrayList ms, PGraphics lpg) {
    this.menus = ms ;
    this.listGraphic = lpg ;
    this.index = 0 ;
    this.tagWidth = lpg.width / ms.size() ;
    this.tagTextSize = tagWidth / 10 ;
  }

  String getMenuName() {
    return ((Menu)(menus.get(index))).getName() ;
  }


  void setIndex(int i) {
    index = i ;
  }
  void switchLeft() {
    if (index > 0) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      index -- ;
      ((Menu)menus.get(index)).reset() ;
    }
  }

  void switchRight() {
    if (index < menus.size() - 1) {
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      index ++ ;
      ((Menu)menus.get(index)).reset() ;
    }
  }

  void draw() {
    listGraphic.beginDraw() ;
    listGraphic.background(0) ;
    for (int i = 0; i < menus.size(); i++ ) {
      if ( i != index) {
        listGraphic.fill(#BEBEBE) ;
        listGraphic.stroke(255) ;
        listGraphic.strokeWeight(tagWidth / 20) ;
        listGraphic.rect(i * tagWidth, 0, tagWidth, listGraphic.height) ;
        listGraphic.textFont(f) ;
        listGraphic.textSize(tagTextSize) ;
        listGraphic.textAlign(CENTER, CENTER) ;
        listGraphic.fill(0) ;
        listGraphic.text(((Menu)(menus.get(i))).getName(), tagWidth * i + tagWidth / 2, listGraphic.height / 2) ;
      } else {
        listGraphic.fill(0) ;
        listGraphic.noStroke() ;
        listGraphic.rect(i * tagWidth, 0, tagWidth, listGraphic.height) ;
        listGraphic.textFont(f) ;
        listGraphic.textSize(tagTextSize) ;
        listGraphic.textAlign(CENTER, CENTER) ;
        listGraphic.fill(255) ;
        listGraphic.text(((Menu)(menus.get(i))).getName(), tagWidth * i + tagWidth / 2, listGraphic.height / 2) ;
      }
    }
    listGraphic.endDraw() ;
    Menu m = ((Menu)(menus.get(index))) ;
    m.draw() ;
  }
}
