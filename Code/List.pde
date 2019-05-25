abstract class List{
  ArrayList containers ;
  int startIndex ;
  int nowIndex ;
  int capacity ;
  ArrayList showList ;
  PVector position ;
  float paddingX ;
  float paddingY ;
  float width ;
  float height ;
  float containerWidth ; 
  float containerHeight ;
  PGraphics graphic ;
  
  void draw() {
    showList = new ArrayList() ;
    for(int i = 0 ; i < min(capacity, containers.size()) ; i ++)
      showList.add(containers.get(startIndex + i)) ;
    for(int i = 0; i< min(capacity, showList.size()); i++){
      Container c = ((Container)(showList.get(i))) ;
      c.draw() ;
    }
    
  }
  
  void addContent(Container c) {
    containers.add(c) ;
  }
    
  
  void removeContent(int index) {
    containers.remove(index) ;
  }
  
  void removeContent() {
    containers.remove(nowIndex) ;
  }
  
  void next(){
    if(nowIndex < containers.size() - 1){
      ((Container)(containers.get(nowIndex))).defocus() ;
      if(nowIndex == startIndex + capacity - 1)
        startIndex++ ;
      nowIndex++ ;
      ((Container)(containers.get(nowIndex))).focus() ;
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
    }
  }
  
  void last(){
    if(nowIndex > 0){
      ((Container)(containers.get(nowIndex))).defocus() ;
      if(nowIndex == startIndex)
        startIndex-- ;
      nowIndex-- ;
      ((Container)(containers.get(nowIndex))).focus() ;
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
    }
  }
  
  Container currentContainer(){
    return ((Container)(containers.get(nowIndex))) ;
  }
  
  void startScan(){
    nowIndex = 0 ;
    ((Container)(containers.get(nowIndex))).focus() ;
  }
  
  void finishScan(){
    ((Container)(containers.get(nowIndex))).defocus() ;
  }
  
  void chooseContainer(){
    ((Container)(containers.get(nowIndex))).chosen() ;
  }
  void focusContainer(){
    ((Container)(containers.get(nowIndex))).focus() ;
  }
  void dechooseContainer(){
    ((Container)(containers.get(nowIndex))).dechosen() ;
  }
  void defocusContainer(){
    ((Container)(containers.get(nowIndex))).defocus() ;
  }
  
  int size(){
    return containers.size() ;
  }
}
