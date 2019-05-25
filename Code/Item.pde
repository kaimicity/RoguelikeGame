abstract class Item{
  String name ;
  String type ;
  int number ;
  int level ;
  String discription ;
  
  String getName(){
    return this.name ;
  }
  
  String getType(){
    return this.type ;
  }
  
  String getDiscription(){
    return this.discription ;
  } 
  
  int getNumber(){
    return this.number ;
  }
  
  void resetNumber(){
    this.number = 0 ;
  } 
  
  int getLevel(){
    return this.level ;
  }
  
  boolean isMedicine(){
    if(type.equals("Medicine"))
      return true ;
    return false ;
  }
  
  boolean isWeapon(){
    if(type.equals("Weapon"))
      return true ;
    return false ;
  }
  
  boolean isArmour(){
    if(type.equals("Armour"))
      return true ;
    return false ;
  }
  
  boolean isShoe(){
    if(type.equals("Shoe"))
      return true ;
    return false ;
  }
  
  void get(){
    this.number ++ ;
  }
  
  void lose(){
    this.number -- ;
  }
  
}
