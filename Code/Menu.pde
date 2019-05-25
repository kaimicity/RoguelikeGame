abstract class Menu {
  Hero hero ;
  PGraphics graphic ;
  String name ;
  int index ;
  PFont f = createFont("Chalkduster.ttf", width / 30);
  
  String getName() {
    return this.name ;
  }
  
  int getIndex() {
    return this.index ;
  }
  
  abstract void draw() ;

  abstract void reset() ;
}
