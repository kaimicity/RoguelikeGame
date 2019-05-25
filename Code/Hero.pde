class Hero extends Individual {

  int score ;
  color myColor = color(0, 0, 255) ;
  HashMap elements ;
  HashMap levels ;
  Maze m ;
  Weapon weapon ;
  Armour armour ;
  Shoe shoe ;
  ArrayList medicines ;
  ArrayList weapons ;
  ArrayList armours ;
  ArrayList shoes ;
  HashMap allItem = SpellsAndItems.getAllItems() ;
  PFont signF = Roguelike.signF ;

  Hero(Maze m, PGraphics pg) {
    this.type = "Hero" ;
    this.graphic = pg ;
    this.m = m ;
    this.width = m.getBrickWidth() * 2 / 3;
    this.height = m.getBrickHeight() * 2 / 3;
    this.position = m.getEntrance().add(m.getBrickWidth() / 2, m.getBrickHeight() / 2) ; 
    this.moveIncrement = width / 10 ;
    this.score = 0 ;
    this.level = 1 ;
    this.exp = 0 ;
    this.levelUpExp = 25 * level * level;
    this.attack = 70 ;
    this.defence = 50 ;
    this.health = 500 ;
    this.maxHealth = 500 ;
    this.magic = 100 ;
    this.maxMagic = 100 ;
    this.criticalChance = 20 ;
    this.hitPoint = 80 ;
    this.dodgePoint = 20 ;
    this.name = "kamimmmmmm" ;
    this.elements = new HashMap() ;
    spells = new ArrayList() ;
    this.levels = new HashMap() ;
    for (int i = 0; i < SpellsAndItems.getElements().length; i++) {
      String ele = (SpellsAndItems.getElements())[i] ;
      elements.put(ele, 0) ;
      levels.put(ele, 1) ;
      spells.addAll((ArrayList)(SpellsAndItems.getAllSpells().get(ele+"-1"))) ;
      //spells.addAll((ArrayList)(SpellsAndItems.getAllSpells().get(ele+"-2"))) ;
      //spells.addAll((ArrayList)(SpellsAndItems.getAllSpells().get(ele+"-3"))) ;
    }
    this.orientation = 0 ;
    this.velocity = new PVector(0, 0) ;
    this.turnIncrement = PI / 16 ;
    this.weapon = null ;
    this.armour = null ;
    this.shoe = null ;
    this.medicines = new ArrayList() ;
    this.weapons = new ArrayList() ;
    this.armours = new ArrayList() ;
    this.shoes = new ArrayList() ;
    medicines.addAll((ArrayList)allItem.get("Medicine-1")) ;
    medicines.addAll((ArrayList)allItem.get("Medicine-2")) ;
    medicines.addAll((ArrayList)allItem.get("Medicine-3")) ;
    weapons.addAll((ArrayList)allItem.get("Weapon-1")) ;
    weapons.addAll((ArrayList)allItem.get("Weapon-2")) ;
    weapons.addAll((ArrayList)allItem.get("Weapon-3")) ;
    armours.addAll((ArrayList)allItem.get("Armour-1")) ;
    armours.addAll((ArrayList)allItem.get("Armour-2")) ;
    armours.addAll((ArrayList)allItem.get("Armour-3")) ;
    shoes.addAll((ArrayList)allItem.get("Shoe-1")) ;
    shoes.addAll((ArrayList)allItem.get("Shoe-2")) ;
    shoes.addAll((ArrayList)allItem.get("Shoe-3")) ;
    for(Object o : medicines){
      ((Item)o).resetNumber() ;
    }
    for(Object o : weapons){
      ((Item)o).resetNumber() ;
    }
    for(Object o : armours){
      ((Item)o).resetNumber() ;
    }
    for(Object o : shoes){
      ((Item)o).resetNumber() ;
    }
  }
  
  void levelUp(){
    level++ ;
    attack += 5 ;
    defence += 5 ;
    maxHealth += 20 ;
    maxMagic += 10 ;
    health = maxHealth ;
    magic = maxMagic ;
    levelUpExp = 25 * level * level;
  } 
    

  void setName(String name) {
    this.name = name ;
  }

  HashMap getElements() {
    return elements ;
  }

  HashMap getLevels() {
    return levels ;
  }

  ArrayList addElementPoint(String element) {
    int elementPoint = (int)(elements.get(element)) ;
    int elementLevel = (int)(levels.get(element)) ;
    elementPoint ++ ;
    elements.put(element, elementPoint) ;
    if (elementPoint == (elementLevel + 1) * elementLevel / 2 * 20 && elementLevel < 4) {
      elementLevel++ ;
      levels.put(element, elementLevel) ;
      spells.addAll((ArrayList)(SpellsAndItems.getAllSpells()).get(element + "-" + elementLevel)) ;
      Roguelike.summonHint("Your " + element + " power levels up! You've learnt some new tricks!") ;
      return (ArrayList)((SpellsAndItems.getAllSpells()).get(element + "-" + elementLevel)) ;
    } else 
    return null ;
  }

  void addScore(int sc) {
    this.score += sc ;
  }

  void reset(Maze m) {
    this.width = m.getBrickWidth() * 2 / 3;
    this.height = m.getBrickHeight() * 2 / 3;
    this.position = new PVector(0, 0).add(m.getBrickWidth() / 2, m.getBrickHeight() / 2) ; 
    this.moveIncrement = width / 10 ;
  }

  void resetToExit(Maze m) {
    this.width = m.getBrickWidth() * 2 / 3;
    this.height = m.getBrickHeight() * 2 / 3;
    this.position = new PVector(graphic.width - m.getBrickWidth() / 2, graphic.height - m.getBrickHeight() / 2) ; 
    this.moveIncrement = width / 10 ;
  }

  int getScore() {
    return this.score ;
  }




  void draw() {
    graphic.fill(myColor) ;
    graphic.pushMatrix() ;
    graphic.translate(position.x, position.y) ;
    graphic.rotate(orientation) ;
    graphic.ellipse(0, 0, width, height) ;
    graphic.textFont(Roguelike.signF) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.textSize(width / 3) ;
    graphic.fill(0) ;
    graphic.text((name.charAt(0)+"").toUpperCase(), 0, height / 4) ;
    ArrayList mons = m.getMonsters() ;
    for (Object o : mons) {
      Monster mon = (Monster)o ;
      if (locate(m).equals(mon.locate(m)) && !m.someoneFighting() && !mon.isWait())
        mon.battle() ;
      else if (mon.getStatus().equals("COME") || mon.getStatus().equals("GO")) {
        if (mon.detect(this))
          mon.startChase() ;
      } else if (mon.getStatus().equals("CHASE"))
        mon.flushChasePath(this) ;
    }
    graphic.popMatrix() ;
  }





  boolean isOnExit(Maze m) {
    PVector exit = m.getExit() ;
    if (this.locate(m).equals(exit)) {
      return true ;
    } else
      return false ;
  }

  boolean isOnEntrance(Maze m) {
    if (this.locate(m).equals(new PVector(0, 0))) {
      return true ;
    } else
      return false ;
  }

  Treasure touchingTreasure(Maze m) {
    ArrayList treasures = m.getTreasures() ;
    for (Object t : treasures) {
      Treasure ts = (Treasure) t ;
      if (CollisionDetector.rect2Rect(this.position, width + 2 * moveIncrement, height + 2 * moveIncrement, new PVector(ts.getPosition().x + ts.getWidth() / 2, ts.getPosition().y + ts.getHeight() / 2), ts.getWidth(), ts.getHeight()))
        return ts ;
    }
    return null ;
  }

  Chip touchingChip(Maze m) {
    ArrayList chips = m.getChips() ;
    for (Object c : chips) {
      Chip chip = (Chip) c ;
      if (CollisionDetector.circle2Circle(this.position, width / 2, chip.getPosition(), chip.getWidth())) 
        return chip ;
    }
    return null ;
  }

  String useMedicine(Medicine m) {
    if ((health == maxHealth && m.getHealthPoint() != 0 && m.getMagicPoint() == 0) || (magic == maxMagic && m.getMagicPoint() != 0 && m.getHealthPoint() == 0)|| (health == maxHealth && magic == maxMagic))
      return "NONEED" ;
    else {
      Roguelike.recoverPlayer.rewind() ;
      Roguelike.recoverPlayer.play() ;
      for (Object o : medicines) {
        if (((Item)o).getName().equals(m.getName()))
          ((Item)o).lose() ;
      }
      health += m.getHealthPoint() ;
      magic += m.getMagicPoint() ;
      if (health > maxHealth)
        health = maxHealth ;
      if (magic > maxMagic)
        magic = maxMagic ;
      return "SUCCESS" ;
    }
  }


  void equipWeapon(Weapon w) {
    dischargeWeapon() ;
    this.attack += w.getAttackPoint() ;
    this.criticalChance += w.getCriticalPoint() ;
    if (this.criticalChance > 100)
      this.criticalChance = 100 ;
    this.weapon = w ;
    for (Object o : weapons) {
      if ((((Item)o).getName()).equals(weapon.getName()))
        ((Item)o).lose() ;
    }
  }

  void equipArmour(Armour a) {
    dischargeArmour() ;
    this.defence += a.getDefencePoint() ;
    this.armour = a ;
    for (Object o : armours) {
      if (((Item)o).getName().equals(armour.getName()))
        ((Item)o).lose() ;
    }
  }

  void equipShoe(Shoe s) {
    dischargeShoe() ;
    this.hitPoint += s.getHitPoint() ;
    this.dodgePoint += s.getDodgePoint() ;
    this.shoe = s ;
    for (Object o : shoes) {
      if (((Item)o).getName().equals(shoe.getName()))
        ((Item)o).lose() ;
    }
  }

  void dischargeWeapon() {
    if (this.weapon != null) {
      attack -= this.weapon.getAttackPoint() ;
      criticalChance = 20 ;
      for (Object o : weapons) {
        if (((Item)o).getName().equals(weapon.getName()))
          ((Item)o).get() ;
      }
      this.weapon = null ;
    }
  }

  void dischargeArmour() {
    if (this.armour != null) {
      defence -= this.armour.getDefencePoint() ;
      for (Object o : armours) {
        if (((Item)o).getName().equals(armour.getName()))
          ((Item)o).get() ;
      }
      this.armour = null ;
    }
  }

  void dischargeShoe() {
    if (this.shoe != null) {
      hitPoint -= this.shoe.getHitPoint() ;
      dodgePoint -= this.shoe.getDodgePoint() ;
      for (Object o : shoes) {
        if (((Item)o).getName().equals(shoe.getName()))
          ((Item)o).get() ;
      }
      this.shoe = null ;
    }
  }

  ArrayList getMedicines() {
    return medicines ;
  }

  ArrayList getWeapons() {
    return weapons ;
  }

  ArrayList getArmours() {
    return armours ;
  }

  ArrayList getShoes() {
    return shoes ;
  }

  Weapon getWeapon() {
    return this.weapon ;
  }

  Armour getArmour() {
    return this.armour ;
  }

  Shoe getShoe() {
    return this.shoe ;
  }

  boolean needWeapon(int lv) {
    for (Object o : weapons) {
      if (((Weapon)o).getLevel() == lv && ((Weapon)o).getNumber() > 0)
        return false ;
    }
    if (weapon != null)
      return false ;
    else
      return true ;
  }

  boolean needArmour(int lv) {
    for (Object o : armours) {
      if (((Armour)o).getLevel() == lv && ((Armour)o).getNumber() > 0)
        return false ;
    }
    if (armour != null)
      return false ;
    else
      return true ;
  }

  boolean needShoe(int lv) {
    for (Object o : shoes) {
      if (((Shoe)o).getLevel() == lv && ((Shoe)o).getNumber() > 0)
        return false ;
    }
    if (shoe != null)
      return false ;
    else
      return true ;
  }

  void getItem(Item i) {
    switch(i.getType()) {
    case "Medicine" :
      for (Object o : medicines) {
        if (((Item)o).getName().equals(i.getName()))
          ((Item)o).get() ;
      }
      break ;
    case "Weapon" :
      for (Object o : weapons) {
        if (((Item)o).getName().equals(i.getName()))
          ((Item)o).get() ;
      }
      break ;
    case "Armour" :
      for (Object o : armours) {
        if (((Item)o).getName().equals(i.getName()))
          ((Item)o).get() ;
      }
      break ;
    case "Shoe" :
      for (Object o : shoes) {
        if (((Item)o).getName().equals(i.getName()))
          ((Item)o).get() ;
      }
      break ;
    }
  }
  
  boolean getExp(int e){
    this.exp += e ;
    if(e >= levelUpExp){
      levelUp() ;
      return true ;
    }
    return false ;
  }
  boolean hasMedicine(){
    for(Object o : medicines){
      if(((Item)o).getNumber() > 0)
        return true ;
    }
    return false ;
  }
}
