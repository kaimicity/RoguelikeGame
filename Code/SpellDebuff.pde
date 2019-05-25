class SpellDebuff extends Spell{
  String debuffType ;
  float debuff ;
  int round ;
  
  SpellDebuff(String name, int cost, String element, float debuff, int round, String debuffType, float ar, int level, String discription){
    this.name = name ;
    this.cost = cost ;
    this.element = element ;
    this.debuff = debuff ;
    this.round = round ;
    this.debuffType = debuffType ;
    this.level = level ;
    this.type = "Debuff" ;
    this.discription = discription ;
    this.additionRate = ar ;
  }
  
  float getDebuff(){
    return this.debuff ;
  }
  
  String getDebuffType() {
    return this.debuffType ;
  }
  
  int getRound() {
    return this.round ;
  }
}
