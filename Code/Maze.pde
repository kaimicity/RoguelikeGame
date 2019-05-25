class Maze {
  int size ;
  int[][] maze ;
  PVector entrance ;
  PVector exit ;
  float brickWidth ;
  float brickHeight ;
  ArrayList impasse ;
  ArrayList secondImpasse ; 
  ArrayList chips ;
  ArrayList treasures ;
  ArrayList monsters ;
  PGraphics graphic ;
  boolean monBlock ;
  int battleMonIndex ;

  Maze(int size, PGraphics pg) {
    this.graphic = pg ;
    this.size = size ;
    this.maze = new int[size * 2 - 1][size * 2 - 1] ;
    for (int i = 0; i< size; i++)
      for (int j = 0; j< size; j++)
        maze[2 * i][2 * j] = 1 ;
    this.brickWidth = (float)pg.width / (size * 2 - 1) ;
    this.brickHeight = (float)pg.height / (size * 2 - 1) ;
    this.impasse = new ArrayList() ;
    this.secondImpasse = new ArrayList() ;
    this.entrance = new PVector(0, 0) ;
    this.exit = new PVector(size * 2 - 2, size * 2 - 2) ;
    produceMaze() ;
    //printMaze() ;
    monBlock = false ;
  }


  int[][] getMaze() {
    return this.maze ;
  }

  PVector getExit() {
    return this.exit ;
  }

  ArrayList getTreasures() {
    return this.treasures ;
  }

  ArrayList getMonsters() {
    return this.monsters ;
  }

  ArrayList getChips() {
    return this.chips ;
  }

  int getSize() {
    return this.size ;
  }

  float getBrickWidth() {
    return this.brickWidth ;
  }

  float getBrickHeight() {
    return this.brickHeight ;
  }

  PVector getEntrance() {
    return this.entrance ;
  }
  void drawMaze() {
    graphic.fill(255) ;
    for (int i = 0; i< size * 2 - 1; i++)
      for (int j = 0; j< size * 2 - 1; j++)
        if (maze[i][j] == 0)
          graphic.rect(i * brickWidth, j * brickHeight, brickWidth, brickHeight) ;
    graphic.fill(color(0, 255, 0)) ;
    graphic.rect(0, 0, brickWidth, brickHeight) ;
    graphic.fill(color(255, 0, 0)) ;
    graphic.rect(exit.x * brickWidth, exit.y * brickHeight, brickWidth, brickHeight) ;
    for (Object t : treasures)
      ((Treasure)t).draw() ;
    for (Object c : chips)
      ((Chip)c).draw() ;
    for (int i = 0; i < monsters.size(); i++) {
      Monster m = (Monster)monsters.get(i) ;
      if (m.isBattle()) {
        if (!monBlock) {
          Roguelike.summonHint("You are going to fight with a monster") ;
        }
          if (!Roguelike.showHint) {
            Roguelike.screen = "BATTLE" ;
            Roguelike.createBattle(m) ;
            battleMonIndex = i ;
          }
        monBlock = true ;
        break ;
      }
      if(i == monsters.size() - 1)
        monBlock = false ;
    }
    for (Object m : monsters) {
      if (!monBlock && !Roguelike.showHint) {
        ((Monster)m).move(this) ;
      }
      ((Monster)m).draw() ;
    }
  }


  PVector randomGet() {
    int x = (int)(Math.random() * size) ;
    int y = (int)(Math.random() * size) ;
    return new PVector(x, y) ;
  }

  PVector reRandom(ArrayList l) {
    int s = l.size() ;
    if ( s > 0) {
      int p = (int)(Math.random() * s) ;
      return (PVector)l.get(p) ;
    } else 
    return new PVector(-1, -1) ;
  }

  boolean listContainVector(ArrayList l, float vX, float vY) {
    for (int i = 0; i < l.size(); i++) {
      PVector p = (PVector)l.get(i) ;
      if (p.x == vX && p.y == vY)
        return true ;
    }
    return false ;
  }

  void produceMaze() {
    ArrayList visited = new ArrayList() ;
    PVector now = randomGet() ;
    //entrance = now ;
    while (visited.size() < size * size) {
      PVector next = new PVector(-1, -1, -1);
      String[] direction = {"UP", "DOWN", "LEFT", "RIGHT"} ;
      String dir = direction[(int)(Math.random() * 4)] ;
      while (!dir.equals("FIN") && !dir.equals("GET")) {
        //Go up!
        if (dir.equals("UP")) {
          if (!(now.y - 1 < 0 || listContainVector(visited, now.x, now.y - 1))) {
            next = new PVector(now.x, now.y - 1, 0) ;
            maze[(int)now.x * 2][(int)now.y * 2 - 1] = 1 ;
            dir = "GET" ;
          } else {
            direction[0] = "NO" ;
            if (direction[0].equals("NO") && direction[1].equals("NO") && direction[2].equals("NO") && direction[3].equals("NO"))
              dir = "FIN" ;
            else
              dir = "NO" ;
            while (dir.equals("NO"))
              dir = direction[(int)(Math.random() * 4)] ;
          }
        }
        //Go down!
        if (dir.equals("DOWN")) {
          if (!(now.y + 1 > size - 1 || listContainVector(visited, now.x, now.y + 1))) {
            next = new PVector(now.x, now.y + 1, 0) ;
            maze[(int)now.x * 2][(int)now.y * 2 + 1] = 1 ;
            dir = "GET" ;
          } else {
            direction[1] = "NO" ;
            if (direction[0].equals("NO") && direction[1].equals("NO") && direction[2].equals("NO") && direction[3].equals("NO"))
              dir = "FIN" ;
            else
              dir = "NO" ;
            while (dir.equals("NO"))
              dir = direction[(int)(Math.random() * 4)] ;
          }
        }
        //Go left!
        if (dir.equals("LEFT")) {
          if (!(now.x - 1 < 0 || listContainVector(visited, now.x - 1, now.y))) {
            next = new PVector(now.x - 1, now.y, 0) ;
            maze[(int)now.x * 2 - 1][(int)now.y * 2] = 1 ;
            dir = "GET" ;
          } else {
            direction[2] = "NO" ;
            if (direction[0].equals("NO") && direction[1].equals("NO") && direction[2].equals("NO") && direction[3].equals("NO"))
              dir = "FIN" ;
            else
              dir = "NO" ;
            while (dir.equals("NO"))
              dir = direction[(int)(Math.random() * 4)] ;
          }
        }
        //Go right
        if (dir.equals("RIGHT")) {
          if (!(now.x + 1 > size - 1 || listContainVector(visited, now.x + 1, now.y))) {
            next = new PVector(now.x + 1, now.y, 0) ;
            maze[(int)now.x * 2 + 1][(int)now.y * 2] = 1 ;
            dir = "GET" ;
          } else {
            direction[3] = "NO" ;
            if (direction[0].equals("NO") && direction[1].equals("NO") && direction[2].equals("NO") && direction[3].equals("NO"))
              dir = "FIN" ;
            else
              dir = "NO" ;
            while (dir.equals("NO"))
              dir = direction[(int)(Math.random() * 4)] ;
          }
        }
      }
      if (dir.equals("FIN")) {
        now.add(0, 0, 1) ;
        next = reRandom(visited) ;
        while (next.z > 0)
          next = reRandom(visited) ;
      }
      if (!listContainVector(visited, now.x, now.y))
        visited.add(now) ;
      now = next ;
    }

    findImpasse() ;
    produceTreasures(1 + (size - 4) * 2) ;
    produceChips(1 + (size - 4) * 4 ) ;
  }
  void printMaze() {
    for (int i = 0; i< size * 2 - 1; i++) {
      String l = "" ;
      for (int j = 0; j< size * 2 - 1; j++)
        l = l + maze[j][i] +" ";
      println(l);
    }
  }

  void findImpasse() {
    for (int i = 0; i< size; i++)
      for (int j = 0; j< size; j++) {
        int walls = 0 ;
        if (!(i * 2 - 1 > 0 && maze[i * 2 - 1][j * 2] == 1))
          walls++ ;
        if (!(i * 2 + 1 < size * 2 - 1 && maze[i * 2 + 1][j * 2] == 1))
          walls++ ;
        if (!(j * 2 - 1 > 0 && maze[i * 2][j * 2 - 1] == 1))
          walls++ ;
        if (!(j * 2 + 1 < size * 2 - 1 && maze[i * 2][j * 2 + 1] == 1))
          walls++ ;
        if (walls == 3)
          impasse.add(new PVector(i * 2, j * 2)) ;
        else if (walls == 2) {
          secondImpasse.add(new PVector(i * 2, j * 2)) ;
        }
      }
    impasse.remove(entrance) ;
    impasse.remove(exit) ;
    secondImpasse.remove(entrance) ;
    secondImpasse.remove(exit) ;
  }

  void produceTreasures(int n) {
    treasures = new ArrayList() ;
    monsters = new ArrayList() ;
    ArrayList treasureImp = impasse ;
    if (impasse.size() < n)
      n = impasse.size() ;
    ArrayList<PVector> treasureLoc = new ArrayList<PVector>() ;
    for (int i = 0; i < n; i++) {
      int x = (int)(Math.random() * treasureImp.size()) ;
      PVector v = (PVector)treasureImp.get(x) ;
      Treasure t = new Treasure(v.x * brickWidth, v.y * brickHeight, brickWidth, brickHeight, size - 5, mazeGraphic) ;
      maze[(int)v.x][(int)v.y] = -1 ;
      treasureLoc.add(v) ;
      treasures.add(t) ;
      treasureImp.remove(x) ;
    }
    for (PVector v : treasureLoc) {
      Monster m = null ;
      if (v.x > 0 && maze[(int)v.x - 1][(int)v.y] > 0 ) {
        ArrayList path = producePath(new PVector(v.x - 1, v.y)) ;
        m = new Monster((v.x - 1) * brickWidth + brickWidth / 2, v.y * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, PI / 2, path, this, mazeGraphic) ;
      } else if (v.x < maze.length - 1 && maze[(int)v.x + 1][(int)v.y] > 0 ) {
        ArrayList path = producePath(new PVector(v.x + 1, v.y)) ;
        m = new Monster((v.x + 1) * brickWidth + brickWidth / 2, v.y * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, 3 * PI / 2, path, this, mazeGraphic) ;
      } else if (v.y < maze.length - 1 && maze[(int)v.x ][(int)v.y + 1] > 0 ) {
        ArrayList path = producePath(new PVector(v.x, v.y + 1)) ;
        m = new Monster(v.x * brickWidth + brickWidth / 2, (v.y + 1) * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, 0, path, this, mazeGraphic) ;
      } else if (v.y > 0 && maze[(int)v.x ][(int)v.y - 1] > 0 ) {
        ArrayList path = producePath(new PVector(v.x, v.y - 1)) ;
        m = new Monster(v.x * brickWidth + brickWidth / 2, (v.y - 1) * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, PI, path, this, mazeGraphic) ;
      }
      monsters.add(m) ;
    }
  }

  void produceChips(int n) {
    chips = new ArrayList() ;
    ArrayList chipImp = impasse ;
    ArrayList chipSecImp = secondImpasse ;
    chipImp.remove(treasures) ;
    if (chipImp.size() >= 0 && chipImp.size() <= n) {
      for (Object pv : chipImp) {
        Chip cp = new Chip(((PVector)pv).x * brickWidth + brickWidth / 2, ((PVector)pv) .y * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, mazeGraphic) ;
        maze[(int)((PVector)pv).x][(int)((PVector)pv).y] = 2 ;
        chips.add(cp) ;
      }
      n = n - chipImp.size() ;
      for (int i = 0; i < n; i++) {
        int x = (int)(Math.random() * chipImp.size()) ;
        PVector c = (PVector)chipSecImp.get(x) ;
        Chip chip = new Chip(c.x * brickWidth + brickWidth / 2, c.y * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, mazeGraphic) ;
        maze[(int)c.x][(int)c.y] = 2 ;
        chips.add(chip) ;
        chipSecImp.remove(x) ;
      }
    } else if (chipImp.size() > n) {
      for (int i = 0; i < n; i++) {
        int x = (int)(Math.random() * chipImp.size()) ;
        PVector c = (PVector)chipImp.get(x) ;
        Chip chip = new Chip(c.x * brickWidth + brickWidth / 2, c.y * brickHeight + brickHeight / 2, brickWidth / 2, brickHeight / 2, mazeGraphic) ;
        maze[(int)c.x][(int)c.y] = 2 ;
        chips.add(chip) ;
        chipImp.remove(x) ;
      }
    }
  }

  boolean chipsClear() {
    for (Object c : chips) {
      if (!((Chip)c).isPicked())
        return false ;
    }
    return true ;
  }

  ArrayList producePath(PVector now) {
    ArrayList res = new ArrayList() ;
    res.add(now) ;
    int nowX = (int)now.x ;
    int nowY = (int)now.y;
    for (int j = 0; j < 5; j++) {
      String[] direction = {"UP", "DOWN", "LEFT", "RIGHT"} ;
      String dir = direction[(int)(Math.random() * 4)] ;
      while (!dir.equals("GET")) {
        switch(dir) {
        case "LEFT":
          if (nowX > 0) {
            PVector pv = new PVector(nowX - 1, nowY) ;
            if (maze[nowX - 1][nowY] > 0 && !res.contains(pv)) {
              res.add(new PVector(nowX - 1, nowY)) ;
              nowX = nowX - 1 ;
              dir = "GET" ;
            } else {
              direction[2] = "NO" ;
            }
          } else {
            direction[2] = "NO" ;
          }
          break ;
        case "RIGHT" :
          if (nowX < maze.length - 1) {
            PVector pv = new PVector(nowX + 1, nowY) ;
            if (maze[nowX + 1][nowY] > 0 && !res.contains(pv)) {
              res.add(new PVector(nowX + 1, nowY)) ;
              nowX = nowX + 1 ;
              dir = "GET" ;
            } else {
              direction[3] = "NO" ;
            }
          } else {
            direction[3] = "NO" ;
          }
          break ;
        case "UP" :
          if (nowY > 0) {
            PVector pv = new PVector(nowX, nowY - 1) ;
            if (maze[nowX][nowY - 1] > 0 && !res.contains(pv)) {
              res.add(new PVector(nowX, nowY - 1)) ;
              nowY = nowY - 1 ;
              dir = "GET" ;
            } else {
              direction[0] = "NO" ;
            }
          } else {
            direction[0] = "NO" ;
          }
          break ;
        case "DOWN" :
          if (nowY < maze.length - 1) {
            PVector pv = new PVector(nowX, nowY + 1) ;
            if (maze[nowX][nowY + 1] > 0 && !res.contains(pv)) {
              res.add(new PVector(nowX, nowY + 1)) ;
              nowY = nowY + 1 ;
              dir = "GET" ;
            } else {
              direction[1] = "NO" ;
            }
          } else {
            direction[1] = "NO" ;
          }
          break ;
        }
        if (!dir.equals("GET")) {
          dir = direction[(int)(Math.random() * 4)] ;
          if (direction[0].equals("NO") && direction[1].equals("NO") && direction[2].equals("NO") && direction[3].equals("NO"))
            break ;
          while (dir.equals("NO"))
            dir = direction[(int)(Math.random() * 4)] ;
        }
      }
    }
    return res ;
  }

  boolean someoneFighting() {
    return monBlock ;
  }

  void removeMonster() {
    monsters.remove(battleMonIndex) ;
  }
}
