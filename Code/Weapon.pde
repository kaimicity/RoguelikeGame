class Weapon extends Item{
  
  int attackPoint ;
  int criticalPoint ;
  
  Weapon(String name, int attackPoint, int criticalPoint, int level, String discription){
    this.name = name ;
    this.attackPoint = attackPoint ;
    this.criticalPoint = criticalPoint ;
    this.level = level ;
    this.type = "Weapon" ;
    this.number = 0 ;
    this.discription = discription ;
  }
  
  int getAttackPoint(){
    return this.attackPoint ;
  }
  
  int getCriticalPoint(){
    return this.criticalPoint ;
  }
}
