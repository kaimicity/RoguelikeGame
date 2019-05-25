class Medicine extends Item{
  
  int healthPoint ;
  int magicPoint ;
  
  Medicine(String name, int healthPoint, int magicPoint, int level, String discription){
    this.name = name ;
    this.healthPoint = healthPoint ;
    this.magicPoint = magicPoint ;
    this.level = level ;
    this.type = "Medicine" ;
    this.number = 0 ;
    this.discription = discription ;
  }
  
  void use(Hero h){
    h.getHealing(healthPoint) ;
    h.getMagic(magicPoint) ;
  }
  
  int getHealthPoint(){
    return healthPoint ;
  }
  
  int getMagicPoint(){
    return magicPoint ;
  }
}
