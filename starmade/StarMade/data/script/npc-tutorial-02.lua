

function isAtBlock(dialogObject, x, y, z)
  return dialogObject:isAtBlock(x,y,z);
end

function callTutorialHookFunc(dialogObject, turorial)
  return dialogObject:callTutorial(turorial);
end

function destroyShipHookFunk(dialogObject, uid)
  return dialogObject:destroyShip(uid);
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
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {-6,9,-38} );
  isAtBlockHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {-6,9,7} );
  moveToHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {8,9,8} );
  isAtBlockHook2          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {8,9,8} );
  moveToHook3             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {4,9,8} );
  isAtBlockHook3          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {4,9,8} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {4,9,-38, false} );
  doorOpenHook2            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {30,9,-38, false} );
  doorCloseHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {-7,9,-33, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  tutHook                 = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics03ShipBuilding"} );
  tutHook2                = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics04ShipConnection"} );

  destroyShip                = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "destroyShipHookFunk", {"ENTITY_SHIP_tutorialShip00"} );
  
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
  dialogObject:format("Ah %s, you made it!\nI'm \"NPC-02\"!\n\n" ..
  "Now that you know how to fly a ship, I will teach you how to build one.\n", dialogObject:getEntity():getName())
  
  , 2000 );
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("There are various ways to acquire a ship. Buy one from the blueprint catalogue,\n".. 
  "steal one, defeat one, get one as a gift, and of course build one yourself!\n"..
  "You can build as many as you like!\n"..
  "A good ship builder can construct ships that dominate any other ship of equal size,\n".. 
  "but let's start with the basics.\n\n")
 
  , 2000 );
  
  
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("A ship needs two essential systems to be usable: Power and Thrust.\n"..  
  "Place both types on your ship and you will be able to fly.\n"..  
  "Keep in mind, the more thrust modules you place, the more power you will need\n"..
  "and the faster you'll accelerate!")
 
  , 2000 );
  
   s3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I will give you a core, a few power modules and a thruster.\n"..
  "To spawn that core, just press 'X' and name it. Be sure there is enough space\n" .. 
  "in front of you, so don't look at the ground while doing this.\n\n"..   
  "Let me remove this pre-made ship real quick for you.")   
  
  , 2000 );

   s4 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Well done %s, you are a fast learner!\n"..
  "Now, let's check out how weapons and other systems work on ships.\n" .. 
  "There are several weapons to choose from, as well as several systems,\n"..   
  "most importantly the salvage beam and the laser cannon.\n", dialogObject:getEntity():getName())   
  
  , 2000 );
  
   s5 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("The salvage beam lets you take blocks and mine minerals from a safe distance.\n"..
  "It's also much faster than picking up those blocks by hand, and will increase efficiency with salvage beam size.\n\n".. 
  "The laser cannon is your basic defence and does more damage the bigger it is.\n"..   
  "You can also make different versions of it, like a shotgun or a machine gun type.\n"..   
  "I'll explain how that works later.\n" )  
  
  , 2000 );
  
   
  
  s9 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Luckily on ships, if you put them down in the right order, you\n"..
  "won't have to do any manual connecting at all!\n\n")
  
  , 2000 );
  
  s10 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("If you place a cannon computer or any other controller on a ship, it is automatically connected to the\n"..
  "core. After you place a computer, each cannon barrel is automatically linked, unless you select\n"..
  "something else.\n\n"..
  "Go ahead, give it a shot. I'll give you a computer and some barrels. Place the computer first and then\n"..
  "place the barrels. After you're happy with it, press 'T' to open the weapons panel.")
  
  , 2000 );
  -- enter tutorial state. let player fly over to other player
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I've taught you everything I know.\n" ..
  "Talk to NPC-3 for the next steps in the tutorial!\n\nHave a good tick!")
  
  , 2000 );
  
  okEntry0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", "Ok", 2000 );
  okEntry1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", "Ok", 2000 );
  okEntry2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", "Ok", 2000 );
  okEntry3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", "Ok", 2000 );
  okEntry10 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", "Ok", 2000 );
  
  s0:setEntryMarking("s0");
  s1:setEntryMarking("s1");
  s2:setEntryMarking("s2");
  s3:setEntryMarking("s3");
  s4:setEntryMarking("s4");s4:setAwnserEntry(false);
  sEnd:setEntryMarking("sEnd");sEnd:setAwnserEntry(false);
  
  s0:add(s1, dialogObject:format("Ok"));
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
  
  s1:add(s2, dialogObject:format("Alright!"));
  
  
  s2:add(s3, dialogObject:format("Yes"));
  s3:add(okEntry3, dialogObject:format("Spawn Core, got it!"));
  s3:add(s4, "you should not see this -> (s4)");
  
  okEntry3:setHook(destroyShip);
  destroyShip:setFollowUp(giveCoreHook);
  destroyShip:setCondition(alwaysTrueHook);

  giveCoreHook:setFollowUp(givePowerHook);
  giveCoreHook:setCondition(alwaysTrueHook);
  
  givePowerHook:setFollowUp(doorCloseHook);
  givePowerHook:setCondition(alwaysTrueHook);

  doorCloseHook:setFollowUp(giveThrusterHook);
  doorCloseHook:setCondition(alwaysTrueHook);
  
  giveThrusterHook:setFollowUp(tutHook);
  giveThrusterHook:setCondition(alwaysTrueHook);
  
  tutHook:setStartState("s4");
  tutHook:setEndState("s4");
 
  s4:add(s5, dialogObject:format("Ok"));
  s5:add(s9, dialogObject:format("Ok"));
  s9:add(s10, dialogObject:format("Ok"));
  s10:add(okEntry10, dialogObject:format("Ok"));
 
  
  
  okEntry10:setHook(giveCannonComputerHook);
  giveCannonComputerHook:setFollowUp(giveCannonBarrelHook);
  giveCannonComputerHook:setCondition(alwaysTrueHook);
  
  giveCannonComputerHook:setStartState("sEnd");
  giveCannonComputerHook:setEndState("sEnd");
  
  giveCannonBarrelHook:setFollowUp(doorOpenHook);
  giveCannonBarrelHook:setCondition(alwaysTrueHook);
  
  giveCannonBarrelHook:setStartState("sEnd");
  giveCannonBarrelHook:setEndState("sEnd");
  
  doorOpenHook:setStartState("sEnd");
  doorOpenHook:setEndState("sEnd");
  
  doorOpenHook:setFollowUp(doorOpenHook2);
  doorOpenHook:setCondition(alwaysTrueHook);
  
  doorOpenHook2:setStartState("sEnd");
  doorOpenHook2:setEndState("sEnd");
  
  doorOpenHook2:setFollowUp(tutHook2);
  doorOpenHook2:setCondition(alwaysTrueHook);
  
  tutHook2:setStartState("sEnd");
  tutHook2:setEndState("sEnd");
  
 
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
