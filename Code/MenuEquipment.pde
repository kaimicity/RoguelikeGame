class MenuEquipment extends Menu {
  float catalogSize ;
  float catalogLine ;
  float catalogHeight ;
  String[] itemCatalog = {"Weapon", "Armour", "Shoe"} ;
  color[] levelColors = {#FFFFFF, #00868B, #FFFF00} ;
  color[] colors = {#0000FF, #FF0000, #ABABAB, #8B6914} ;
  int catalogIndex = 0 ;
  int flashMark ;
  int flashRound ;
  MenuEquipment(Hero hero, int i, PGraphics pg) {
    this.hero = hero ;
    this.graphic = pg ;
    this.name = "Equipment" ;
    this.index = i ;
    this.catalogSize = pg.width / 35 ;
    this.catalogLine = pg.width / 5 ;
    this.catalogHeight = pg.height / 4 ;
    this.catalogIndex = 0 ;
    this.flashMark = 0 ;
    this.flashRound = 120 ;
  }

  void nextCatalog() {
    if (catalogIndex < 2 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      this.catalogIndex++ ;
    }
  }

  void lastCatalog() {
    if (catalogIndex > 0 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      catalogIndex-- ;
    }
  }

  void reset() {
    this.catalogIndex = 0 ;
  }
  
  void discharge(){
    switch(catalogIndex) {
    case 0 :
      hero.dischargeWeapon() ;
      break ;
    case 1 :
      hero.dischargeArmour() ;
      break ;
    case 2 :
      hero.dischargeShoe() ;
      break ;
    }
  }

  void draw() {
    graphic.beginDraw() ;
    graphic.background(0) ;
    flashStroke(127) ;
    graphic.fill(0) ;
    switch(catalogIndex) {
    case 0 :
      graphic.rect(graphic.width * 0.05, catalogHeight / 10, graphic.width * 0.9 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      break ;
    case 1 :
      graphic.rect(graphic.width * 0.05, catalogHeight + catalogHeight / 10, graphic.width * 0.9 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      break ;
    case 2 :
      graphic.rect(graphic.width * 0.05, 2 * catalogHeight + catalogHeight / 10, graphic.width * 0.9 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      break ;
    }
    for (int i = 0; i < 3; i++) {
      if ( i ==catalogIndex ) {
        graphic.strokeWeight(catalogHeight / 20) ;
        graphic.stroke(255) ;
        graphic.fill(0) ;
        graphic.rect(graphic.width * 0.3, catalogHeight * i +catalogHeight / 10, graphic.width * 0.2 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      } 
      graphic.textFont(f) ;
      graphic.textSize(catalogSize) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.fill(colors[i]) ;
      graphic.text(itemCatalog[i], graphic.width * 0.3, catalogHeight * i, graphic.width * 0.2, catalogHeight ) ;
    }
    graphic.textAlign(CENTER, CENTER) ;
    if (hero.getWeapon() != null) {
      graphic.fill(levelColors[hero.getWeapon().getLevel() - 1]) ;
      graphic.text(hero.getWeapon().getName(), graphic.width * 0.05, 0, graphic.width * 0.25, catalogHeight ) ;
      graphic.text("Attack+" + hero.getWeapon().getAttackPoint() + "  Critical Chance+" + hero.getWeapon().getCriticalPoint(), graphic.width * 0.5, 0, graphic.width * 0.4, catalogHeight ) ;
    }
    if (hero.getArmour() != null) {
      graphic.fill(levelColors[hero.getArmour().getLevel() - 1]) ;
      graphic.text(hero.getArmour().getName(), graphic.width * 0.05, catalogHeight, graphic.width * 0.25, catalogHeight ) ;
      graphic.text("Defence+" + hero.getArmour().getDefencePoint() , graphic.width * 0.5, catalogHeight, graphic.width * 0.4, catalogHeight ) ;
    }
    if (hero.getShoe() != null) {
      graphic.fill(levelColors[hero.getShoe().getLevel() - 1]) ;
      graphic.text(hero.getShoe().getName(), graphic.width * 0.05, 2 * catalogHeight, graphic.width * 0.25, catalogHeight ) ;
      graphic.text("Hit Point+" + hero.getShoe().getHitPoint()  + "  Dodge Point+" + hero.getShoe().getDodgePoint(), graphic.width * 0.5, 2 * catalogHeight, graphic.width * 0.4, catalogHeight ) ;
    }
      graphic.fill(255) ;
      graphic.text("Press 'D' to discharge!", graphic.width * 0.4, catalogHeight * 3.5 ) ;
    graphic.endDraw() ;
  }

  void flashStroke(int c) {
    if (flashMark < flashRound / 2)
      graphic.stroke(c) ;
    else
      graphic.stroke(0) ;
    flashMark++ ;
    if (flashMark == flashRound)
      flashMark = 0 ;
  }
}
