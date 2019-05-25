class ListSpell extends List {
  ArrayList spells ;

  ListSpell(float x, float y, float w, float h, int capacity, PGraphics pg) {
    this.graphic = pg ;
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.capacity = capacity ;
    this.paddingX = 0.1 * this.width ; 
    this.paddingY = 0.05 * this.height ;
    this.containerWidth = 0.8 * width ; 
    this.containerHeight = 0.8 * height / capacity ;
    
  }
  
  void setSpells(ArrayList spells){
    this.spells = new ArrayList(spells) ;
    this.containers = new ArrayList() ;
    for (int i = 0; i < spells.size(); i++) {
      Spell s = (Spell) spells.get(i) ;
      ContainerSpell cs = new ContainerSpell(position.x + paddingX, position.y + paddingY + i * containerHeight, containerWidth, containerHeight, s, graphic) ;
      containers.add(cs) ;
    }
    startIndex = 0 ;
    if(nowIndex >= containers.size())
      nowIndex = containers.size() - 1 ;
  }
  
  ArrayList getSpells(){
    return this.spells ;
  }
  
  Spell getSpell(){
    return ((ContainerSpell)currentContainer()).getSpell() ;
  }
  
  void catchSpells(Hero h, String ele){
    ArrayList mySpells = new ArrayList() ;
    for (Object o : h.getSpells()) {
      Spell s = (Spell) o ;
      if (s.getElement().equals(ele))
        mySpells.add(s) ;
    }
    setSpells(mySpells) ;
  }
}
