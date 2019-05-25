class SpellHealing extends Spell{
  int heal ;
  SpellHealing(String name, int cost, String element,  int heal, float ar, int level, String discription){
    this.name = name ;
    this.cost = cost ;
    this.element = element ;
    this.heal = heal ;
    this.level = level ;
    this.type = "Healing" ;
    this.discription = discription ;
    this.additionRate = ar ;
  }
  
  
  int getHeal(){
    return this.heal ;
  }
}
