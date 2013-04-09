class Player
  
  def initialize()
  	@health = 20
    @shoot = false
  end

  def play_turn(warrior)

    if just_wall?(warrior)
      warrior.pivot!

    elsif warrior.feel.captive?
      warrior.rescue!

    elsif warrior.feel(:backward).captive?
      warrior.rescue! :backward

    elsif warrior.feel.enemy?
      warrior.attack!

    elsif been_attacked?(warrior)
      
      if warrior.health < 15 && enemy_distance(warrior) > 1
        warrior.walk! :backward
        @shoot = false

      elsif wissard_forward?(warrior)
        warrior.shoot!
        @shoot = true

      else
        warrior.walk!
        @shoot = false
        
      end
      
    elsif attack_distance?( warrior )

      if warrior.health > 9
        
        if cautive_back?(warrior)
          warrior.walk! :backward
        else
          warrior.walk!
        end

        @shoot = false
      
      elsif @shoot
        warrior.rest!
        @shoot = false

      else
        warrior.shoot!
        @shoot = true
        
      end

    elsif warrior.health > 12 || look_stairs?(warrior)
      warrior.walk!

    else
       warrior.rest!

    end
  		
  	@health = warrior.health

  end

  def just_wall?(warrior)
    wall = 0
    objects = 0
    
    for feel in warrior.look
      objects += 1 unless feel.empty? && !feel.stairs?
      wall += 1 if feel.wall?
    end

    wall > 0 && objects <= wall ? true : false

  end

  def wissard_forward?(warrior)
    @health - warrior.health == 11
  end

  def cautive_back?(warrior)
    for feel in warrior.look :backward
      return true if feel.captive?  
    end

    false
  end

  def enemy_distance(warrior)
    count = 0

    for feel in warrior.look
      return count if feel.enemy?
      count += 1
    end

  end

  def look_stairs?(warrior)
    stairs =  false

    for feel in warrior.look
      return false if feel.enemy?
      stairs = true if feel.stairs?
    end

    stairs

  end

  def attack_distance?(warrior)
    enemy = false
    
    for feel in warrior.look
      if feel.enemy?
        enemy = true
      elsif feel.captive?
        return false
      end
    end

    enemy
  end

  def been_attacked?(warrior)
  	warrior.health < @health
  end

end


