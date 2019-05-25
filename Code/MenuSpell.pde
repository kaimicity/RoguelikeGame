class MenuSpell extends Menu {
  float elementSize ;
  float elementLine ;
  float elementHeight ;
  int index ;
  String[] elements = SpellsAndItems.allElements ;
  color[] colors = SpellsAndItems.elementColors ;
  int elementsIndex = 0 ;
  int flashMark ;
  int flashRound ;
  ArrayList spells ;
  ListSpell spellList ;
  Spell chosenSpell ;
  String chosenElement ;
  String status ;
  ArrayList heroSpells ;
  float headingSize ;
  float discriptionSize ;
  float discriptionHeadingLine ;
  float buttonCursorMark ;
  float buttonCursorRound ;
  MenuSpell(Hero hero, int i, PGraphics pg) {
    this.hero = hero ;
    heroSpells = hero.getSpells() ;
    this.graphic = pg ;
    this.name = "Spell" ;
    this.index = i ;
    this.elementsIndex = 0 ;
    this.elementSize = pg.width / 35 ;
    this.elementLine = pg.width / 5 ;
    this.elementHeight = pg.height / 6 ;
    this.elementsIndex = 0 ;
    this.flashMark = 0 ;
    this.flashRound = 60 ;
    spellList = new ListSpell(0, 0, pg.width * 0.3, pg.height, 10, pg) ;
    headingSize = pg.width / 40 ;
    discriptionSize = pg.width / 50 ;
    discriptionHeadingLine = 0.2 * pg.height ;
    chosenSpell = null ;
    chosenElement = "" ;
    status = "CHOOSE_ELEMENT" ;
    getSpells() ;
    buttonCursorMark = 0 ;
    buttonCursorRound = 60 ;
  }

  void reset() {
    heroSpells = hero.getSpells() ;
    this.elementsIndex = 0 ;
    chosenElement = "" ;
    chosenSpell = null ;
    getSpells() ;
    status = "CHOOSE_ELEMENT" ;
  }

  String getCurrentElement() {
    return elements[elementsIndex] ;
  }

  void getSpells() {
    spells = new ArrayList() ;
    for (Object o : heroSpells) {
      Spell s = (Spell) o ;
      if (s.getElement().equals(getCurrentElement()))
        spells.add(s) ;
    }
    spellList.setSpells(spells) ;
  }
  void nextElement() {
    if (elementsIndex < 5 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      this.elementsIndex++ ;
      getSpells() ;
    }
  }

  void lastElement() {
    if (elementsIndex > 0 ) {      
      Roguelike.switchPlayer.rewind() ;
      Roguelike.switchPlayer.play() ;
      elementsIndex-- ;
      getSpells() ;
    }
  }

  String getStatus() {
    return this.status ;
  }

  Spell getChosenSpell() {
    return this.chosenSpell ;
  }

  void chooseElement() {
    chosenElement = elements[elementsIndex] ;
    spellList.startScan() ;
    chosenSpell = spellList.getSpell() ;
    status = "CHOOSE_SPELL" ;
  }

  void cancelElement() {
    spellList.finishScan() ;
    status = "CHOOSE_ELEMENT" ;
  }

  void chooseSpell() {
    spellList.chooseContainer() ;
    status = "CHOOSE_OPERATION" ;
  }

  void dechooseSpell() {
    spellList.dechooseContainer() ;
    status = "CHOOSE_SPELL" ;
  }
  void nextSpell() {
    spellList.next() ;
    chosenSpell = spellList.getSpell() ;
  }

  void lastSpell() {
    spellList.last() ;
    chosenSpell = spellList.getSpell() ;
  }

  String healHero() {
    if (hero.getMagic() < chosenSpell.getCost())
      return "NOMAGIC" ;
    else if (hero.getHealth() == hero.getMaxHealth())
      return "NONEED" ;
    else {
      Roguelike.playSpout(elements[elementsIndex]) ;
      hero.getHealing(((SpellHealing)chosenSpell).getHeal() + (int)chosenSpell.getAdditionRate() * (int)(hero.getElements().get(chosenElement))) ;
      hero.spendMagic(chosenSpell.getCost()) ;
      int levelBefore = (int)(hero.getLevels().get(elements[elementsIndex])) ;
      hero.addElementPoint(elements[elementsIndex]) ;
      int levelAfter = (int)(hero.getLevels().get(elements[elementsIndex])) ;
      if(levelAfter > levelBefore){
        getSpells() ;
        chooseSpell() ;
      }
      return "SUCCESS" ;
    }
  }



  void draw() {
    graphic.beginDraw() ;
    graphic.background(0) ;
    for (int i = 0; i < 6; i++) {
      int level = (int)(hero.getLevels().get(elements[i])) ;
      int points = (int)(hero.getElements().get(elements[i])) ;
      int maxPoints = (level + 1) * level / 2 * 20;
      if ( i ==elementsIndex  && status.equals("CHOOSE_ELEMENT")) {
        graphic.strokeWeight(elementHeight / 20) ;
        flashStroke() ;
        graphic.fill(0) ;
        graphic.rect(graphic.width * 0.3, elementHeight * i +elementHeight / 10, graphic.width * 0.2 - elementHeight / 10, elementHeight - elementHeight / 10) ;
      } else if (i ==elementsIndex && !status.equals("CHOOSE_ELEMENT")) {
        graphic.strokeWeight(elementHeight / 20) ;
        graphic.stroke(255) ;
        graphic.fill(0) ;
        graphic.rect(graphic.width * 0.3, elementHeight * i +elementHeight / 10, graphic.width * 0.2 - elementHeight / 10, elementHeight - elementHeight / 10) ;
      }
      graphic.textFont(f) ;
      graphic.textSize(elementSize) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.fill(colors[i]) ;
      graphic.text(elements[i] + " LV." + level + " " + points + "/"+ maxPoints, graphic.width * 0.3, elementHeight * i, graphic.width * 0.2, elementHeight ) ;
    }
    spellList.draw() ;
    if (!status.equals("CHOOSE_ELEMENT")) {
      color c = colors[elementsIndex] ;
      graphic.textFont(f) ;
      graphic.textSize(headingSize) ;
      graphic.textAlign(LEFT, CENTER) ;
      graphic.fill(c) ;
      graphic.text(chosenSpell.getName(), 0.55 * graphic.width, 0.1 * graphic.height) ;
      graphic.textAlign(RIGHT, CENTER) ;
      graphic.text("Lv. " + chosenSpell.getLevel(), 0.95 * graphic.width, 0.1 * graphic.height) ;
      graphic.strokeCap(ROUND) ;
      graphic.stroke(c) ;
      graphic.strokeWeight(graphic.width / 100) ;
      graphic.line(0.55 * graphic.width, 0.15 * graphic.height, 0.95 * graphic.width, 0.15 * graphic.height) ;
      graphic.textSize(discriptionSize) ;
      graphic.textAlign(LEFT, CENTER) ;
      graphic.text(chosenSpell.getDiscription(), 0.55 * graphic.width, 0.1 * graphic.height, 0.4 * graphic.width, 0.3 * graphic.height) ;
      graphic.text("Type: " + chosenSpell.getType() + " spell;", 0.55 * graphic.width, 0.6 * graphic.height) ;
      graphic.text("Cost: " + chosenSpell.getCost() + " MP;", 0.55 * graphic.width, 0.65 * graphic.height) ;
      graphic.textAlign(LEFT, TOP) ;
      switch(chosenSpell.getType()) {
      case "Attack":
        graphic.text("Damage: " + ((SpellAttack)chosenSpell).getDamage() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+"));", 
          0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
        break ;
      case "Healing":
        graphic.text("Healing: " + ((SpellHealing)chosenSpell).getHeal() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+"));", 
          0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.1 * graphic.height);
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
        graphic.text("Spout", 0.75 * graphic.width, 0.9 * graphic.height) ;
        break ;
      case "Buff":
        if (((SpellBuff)chosenSpell).getBuffType().equals("Invincible"))
          graphic.text("Effect: You will not take any damage in the next " + ((SpellBuff)chosenSpell).getRound() + " rounds;", 
            0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
           else if (((SpellBuff)chosenSpell).getBuffType().equals("Critical Chance"))
          graphic.text("Effect: Your attack will be " + ((SpellBuff)chosenSpell).getBuff() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
            ")) % critical in the next "+ ((SpellBuff)chosenSpell).getRound() + " rounds;", 
            0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
        else
          graphic.text("Effect: Your " + ((SpellBuff)chosenSpell).getBuffType().toLowerCase() + " power will increase to " + ((SpellBuff)chosenSpell).getBuff() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
            ")) times in the next " + ((SpellBuff)chosenSpell).getRound() + " rounds;", 
            0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
        break ;
      case "Debuff":
        if (((SpellDebuff)chosenSpell).getDebuffType().equals("Burning"))
          graphic.text("Effect: Your enemy will keep losing " + ((SpellDebuff)chosenSpell).getDebuff()  + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
            ")) HP in every of the next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", 0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
        else if(((SpellDebuff)chosenSpell).getDebuffType().equals("Silence"))
          graphic.text("Effect: Your enemy can not spout spells in next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", 0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
        else
          graphic.text("Effect: The " + ((SpellDebuff)chosenSpell).getDebuffType().toLowerCase() + " power of your enemy will decrease to " + ((SpellDebuff)chosenSpell).getDebuff()  + "(-" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
            ")) times in the next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", 0.55 * graphic.width, 0.7 * graphic.height, 0.4 * graphic.width, 0.2 * graphic.height);
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
}
