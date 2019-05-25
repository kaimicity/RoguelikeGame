class ContainerSpell extends Container {
  Spell spell ;
  HashMap colors = SpellsAndItems.getAllElementColors() ;
  
  ContainerSpell(float x, float y, float w, float h, Spell s, PGraphics pg){
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.textSize = width / 15 ;
    this.strokeWidth = width / 30 ;
    this.spell = s ;
    this.textColor = (color)(colors.get(s.getElement())) ;
    this.graphic = pg ;
    this.focused = false ;
    this.chosen = false ;
    this.cursorMark = 0 ;
    this.cursorRound = 60 ;
    this.containerText = spell.getName() ;
    this.shownNumber = null ;
    this.f = Roguelike.hintF ;
  }
  
  Spell getSpell(){
    return spell ;
  }
  
  
}
