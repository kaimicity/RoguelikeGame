abstract class  Spell{
  String name ; 
  int cost ;
  String element ;
  int level ;
  String type ;
  float additionRate ;
  String discription ;
  
  String getName(){
    return this.name ;
  }
  
  int getCost(){
    return this.cost ;
  }
  
  String getElement(){
    return this.element ;
  }
  
  int getLevel(){
    return this.level ;
  }
  
  String getType(){
    return this.type ;
  }
  
  String getDiscription(){
    return this.discription ;
  }
  
  float getAdditionRate(){
    return this.additionRate ;
  }
}
