class Shoe extends Item{
  int hitPoint ;
  int dodgePoint ;
  
  Shoe(String name, int hitPoint, int dodgePoint, int level, String discription){
    this.name = name ;
    this.hitPoint = hitPoint ;
    this.dodgePoint = dodgePoint ;
    this.level = level ;
    this.discription = discription ;
    this.type = "Shoe" ;
    this.number = 0 ;
  }
  
  int getHitPoint(){
    return this.hitPoint ;
  }
  
  int getDodgePoint(){
    return this.dodgePoint ;
  }
}
