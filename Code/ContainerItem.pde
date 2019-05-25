class ContainerItem extends Container{
  Item item ;
  color[] colors = {#FFFFFF, #00868B, #FFFF00} ;
  
  ContainerItem(float x, float y, float w, float h, Item i, PGraphics pg){
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.textSize = width / 15 ;
    this.strokeWidth = width / 30 ;
    this.item = i ;
    this.textColor = colors[item.getLevel() - 1] ;
    this.graphic = pg ;
    this.focused = false ;
    this.chosen = false ;
    this.cursorMark = 0 ;
    this.cursorRound = 60 ;
    this.containerText = item.getName() ;
    this.shownNumber = "x" + item.getNumber() + "" ;
    this.f = Roguelike.hintF ;
  }
  
  Item getItem(){
    return this.item ;
  }
  
  void refreshNumber(){
    this.shownNumber = "x" + item.getNumber() + "" ;
  }
  
}
