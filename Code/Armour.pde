class Armour extends Item{
  
  int defencePoint ;
  
  Armour(String name, int defencePoint, int level, String discription) {
    this.name = name ;
    this.defencePoint = defencePoint ;
    this.level = level ;
    this.type = "Armour" ;
    this.number = 0 ;
    this.discription = discription ;
  }
  
  int getDefencePoint(){
    return this.defencePoint ;
  }
}
