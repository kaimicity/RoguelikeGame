class Battle {
  Hero hero ;
  Monster monster ;
  ArrayList heroBuff ;
  ArrayList heroDebuff ;
  ArrayList monsterBuff ;
  ArrayList monsterDebuff ;
  PGraphics graphic ;
  PFont f = Roguelike.f;
  float nameSize ;
  float attrSize ;
  float textSize ;
  float discSize ;
  float bigLineHeight ;
  float smallLineHeight ;
  String battleInfo ;
  float xBorder ;
  float yBorder ;
  boolean playerOpr ;
  int button ;
  int buttonMark ;
  int maxButtonMark ;
  String[] oprs = {"Attack", "Defense", "Spell", "Item", "Escape"} ;
  String[] eles = SpellsAndItems.allElements ;
  color[] colors = SpellsAndItems.elementColors ;
  color[] itemColors = {#FFFFFF, #00868B, #FFFF00} ;
  String oprPhase ;
  int takeTurnMark ;
  int maxTakeTurnMark ;
  boolean heroDefence ;
  boolean monsterDefence ;
  int chosenButton ;
  int currElement ;
  ListSpell spells ;
  ListItem items ;
  Spell chosenSpell ;
  Spell monsterSpell ;
  Item chosenItem ;

  Battle(Hero h, Monster m, PGraphics pg) {
    this.hero = h ;
    this.monster = m ;
    this.graphic = pg ;
    this.heroBuff = new ArrayList() ;
    this.heroDebuff = new ArrayList() ;
    this.monsterBuff = new ArrayList() ;
    this.monsterDebuff = new ArrayList() ;
    battleInfo = "" ;
    this.nameSize = pg.width / 30 ;
    this.xBorder = pg.width / 30 ;
    this.yBorder = pg.height / 30 ;
    this.bigLineHeight = pg.height / 20 ;
    this.smallLineHeight = pg.height / 25 ;
    this.textSize = pg.width / 35 ;
    this.attrSize = pg.width / 35 ;
    this.discSize = pg.width / 35 ;
    playerOpr = true ;
    button = 0 ;   
    buttonMark = 0 ;
    maxButtonMark = 120 ;
    oprPhase = "EFFECT" ;
    takeTurnMark = 0 ;
    maxTakeTurnMark = 100 ;
    monster.initStatus() ;
    heroDefence = false ;
    monsterDefence = false ;
    chosenButton = -1 ;
    currElement = 0 ;
    spells = new ListSpell(xBorder, 0.65 * graphic.height, 0.3 * graphic.width, 0.3 * graphic.height, 6, graphic) ;
    items = new ListItem(xBorder, 0.65 * graphic.height, 0.3 * graphic.width, 0.3 * graphic.height, 6, graphic) ;
  }

  void draw() {
    if (monster.getHealth() <= 0 && !Roguelike.showHint) {
      Roguelike.screen = "MAZE" ;
      hero.addScore(3 * monster.level) ;
      Roguelike.maze.removeMonster() ;
    } else if (hero.getHealth() <= 0 && !Roguelike.showHint) {
      Roguelike.screen = "DEAD" ;
    }
    if (monster.getStatus().equals("WAIT") && !Roguelike.showHint) {
      Roguelike.screen = "MAZE";
    }
    graphic.textFont(f) ;
    graphic.stroke(255) ;
    graphic.line(graphic.width * 0.4, 0, graphic.width * 0.4, graphic.height) ;
    graphic.line(graphic.width * 0.6, 0, graphic.width * 0.6, graphic.height) ;
    graphic.fill(255) ;
    graphic.textSize(textSize) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.text(battleInfo, graphic.width * 0.4, graphic.height * 0.2, graphic.width * 0.2, graphic.height * 0.6) ;
    write(hero, xBorder) ;
    write(monster, 0.6 * graphic.width + xBorder) ;
    drawEffect() ;
    if (playerOpr && hero.getHealth() > 0) {
      if (!oprPhase.equals("TURNING"))
        drawButtons() ;
      switch(oprPhase) {
      case "EFFECT" :
        effectAll() ;
        heroDefence = false ;
        oprPhase = "CHOOSE_OPERATION" ;
        break ;
      case "TURNING" :
        takeTurn() ;
        break ;
      case "CHOOSE_ELEMENT" :
        drawElementList() ;
        break ;
      case "CHOOSE_SPELL" :
        spells.draw() ;
        break ;
      case "SPOUT" :
        drawSpellInfo() ;
        break ;
      case "CHOOSE_ITEM" :
        items.draw() ;
        break ;
      case "USE" :
        drawItemInfo() ;
        break ;
      }
    } else if ( monster.getHealth() > 0) {
      if (oprPhase.equals("EFFECT")) {
        effectAll() ;
        oprPhase = "MONSTER_OPERATION" ;
      } else if (!oprPhase.equals("TURNING")) {
        monsterOperation() ;
      } else if (oprPhase.equals("TURNING")) {
        takeTurn() ;
      }
    }
  }

  void write(Individual i, float left) {
    graphic.textFont(f) ;
    graphic.textSize(nameSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text(i.getName(), left, yBorder) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("Lv. " + i.getLevel(), left, yBorder + bigLineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.textSize(attrSize) ;
    graphic.text("HP ", left, yBorder + 2 * bigLineHeight) ;
    graphic.stroke(255) ;
    graphic.fill(0) ;
    graphic.rect(left - xBorder + graphic.width / 9, yBorder + 2 * bigLineHeight - attrSize / 2, 
      graphic.width / 4, graphic.height / 30) ;
    graphic.noStroke() ;
    graphic.fill(255, 0, 0) ;
    graphic.rect(left - xBorder + graphic.width / 9 + 1, yBorder + 2 * bigLineHeight - attrSize / 2 + 1, 
      i.getHealth() * graphic.width / 4 / i.getMaxHealth() - 1, graphic.height / 30 - 1) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(255) ;
    graphic.text(i.getHealth() + " / " + i.getMaxHealth(), left - xBorder + 17 * graphic.width / 72, yBorder + 2 * bigLineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.textSize(attrSize) ;
    graphic.text("MP ", left, yBorder +  3 * bigLineHeight) ;
    graphic.stroke(255) ;
    graphic.fill(0) ;
    graphic.rect(left - xBorder + graphic.width / 9, yBorder + 3 * bigLineHeight - attrSize / 2, 
      graphic.width / 4, graphic.height / 30) ;
    graphic.noStroke() ;
    graphic.fill(#191970) ;
    graphic.rect(left - xBorder + graphic.width / 9 + 1, yBorder + 3 * bigLineHeight - attrSize / 2 + 1, 
      i.getMagic() * graphic.width / 4 / i.getMaxMagic() - 1, graphic.height / 30 - 1) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(255) ;
    graphic.text(i.getMagic() + " / " + i.getMaxMagic(), left - xBorder + 17 * graphic.width / 72, yBorder + 3 * bigLineHeight) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("Attack: " + i.getAttack(), left, yBorder + 4 * bigLineHeight) ;
    graphic.text("Defence: " + i.getDefence(), left, yBorder + 4 * bigLineHeight + smallLineHeight) ;
    graphic.text("Critical Chance: " + i.getCriticalChance(), left, yBorder + 4 * bigLineHeight + 2 * smallLineHeight) ;
    graphic.text("Hit Point: " + i.getHitPoint(), left, yBorder + 4 * bigLineHeight + 3 * smallLineHeight) ;
    graphic.text("Dodge Point: " + i.getDodgePoint(), left, yBorder + 4 * bigLineHeight + 4 * smallLineHeight) ;
  }

  void drawEffect() {
    graphic.textFont(Roguelike.signF) ;
    String hb = "" ;
    String hd = "" ;
    String mb = "" ;
    String md = "" ;
    for (Object o : heroBuff) {
      if (((Effect)o).isWorking())
        hb += ((Effect)o).getLogo() ;
    }
    for (Object o : heroDebuff) {
      if (((Effect)o).isWorking())
        hd += ((Effect)o).getLogo() ;
    }
    for (Object o : monsterBuff) {
      if (((Effect)o).isWorking())
        mb += ((Effect)o).getLogo() ;
    }
    for (Object o : monsterDebuff) {
      if (((Effect)o).isWorking())
        md += ((Effect)o).getLogo() ;
    }
    graphic.pushMatrix() ;
    graphic.scale(2, 1) ;
    graphic.textSize(nameSize * 2 / 3) ;
    graphic.fill(255, 0, 0) ;
    graphic.textAlign(RIGHT, BOTTOM) ;
    graphic.text(hb, (0.35 * graphic.width) / 2, yBorder + bigLineHeight) ;
    graphic.textAlign(LEFT, BOTTOM) ;
    graphic.text(mb, (0.75 * graphic.width) / 2, yBorder + bigLineHeight) ;
    graphic.fill(0, 0, 255) ;
    graphic.textAlign(RIGHT, TOP) ;
    graphic.text(hd, (0.35 * graphic.width) / 2, yBorder + bigLineHeight) ;
    graphic.textAlign(LEFT, TOP) ;
    graphic.text(md, (0.75 * graphic.width) / 2, yBorder + bigLineHeight) ;
    graphic.popMatrix() ;
  }

  void drawButtons() {
    graphic.textFont(f) ;
    color bc = color(127, 255 * ((float)Math.abs(buttonMark - maxButtonMark / 2 ) / (maxButtonMark / 2))) ;
    buttonMark ++ ;
    if (buttonMark == maxButtonMark)
      buttonMark = 0 ;
    for (int i = 0; i < 5; i++) {
      if (i == button && i != chosenButton) {
        graphic.fill(bc) ;
      } else if (i != button && i != chosenButton) {
        graphic.fill(255) ;
      } else if (i == chosenButton) {
        graphic.stroke(255) ;
        graphic.fill(0) ;
      }
      graphic.rect(xBorder + (i % 2) * 0.2 * graphic.width, yBorder + (4 + i / 2) * bigLineHeight + 5 * smallLineHeight, 0.1 * graphic.width, smallLineHeight) ;
      graphic.textSize(graphic.height / 50) ;
      graphic.textAlign(CENTER, CENTER) ;
      if (i == chosenButton)
        graphic.fill(255) ;
      else {
        graphic.fill(0) ;
      }
      graphic.text(oprs[i], 2.5 * xBorder + (i % 2) * 0.2 * graphic.width, yBorder + (4 + i / 2) * bigLineHeight + 5.5 * smallLineHeight) ;
      graphic.noStroke() ;
    }
  }

  void battleOperation(int key) {
    if (playerOpr) {
      switch(oprPhase) {
      case "CHOOSE_OPERATION":
        oprChooseOpr(key) ;
        break ;
      case "CHOOSE_ELEMENT":
        oprChooseElement(key) ;
        break ;
      case "CHOOSE_SPELL":
        oprChooseSpell(key) ;
        break ;
      case "SPOUT":
        oprSpout(key) ;
        break ;
      case "CHOOSE_ITEM" :
        oprChooseItem(key) ;
        break ;
      case "USE" :
        oprUse(key) ;
        break ;
      }
    }
  }

  void oprChooseOpr(int key) {
    if (key == LEFT) {
      if (button % 2 > 0) {      
        Roguelike.switchPlayer.rewind() ;
        Roguelike.switchPlayer.play() ;
        button-- ;
      }
    } else if (key == RIGHT) {
      if (button % 2 < 1) {      
        Roguelike.switchPlayer.rewind() ;
        Roguelike.switchPlayer.play() ;
        button++ ;
      }
    } else if (key == UP) {
      if (button / 2 > 0) {      
        Roguelike.switchPlayer.rewind() ;
        Roguelike.switchPlayer.play() ;
        button -= 2 ;
      }
    } else if (key == DOWN) {
      if (button < 3) {      
        Roguelike.switchPlayer.rewind() ;
        Roguelike.switchPlayer.play() ;
        button += 2 ;
      }
    } else if (key == ENTER) {
      switch(button) {
      case 4 :
        if (escapeSuccess(hero)) {
          Roguelike.summonHint("You has successfully escaped, crowd.") ;
          retireAll() ;
          monster.startWait();
        } else {
          battleInfo = "You want to escape, but your enemy kicks you back"; 
          startTurn();
        }
        break; 
      case 0 : 
        if (!monster.isInvin()) {
          int damage = hero.getAttack() * 100 / (100 + monster.getDefence()) ;
          if (monsterDefence)
            damage = damage * 3 / 4 ;
          double cc = Math.random() * 100;
          if( cc <= hero.getCriticalChance())
            damage = damage * 3 / 2 ;
          if (hitMonster()) {
            monsterInjured(damage); 
            battleInfo = "You attack your enemy and make " + damage + " damage.";
          } else {
            battleInfo = "You try to attack your enemy but hit somewhere else.";
          }
          startTurn();
        } else {
          battleInfo = "You cannot attack your enemy because he is invincible now!" ;
        }
        break;
      case 1 :
        heroDefence = true ;
        battleInfo = "You square away to protect your selef." ;
        startTurn();
        break ;
      case 2 :
        if (!hero.isSilence()) {
          chosenButton = 2 ;
          oprPhase = "CHOOSE_ELEMENT" ;
        } else {
          battleInfo = "You are silenced and cannot spout spells." ;
        }
        break ;
      case 3 :
        if (hero.hasMedicine() ) {
          chosenButton = 3 ;
          items.setItems(hero.getMedicines()) ;
          items.startScan() ;
          oprPhase = "CHOOSE_ITEM" ;
        } else
          battleInfo = "You don't have any medicines to use!" ;
        break ;
      }
    }
  }

  void oprChooseElement(int key) {
    switch(key) {
    case DOWN :
      if (currElement == 0)
        currElement = 3 ;
      else if (currElement < 3)
        currElement++ ;
      else if (currElement > 3)
        currElement-- ;
      break ;
    case UP :
      if (currElement == 3)
        currElement = 0 ;
      else if (currElement < 3)
        currElement-- ;
      else if (currElement > 3)
        currElement++ ;
      currElement = currElement % 6 ;
      break ;
    case LEFT :
      if (currElement < 2)
        currElement = 5 ;
      else if (currElement < 4)
        currElement = 4 ;
      break ;
    case RIGHT :
      if (currElement == 0 || currElement > 4)
        currElement = 1 ;
      else if (currElement > 2)
        currElement = 2 ;
      break ;
    case ENTER :
      oprPhase = "CHOOSE_SPELL" ;
      spells.catchSpells(hero, eles[currElement]) ;
      spells.startScan() ;
      break ;
    case BACKSPACE :
      oprPhase = "CHOOSE_OPERATION" ;
      chosenButton = -1 ;
      break ;
    }
  }

  void oprChooseSpell(int key) {
    switch(key) {
    case DOWN :
      spells.next() ;
      break ;
    case UP :
      spells.last() ;
      break ;
    case ENTER :
      chosenSpell = spells.getSpell() ;
      oprPhase = "SPOUT" ;
      break ;
    case BACKSPACE :
      oprPhase = "CHOOSE_ELEMENT" ;
      break ;
    }
  }

  void oprSpout(int key) {
    switch(key) {
    case BACKSPACE :
      oprPhase = "CHOOSE_SPELL" ;
      break ;
    case ENTER :
      spout() ;
      break ;
    }
  } 

  void oprChooseItem(int key) {
    switch(key) {
    case BACKSPACE :
      oprPhase = "CHOOSE_OPERATION" ;
      chosenButton = -1 ;
      break ;
    case UP :
      items.last() ;
      break ;
    case DOWN :
      items.next() ;
      break ;
    case ENTER :
      chosenItem = items.getItem() ;
      oprPhase = "USE" ;
      break ;
    }
  }

  void oprUse(int key) {
    switch(key) {
    case BACKSPACE :
      oprPhase = "CHOOSE_ITEM" ;
      break ;
    case ENTER :
      use() ;
      break ;
    }
  } 

  boolean escapeSuccess(Individual i) {
    double p = Math.random(); 
    double a = (double)(i.getHitPoint() + i.getDodgePoint()) / (hero.getHitPoint() + hero.getDodgePoint() + monster.getHitPoint() + monster.getDodgePoint()); 
    if (p <= a)
      return true; 
    else {
      return false;
    }
  }

  void monsterInjured(int health) {
    monster.loseLife(health); 
    if (monster.getHealth() <= 0) {
      hero.getItem(monster.getTrophy()) ;

      Roguelike.summonHint("You beat the "+ monster.getName() + "! You get " + monster.getExpValue() + " Exp. and a " + monster.getTrophyName() + "!");
      if (hero.getExp(monster.getExpValue()))
        Roguelike.summonHint("Level up!");
    }
  }

  void heroInjured(int health) {
    hero.loseLife(health); 
    if (hero.getHealth() <= 0) {
      Roguelike.summonHint("You die!");
    }
  }

  boolean hitMonster() { 
    double p = Math.random(); 
    double a = (double)monster.getHitPoint() / (hero.getHitPoint() + monster.getDodgePoint()); 
    if (p <= a) {
      Roguelike.attackPlayer.rewind() ;
      Roguelike.attackPlayer.play() ;
      return true;
    } else 
    return false;
  }


  boolean hitHero() { 
    double p = Math.random(); 
    double a = (double)monster.getHitPoint() / (monster.getHitPoint() + hero.getDodgePoint()); 
    if (p <= a) {
      Roguelike.attackPlayer.rewind() ;
      Roguelike.attackPlayer.play() ;
      return true;
    } else 
    return false;
  }

  void takeTurn() {
    if (takeTurnMark < maxTakeTurnMark)
      takeTurnMark ++; 
    else {
      if (playerOpr)
        playerOpr = false ;
      else 
      playerOpr = true ;
      oprPhase = "EFFECT" ;
    }
  }

  void retireAll() {
    for (int i = 0; i < heroBuff.size(); i++) {
      Buff e = (Buff)heroBuff.get(i);
      e.retire() ;
    }
    for (int i = 0; i < heroDebuff.size(); i++) {
      Debuff e = (Debuff)heroDebuff.get(i);
      e.retire() ;
    }
    for (int i = 0; i < monsterBuff.size(); i++) {
      Buff e = (Buff)monsterBuff.get(i);
      e.retire() ;
    }
    for (int i = 0; i < monsterDebuff.size(); i++) {
      Debuff e = (Debuff)monsterDebuff.get(i);
      e.retire() ;
    }
  }

  void effectAll() {
    if (playerOpr) {
      heroDefence = false ;
      for (int i = 0; i < heroBuff.size(); i++) {
        Buff e = (Buff)heroBuff.get(i);
        if (e.getType().equals("Growing"))
          e.work() ;
        e.minusRound() ;
        if (e.runOut()) 
          e.retire() ;
      }
      for (int i = 0; i < heroDebuff.size(); i++) {
        Debuff e = (Debuff)heroDebuff.get(i);
        if (e.getType().equals("Burning"))
          e.work() ;
        e.minusRound() ;
        if (e.runOut()) 
          e.retire() ;
      }
    } else {
      monsterDefence = false ;
      for (int i = 0; i < monsterBuff.size(); i++) {
        Buff e = (Buff)monsterBuff.get(i);
        if (e.getType().equals("Growing"))
          e.work() ;
        e.minusRound() ;
        if (e.runOut()) 
          e.retire() ;
      }
      for (int i = 0; i < monsterDebuff.size(); i++) {
        Debuff e = (Debuff)monsterDebuff.get(i);
        if (e.getType().equals("Burning"))
          e.work() ;
        e.minusRound() ;
        if (e.runOut()) 
          e.retire() ;
      }
    }
  }

  void startTurn() {
    oprPhase = "TURNING" ;
    takeTurnMark = 0;
    button = 0 ;
    chosenButton = -1 ;
  }

  void drawElementList() {
    graphic.textFont(f) ;
    for (int i = 0; i < eles.length; i++) {
      graphic.pushMatrix() ;
      graphic.translate(0.2 * graphic.width, 0.8 * graphic.height) ;
      graphic.rotate(i * PI / 3 + 2 * PI / 3) ;
      float alpha = 255 * ((float)Math.abs(buttonMark - maxButtonMark / 2 ) / (maxButtonMark / 2)) ;
      graphic.rotate(PI / 3) ;
      graphic.stroke(colors[i]) ;
      if (i == currElement)
        graphic.fill(colors[i], alpha) ;
      else
        graphic.fill(0) ;
      graphic.ellipse(0, 0.12 * graphic.height, 0.1 * graphic.height, 0.1 * graphic.height) ;
      graphic.translate(0, 0.12 * graphic.height) ;
      graphic.rotate(-PI - i * PI / 3) ;
      graphic.fill(0) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.textSize(attrSize) ;
      graphic.text(eles[i], 0, 0) ;
      graphic.popMatrix() ;
    }
    buttonMark ++ ;
    if (buttonMark == maxButtonMark)
      buttonMark = 0 ;
  }

  void drawSpellInfo() {
    graphic.textFont(f) ;
    color c = colors[currElement] ;
    String chosenElement = eles[currElement] ;
    graphic.textFont(f) ;
    graphic.textSize(nameSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.fill(c) ;
    graphic.text(chosenSpell.getName(), xBorder, 0.6 * graphic.height) ;
    graphic.textAlign(RIGHT, CENTER) ;
    graphic.text("Lv. " + chosenSpell.getLevel(), 0.35 * graphic.width, 0.6 * graphic.height) ;
    graphic.textSize(discSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.text("Type: " + chosenSpell.getType() + " spell;", xBorder, 0.63 * graphic.height) ;
    graphic.text("Cost: " + chosenSpell.getCost() + " MP;", xBorder, 0.66 * graphic.height) ;
    graphic.textAlign(LEFT, TOP) ;
    switch(chosenSpell.getType()) {
    case "Attack":
      graphic.text("Damage: " + ((SpellAttack)chosenSpell).getDamage() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+"));", 
        xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.1 * graphic.height);
      break ;
    case "Healing":
      graphic.text("Healing: " + ((SpellHealing)chosenSpell).getHeal() + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+"));", 
        xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.1 * graphic.height);
      break ;
    case "Buff":
      if (((SpellBuff)chosenSpell).getBuffType().equals("Invincible"))
        graphic.text("Effect: You will not take any damage in the next " + ((SpellBuff)chosenSpell).getRound() + " rounds;", 
          xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      else if (((SpellBuff)chosenSpell).getBuffType().equals("Critical Chance"))
        graphic.text("Effect: Your attack will be " + ((SpellBuff)chosenSpell).getBuff() + " (+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
          ")) % critical in the next "+ ((SpellBuff)chosenSpell).getRound() + " rounds;", 
          xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      else
        graphic.text("Effect: Your " + ((SpellBuff)chosenSpell).getBuffType().toLowerCase() + " power will increase to " + ((SpellBuff)chosenSpell).getBuff() + " ( + " + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
          ")) times in the next " + ((SpellBuff)chosenSpell).getRound() + " rounds.", 
          xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      break ;
    case "Debuff":
      if (((SpellDebuff)chosenSpell).getDebuffType().equals("Burning"))
        graphic.text("Effect: Your enemy will keep losing " + ((SpellDebuff)chosenSpell).getDebuff()  + "(+" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
          ")) HP in every of the next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      else if (((SpellDebuff)chosenSpell).getDebuffType().equals("Silence"))
        graphic.text("Effect: Your enemy can not spout spells in next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      else
        graphic.text("Effect: The " + ((SpellDebuff)chosenSpell).getDebuffType().toLowerCase() + " power of your enemy will decrease to " + ((SpellDebuff)chosenSpell).getDebuff()  + "(-" + chosenSpell.getAdditionRate() +" x " + chosenElement.toLowerCase() + " EXP"+"("+(int)(hero.getElements().get(chosenElement))+
          ")) times in the next " + ((SpellDebuff)chosenSpell).getRound() + " rounds;", xBorder, 0.69 * graphic.height, 0.3 * graphic.width, 0.25 * graphic.height);
      break ;
    }
    drawButton("Spout", c) ;
  }

  void spout() {
    if (chosenSpell.getCost() > hero.getMagic())
      battleInfo = "You don't have enough magic to spout this spell!" ;
    else if (chosenSpell.getType().equals("Healing") && hero.getHealth() == hero.getMaxHealth())
      battleInfo = "You don't need healing!" ;
    else if (chosenSpell.getType().equals("Attack") && monster.isInvin())
      battleInfo = "You can't spout a attack spell when your enemy is invincible!" ;
    else {
      String type = chosenSpell.getType() ;
      String ele = eles[currElement] ;
      String additionalInfo = "" ;
      switch(type) {
      case "Attack":
        int damage = ((SpellAttack)chosenSpell).getDamage() + (int)(chosenSpell.getAdditionRate() * (int)(hero.getElements().get(ele))) ;
        if (monster.getElement().equals(SpellsAndItems.conquerRelation.get(ele))) {
          damage = damage * 4 / 3 ;
          additionalInfo = "This attack is critical because your enemy is in the element of " + monster.getElement() + "." ;
        }
        if (monsterDefence)
          damage = damage * 3 / 4 ;
        monsterInjured(damage); 
        battleInfo = "You spout " + ele + " " + type + " spell: " + chosenSpell.getName() + " and make " + damage + " to your enemy! " + additionalInfo;
        hero.addElementPoint(ele) ;
        startTurn() ;
        break ;
      case "Healing":
        int healing = ((SpellHealing)chosenSpell).getHeal() + (int)(chosenSpell.getAdditionRate() * (int)(hero.getElements().get(ele))) ;
        hero.getHealing(healing) ; 
        battleInfo = "You spout " + ele + " " + type + " spell: " + chosenSpell.getName() + " and recover " + healing + " HP! ";
        break ;
      case "Buff":
        String bType = ((SpellBuff)chosenSpell).getBuffType() ;
        for (Object o : heroBuff) {
          if (((Buff)o).getType().equals(bType) && ((Buff)o).isWorking())
            ((Buff)o).retire() ;
        }
        float bValue = ((SpellBuff)chosenSpell).getBuff() + chosenSpell.getAdditionRate() * (int)(hero.getElements().get(ele)) ;
        Buff buff = new Buff(hero, bType, bValue, ((SpellBuff)chosenSpell).getRound()) ;
        buff.work() ;
        heroBuff.add(buff) ;
        battleInfo = "You spout " + ele + " " + type + " spell: " + chosenSpell.getName() + " and get a " + bType + " Buff! ";
        break ;
      case "Debuff":
        String dType = ((SpellDebuff)chosenSpell).getDebuffType() ;
        for (Object o : monsterDebuff) {
          if (((Debuff)o).getType().equals(dType) && ((Debuff)o).isWorking())
            ((Debuff)o).retire() ;
        }
        float dValue = ((SpellDebuff)chosenSpell).getDebuff() - chosenSpell.getAdditionRate() * (int)(hero.getElements().get(ele)) ;
        Debuff debuff = new Debuff(monster, dType, dValue, ((SpellDebuff)chosenSpell).getRound()) ;
        debuff.work() ;
        monsterDebuff.add(debuff) ;
        battleInfo = "You spout " + ele + " " + type + " spell: " + chosenSpell.getName() + " and give a " + dType + " Debuff to your enemy! ";
        break ;
      }
      Roguelike.playSpout(ele) ;
      hero.addElementPoint(ele) ;
      hero.spendMagic(chosenSpell.getCost()) ;
      startTurn() ;
    }
  }

  void drawItemInfo() {
    color c = itemColors[chosenItem.getLevel() - 1] ;
    graphic.textFont(f) ;
    graphic.textSize(nameSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    graphic.fill(c) ;
    graphic.text(chosenItem.getName(), xBorder, 0.6 * graphic.height) ;
    graphic.textAlign(RIGHT, CENTER) ;
    graphic.text("Lv. " + chosenItem.getLevel(), 0.35 * graphic.width, 0.6 * graphic.height) ;
    graphic.textSize(discSize) ;
    graphic.textAlign(LEFT, CENTER) ;
    int hp = ((Medicine)chosenItem).getHealthPoint() ;
    int mp = ((Medicine)chosenItem).getMagicPoint() ;
    if (hp > 0 && mp > 0) {
      graphic.text("Health +" + ((Medicine)chosenItem).getHealthPoint(), xBorder, 0.63 * graphic.height) ;
      graphic.text("Magic +" + ((Medicine)chosenItem).getMagicPoint(), xBorder, 0.66 * graphic.height) ;
    } else if (hp > 0)
      graphic.text("Health +" + ((Medicine)chosenItem).getHealthPoint(), xBorder, 0.63 * graphic.height) ;
    else if (mp > 0)
      graphic.text("Magic +" + ((Medicine)chosenItem).getMagicPoint(), xBorder, 0.63 * graphic.height) ;
    drawButton("Use", c) ;
  }

  void drawButton(String txt, color c) {
    float bc = 255 * ((float)Math.abs(buttonMark - maxButtonMark / 2 ) / (maxButtonMark / 2)) ;
    buttonMark ++ ;
    if (buttonMark == maxButtonMark)
      buttonMark = 0 ;
    graphic.fill(c, bc) ;
    graphic.rect(0.1 * graphic.width, 0.9 * graphic.height, 0.2 * graphic.width, 0.05 * graphic.height) ;
    graphic.textSize(nameSize) ;
    graphic.textAlign(CENTER, CENTER) ;
    graphic.fill(c) ;
    graphic.text(txt, 0.2 * graphic.width, 0.925 * graphic.height) ;
  }

  void use() {
    String res = hero.useMedicine((Medicine)chosenItem) ;
    switch(res) {
    case "NONEED" :
      battleInfo = "You don't need healing." ;
      break ;
    case "SUCCESS" :
      battleInfo = "You use a " + ((Medicine)chosenItem).getName() + " and recover " + ((Medicine)chosenItem).getHealthPoint() + " HP and " + ((Medicine)chosenItem).getMagicPoint() + " MP.";
      startTurn() ;
      break ;
    }
  }

  void monsterOperation() {
    monsterSpell = null ;
    monsterDefence = false ;
    String character = monster.getChara() ;
    double chaRate = Math.random() ;
    boolean charaOpr = false ;
    if (chaRate < 0.2) {
      charaOpr = true ;
      switch(character) {
      case "Timid" :
        if (escapeSuccess(monster)) {
          monster.loseLife(monster.getHealth()) ;
          Roguelike.summonHint("Your enemy has run away.") ;
          startTurn() ;
        } else {
          battleInfo = "Your enemy wants to escape, but you kicks him back" ;
          startTurn() ;
        }
        break ;
      case "Rage" :
        if (!monsterAttack())
          charaOpr = false ;
        break ;
      }
    } 
    if (!charaOpr) {
      if (monster.getHealth() < monster.getMaxHealth() / 2) {
        monsterSpell = monsterHasSpell("Healing") ;
        if (monsterSpell != null) {
          monsterSpout() ;
          return ;
        }
      }
      if (needBuffDebuff()) {
        double bd = Math.random() ;
        if (bd < 0.5) {
          monsterSpell = monsterHasSpell("Buff") ;
          if (monsterSpell == null )
            monsterSpell = monsterHasSpell("Debuff") ;
        } else {
          monsterSpell = monsterHasSpell("Debuff") ;
          if (monsterSpell == null)
            monsterSpell = monsterHasSpell("Buff") ;
        }
        if (monsterSpell != null) {
          monsterSpout() ;
          return ;
        }
      }
      if (monsterAttack())
        return ;
      else {
        monsterDefence = true ;
        battleInfo = "Your enemy square away to protext your selef." ;
        startTurn();
      }
    }
  }

  Spell monsterHasSpell(String type) {
    ArrayList monSpells = monster.getSpells() ;
    for (int i = monster.getLevel(); i > 0; i--) {
      for (Object o : monSpells) {
        if ( ((Spell)o).getType().equals(type) && ((Spell)o).getCost() <= monster.getMagic())
          return ((Spell)o) ;
      }
    }
    return null ;
  }

  void monsterSpout() {
    String type = monsterSpell.getType() ;
    String ele = monsterSpell.getElement() ;
    switch(type) {
    case "Attack":
      int damage = ((SpellAttack)monsterSpell).getDamage();
      if ((int)(hero.getElements().get(ele)) < (int)(hero.getElements().get(SpellsAndItems.conquerRelation.get(ele)))) {
        damage = damage * 4 / 3 ;
      }
      if (heroDefence)
        damage = damage * 3 / 4 ;
      heroInjured(damage); 
      battleInfo = "Your enemy spout " + ele + " " + type + " spell: " + monsterSpell.getName() + " and make " + damage + " to you! ";
      startTurn() ;
      break ;
    case "Healing":
      int healing = ((SpellHealing)monsterSpell).getHeal() ;
      monster.getHealing(healing) ; 
      battleInfo = "Your enemy spout " + ele + " " + type + " spell: " + monsterSpell.getName() + " and recover " + healing + " HP! ";
      break ;
    case "Buff":
      String bType = ((SpellBuff)monsterSpell).getBuffType() ;
      for (Object o : monsterBuff) {
        if (((Buff)o).getType().equals(bType) && ((Buff)o).isWorking())
          ((Buff)o).retire() ;
      }
      float bValue = ((SpellBuff)monsterSpell).getBuff() ;
      Buff buff = new Buff(monster, bType, bValue, ((SpellBuff)monsterSpell).getRound()) ;
      buff.work() ;
      monsterBuff.add(buff) ;
      battleInfo = "Your enemy spout " + ele + " " + type + " spell: " + monsterSpell.getName() + " and get a " + bType + " Buff! ";
      break ;
    case "Debuff":
      String dType = ((SpellDebuff)monsterSpell).getDebuffType() ;
      for (Object o : heroDebuff) {
        if (((Debuff)o).getType().equals(dType) && ((Debuff)o).isWorking())
          ((Debuff)o).retire() ;
      }
      float dValue = ((SpellDebuff)monsterSpell).getDebuff() ;
      Debuff debuff = new Debuff(hero, dType, dValue, ((SpellDebuff)monsterSpell).getRound()) ;
      debuff.work() ;
      heroDebuff.add(debuff) ;
      battleInfo = "Your enemy spout " + ele + " " + type + " spell: " + monsterSpell.getName() + " and give a " + dType + " Debuff to you! ";
      break ;
    }
    Roguelike.playSpout(ele) ;
    monster.spendMagic(monsterSpell.getCost()) ;
    startTurn() ;
  }

  boolean monsterAttack() {
    monsterSpell = monsterHasSpell("Attack") ;
    if (!monster.isSilence() && monsterSpell != null) {
      if (!hero.isInvin()) {
        monsterSpout() ;
        return true ;
      }
      return false ;
    } else {
      if (!hero.isInvin()) {
        int damage = monster.getAttack() * 100 / (100 + hero.getDefence()) ;
        if (heroDefence)
          damage = damage * 3 / 4 ;
          double cc = Math.random() * 100;
        if( cc <= monster.getCriticalChance())
            damage = damage * 3 / 2 ;
        if (hitHero()) {
          heroInjured(damage); 
          battleInfo = "Your enemy attack you and make " + damage + " damage.";
        } else {
          battleInfo = "Your enemy try to attack you enemy but hit somewhere else.";
        }
        startTurn() ;
        return true ;
      }
      return false ;
    }
  }

  boolean needBuffDebuff() {
    for (Object o : monsterBuff) {
      if (((Buff)o).isWorking())
        return false ;
    }
    for (Object o : heroDebuff) {
      if (((Debuff)o).isWorking())
        return false ;
    }
    return true ;
  }
}
