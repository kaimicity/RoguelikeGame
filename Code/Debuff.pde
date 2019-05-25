class Debuff extends Effect{
  
  Debuff(Individual holder, String type, float value, int round) {
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
      holder.setAttack(Math.max((int)(holder.getAttack() * value), 0)) ;
      logo = "A" ;
      break ;
    case "Defense":
      origin = holder.getDefence() ;
      holder.setDefence(Math.max((int)(holder.getDefence() * value), 0)) ;
      logo = "D" ;
      break ;
    case "Hit Point":
      origin = holder.getHitPoint() ;
      holder.setHitPoint(Math.max((int)(holder.getHitPoint() * value), 0)) ;
      logo = "HP" ;
      break ;
    case "Dodge Point":
      origin = holder.getDodgePoint() ;
      holder.setDodgePoint(Math.max((int)(holder.getDodgePoint() * value), 0)) ;
      logo = "DP" ;
      break ;
    case "Burning" : 
      holder.loseLife((int)value) ;
      logo = "B" ;
      break ;
    case "Silence" :
      holder.setSilence(true) ;
      logo = "S" ;
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
    case "Silence":
      holder.setSilence(false) ;
      break ;
    }
  }
}
