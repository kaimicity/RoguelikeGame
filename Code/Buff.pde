class Buff extends Effect {

  Buff(Individual holder, String type, float value, int round) {
    this.type = type ;
    this.holder = holder ;
    this.value = value ;
    this.working = true ;
    this.round = round ;
  }

  void work() {
    switch(type) {
    case "Attack":
      origin = holder.getAttack() ;
      holder.setAttack((int)(holder.getAttack() * value)) ;
      logo = "A" ;
      break ;
    case "Defense":
      origin = holder.getDefence() ;
      holder.setDefence((int)(holder.getDefence() * value)) ;
      logo = "D" ;
      break ;
    case "Hit Point":
      origin = holder.getHitPoint() ;
      holder.setHitPoint((int)(holder.getHitPoint() * value)) ;
      logo = "HP" ;
      break ;
    case "Dodge Point":
      origin = holder.getDodgePoint() ;
      holder.setDodgePoint((int)((holder.getDodgePoint() * value))) ;
      logo = "DP" ;
      break ;
    case "Critical Chance":
      origin = holder.getCriticalChance() ;
      int cc = holder.getCriticalChance() +(int) value ;
      if (cc > 100)
        cc = 100 ;
      holder.setCriticalChance(cc) ;
      logo = "CC" ;
      break ;
    case "Growing" : 
      holder.getHealing((int)value) ;
      logo = "G" ;
      break ;
    case "Invincible":
      holder.setInvin(true) ;
      logo = "I" ;
      break ;
    }
  }
  
  void retire(){
    this.working = false ;
    switch(type) {
    case "Attack":
      holder.setAttack(origin) ;
      break ;
    case "Defence":
      holder.setDefence(origin) ;
      break ;
    case "Hit Point":
      holder.setHitPoint(origin) ;
      break ;
    case "Dodge Point":
      holder.setDodgePoint(origin) ;
      break ;
    case "Critical Chance":
      holder.setCriticalChance(origin) ;
      break ;
    case "Invincible":
      holder.setInvin(false) ;
      break ;
    }
  }
}
