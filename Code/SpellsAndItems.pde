static class SpellsAndItems {
  static HashMap allSpells = new HashMap();
  static HashMap elementColorDic = new HashMap() ;
  static color[] elementColors = {#8DEEEE, #FF0000, #458B74, #8B6914, #FFFFFF, #ABABAB} ;
  static String[] allElements = {"Water", "Fire", "Wood", "Earth", "Holy", "Evil"} ;
  static String[] allBuff = {"Attack", "Defense", "Hit Point", "Dodge Point", "Critical Chance", "Invincible", "Growing"} ;
  static String[] allDebuff = {"Attack", "Defense", "Hit Point", "Dodge Point", "Burning", "Silence"} ;
  static String[] itemCatalog = {"Medicine", "Weapon", "Armour", "Shoe"} ;
  static HashMap<String, String> conquerRelation = new HashMap<String, String>() ;
  static ArrayList water1 = new ArrayList() ;
  static ArrayList water2 = new ArrayList() ;
  static ArrayList water3 = new ArrayList() ;
  static ArrayList fire1 = new ArrayList() ;
  static ArrayList fire2 = new ArrayList() ;
  static ArrayList fire3 = new ArrayList() ;
  static ArrayList wood1 = new ArrayList() ;
  static ArrayList wood2 = new ArrayList() ;
  static ArrayList wood3 = new ArrayList() ;
  static ArrayList earth1 = new ArrayList() ;
  static ArrayList earth2 = new ArrayList() ;
  static ArrayList earth3 = new ArrayList() ;
  static ArrayList holy1 = new ArrayList() ;
  static ArrayList holy2 = new ArrayList() ;
  static ArrayList holy3 = new ArrayList() ;
  static ArrayList evil1 = new ArrayList() ;
  static ArrayList evil2 = new ArrayList() ;
  static ArrayList evil3 = new ArrayList() ;
  static ArrayList[][] spellSets = {{water1, water2, water3}, {fire1, fire2, fire3}, {wood1, wood2, wood3}, {earth1, earth2, earth3}, {holy1, holy2, holy3}, {evil1, evil2, evil3}} ;


  static void initSpell(JSONObject spellsJSON) {
    conquerRelation.put("Water", "Fire") ;
    conquerRelation.put("Fire", "Wood") ;
    conquerRelation.put("Wood", "Earth") ;
    conquerRelation.put("Earth", "Water") ;
    conquerRelation.put("Holy", "Evil") ;
    conquerRelation.put("Evil", "Holy") ;
    for (int i = 0; i < 6; i++)
      elementColorDic.put(allElements[i], elementColors[i]) ;
    String[] spellLvs = {"Lv1", "Lv2", "Lv3"} ;
    for (int i = 0; i < allElements.length; i++) {
      for (int j = 0; j < spellLvs.length; j ++) {
        JSONArray as = spellsJSON.getJSONObject(allElements[i]).getJSONObject(spellLvs[j]).getJSONArray("Attack") ;
        JSONArray hs = spellsJSON.getJSONObject(allElements[i]).getJSONObject(spellLvs[j]).getJSONArray("Healing") ;
        JSONArray bs = spellsJSON.getJSONObject(allElements[i]).getJSONObject(spellLvs[j]).getJSONArray("Buff") ;
        JSONArray ds = spellsJSON.getJSONObject(allElements[i]).getJSONObject(spellLvs[j]).getJSONArray("Debuff") ;
        for (int k = 0; k < as.size(); k ++) {
          JSONObject s = as.getJSONObject(k) ;
          spellSets[i][j].add(new Roguelike().new SpellAttack(s.getString("name"), s.getInt("cost"), allElements[i], s.getInt("damage"), s.getFloat("additionRate"), (j+1), s.getString("discription"))) ;
        }
        for (int k = 0; k < hs.size(); k ++) {
          JSONObject s = hs.getJSONObject(k) ;
          spellSets[i][j].add(new Roguelike().new SpellHealing(s.getString("name"), s.getInt("cost"), allElements[i], s.getInt("heal"), s.getFloat("additionRate"), (j+1), s.getString("discription"))) ;
        }
        for (int k = 0; k < bs.size(); k ++) {
          JSONObject s = bs.getJSONObject(k) ;
          spellSets[i][j].add(new Roguelike().new SpellBuff(s.getString("name"), s.getInt("cost"), allElements[i], s.getFloat("buff"), s.getInt("round"), s.getString("buffType"), s.getFloat("additionRate"), (j+1), s.getString("discription"))) ;
        }
        for (int k = 0; k < ds.size(); k ++) {
          JSONObject s = ds.getJSONObject(k) ;
          spellSets[i][j].add(new Roguelike().new SpellDebuff(s.getString("name"), s.getInt("cost"), allElements[i], s.getFloat("debuff"), s.getInt("round"), s.getString("debuffType"), s.getFloat("additionRate"), (j+1), s.getString("discription"))) ;
        }
      }
    }
    allSpells.put("Water-1", water1 ) ;
    allSpells.put("Water-2", water2 ) ;
    allSpells.put("Water-3", water3 ) ;
    allSpells.put("Fire-1", fire1 ) ;
    allSpells.put("Fire-2", fire2 ) ;
    allSpells.put("Fire-3", fire3 ) ;
    allSpells.put("Wood-1", wood1 ) ;
    allSpells.put("Wood-2", wood2 ) ;
    allSpells.put("Wood-3", wood3 ) ;
    allSpells.put("Earth-1", earth1 ) ;
    allSpells.put("Earth-2", earth2 ) ;
    allSpells.put("Earth-3", earth3 ) ;
    allSpells.put("Holy-1", holy1 ) ;
    allSpells.put("Holy-2", holy2 ) ;
    allSpells.put("Holy-3", holy3 ) ;
    allSpells.put("Evil-1", evil1 ) ;
    allSpells.put("Evil-2", evil2 ) ;
    allSpells.put("Evil-3", evil3 ) ;
  }

  static HashMap getAllSpells() {
    return allSpells ;
  }

  static HashMap getAllElementColors() {
    return elementColorDic ;
  }

  static String[] getElements() {
    return allElements ;
  }

  static HashMap allItems = new HashMap();
  static ArrayList medicine1 = new ArrayList() ;
  static ArrayList medicine2 = new ArrayList() ;
  static ArrayList medicine3 = new ArrayList() ;
  static ArrayList weapon1 = new ArrayList() ;
  static ArrayList weapon2 = new ArrayList() ;
  static ArrayList weapon3 = new ArrayList() ;
  static ArrayList armour1 = new ArrayList() ;
  static ArrayList armour2 = new ArrayList() ;
  static ArrayList armour3 = new ArrayList() ;
  static ArrayList shoe1 = new ArrayList() ;
  static ArrayList shoe2 = new ArrayList() ;
  static ArrayList shoe3 = new ArrayList() ;
  static ArrayList[][] itemSets = {{medicine1, medicine2, medicine3}, {weapon1, weapon2, weapon3}, {armour1, armour2, armour3}, {shoe1, shoe2, shoe3}} ;

  static String[] getAllItemCatalog() {
    return itemCatalog ;
  }

  static HashMap getAllItems() {
    return allItems ;
  }
  static void initItem(JSONObject itemsJSON) {
    String[] itemLvs = {"Lv1", "Lv2", "Lv3"} ;
    for (int j = 0; j < itemLvs.length; j ++) {
      JSONArray m = itemsJSON.getJSONObject("Medicine").getJSONArray(itemLvs[j]) ;
      JSONArray w = itemsJSON.getJSONObject("Weapon").getJSONArray(itemLvs[j]) ;
      JSONArray a = itemsJSON.getJSONObject("Armour").getJSONArray(itemLvs[j]) ;
      JSONArray s = itemsJSON.getJSONObject("Shoe").getJSONArray(itemLvs[j]) ;
      for (int k = 0; k < m.size(); k ++) {
        JSONObject item = m.getJSONObject(k) ;
        itemSets[0][j].add(new Roguelike().new Medicine(item.getString("name"), item.getInt("healthPoint"), item.getInt("magicPoint"), (j+1), item.getString("discription"))) ;
      }
      for (int k = 0; k < w.size(); k ++) {
        JSONObject item = w.getJSONObject(k) ;
        itemSets[1][j].add(new Roguelike().new Weapon(item.getString("name"), item.getInt("attackPoint"), item.getInt("criticalPoint"), (j+1), item.getString("discription"))) ;
      }
      for (int k = 0; k < a.size(); k ++) {
        JSONObject item = a.getJSONObject(k) ;
        itemSets[2][j].add(new Roguelike().new Armour(item.getString("name"), item.getInt("defencePoint"), (j+1), item.getString("discription"))) ;
      }
      for (int k = 0; k < s.size(); k ++) {
        JSONObject item = s.getJSONObject(k) ;
        itemSets[3][j].add(new Roguelike().new Shoe(item.getString("name"), item.getInt("hitPoint"), item.getInt("dodgePoint"), (j+1), item.getString("discription"))) ;
      }
    }
    allItems.put("Medicine-1", medicine1) ;
    allItems.put("Medicine-2", medicine2) ;
    allItems.put("Medicine-3", medicine3) ;
    allItems.put("Weapon-1", weapon1) ;
    allItems.put("Weapon-2", weapon2) ;
    allItems.put("Weapon-3", weapon3) ;
    allItems.put("Armour-1", armour1) ;
    allItems.put("Armour-2", armour2) ;
    allItems.put("Armour-3", armour3) ;
    allItems.put("Shoe-1", shoe1) ;
    allItems.put("Shoe-2", shoe2) ;
    allItems.put("Shoe-3", shoe3) ;
  }


  static ArrayList produceTreasure(int lv, ArrayList cata) {
    ArrayList res = new ArrayList() ;
    for (Object o : cata) {
      String c = (String) o ;
      res.addAll((ArrayList)allItems.get(c + "-" + (lv+1))) ;
    }
    return res ;
  }
}
