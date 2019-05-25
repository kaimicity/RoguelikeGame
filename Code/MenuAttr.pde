class MenuAttr extends Menu {
  float textSize ;
  float margin ;
  float marginTop ;
  float lineHeight ;
  PShape healthTube ;
  Individual hero ;
  MenuAttr(Individual hero, int i, PGraphics pg) {
    this.hero = hero ;
    this.graphic = pg ;
    this.name = "Attribute" ;
    this.index = i ;
    this.textSize = pg.width / 30 ;
    this.margin = pg.width / 10 ;
    this.marginTop = pg.height / 5 ;
    this.lineHeight = pg.height / 10 ;
  }

  void draw() {
    graphic.beginDraw() ;
    graphic.background(0) ;
    graphic.fill(255) ;
    graphic.textFont(f) ;
    graphic.textSize(textSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("LV." + hero.getLevel() + "  " + hero.getName(), margin, marginTop) ;
    graphic.textAlign(RIGHT, CENTER) ;
    graphic.text("EXP. " + hero.getExp()+" / " + hero.getLevelUpExp(), graphic.width - margin, marginTop) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("HP ", margin, marginTop + lineHeight) ;
    graphic.stroke(255) ;
    graphic.fill(0) ;
    graphic.rect(graphic.width / 5, marginTop + lineHeight - graphic.height / 40, 
      7 * graphic.width / 10, graphic.height / 20) ;
    graphic.noStroke() ;
    graphic.fill(255, 0, 0) ;
    graphic.rect(graphic.width / 5 + 1, marginTop + lineHeight - graphic.height / 40 + 1, 
      hero.getHealth() * 7 * graphic.width / 10 / hero.getMaxHealth() - 1, graphic.height / 20 - 1) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(255) ;
    graphic.text(hero.getHealth() + " / " + hero.getMaxHealth(), 11 * graphic.width / 20, marginTop + lineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("MP ", margin, marginTop + 2 * lineHeight) ;
    graphic.stroke(255) ;
    graphic.fill(0) ;
    graphic.rect(graphic.width / 5, marginTop + 2 * lineHeight - graphic.height / 40, 
      7 * graphic.width / 10, graphic.height / 20) ;
    graphic.noStroke() ;
    graphic.fill(#191970) ;
    graphic.rect(graphic.width / 5 + 1, marginTop + 2 * lineHeight - graphic.height / 40 + 1, 
      hero.getMagic() * 7 * graphic.width / 10 / hero.getMaxMagic() - 1, graphic.height / 20 - 1) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(255) ;
    graphic.text(hero.getMagic() + " / " + hero.getMaxMagic(), 11 * graphic.width / 20, marginTop + 2 * lineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("ATTACK: " + hero.getAttack(), margin, marginTop + 3 * lineHeight) ;
    graphic.textAlign(RIGHT, CENTER) ;
    graphic.text("DEFENCE: " + hero.getDefence(), graphic.width - margin, marginTop + 3 * lineHeight) ;    
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("HIT POINT: " + hero.getHitPoint(), margin, marginTop + 4 * lineHeight) ;
    graphic.textAlign(RIGHT, CENTER) ;
    graphic.text("DODGE POINT: " + hero.getDodgePoint(), graphic.width - margin, marginTop + 4 * lineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("CRITICAL CHANCE: " + hero.getCriticalChance() + "%", margin, marginTop + 5 * lineHeight) ;
    graphic.endDraw() ;
  }
  
  void reset(){
    return ;
  }
}
