class SpellAttack extends Spell{
  int damage ;
  SpellAttack(String name, int cost, String element,  int damage, float ar, int level, String discription){
    this.name = name ;
    this.cost = cost ;
    this.element = element ;
    this.damage = damage ;
    this.level = level ;
    this.type = "Attack" ;
    this.discription = discription ;
    this.additionRate = ar ;
  }
  
  
  int getDamage(){
    return this.damage ;
  }
}
