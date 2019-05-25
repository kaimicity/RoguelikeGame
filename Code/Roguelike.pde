import ddf.minim.* ;

static Maze maze ;
ArrayList mazes ;
static Hero hero ;
static String heroName ;
static String screen ;
static PFont f ; 
static PFont hintF ; 
static PFont signF  ;
int level ;
PGraphics mazeGraphic ;
PGraphics hintGraphic ;
PGraphics scoreBoard ;
PGraphics deadGraphic ;
static PGraphics battleGraphic ;
static String hintText ;
static boolean showHint ;
static boolean operationLock ;
int cursorMark ;
PImage cursor ;
int cursorRound ;
int treasureScore ;
int chipScore ;
int levelScore ;
Chip picked ;
ArrayList menus ;
MenuList menuList ;
MenuAttr attrMenu ;
MenuSpell spellMenu ;
MenuItem itemMenu ;
MenuEquipment equipmentMenu ;
PGraphics menuListGraphic ;
PGraphics menuGraphic ;
static ArrayList waitHint ;
static JSONArray monstersJSON ;
JSONObject spellsJSON ;
JSONObject itemsJSON  ;
static Battle fighting ;
int deadButton ;
int deadButtonMark ;
int maxDeadButtonMark ;
Minim minim ;
static AudioPlayer switchPlayer ;
static AudioPlayer waterPlayer ;
static AudioPlayer firePlayer ;
static AudioPlayer woodPlayer ;
static AudioPlayer earthPlayer ;
static AudioPlayer holyPlayer ;
static AudioPlayer evilPlayer ;
static AudioPlayer recoverPlayer ;
static AudioPlayer attackPlayer ;
void setup() {
  size(630, 700) ;
  spellsJSON =loadJSONObject("Spell.json") ;
  itemsJSON =loadJSONObject("Item.json") ;
  monstersJSON = loadJSONArray("Monster.json") ;
  SpellsAndItems.initSpell(spellsJSON) ;
  SpellsAndItems.initItem(itemsJSON) ;
  mazeGraphic = createGraphics(width, 9 * height / 10) ;
  menuGraphic = createGraphics(width, 8 * height / 10) ;
  menuListGraphic = createGraphics(width, height / 10) ;
  battleGraphic = createGraphics(width, height) ;
  deadGraphic = createGraphics(width, height) ;
  hintGraphic = createGraphics(width, height / 5) ;
  scoreBoard = createGraphics(width, height / 10) ;
  hintF = createFont("Chalkduster.ttf", width / 30);
  f = createFont("Bradley Hand ITC.ttf", width / 20);
  signF = createFont("Crown Title.TTF", 10) ;
  level = 1 ;
  maze = new Maze(level + 4, mazeGraphic) ;
  mazes = new ArrayList() ;
  hero = new Hero(maze, mazeGraphic) ;
  heroName = "" ;
  hintText = "" ;
  showHint = false ;
  operationLock = false ;
  cursorMark = 0 ;
  cursor = loadImage("cursor.png") ;
  cursorRound = 60 ;
  screen = "NAME" ;
  treasureScore = 3 ;
  chipScore = 1 ;
  levelScore = 5 ;
  picked = null ;
  menus = new ArrayList() ;
  attrMenu = new MenuAttr(hero, 0, menuGraphic) ;
  equipmentMenu = new MenuEquipment(hero, 1, menuGraphic) ;
  itemMenu = new MenuItem(hero, 2, menuGraphic) ;
  spellMenu = new MenuSpell(hero, 3, menuGraphic) ;
  menus.add(attrMenu) ;
  menus.add(equipmentMenu) ;
  menus.add(itemMenu) ;
  menus.add(spellMenu) ;
  menuList = new MenuList(menus, menuListGraphic) ;
  waitHint = new ArrayList() ;
  deadButton = 1 ;
  deadButtonMark = 0 ;
  maxDeadButtonMark = 100 ;
  minim = new Minim(this) ;
  switchPlayer = minim.loadFile("switch.mp3") ;
  evilPlayer = minim.loadFile("evil.mp3") ;
  waterPlayer = minim.loadFile("water.mp3") ;
  firePlayer = minim.loadFile("fire.mp3") ;
  woodPlayer = minim.loadFile("wood.mp3") ;
  earthPlayer = minim.loadFile("earth.mp3") ;
  holyPlayer = minim.loadFile("holy.mp3") ;
  recoverPlayer = minim.loadFile("recover.mp3") ;
  attackPlayer = minim.loadFile("attack.mp3") ;
}

void draw() {
  switch(screen) {
  case "NAME":
    drawName() ;
    break ;
  case "MAZE":
    drawMaze() ;
    drawScoreBoard() ;
    image(mazeGraphic, 0, height / 10) ;
    image(scoreBoard, 0, 0) ;
    if (showHint) {
      drawHint() ;
      image(hintGraphic, 0, 4 * height / 5) ;
    }
    break ;
  case "MENU":
    menuList.draw() ;
    drawScoreBoard() ;
    image(scoreBoard, 0, 0) ;
    image(menuListGraphic, 0, height / 10) ;
    image(menuGraphic, 0, height / 5) ;
    if (showHint) {
      drawHint() ;
      image(hintGraphic, 0, 4 * height / 5) ;
    }
    break ;
  case "BATTLE" :
    drawBattle() ;
    image(battleGraphic, 0, 0) ;
    if (showHint) {
      drawHint() ;
      image(hintGraphic, 0, 4 * height / 5) ;
    }
    break ;
  case "DEAD" :
    drawDead() ;
    image(deadGraphic, 0, 0) ;
    break ;
  }
}

void keyPressed() {
  if (unlock())
    return ;
  if (!operationLock)
    switch(screen) {
    case "NAME":
      inputName() ;
      break ;
    case "MAZE":
      mazeOperation() ;
      break ;
    case "MENU":
      menuOperation() ;
      break ;
    case "BATTLE":
      if (key == CODED)
        fighting.battleOperation(keyCode) ;
      else
        fighting.battleOperation(key) ;
      break ;
    case "DEAD" :
      deadOperation() ;
      break ;
    }
}

boolean unlock() {
  if (operationLock) {
    if (key == ENTER) {
      operationLock = false ;
      if (showHint) {
        showHint = false ;
        if (waitHint.size() > 0) {
          summonHint((String)waitHint.get(0)) ;
          waitHint.remove(0) ;
        }
      }
    }
    return true ;
  } else
    return false ;
}

void drawName() {
  background(0) ;
  textFont(f);
  textAlign(CENTER, CENTER);
  fill(255) ;
  textSize(width / 20) ;
  text("Hello, brave! What is your name?", width / 2, height / 3) ;
  rect(width / 4, 5 * height / 12, width / 2, height / 8) ;
  fill(0) ;
  text(heroName, width / 2, 23 * height / 48) ;
  textFont(f) ;
  textSize(width / 30) ;
  fill(255) ;
  text("1. ONLY numbers and characers !", width / 2, 2 * height / 3) ;
  text("2. NO longer than 10 !", width / 2, 11 * height / 15) ;
}

void inputName() {
  if (!(key == CODED)) {
    if (key == ENTER && heroName.length() > 0) {
      hero.setName(heroName) ;
      screen = "MAZE" ;
    } else if (key == BACKSPACE && heroName.length() > 0) {
      heroName = heroName.substring(0, heroName.length() - 1) ;
    } else if (heroName.length() < 11 && (Character.isLetter(key) || Character.isDigit(key))) {
      heroName += key ;
    }
  }
}

void drawMaze() {
  mazeGraphic.beginDraw() ;
  mazeGraphic.background(0) ;
  maze.drawMaze() ;
  hero.draw() ;
  if (picked != null) {
    picked.drawPicked() ;
  }
  if (keyPressed && !operationLock) {
    if (key == CODED) {
      switch(keyCode) {
      case RIGHT:
        hero.moveRight(maze) ;
        break ;
      case LEFT:
        hero.moveLeft(maze) ;
        break ;
      case UP:
        hero.moveUp(maze) ;
        break ;
      case DOWN:
        hero.moveDown(maze) ;
        break ;
      }
    } else {
      switch(key) {
      case 'w':
      case 'W':
        hero.moveAhead(maze) ;
        break ;
      case 'a':
      case 'A':
        hero.turnLeft() ;
        break ;
      case 'd':
      case 'D':
        hero.turnRight() ;
        break ;
      }
    }
  }
  mazeGraphic.endDraw() ;
}

void drawScoreBoard() {
  scoreBoard.beginDraw() ;
  scoreBoard.background(#A8A8A8) ;
  scoreBoard.textFont(f) ;
  scoreBoard.textAlign(CENTER, CENTER) ;
  scoreBoard.textSize(scoreBoard.height / 2) ;
  scoreBoard.text(hero.getName() + "    Lv."+hero.getLevel() + "    Score: " + hero.getScore() + "    Floor: " + level, scoreBoard.width / 2, scoreBoard.height / 2) ;
  scoreBoard.endDraw() ;
}
void mazeOperation() {
  if (key == ENTER) {
    Treasure goToOpen = hero.touchingTreasure(maze) ;
    Chip goToPick = hero.touchingChip(maze) ;
    if (hero.isOnExit(maze)) {
      if (maze.chipsClear()) {
        level ++ ;
        if (mazes.size() < level - 1) {
          hero.addScore(levelScore) ;
          mazes.add(maze) ;
          maze = new Maze(level + 4, mazeGraphic) ;
        } else {

          maze = (Maze)mazes.get(level - 1) ;
        }
        hero.reset(maze) ;
      } else
        summonHint("Do your job! Still some chips need to collect!") ;
    } else if (hero.isOnEntrance(maze) && level > 1) {
      level-- ;
      mazes.add(maze) ;
      maze = (Maze)mazes.get(level - 1) ;
      hero.resetToExit(maze) ;
    } else if (goToOpen != null || goToPick != null) {
      if (goToOpen != null) {
        if (goToOpen.isOpened() && !showHint)
          summonHint("You have opened this box, greedy guy!") ;
        else {
          Item it = goToOpen.open(hero) ;
          summonHint("You have gotten a " + it.getName() + ", you lucky guy!") ;
          hero.addScore(treasureScore) ;
        }
      }
      if (goToPick != null) {
        if (!goToPick.isPicked()) {
          goToPick.pick() ;
          picked = goToPick ;
          hero.addScore(chipScore) ;
        }
      }
    }
  } else if (key == 's' || key == 'S') {
    hero.turnBack() ;
  } else if (key == 'i' || key == 'I') {
    screen = "MENU" ;
    menuList.setIndex(attrMenu.getIndex()) ;
  }
}

void drawHint() {
  hintGraphic.beginDraw() ;
  hintGraphic.background(#8F8F8F) ; 
  hintGraphic.textFont(hintF) ;
  hintGraphic.fill(255) ;
  hintGraphic.text(hintText, hintGraphic.width / 20, hintGraphic.height / 20, 9 * hintGraphic.width / 10, hintGraphic.height - hintGraphic.width / 10 ) ;
  if (cursorMark < cursorRound / 2)
    hintGraphic.image(cursor, hintGraphic.width - hintGraphic.width / 10, hintGraphic.height - hintGraphic.width / 10, hintGraphic.width / 20, hintGraphic.width / 20) ;
  cursorMark++ ;
  if (cursorMark == cursorRound)
    cursorMark = 0 ;
  hintGraphic.endDraw() ;
}

static void summonHint(String ht) {
  if (!showHint) {
    hintText = ht ;
    showHint = true ;
    operationLock = true ;
  } else
    waitHint.add(ht) ;
}

void menuOperation() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT:
      menuList.switchLeft() ;
      break ;
    case RIGHT:
      menuList.switchRight() ;
      break ;
    }
  } else {
    switch(key) {
    case 'm':
    case 'M':
      screen = "MAZE" ;
      break ;
    }
  }
  String menuName = menuList.getMenuName() ;
  switch(menuName) {
  case "Spell":
    spellMenuOperation() ;
    break ;
  case "Item":
    itemMenuOperation() ;
    break ;
  case "Equipment":
    equipmentMenuOperation() ;
    break ;
  }
}

void spellMenuOperation() {
  String menuStatus = spellMenu.getStatus() ;
  switch(menuStatus) {
  case "CHOOSE_ELEMENT":
    if (key == CODED) {
      switch(keyCode) {
      case UP:
        spellMenu.lastElement() ;
        break ;
      case DOWN:
        spellMenu.nextElement() ;
        break ;
      }
    } else if (key == ENTER) {
      spellMenu.chooseElement() ;
    } 
    break ;
  case "CHOOSE_SPELL" :
    if (key == BACKSPACE) {
      spellMenu.cancelElement() ;
    } else if (key == ENTER && spellMenu.getChosenSpell().getType().equals("Healing")) {
      spellMenu.chooseSpell() ;
    } else if (key == CODED) {
      switch(keyCode) {
      case DOWN:
        spellMenu.nextSpell() ;
        break ;
      case UP:
        spellMenu.lastSpell() ;
        break ;
      }
    }
    break ;
  case "CHOOSE_OPERATION":
    if (key == BACKSPACE) {
      spellMenu.dechooseSpell() ;
    } else if ( key == ENTER) {
      String rep = spellMenu.healHero() ;
      switch(rep) {
      case "NONEED":
        summonHint("Your HP is full! Do you need me to help you to spend your superfluous MP???") ;
        break ;
      case "NOMAGIC":
        summonHint("You do not have enough HP neither MP. What a poor guy!") ;
        break ;
      case "SUCCESS":
        summonHint("Well, it seems like you prolong your last gasp") ;
        break ;
      }
    }
    break ;
  }
}

void itemMenuOperation() {
  String menuStatus = itemMenu.getStatus() ;
  switch(menuStatus) {
  case "CHOOSE_CATALOG":
    if (key == CODED) {
      switch(keyCode) {
      case UP:
        itemMenu.lastCatalog() ;
        break ;
      case DOWN:
        itemMenu.nextCatalog() ;
        break ;
      }
    } else if (key == ENTER) {
      itemMenu.chooseCatalog() ;
    } 
    break ;
  case "CHOOSE_ITEM" :
    if (key == BACKSPACE) {
      itemMenu.cancelCatalog() ;
    } else if (key == ENTER ) {
      itemMenu.chooseItem() ;
    } else if (key == CODED) {
      switch(keyCode) {
      case DOWN:
        itemMenu.nextItem() ;
        break ;
      case UP:
        itemMenu.lastItem() ;
        break ;
      }
    }
    break ;
  case "CHOOSE_OPERATION":
    if (key == BACKSPACE) {
      itemMenu.dechooseItem() ;
    } else if ( key == ENTER) {
      String rep = itemMenu.useItem() ;
      switch(rep) {
      case "NONEED":
        summonHint("You don't need healing, you wastrel!") ;
        break ;
      case "EQUIP_WEAPON":
        summonHint("The monster can be tickled little harder!") ;
        break ;
      case "EQUIP_ARMOUR":
        summonHint("You look like a can!") ;
        break ;
      case "EQUIP_SHOE":
        summonHint("Don't try to escape your fate even though you have a new pair of shoes!") ;
        break ;
      case "SUCCESS":
        summonHint("Well, it seems like you prolong your last gasp") ;
        break ;
      }
    }
    break ;
  }
}
void equipmentMenuOperation() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      equipmentMenu.lastCatalog() ;
      break ;
    case DOWN:
      equipmentMenu.nextCatalog() ;
      break ;
    }
  } else if (key == 'd' || key == 'D')
    equipmentMenu.discharge() ;
}

void drawBattle() {
  battleGraphic.beginDraw() ;
  battleGraphic.background(0) ;
  fighting.draw() ;
  battleGraphic.endDraw() ;
}

static void createBattle(Monster m) {
  fighting = new Roguelike().new Battle(hero, m, battleGraphic) ;
}

void drawDead() {
  deadGraphic.beginDraw() ;
  deadGraphic.background(0) ;
  deadGraphic.strokeWeight(1) ;
  deadGraphic.textFont(f) ;
  deadGraphic.textSize(deadGraphic.height / 20) ;
  deadGraphic.textAlign(CENTER, CENTER) ;
  deadGraphic.fill(255) ;
  deadGraphic.text("Your Die!", 0.5 * deadGraphic.width, 0.2 * deadGraphic.height) ;
  deadGraphic.text("Your Score:", 0.5 * deadGraphic.width, 0.3 * deadGraphic.height) ;
  deadGraphic.text(hero.getScore(), 0.5 * deadGraphic.width, 0.4 * deadGraphic.height) ;
  color bc = color(127, 255 * ((float)Math.abs(deadButtonMark - maxDeadButtonMark / 2 ) / (maxDeadButtonMark / 2))) ;
  if (deadButton == 1)
    deadGraphic.fill(bc) ;
  else
    deadGraphic.fill(255) ;
  deadGraphic.rect(0.15 * deadGraphic.width, deadGraphic.height * 0.8, 0.3 * deadGraphic.width, 0.1 * deadGraphic.height) ;
  if (deadButton == 2)
    deadGraphic.fill(bc) ;
  else
    deadGraphic.fill(255) ;
  deadGraphic.rect(0.55 * deadGraphic.width, deadGraphic.height * 0.8, 0.3 * deadGraphic.width, 0.1 * deadGraphic.height) ;
  deadButtonMark++ ;
  if (deadButtonMark == maxDeadButtonMark)
    deadButtonMark = 0 ;
  deadGraphic.fill(0) ;
  deadGraphic.text("Replay", 0.3 * deadGraphic.width, deadGraphic.height * 0.85) ;
  deadGraphic.text("Exit", 0.7 * deadGraphic.width, deadGraphic.height * 0.85) ;
  deadGraphic.endDraw() ;
}

void deadOperation() {
  if (key == CODED) {
    switch(keyCode) {
    case LEFT:
      if (deadButton == 2)
        deadButton = 1 ;
      break ;
    case RIGHT:
      if (deadButton == 1)
        deadButton = 2 ;
      break ;
    }
  } else if (key == ENTER) {
    switch(deadButton) {
    case 1 :
      initGame() ;
      break ;
    case 2:
      exit() ;
    }
  }
}

void initGame() {
  level = 1 ;
  maze = new Maze(level + 4, mazeGraphic) ;
  mazes = new ArrayList() ;
  hero = new Hero(maze, mazeGraphic) ;
  heroName = "" ;
  hintText = "" ;
  showHint = false ;
  operationLock = false ;
  cursorMark = 0 ;
  cursor = loadImage("cursor.png") ;
  cursorRound = 60 ;
  screen = "NAME" ;
  treasureScore = 3 ;
  chipScore = 1 ;
  levelScore = 5 ;
  picked = null ;
  menus = new ArrayList() ;
  attrMenu = new MenuAttr(hero, 0, menuGraphic) ;
  equipmentMenu = new MenuEquipment(hero, 1, menuGraphic) ;
  itemMenu = new MenuItem(hero, 2, menuGraphic) ;
  spellMenu = new MenuSpell(hero, 3, menuGraphic) ;
  menus.add(attrMenu) ;
  menus.add(equipmentMenu) ;
  menus.add(itemMenu) ;
  menus.add(spellMenu) ;
  menuList = new MenuList(menus, menuListGraphic) ;
  waitHint = new ArrayList() ;
  deadButton = 1 ;
  deadButtonMark = 0 ;
  maxDeadButtonMark = 100 ;
}

static void playSpout(String ele){
  switch(ele){
    case "Water" :
      waterPlayer.rewind() ;
      waterPlayer.play() ;
      break ;
    case "Fire" :
      firePlayer.rewind() ;
      firePlayer.play() ;
      break ;
    case "Wood" :
      woodPlayer.rewind() ;
      woodPlayer.play() ;
      break ;
    case "Earth" :
      earthPlayer.rewind() ;
      earthPlayer.play() ;
      break ;
    case "Holy" :
      holyPlayer.rewind() ;
      holyPlayer.play() ;
      break ;
    case "Evil" :
      evilPlayer.rewind() ;
      evilPlayer.play() ;
      break ;
  }
}
