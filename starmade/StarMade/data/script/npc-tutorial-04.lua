

function isAtBlock(dialogObject, x, y, z)
  return dialogObject:isAtBlock(x,y,z);
end

function callTutorialHookFunc(dialogObject, turorial)
  return dialogObject:callTutorial(turorial);
end

function unhireHookFunc(dialogObject)
  return dialogObject:unhireConverationPartner();
end
function alwaysTrueHookFunc(dialogObject)
  return true;
end

function hireHookFunc(dialogObject)
  return dialogObject:hireConverationPartner();
end

function activateBlockHookFunc(dialogObject, x, y, z, active)
  return dialogObject:activateBlock(x, y, z, active);
end

function activateBlockSwitchHookFunc(dialogObject, x, y, z)
  return dialogObject:activateBlockSwitch(x,y,z);
end

function giveHelmetHookFunc(dialogObject)
  return dialogObject:giveHelmet(0);
end

function giveRocketLauncherHookFunc(dialogObject)
  return dialogObject:giveRocketLauncher(0);
end

function giveSniperRifleHookFunc(dialogObject)
  return dialogObject:giveSniperRifle(0);
end

function giveLaserWeaponHookFunc(dialogObject)
  return dialogObject:giveLaserWeapon(0);
end

function moveToHookFunc(dialogObject, x, y, z)
  return dialogObject:moveTo(x,y,z);
end

function giveGravityHookFunc(dialogObject, gravBool)
  return dialogObject:giveGravity(gravBool);
end

function giveTypeHookFunc(dialogObject, type, count)
  return dialogObject:giveType(type, count);
end


function mainConversationState(dialogObject)


end

function create(dialogObject, bindings)
  
  dSysClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogSystem" );
  dSysFactoryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactory" );
  dSysEntryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactoryEntry" );
  hookClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua" );
  
  
  dSys = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", dialogObject );
  
  
  hireHook                = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "hireHookFunc", {} );
  unhireHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "unhireHookFunc", {} );
  activateBlockHook       = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {8,9,9,true} );
  activateBlockSwitchHook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockSwitchHookFunc",{8,9,9} );
  giveHelmetHook          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveHelmetHookFunc", {} );
  giveRocketLauncherHook  = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveRocketLauncherHookFunc", {} );
  giveSniperRifleHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveSniperRifleHookFunc", {} );
  giveLaserWeaponHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveLaserWeaponHookFunc", {} );
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {67,9,-1} );
  isAtBlockHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {-6,9,7} );
  moveToHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {36,9,-41} );
  isAtBlockHook2          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {8,9,8} );
  moveToHook3             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {36,9,-41} );
  isAtBlockHook3          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {4,9,8} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {74,9,-5, false} );
  doorCloseHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {6,9,8, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  tutHook                 = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics07PersonalWeapons"} );
  
  alwaysTrueHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "alwaysTrueHookFunc", {} );
  
  giveGravityHook         = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveGravityHookFunc", {true} );
  giveCoreHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {1,1});
  giveCannonBarrelHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {16,6});
  giveCannonComputerHook   = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {6,1});
  givePowerHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {1,1});
  giveThrusterHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {8,1});
  givePowerHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {2,3});
  giveHullHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {5,10});
  
  factory = dSys:getFactory(bindings);
 

  s0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Just two more basic things to learn and you are done.\n" ..
  "You need something to defend yourself without a ship.\n\n" ..
  "I'll tell you about using personal weapons.\n\n")
  , 2000 );
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I'll give you a laser pistol, sniper rifle and a rocket launcher.\n".. 
  "Just hit 'I' to open your inventory and drag them to your quick bar.\n")
  
   , 2000 );
   
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Then, you just have to select the slot and left click to use them.\n\n".. 
  "Try them out over there, at the shooting range.")
  
  , 2000 );
  
 
  
 
  
  
  -- enter tutorial state. let player fly over to other player
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I've taught you everything I know.\n" ..
  "Talk to NPC-5 for the last lesson!")
  , 2000 );
  
  okEntry0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry4 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry10 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  
  s0:setEntryMarking("s0");
  s1:setEntryMarking("s1");
  s2:setEntryMarking("s2");s2:setAwnserEntry(false);
  sEnd:setEntryMarking("sEnd");sEnd:setAwnserEntry(false);
  
  s0:add(s1, "Ok");
  s0:setHook(giveGravityHook);
  s0:addReaction(giveGravityHook, -1, s0);
  s0:addReaction(giveGravityHook, 0, s0);
  s0:addReaction(giveGravityHook, 1, s0);
  
  s1:setHook(moveToHook);
  moveToHook:setStartState("s1");
  moveToHook:setEndState("s1");
  
  s1:addReaction(moveToHook, -1, s1);
  s1:addReaction(moveToHook, 0, s1);
  s1:addReaction(moveToHook, 1, s1);
  
  s1:add(sEnd, "You should not see this ->(sEnd)");
  s1:add(s2, "You should not see this ->(sEnd)");
  
  s1:add(okEntry2, dialogObject:format("Let's blow some stuff up!"));
  okEntry2:setHook(giveLaserWeaponHook);
  giveLaserWeaponHook:setFollowUp(giveRocketLauncherHook);
  giveLaserWeaponHook:setCondition(alwaysTrueHook);
  giveRocketLauncherHook:setFollowUp(giveSniperRifleHook);
  giveRocketLauncherHook:setCondition(alwaysTrueHook);
  giveSniperRifleHook:setFollowUp(doorOpenHook);
  giveSniperRifleHook:setCondition(alwaysTrueHook);
  doorOpenHook:setFollowUp(tutHook);
  doorOpenHook:setCondition(alwaysTrueHook);
  
  tutHook:setStartState("sEnd");
  tutHook:setEndState("sEnd");
 
 
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
