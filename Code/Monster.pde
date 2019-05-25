class Monster extends Individual {
  ArrayList path ;
  ArrayList chasePath ;
  String status ; 
  PVector from ;
  PVector to ;
  int pathMark ;
  int chasePathMark ;
  float tarOr ;
  Maze m ;
  int restMark ;
  int maxRestMark ;
  float detectionRange ;
  PFont f = createFont("Chalkduster.ttf", 10);
  float accelerate ;
  float maxSpeed ;
  float minSpeed ;
  String preStatus ;
  String statusBeforeBattle ;
  PVector preTo ;
  String character ;
  int expValue ;
  Item trophy ;
  String[] allChara = {"Rage", "Calm", "Timid"} ;
  HashMap charaColor= new HashMap() ;
  String element ;
  color monColor ;
  int waitTime ;
  int maxWaitTime ;

  Monster(float x, float y, float w, float h, float orientation, ArrayList path, Maze m, PGraphics pg) {
    this.type = "Monster" ;
    this.graphic = pg ;
    this.position = new PVector(x, y) ;
    this.width = w ;
    this.height = h ;
    this.moveIncrement = w / 30 ;
    this.orientation = orientation ;
    this.velocity = new PVector() ;
    this.turnIncrement = PI / 64 ;
    this.path = path ;
    this.name = "Monster" ;
    this.m = m ;
    from = (PVector)path.get(0) ;
    to = (PVector)path.get(1) ;
    from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
    to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
    status = "COME" ;
    pathMark = 1 ;
    chasePathMark = 1 ;
    restMark = 0 ;
    maxRestMark = 100 ;
    detectionRange = m.getBrickWidth() * 2 ;
    maxSpeed = w / 10 ;
    minSpeed = w / 30 ;
    accelerate = w / 225 ;
    born() ;
    waitTime = 0 ;
    maxWaitTime = 300 ;
  }

  void turnTo(float target) {
    if (2 * PI - orientation < PI &&  orientation - target > PI) 
      turnRight() ;
    else if (orientation < PI &&  target - orientation > PI)
      turnLeft() ;
    else if (target > orientation + turnIncrement)
      turnRight() ;
    else if (target < orientation - turnIncrement)
      turnLeft() ;
  }

  String getStatus() {
    return this.status ;
  }

  void startChase() {
    status = "CHASE" ;
  }

  void battle() {
    statusBeforeBattle = status ;
    if (statusBeforeBattle.equals("CHASE"))
      statusBeforeBattle = "RETURN" ;
    status = "BATTLE" ;
  }

  void destroyed() {
    status = "DESTROYED" ;
  }

  boolean isBattle() {
    if (status.equals("BATTLE")) {
      return true ;
    }
    return false ;
  }

  boolean isWait() {
    if (status.equals("WAIT")) {
      return true ;
    }
    return false ;
  }
  
  String getElement(){
    return this.element ;
  }

  void flushChasePath(Hero h) {
    if (!chasePath.contains(h.locate(m)) && chasePath.size() < 5) {
      chasePath.add(h.locate(m)) ;
    } else if (chasePath.size() >= 2) {
      if (h.locate(m).equals(chasePath.get(chasePath.size() - 2))) {
        chasePath.remove(chasePath.size() - 1) ;
      } else if (!h.locate(m).equals(chasePath.get(chasePath.size() - 1  )) && chasePath.size() < 7) {
        chasePath.add(h.locate(m)) ;
      }
    }
  }

  void move(Maze m) {
    if (to.y > from.y)
      tarOr = 0 ;
    else if (to.y < from.y)
      tarOr = PI ;
    else if (to.x < from.x)
      tarOr = PI / 2 ;
    else if (to.x > from.x)
      tarOr = 3 * PI / 2 ;
    if (orientation != tarOr) {
      if (tarOr < orientation + turnIncrement && tarOr > orientation - turnIncrement)
        orientation = tarOr ;
      else
        turnTo(tarOr) ;
    } else if (status.equals("COME") || status.equals("GO")) {
      if (caMag(position, from) < caMag(from, to))
        moveAhead(m) ;
      else if (status.equals("COME")) {
        from = (PVector)path.get(pathMark) ;
        if (pathMark < path.size() - 1) {
          to = (PVector)path.get(pathMark + 1) ;
          to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
          pathMark ++ ;
        } else {
          if (restMark == maxRestMark) {
            status = "GO" ;
            to = (PVector)path.get(pathMark - 1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            restMark = 0 ;
          } else
            restMark++ ;
        }
        from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
      } else if (status.equals("GO")) {
        from = (PVector)path.get(pathMark) ;
        if (pathMark > 0) {
          to = (PVector)path.get(pathMark - 1) ;
          to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
          pathMark -- ;
        } else {
          if (restMark == maxRestMark) {
            status = "COME" ;
            to = (PVector)path.get(pathMark + 1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            restMark = 0 ;
          } else
            restMark ++ ;
        }
        from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
      }
    } else if (status.equals("CHASE")) {
      if (from.equals(to) && status.equals("WAIT"))
        status = "BATTLE" ;
      else if (caMag(position, from) < caMag(from, to)) {
        if (moveIncrement < maxSpeed)
          moveIncrement += accelerate ;
        moveAhead(m) ;
      } else {
        from = to ;
        if (chasePathMark < chasePath.size() - 1) {
          chasePathMark ++ ;
          to = (PVector)chasePath.get(chasePathMark) ;
          to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        } else {
          if (chasePathMark < 4)
            status = "BATTLE" ;
          else {
            status = "RETURN" ;
            moveIncrement = minSpeed ;
            to = (PVector)chasePath.get(chasePathMark - 1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
          }
        }
      }
    } else if (status.equals("RETURN")) {
      if (caMag(position, from) < caMag(from, to)) {
        moveAhead(m) ;
      } else {
        from = to ;
        if (chasePathMark > 0) {
          chasePathMark -- ;
          to = (PVector)chasePath.get(chasePathMark) ;
          to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        } else {
          status = preStatus ;
          to = preTo ;
        }
      }
    } else if (status.equals("WAIT")) {
      if (waitTime == maxWaitTime) {
        waitTime = 0 ;
        status = statusBeforeBattle ;
        moveIncrement = minSpeed ;
      } else {
        waitTime ++ ;
      }
    }
  }


  void draw() {
    graphic.fill(monColor) ;
    graphic.pushMatrix() ;
    //graphic.noStroke() ;
    graphic.translate(position.x, position.y) ;
    graphic.rotate(orientation) ;
    graphic.ellipse(0, 0, width, height) ;
    graphic.fill(255) ;
    if (status.equals("CHASE")) {
      graphic.fill(#CD3278) ;
      graphic.arc(0, height / 2, width / 2, height / 2, - PI / 2, PI / 2) ;
      graphic.popMatrix() ;
      graphic.fill(#FF0000) ;
      graphic.textFont(f) ;
      graphic.textSize(width / 2) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.text("!", position.x + width / 2, position.y - height / 2) ;
    } else if (status.equals("RETURN") || status.equals("WAIT") ) {
      graphic.fill(#FFFF00) ;
      graphic.ellipse( 0, height / 2, width / 2, height / 2) ;
      graphic.textFont(f) ;
      graphic.textSize(width / 2) ;
      graphic.textAlign(CENTER, CENTER) ;
      graphic.popMatrix() ;
      graphic.text("?", position.x + width / 2, position.y - height / 2) ;
    } else {
      graphic.ellipse( 0, height / 2, width / 2, height / 2) ;
      graphic.popMatrix() ;
    }
  }

  boolean detect(Hero h) {
    if (caMag(h.getPosition(), position) <= detectionRange) {
      if (Math.abs(h.getX() - position.x) < m.getBrickWidth() / 2) {
        if (h.getY() <= position.y && orientation > 3 * PI / 4 && orientation < 5 * PI / 4 ) {
          if (h.locate(m).equals(this.locate(m))) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            from = (PVector) chasePath.get(0) ;
            from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            to = from ;
            chasePathMark = 0 ;
            preStatus = status ;
            return true ;
          } else if ((m.getMaze())[(int)this.locate(m).x][(int)this.locate(m).y - 1] > 0) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            chasePath.add(new PVector((int)locate(m).x, (int)locate(m).y - 1)) ;
            to = (PVector) chasePath.get(1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            chasePathMark = 1 ;
            preStatus = status ;
            return true ;
          }
        } else if (h.getY() >= position.y && (orientation > 7 * PI / 4 || orientation < PI / 4 )) {
          if (h.locate(m).equals(this.locate(m))) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            from = (PVector) chasePath.get(0) ;
            from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            to = from ;
            chasePathMark = 0 ;
            preStatus = status ;
            return true ;
          } else if ((m.getMaze())[(int)this.locate(m).x][(int)this.locate(m).y + 1] > 0) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            chasePath.add(new PVector((int)locate(m).x, (int)locate(m).y + 1)) ;
            to = (PVector) chasePath.get(1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            chasePathMark = 1 ;
            preStatus = status ;
            return true ;
          }
        }
      } else if (Math.abs(h.getY() - position.y) < m.getBrickHeight() / 2) {
        if (h.getX() <= position.x && orientation > PI / 4 && orientation < 3 * PI / 4 ) {
          if (h.locate(m).equals(this.locate(m))) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            from = (PVector) chasePath.get(0) ;
            from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            to = from ;
            chasePathMark = 0 ;
            preStatus = status ;
            return true ;
          } else if ((m.getMaze())[(int)this.locate(m).x - 1][(int)this.locate(m).y] > 0) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            chasePath.add(new PVector((int)locate(m).x - 1, (int)locate(m).y)) ;
            to = (PVector) chasePath.get(1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            chasePathMark = 1 ;
            preStatus = status ;
            return true ;
          }
        } else if (h.getX() >= position.x && orientation > 5 * PI / 4 && orientation < 7 * PI / 4 ) {
          if (h.locate(m).equals(this.locate(m))) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            from = (PVector) chasePath.get(0) ;
            from = new PVector(from.x * m.getBrickWidth() + m.getBrickWidth() / 2, from.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            to = from ;
            chasePathMark = 0 ;
            preStatus = status ;
            return true ;
          } else if ((m.getMaze())[(int)this.locate(m).x + 1][(int)this.locate(m).y] > 0) {
            preTo = to ;
            chasePath = new ArrayList() ;
            chasePath.add(locate(m)) ;
            chasePath.add(new PVector((int)locate(m).x + 1, (int)locate(m).y)) ;
            to = (PVector) chasePath.get(1) ;
            to = new PVector(to.x * m.getBrickWidth() + m.getBrickWidth() / 2, to.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
            chasePathMark = 1 ;
            preStatus = status ;
            return true ;
          }
        }
      }
    }
    return false ;
  }

  void born() {
    this.level = m.getSize() / 5;
    if (level > 3)
      level = 3 ;
    this.expValue = level * 5 ;
    int monNumber = (int)(Math.random() * Roguelike.monstersJSON.size()) ;
    JSONObject attrs = Roguelike.monstersJSON.getJSONObject(monNumber).getJSONObject("lv" + level) ;
    this.name = attrs.getString("name") ;
    this.attack = attrs.getInt("attack") ;
    this.defence = attrs.getInt("defence") ;
    this.criticalChance = attrs.getInt("criticalChance") ;
    this.hitPoint = attrs.getInt("hitPoint") ;
    this.dodgePoint = attrs.getInt("dodgePoint") ;
    this.maxHealth = attrs.getInt("maxHealth") ;
    this.maxMagic = attrs.getInt("maxMagic") ;
    this.health = maxHealth ;
    this.magic = maxMagic ;
    this.element = attrs.getString("element") ;
    this.spells = new ArrayList() ;
    for (int i = 1; i < level + 1; i++)
      spells.addAll((ArrayList)SpellsAndItems.getAllSpells().get(element + "-" + i)) ;
    monColor = (color)SpellsAndItems.getAllElementColors().get(element) ;
    ArrayList cata = new ArrayList() ;
    cata.add("Medicine") ;
    ArrayList choices = SpellsAndItems.produceTreasure(level, cata) ;
    int choice = (int)Math.floor(Math.random() * choices.size()) ;
    trophy = (Item) choices.get(choice) ;
    int chaNumber = (int)(Math.random() * allChara.length) ;
    this.character = allChara[chaNumber] ;
    this.name = this.character + " " + this.name ;
    switch(character){
      case "Timid" :
        this.hitPoint *= 1.2 ;
        this.dodgePoint *= 1.2 ;
        break ;
      case "Rage" : 
        this.attack *= 1.2 ;
        this.criticalChance *= 2 ;
        break ;
      case "Calm" :
        this.defence *= 1.2 ;
        this.maxHealth *= 1.2 ;
        this.health = this.maxHealth ;
        break ;
    }
  }

  void startWait() {
    this.status = "WAIT" ;
  }
  
  int getExpValue(){
    return this.expValue ;
  }
  String getTrophyName(){
    return this.trophy.getName() ;
  }
  
  Item getTrophy(){
    return trophy ;
  }
  
  String getChara(){
    return this.character ;
  }
}
