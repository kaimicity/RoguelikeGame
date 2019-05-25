abstract class Individual {
  String name ;
  PVector position ;
  float width ;
  float height ;
  float moveIncrement ;
  int level ;
  int exp ;
  int levelUpExp ;
  int attack ;
  int defence ;
  int health ;
  int maxHealth ;
  int magic ;
  int maxMagic ;
  int criticalChance ;
  int hitPoint ; //my hit  / (enemy dodge + my hit)
  int dodgePoint ;
  PGraphics graphic ;
  ArrayList spells ;
  float orientation ;
  PVector velocity ;
  float turnIncrement ;
  String type ; 
  boolean invincible ;
  boolean silence ;



  float getX() {
    return this.position.x ;
  }

  float getY() {
    return this.position.y ;
  }
  
  PVector getPosition(){
    return this.position ;
  }

  float getWidth() {
    return this. width ;
  }

  float getHeight() {
    return this.height ;
  }
  String getName() {
    return this.name ;
  }
  
  String getType(){
    return this.type ;
  }
  int getExp() {
    return this.exp ;
  }

  int getLevelUpExp() {
    return this.levelUpExp ;
  }
  int getAttack() {
    return this.attack ;
  }

  void setAttack(int attack){
    this.attack = attack ;
  }
  
  int getDefence() {
    return this.defence ;
  }
  
  void setDefence(int defence){
    this.defence = defence ;
  }

  int getHealth() {
    return this.health ;
  }

  int getMaxHealth() {
    return this.maxHealth ;
  }

  int getMagic() {
    return this.magic ;
  }

  int getMaxMagic() {
    return this.maxMagic ;
  }

  int getCriticalChance() {
    return this.criticalChance ;
  }
  
  void setCriticalChance(int cc){
    this.criticalChance = cc ;
  }

  int getHitPoint() {
    return this.hitPoint ;
  }

  void setHitPoint(int hp){
    this.hitPoint = hp ;
  }
  
  int getDodgePoint() {
    return this.dodgePoint ;
  }
  
  void setDodgePoint(int dp){
    this.dodgePoint = dp ;
  }

  int getLevel() {
    return this.level ;
  }

  ArrayList getSpells() {
    return this.spells ;
  }

  PVector locate(Maze m) {
    int x = (int)(this.position.x / m.getBrickWidth()) ;
    int y = (int)(this.position.y / m.getBrickHeight()) ;
    return new PVector(x, y) ;
  }
  
  void getHealing(int heal){
    this.health += heal ;
    if(health > maxHealth)
      health = maxHealth ;
  }
  
  void getMagic(int mgc){
    this.magic += mgc ;
    if(magic > maxMagic)
      magic = maxMagic ;
  }

  void moveRight(Maze m) {
    boolean rightAccess = true ;
    int[][] maze = m.getMaze() ;
    PVector location = locate(m) ;
    if (location.x + 1 > maze.length - 1) {
      if (position.x + width / 2 + moveIncrement >= maze.length * m.getBrickWidth()) {
        rightAccess = false ;
      }
    } else {
      PVector rightGuy1 = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
      boolean collision1 = CollisionDetector.rect2Rect(new PVector(this.position.x + moveIncrement, position.y), width, height, rightGuy1, m.getBrickWidth(), m.getBrickHeight()) 
        && maze[(int)location.x + 1][(int)location.y] < 1 ;
      boolean collision2 = false ;
      if (location.y > 0) {
        PVector rightGuy2 = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collision2 = CollisionDetector.rect2Rect(new PVector(this.position.x + moveIncrement, position.y), width, height, rightGuy2, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y - 1] < 1 ;
      }
      boolean collision3 = false ;
      if (location.y < maze.length - 1 ) {
        PVector rightGuy3 = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collision3 = CollisionDetector.rect2Rect(new PVector(this.position.x + moveIncrement, position.y), width, height, rightGuy3, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y + 1] < 1 ;
      }
      if (collision1 || collision2 || collision3)
        rightAccess = false ;
    }
    if (rightAccess)
      this.position.x += moveIncrement;
  }

  void moveLeft(Maze m) {
    boolean leftAccess = true ;
    int[][] maze = m.getMaze() ;
    PVector location = locate(m) ;
    if (location.x - 1 < 0) {
      if (position.x - width / 2 - moveIncrement <= 0) {
        leftAccess = false ;
      }
    } else {
      PVector leftGuy1 = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
      boolean collision1 = CollisionDetector.rect2Rect(new PVector(this.position.x - moveIncrement, position.y), width, height, leftGuy1, m.getBrickWidth(), m.getBrickHeight())
        && maze[(int)location.x - 1][(int)location.y] < 1 ;
      boolean collision2 = false ;
      if (location.y > 0) {
        PVector leftGuy2 = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collision2 = CollisionDetector.rect2Rect(new PVector(this.position.x - moveIncrement, position.y), width, height, leftGuy2, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y - 1] < 1;
      }
      boolean collision3 = false ;
      if (location.y < maze.length - 1 ) {
        PVector leftGuy3 = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collision3 = CollisionDetector.rect2Rect(new PVector(this.position.x - moveIncrement, position.y), width, height, leftGuy3, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y + 1] < 1;
      }
      if (collision1 || collision2 || collision3)
        leftAccess = false ;
    }
    if (leftAccess)
      this.position.x -= moveIncrement;
  }

  void moveUp(Maze m) {
    boolean upAccess = true ;
    int[][] maze = m.getMaze() ;
    PVector location = locate(m) ;
    if (location.y - 1 < 0) {
      if (position.y - height / 2 - moveIncrement <= 0) {
        upAccess = false ;
      }
    } else {
      PVector upGuy1 = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
      boolean collision1 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y - moveIncrement), width, height, upGuy1, m.getBrickWidth(), m.getBrickHeight())
        && maze[(int)location.x][(int)location.y - 1] < 1 ;
      boolean collision2 = false ;
      if (location.x > 0) {
        PVector upGuy2 = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collision2 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y - moveIncrement), width, height, upGuy2, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y - 1] < 1;
      }
      boolean collision3 = false ;
      if (location.x < maze.length - 1 ) {
        PVector upGuy3 = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collision3 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y - moveIncrement), width, height, upGuy3, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y - 1] < 1;
      }
      if (collision1 || collision2 || collision3)
        upAccess = false ;
    }
    if (upAccess)
      this.position.y -= moveIncrement;
  }

  void moveDown(Maze m) {
    boolean downAccess = true ;
    int[][] maze = m.getMaze() ;
    PVector location = locate(m) ;
    if (location.y + 1 > maze.length - 1) {
      if (position.y + height / 2 + moveIncrement >= maze.length * m.getBrickHeight()) {
        downAccess = false ;
      }
    } else {
      PVector downGuy1 = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
      boolean collision1 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y + moveIncrement), width, height, downGuy1, m.getBrickWidth(), m.getBrickHeight())
        && maze[(int)location.x][(int)location.y + 1] < 1 ;
      boolean collision2 = false ;
      if (location.x > 0) {
        PVector downGuy2 = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collision2 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y + moveIncrement), width, height, downGuy2, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y + 1] < 1;
      }
      boolean collision3 = false ;
      if (location.x < maze.length - 1 ) {
        PVector downGuy3 = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collision3 = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y + moveIncrement), width, height, downGuy3, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y + 1] < 1;
      }
      if (collision1 || collision2 || collision3)
        downAccess = false ;
    }
    if (downAccess)
      this.position.y += moveIncrement;
  }

  void moveAhead(Maze m) {
    velocity.x = - moveIncrement * sin(orientation) ;
    velocity.y = moveIncrement * cos(orientation) ;
    int[][] maze = m.getMaze() ;
    PVector location = locate(m) ;

    if (isGoingUpRight()) {
      boolean collisionUp = false ;
      boolean collisionRight = false ;
      boolean collisionUpRight = false ;
      if (location.y - 1 < 0 ) {
        if (position.y - moveIncrement - height / 2 <= 0 )
          collisionUp = true ;
      } else {
        PVector upGuy = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionUp = CollisionDetector.rect2Rect(new PVector(position.x+ velocity.x, this.position.y + velocity.y ), width, height, upGuy, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x][(int)location.y - 1] < 1 ;
      }
      if (location.x + 1 > maze.length - 1) {
        if (position.x + width / 2 + moveIncrement >= graphic.width )
          collisionRight = true ;
      } else {
        PVector rightGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        collisionRight = CollisionDetector.rect2Rect(new PVector(this.position.x+ velocity.x, position.y+ velocity.y), width, height, rightGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y] < 1 ;
      }
      boolean collisionDownRight = false ;
      if(location.x + 1 < maze.length - 1 && location.y + 1 < maze.length + 1){
        PVector rightDownGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDownRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, rightDownGuy.x, rightDownGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x + 1][(int)location.y + 1] < 1 ;
      }
      boolean collisionUpLeft = false ;
      if(location.x - 1 > 0 && location.y - 1 > 0){
        PVector upLeftGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionDownRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, upLeftGuy.x, upLeftGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y - 1] < 1 ;
      }
      if (collisionUp || collisionUpLeft)
        velocity.y = 0 ;
      if (collisionRight || collisionDownRight)
        velocity.x = 0 ;
      PVector rightUpGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
      if (location.y - 1 > 0 && location.x + 1 < maze.length - 1) {
        collisionUpRight = CollisionDetector.rect2Rect(new PVector(position.x + velocity.x, this.position.y + velocity.y), width, height, rightUpGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y - 1] < 1;
      }
      if (!collisionUp && !collisionRight && collisionUpRight) {
          if(position.x <= rightUpGuy.x - m.getBrickWidth() / 2 - width / 2 )
            velocity.x = 0 ;
          else 
            velocity.y = 0 ;
      }
    } 
    if (isGoingUpLeft()) {
      boolean collisionUp = false ;
      boolean collisionLeft = false ;
      boolean collisionUpLeft = false ;
      if (location.y - 1 < 0 ) {
        if (position.y - moveIncrement - height / 2 <= 0)
          collisionUp = true ;
      } else {
        PVector upGuy = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionUp = CollisionDetector.rect2Rect(new PVector(position.x+ velocity.x, this.position.y + velocity.y ), width, height, upGuy, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x][(int)location.y - 1] < 1 ;
      }
      if (location.x - 1 < 0) {
        if (position.x - width / 2 - moveIncrement <= 0 )
          collisionLeft = true ;
      } else {
        PVector leftGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        collisionLeft = CollisionDetector.rect2Rect(new PVector(position.x + velocity.x, this.position.y + velocity.y), width, height, leftGuy, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y] < 1 ;
      }
      boolean collisionDownLeft = false ;
      if(location.x - 1 > 0 && location.y + 1 < maze.length + 1){
        PVector leftDownGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDownLeft = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, leftDownGuy.x, leftDownGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y + 1] < 1 ;
      }
      boolean collisionUpRight = false ;
      if(location.x + 1 < maze.length - 1 && location.y - 1 > 0){
        PVector upRightGuy = new PVector(location.x * m.getBrickWidth() + 3 *  m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionUpRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, upRightGuy.x, upRightGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x + 1][(int)location.y - 1] < 1 ;
      }
      if (collisionUp || collisionUpRight)
        velocity.y = 0 ;
      if (collisionLeft || collisionDownLeft)
        velocity.x = 0 ;
      PVector leftUpGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
      if (location.y - 1 > 0 && location.x - 1 > 0) {
        collisionUpLeft = CollisionDetector.rect2Rect(new PVector(position.x, this.position.y - moveIncrement), width, height, leftUpGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y - 1] < 1;
      }
      if (!collisionUp && !collisionLeft && collisionUpLeft) {
        if(position.x >= leftUpGuy.x + m.getBrickWidth() / 2 + width / 2 )
            velocity.x = 0 ;
          else 
            velocity.y = 0 ;
      }
    } 
    if (isGoingDownLeft()) {
      boolean collisionDown = false ;
      boolean collisionLeft = false ;
      boolean collisionDownLeft = false ;
      if (location.y + 1 > maze.length - 1 ) {
        if (position.y + moveIncrement + height / 2 >= graphic.height)
          collisionDown = true ;
      } else {
        PVector downGuy = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDown = CollisionDetector.rect2Rect(new PVector(position.x+velocity.x, this.position.y + velocity.y), width, height, downGuy, m.getBrickWidth(), m.getBrickHeight())
        && maze[(int)location.x][(int)location.y + 1] < 1 ;
      }
      if (location.x - 1 < 0) {
        if (position.x - width / 2 - moveIncrement <= 0 )
          collisionLeft = true ;
      } else {
        PVector leftGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        collisionLeft = CollisionDetector.rect2Rect(new PVector(position.x+ velocity.x, this.position.y + velocity.y), width, height, leftGuy, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y] < 1 ;
      }
      boolean collisionDownRight = false ;
      if(location.x + 1 < maze.length - 1 && location.y + 1 < maze.length + 1){
        PVector rightDownGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDownRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, rightDownGuy.x, rightDownGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x + 1][(int)location.y + 1] < 1 ;
      }
      boolean collisionUpLeft = false ;
      if(location.x - 1 > 0 && location.y - 1 > 0){
        PVector upLeftGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionDownRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, upLeftGuy.x, upLeftGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y - 1] < 1 ;
      }
      if (collisionDown || collisionDownRight)
        velocity.y = 0 ;
      if (collisionLeft || collisionUpLeft)
        velocity.x = 0 ;
      PVector leftDownGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
      if (location.y + 1 < maze.length  && location.x - 1 > 0) {
        collisionDownLeft = CollisionDetector.rect2Rect(new PVector(position.x + velocity.x, this.position.y + velocity.y), width, height, leftDownGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x - 1][(int)location.y + 1] < 1;
      }
      if (!collisionDown && !collisionLeft && collisionDownLeft) {
        if(position.x >= leftDownGuy.x + m.getBrickWidth() / 2 + width / 2 )
            velocity.x = 0 ;
          else 
            velocity.y = 0 ;
      }
    } 
    if (isGoingDownRight()) {
      boolean collisionDown = false ;
      boolean collisionRight = false ;
      boolean collisionDownRight = false ;
      if (location.y + 1 > maze.length - 1 ) {
        if (position.y + moveIncrement + height / 2 >= graphic.height)
          collisionDown = true ;
      } else {
        PVector downGuy = new PVector(location.x * m.getBrickWidth() + m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDown = CollisionDetector.rect2Rect(new PVector(position.x+velocity.x, this.position.y + velocity.y), width, height, downGuy, m.getBrickWidth(), m.getBrickHeight())
        && maze[(int)location.x][(int)location.y + 1] < 1 ;
      }
      if (location.x + 1 > maze.length - 1) {
        if (position.x + width / 2 + moveIncrement >= graphic.width )
          collisionRight = true ;
      } else {
        PVector rightGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + m.getBrickHeight() / 2) ;
        collisionRight = CollisionDetector.rect2Rect(new PVector(this.position.x+ velocity.x, position.y+ velocity.y), width, height, rightGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y] < 1 ;
      }
      boolean collisionDownLeft = false ;
      if(location.x - 1 > 0 && location.y + 1 < maze.length + 1){
        PVector leftDownGuy = new PVector(location.x * m.getBrickWidth() - m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
        collisionDownLeft = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, leftDownGuy.x, leftDownGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x - 1][(int)location.y + 1] < 1 ;
      }
      boolean collisionUpRight = false ;
      if(location.x + 1 < maze.length - 1 && location.y - 1 > 0){
        PVector upRightGuy = new PVector(location.x * m.getBrickWidth() + 3 *  m.getBrickWidth() / 2, location.y * m.getBrickHeight() - m.getBrickHeight() / 2) ;
        collisionUpRight = CollisionDetector.circle2Rect(position.x+ velocity.x, this.position.y + velocity.y, width / 2, upRightGuy.x, upRightGuy.y, m.getBrickWidth(), m.getBrickHeight())
          && maze[(int)location.x + 1][(int)location.y - 1] < 1 ;
      }
      if (collisionDown || collisionDownLeft)
        velocity.y = 0 ;
      if (collisionRight || collisionUpRight)
        velocity.x = 0 ;
      PVector rightDownGuy = new PVector(location.x * m.getBrickWidth() + 3 * m.getBrickWidth() / 2, location.y * m.getBrickHeight() + 3 * m.getBrickHeight() / 2) ;
      if (location.y + 1 < maze.length  && location.x - 1 > 0) {
        collisionDownRight = CollisionDetector.rect2Rect(new PVector(position.x + velocity.x, this.position.y + velocity.y), width, height, rightDownGuy, m.getBrickWidth(), m.getBrickHeight()) 
          && maze[(int)location.x + 1][(int)location.y + 1] < 1;
      }
      if (!collisionDown && !collisionRight && collisionDownRight) {
        if(position.x <= rightDownGuy.x - m.getBrickWidth() / 2 - width / 2 )
            velocity.x = 0 ;
          else 
            velocity.y = 0 ;
      }
    }
    position.add(velocity) ;
  }

  void turnRight() {
    orientation += turnIncrement ;
    while (orientation >= 2 * PI)
      orientation -= 2 * PI ;
  }

  void turnLeft() {
    orientation -= turnIncrement ;
    while (orientation < 0)
      orientation += 2 * PI ;
  }
  
  void turnBack() {
    orientation -= PI ;
    while (orientation < 0)
      orientation += 2 * PI ;
  }
  boolean isGoingDownLeft() {
    return (orientation <= PI / 2 && orientation >= 0) ;
  }

  boolean isGoingUpLeft() {
    return (orientation <= PI  && orientation >= PI / 2) ;
  }

  boolean isGoingDownRight() {
    return (orientation <= 2 * PI && orientation >= 3 * PI / 2) ;
  }

  boolean isGoingUpRight() { 
    return (orientation <= 3 * PI / 2 && orientation >= PI) ;
  }
  
  float caMag(PVector v1, PVector v2){
    PVector pv = new PVector(v2.x - v1.x, v2.y - v1.y) ;
    return pv.mag() ;
  }
  
  void loseLife(int ll){
    this.health -= ll ;
    if(health < 0)
      health = 0 ;
  }
  
  boolean isInvin(){
    return this.invincible ;
  }
  
  boolean isSilence(){
    return this.silence ;
  }
  
  void setInvin(boolean i){
    this.invincible = i ;
  }
  
  void setSilence(boolean s){
    this.silence = s ;
  }
  
  void initStatus(){
    health = maxHealth ;
    magic = maxMagic ;
  }
  
  
  void spendMagic(int cost) {
    this.magic -= cost ;
  }
}
