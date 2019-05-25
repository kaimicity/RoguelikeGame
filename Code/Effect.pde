abstract class Effect{
  String type ;
  int round ;
  Individual holder ;
  float value ;
  int origin ;
  boolean working ;
  String logo ;
  
  abstract void work() ;
  abstract void retire() ;
  
  void minusRound(){
    this.round-- ;
  }
  
  boolean runOut(){
    if(this.round == -1 && working )
      return true ;
    else 
      return false ;
  }
  
  boolean isWorking(){
    return this.working ;
  }
  
  String getType(){
    return this.type ;
  }
  
  String getLogo(){
    return this.logo ;
  }
}
