function getHitpoints(o)
  return o:getHitpoints();
end

function getShields(o)
  return o:getShields();
end
function getHitpoints(o)
  return o:getHitpoints();
end

function getArmorHitpoints(o)
  return o:getArmorHitpoints();
end

function isTurret(o)
  return o:isTurret();
end

function isDocked(o)
  return o:isDocked();
end

--number of jumpdrives
function getJumpDriveIndex(o)
  return o:getJumpDriveIndex();
end
function getMining(o)
  return o:getMining();
end

function getThrust(o)
  return o:getThrust();
end
function getMass(o)
  return o:getMass();
end

function calculateWeaponDamageIndex(o)
  return o:calculateWeaponDamageIndex();
end

function calculateWeaponRangeIndex(o)
  return o:calculateWeaponRangeIndex();
end

function calculateWeaponHitPropabilityIndex(o)
  return o:calculateWeaponHitPropabilityIndex();
end
function calculateWeaponSpecialIndex(o)
  return o:calculateWeaponSpecialIndex();
end
function calculateWeaponPowerConsumptionPerSecondIndex(o)
  return o:calculateWeaponPowerConsumptionPerSecondIndex();
end

function calculateWeaponDamageIndex(o)
  return o:calculateWeaponDamageIndex();
end

function getPowerRecharge(o)
  return o:getPowerRecharge();
end

function getMaxPower(o)
  return o:getMaxPower();
end

function calculateSupportIndex(o)
  return o:calculateSupportIndex();
end



-- called first. this is called for an entity and all its docks once
function calcuateScore(o, bindings)
  score = luajava.newInstance( "org.schema.game.common.controller.elements.EntityIndexScore" );
  
  
  score.weaponDamageIndex = calculateWeaponDamageIndex(o); -- sum dps
  score.weaponRangeIndex = calculateWeaponRangeIndex(o); -- ranges added up / amount of weapons
  score.weaponhitPropabilityIndex = calculateWeaponHitPropabilityIndex(o); -- sum (split * speed (100 for beam)) / reloadSec
  score.weaponSpecialIndex = calculateWeaponSpecialIndex(o);
  score.weaponPowerConsumptionPerSecondIndex = calculateWeaponPowerConsumptionPerSecondIndex(o);
  score.hitpoints = getHitpoints(o);
  score.armor = 0;//getArmorHitpoints(o);
  score.thrust = getThrust(o);
  score.mining = getMining(o);
  score.shields = getShields(o);
  score.jumpDriveIndex = getJumpDriveIndex(o);
  score.mass = getMass(o);
  score.powerRecharge = getPowerRecharge(o);
  score.maxPower = getMaxPower(o);
  score.supportIndex = calculateSupportIndex(o);
  score.docked = isDocked(o);
  score.turret = isTurret(o);
  
  --score children are added automatically
  
  return score;

end

-- called once after all calculateScore for an entity and its docks
function accumulateScores(o, currentScore, bindings)

    

  if(currentScore.docked and not currentScore.turret) then
    o.totalPotentialScore:addScores(currentScore);
  else
    o.totalRealScore:addScores(currentScore);
  end
  

  -- recusively calculate for all docked entities
  for i=0, currentScore.children:size()-1 do
    accumulateScores(o, currentScore.children:get(i), bindings);
  end
  
  
  
end

function calculateResultScores(o, bindings)
  calculateResultScore(o, o.totalRealScore, bindings);
  calculateResultScore(o, o.totalPotentialScore, bindings);
end

function calculateResultScore(o, score, bindings)
  
  powerWM = 0;
  powerWR = 0;
  
  
  -- prevent NaN
  if(score.weaponPowerConsumptionPerSecondIndex > 0) then
    powerWM = score.maxPower / score.weaponPowerConsumptionPerSecondIndex
    powerWR = score.powerRecharge / score.weaponPowerConsumptionPerSecondIndex
  end
 
  
  score.offensiveIndex = 
    (score.weaponDamageIndex + 
    score.weaponRangeIndex + 
    score.weaponhitPropabilityIndex +
    score.weaponSpecialIndex) * 
    (powerWM + powerWR);
    
    
  score.defensiveIndex = (score.armor*0.5 + score.hitpoints + score.shields*2)/60; -- in minutes?
  
  score.powerIndex = score.powerRecharge + score.maxPower;
  
  
  
  score.mobilityIndex = (score.thrust / getMass(o))*10000;
  
  
  score.dangerIndex = score.offensiveIndex + score.defensiveIndex + score.mobilityIndex;

  score.survivabilityIndex = score.defensiveIndex + score.mobilityIndex + score.jumpDriveIndex;

  score.supportIndex = score.support;

  score.miningIndex = score.mining;
  
  
  
end

