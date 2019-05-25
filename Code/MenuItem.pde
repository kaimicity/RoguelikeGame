class MenuItem extends Menu {
  float catalogSize ;
  float catalogLine ;
  float catalogHeight ;
  String[] itemCatalog = SpellsAndItems.getAllItemCatalog() ;
  color[] colors = {#0000FF, #FF0000, #ABABAB, #8B6914} ;
  int catalogIndex = 0 ;
  int flashMark ;
  int flashRound ;
  ArrayList items ;
  ListItem itemList ;
  Item chosenItem ;
  String chosenCatalog ;
  String status ;
  ArrayList heroMedicines ;
  ArrayList heroWeapons ;
  ArrayList heroArmours ;
  ArrayList heroShoes ;
  float headingSize ;
  float discriptionSize ;
  float discriptionHeadingLine ;
  float buttonCursorMark ;
  float buttonCursorRound ;
  MenuItem(Hero hero, int i, PGraphics pg) {
    this.hero = hero ;
    this.graphic = pg ;
    this.name = "Item" ;
    this.index = i ;
    this.catalogSize = pg.width / 35 ;
    this.catalogLine = pg.width / 5 ;
    this.catalogHeight = pg.height / 4 ;
    this.catalogIndex = 0 ;
    this.flashMark = 0 ;
    this.flashRound = 60 ;
    itemList = new ListItem(0, 0, pg.width * 0.3, pg.height, 10, pg) ;
    headingSize = pg.width / 40 ;
    discriptionSize = pg.width / 50 ;
    discriptionHeadingLine = 0.2 * pg.height ;
    buttonCursorRound = 60 ;
  }

  void reset() {
    heroMedicines = hero.getMedicines() ;
    heroWeapons = hero.getWeapons() ;
    heroArmours = hero.getArmours() ;
    heroShoes = hero.getShoes() ;
    this.catalogIndex = 0 ;
    chosenCatalog = "" ;
    chosenItem = null ;
    getItems() ;
    status = "CHOOSE_CATALOG" ;
  }

  String getCurrentCatalog() {
    return itemCatalog[catalogIndex] ;
  }

  void getItems() {
    items = new ArrayList() ;
    String cc = getCurrentCatalog() ;
    switch(cc) {
    case "Medicine":
      itemList.setItems(heroMedicines) ;
      break ;
    case "Weapon":
      itemList.setItems(heroWeapons) ;
      break ;
    case "Armour":
      itemList.setItems(heroArmours) ;
      break ;
    case "Shoe":
      itemList.setItems(heroShoes) ;
      break ;
    }
  }
  void nextCatalog() {
    if (catalogIndex < 3 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      this.catalogIndex++ ;
      getItems() ;
    }
  }

  void lastCatalog() {
    if (catalogIndex > 0 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      catalogIndex-- ;
      getItems() ;
    }
  }

  String getStatus() {
    return this.status ;
  }

  Item getChosenItem() {
    return this.chosenItem ;
  }

  void chooseCatalog() {
    if (itemList.size() > 0) {
      chosenCatalog = itemCatalog[catalogIndex] ;
      itemList.startScan() ;
      chosenItem = itemList.getItem() ;
      status = "CHOOSE_ITEM" ;
    }
  }

  void cancelCatalog() {
    itemList.finishScan() ;
    status = "CHOOSE_CATALOG" ;
  }

  void chooseItem() {
    itemList.chooseContainer() ;
    status = "CHOOSE_OPERATION" ;
  }

  void dechooseItem() {
    itemList.dechooseContainer() ;
    status = "CHOOSE_ITEM" ;
  }
  void nextItem() {
    itemList.next() ;
    chosenItem = itemList.getItem() ;
  }

  void lastItem() {
    itemList.last() ;
    chosenItem = itemList.getItem() ;
  }

  String useItem() {
    String type = chosenItem.getType() ;
    switch(type) {
    case "Medicine" :
      String res = hero.useMedicine((Medicine)chosenItem) ;
      itemList.setItems(heroMedicines) ;
      if (itemList.size() > 0) {
        chosenItem = itemList.getItem() ;
        itemList.chooseContainer() ;
      } else {
        chosenItem = null ;
        status = "CHOOSE_CATALOG" ;
      }
      return  res;
    case "Weapon" :
      hero.equipWeapon((Weapon)chosenItem) ;
      itemList.setItems(heroWeapons) ;
      if (itemList.size() > 0) {
        chosenItem = itemList.getItem() ;
        itemList.chooseContainer() ;
      } else {
        chosenItem = null ;
        status = "CHOOSE_CATALOG" ;
      }
      return "EQUIP_WEAPON" ;
    case "Armour" :
      hero.equipArmour((Armour)chosenItem) ;
      itemList.setItems(heroArmours) ;
      if (itemList.size() > 0) {
        chosenItem = itemList.getItem() ;
        itemList.chooseContainer() ;
      } else {
        chosenItem = null ;
        status = "CHOOSE_CATALOG" ;
      }
      return "EQUIP_ARMOUR" ;
    case "Shoe" :
      hero.equipShoe((Shoe)chosenItem) ;
      itemList.setItems(heroShoes) ;
      if (itemList.size() > 0) {
        chosenItem = itemList.getItem() ;
        itemList.chooseContainer() ;
      } else {
        chosenItem = null ;
        status = "CHOOSE_CATALOG" ;
      }
      return "EQUIP_SHOE" ;
    }
    return null ;
  }
  void draw() {
    graphic.beginDraw() ;
    graphic.background(0) ;
    for (int i = 0; i < 4; i++) {
      if ( i ==catalogIndex  && status.equals("CHOOSE_CATALOG")) {
        graphic.strokeWeight(catalogHeight / 20) ;
        flashStroke() ;
        graphic.fill(0) ;
        graphic.rect(graphic.width * 0.3, catalogHeight * i +catalogHeight / 10, graphic.width * 0.2 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      } else if (i ==catalogIndex && !status.equals("CHOOSE_CATALOG")) {
        graphic.strokeWeight(catalogHeight / 20) ;
        graphic.stroke(255) ;
        graphic.fill(0) ;
        graphic.rect(graphic.width * 0.3, catalogHeight * i +catalogHeight / 10, graphic.width * 0.2 - catalogHeight / 10, catalogHeight - catalogHeight / 10) ;
      }
      graphic.textFont(f) ;
      graphic.textSize(catalogSize) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.fill(colors[i]) ;
      graphic.text(itemCatalog[i], graphic.width * 0.3, catalogHeight * i, graphic.width * 0.2, catalogHeight ) ;
    }
    itemList.draw() ;
    if (!status.equals("CHOOSE_CATALOG")) {
      color c = colors[catalogIndex] ;
      graphic.textFont(f) ;
      graphic.textSize(headingSize) ;
      graphic.textAlign(LEFT, CENTER) ;
      graphic.fill(c) ;
      graphic.text(chosenItem.getName(), 0.55 * graphic.width, 0.1 * graphic.height) ;
      graphic.textAlign(RIGHT, CENTER) ;
      graphic.text("Lv. " + chosenItem.getLevel(), 0.95 * graphic.width, 0.1 * graphic.height) ;
      graphic.strokeCap(ROUND) ;
      graphic.stroke(c) ;
      graphic.strokeWeight(graphic.width / 100) ;
      graphic.line(0.55 * graphic.width, 0.15 * graphic.height, 0.95 * graphic.width, 0.15 * graphic.height) ;
      graphic.textSize(discriptionSize) ;
      graphic.textAlign(LEFT, CENTER) ;
      graphic.text(chosenItem.getDiscription(), 0.55 * graphic.width, 0.1 * graphic.height, 0.4 * graphic.width, 0.3 * graphic.height) ;
      switch(chosenItem.getType()) {
      case "Medicine":
        int hp = ((Medicine)chosenItem).getHealthPoint() ;
        int mp = ((Medicine)chosenItem).getMagicPoint() ;
        if (hp > 0 && mp > 0) {
          graphic.text("Health +" + ((Medicine)chosenItem).getHealthPoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
          graphic.text("Magic +" + ((Medicine)chosenItem).getMagicPoint(), 0.55 * graphic.width, 0.55 * graphic.height) ;
        } else if (hp > 0)
          graphic.text("Health +" + ((Medicine)chosenItem).getHealthPoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
        else if (mp > 0)
          graphic.text("Magic +" + ((Medicine)chosenItem).getMagicPoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
        drawButton("Use");
        break ;
      case "Weapon":
        graphic.text("Attack +" + ((Weapon)chosenItem).getAttackPoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
        graphic.text("Critical chance +" + ((Weapon)chosenItem).getCriticalPoint() + " %", 0.55 * graphic.width, 0.55 * graphic.height) ;
        drawButton("Equip") ;
        break ;
      case "Armour":
        graphic.text("Defence +" + ((Armour)chosenItem).getDefencePoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
        drawButton("Equip") ;
        break ;
      case "Shoe":
        graphic.text("Hit point +" + ((Shoe)chosenItem).getHitPoint(), 0.55 * graphic.width, 0.5 * graphic.height) ;
        graphic.text("Dodge point +" + ((Shoe)chosenItem).getDodgePoint(), 0.55 * graphic.width, 0.55 * graphic.height) ;
        drawButton("Equip") ;
        break ;
      }
    }
    graphic.endDraw() ;
  }

  void flashStroke() {
    if (flashMark < flashRound / 2)
      graphic.stroke(255) ;
    else
      graphic.stroke(0) ;
    flashMark++ ;
    if (flashMark == flashRound)
      flashMark = 0 ;
  }

  void drawButton(String txt) {
    color c = colors[catalogIndex] ;
    graphic.strokeWeight(graphic.width / 200) ;
    if (status.equals("CHOOSE_OPERATION")) {
      if (buttonCursorMark < buttonCursorRound / 2)
        graphic.stroke(c) ;
      else 
      graphic.stroke(255) ;
      buttonCursorMark ++ ;
      if (buttonCursorMark == buttonCursorRound)
        buttonCursorMark = 0 ;
    } else
      graphic.stroke(c) ;
    graphic.fill(0) ;
    graphic.rect(0.65 * graphic.width, 0.85 * graphic.height, 0.2 * graphic.width, 0.1 * graphic.height) ;
    graphic.textSize(headingSize) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(c) ;
    graphic.text(txt, 0.75 * graphic.width, 0.9 * graphic.height) ;
  }
}
