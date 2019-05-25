class Treasure {

  PVector position ;
  float width, height ;
  boolean isOpened ;
  int openCounter ;
  PGraphics graphic ;
  int level ;
  Item item ;

  Treasure(float x, float y, float w, float h, int level, PGraphics pg) {
    this.graphic = pg ;
    this.position = new PVector(x, y) ;
    this. width = w ;
    this.height = h ; 
    this.isOpened = false ;
    this.openCounter = 20 ;
    this.level = level ;
  }

  Item open(Hero h) {
    this.isOpened = true ;
    generateItem(h) ;
    h.getItem(item) ;
    return item ;
  }

  boolean isOpened() {
    return this.isOpened ;
  }

  PVector getPosition() {
    return this.position;
  }

  float getWidth() {
    return this.width ;
  }

  float getHeight() {
    return this.height ;
  }

  void draw() {
    graphic.fill(#FFCC00) ;
    if (!isOpened) 
      graphic.rect(position.x, position.y, width, height) ;
    else {
      graphic.rect(position.x, position.y, width, 2 * height / 5) ;
      graphic.rect(position.x, position.y + 3 * height / 5, width, 2 * height / 5) ;
      if (openCounter > 0) {
        graphic.rect(position.x, position.y + 2 * height / 5, width, openCounter * height / 100) ;
        openCounter-- ;
      }
    }
  }
  
  void generateItem(Hero h){
    int itemlevel = level / 5 ;
    if(itemlevel > 3)
      itemlevel = 3 ;
    ArrayList cata = new ArrayList() ;
    cata.add("Medicine") ;
    if(h.needWeapon(itemlevel + 1))
      cata.add("Weapon") ;
    if(h.needArmour(itemlevel + 1))
      cata.add("Armour") ;
    if(h.needShoe(itemlevel + 1))
      cata.add("Shoe") ;
    ArrayList choices = SpellsAndItems.produceTreasure(itemlevel + 1, cata) ;
    int choice = (int)Math.floor(Math.random() * choices.size()) ;
    item = (Item) choices.get(choice) ;
  }
}
