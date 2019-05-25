class ListItem extends List {
  ArrayList items ;

  ListItem(float x, float y, float w, float h, int capacity, PGraphics pg) {
    this.graphic = pg ;
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.capacity = capacity ;
    this.paddingX = 0.1 * this.width ; 
    this.paddingY = 0.05 * this.height ;
    this.containerWidth = 0.8 * width ; 
    this.containerHeight = 0.8 * height / capacity ;
  }

  void setItems(ArrayList items) {
    this.items = new ArrayList(items) ;
    this.containers = new ArrayList() ;
    for (int i = 0; i < items.size(); i++) {
      Item it = (Item) items.get(i) ;
      if (it.getNumber() > 0) {
        ContainerItem ci = new ContainerItem(position.x + paddingX, position.y + paddingY + containers.size() * containerHeight, containerWidth, containerHeight, it, graphic) ;
        containers.add(ci) ;
      }
    }
    startIndex = 0 ;
    if(nowIndex >= containers.size())
      nowIndex = containers.size() - 1 ;
  }

  ArrayList getItems() {
    return this.items ;
  }

  Item getItem() {
    return ((ContainerItem)currentContainer()).getItem() ;
  }
  
}
