class SpellBuff extends Spell{
  
  String buffType ;
  float buff ;
  int round ;
  
  SpellBuff(String name, int cost, String element, float buff, int round, String buffType, float ar, int level, String discription){
    this.name = name ;
    this.cost = cost ;
    this.element = element ;
    this.buff = buff ;
    this.round = round ;
    this.buffType = buffType ;
    this.level = level ;
    this.type = "Buff" ;
    this.discription = discription ;
    this.additionRate = ar ;
  }
  
  float getBuff(){
    return this.buff ;
  }
  
  String getBuffType() {
    return this.buffType ;
  }
  
  int getRound() {
    return this.round ;
  }
}
