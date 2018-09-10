

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
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {36,9,-41} );
  isAtBlockHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {-6,9,7} );
  moveToHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {36,9,-41} );
  isAtBlockHook2          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {8,9,8} );
  moveToHook3             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {36,9,-41} );
  isAtBlockHook3          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {4,9,8} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {51,9,-38, false} );
  doorOpenHook2            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {57,9,-30, false} );
  doorOpenHook3            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {63,9,-6, false} );
  actPA1           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {39,7,-47, true} );
  actPA2           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {39,7,-47, false} );
  actPB1           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {47,7,-47, false} );
  actPB2           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {47,7,-47, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  tutHook                 = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics05ManualConnection"} );
  tutHook2                 = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics06Combination"} );
  
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
  dialogObject:format("Hello there! Welcome to the advanced class!\n\n" ..
  "I've heard from NPC-02 that you have already built your first ship!\n" ..
  "That's really impressive!\n\n")
  
  , 2000 );
  
 
 
  s01 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Now this is the system everyone in our universe is using: the controller system!\n"..
  "Understanding this system is the key to make anything functional in this world!\n\n")
  
  , 2000 );
  
  s02 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Here's how it works:\n"..
  "Almost all functional blocks come in two types: A controller and modules.\n\n".. 
  "Each module on a structure is used by the controller it is connected to.\n")
  
  , 2000 );

  s03 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("So if you place a Cannon Computer (the controller) down,\n"..
  "the cannon barrels (modules) that are connected to it will fire when you use the controller!\n\n".. 
  "It's the computer that controls the cannons as one object on the quick bar.")
  
  , 2000 ); 
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("First, you need to fix this connection for me. This cannon should fire automatically,\n".. 
  "but they are not linked.")
  , 2000 );
  
  
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("This information can give you an edge over your opponent, so listen closely:\n\n".. 
  "As you may have noticed when you flew those ships back there, the laser cannon has a fairly\n"..
  "long reload time. There is actually a way to change that!\n"..
  "And the best thing is, you can apply the same knowledge to any other weapon out there.\n\n")
 
  , 2000 );
  
  s3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("This is how it works:\n\n".. 
  "If you have two computers with each having their own connected modules, you can actually link\n".. 
  "those two computers together to create a powerful combination weapon.\n\n"..
  "You forfeit the ability to fire both weapons separately for a single, more powerful weapon\n\n"..
  "Depending on which weapon system you \"slave\" to another, the results will differ.\n")
 
  , 2000 );
  
  s4 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Here are some of the most common examples:\n\n".. 
  "- A 'Cannon Computer' slave will increase firing speed.\n"..
  "- A 'Missile Computer' slave will fire more projectiles.\n"..
  "- A 'Damage Beam Computer' will increase range and/or speed.\n"..
  "- A 'Damage Pulse Computer' will increase the damage dealt.\n\n"..
  "There are a lot of combinations.\n\n"..
  "I prepared an example for you over there! We are going to turn this cannon into a shotgun.\n\n")
 
  , 2000 );
  
  
  -- enter tutorial state. let player fly over to other player
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  "I've taught you everything I know.\n" ..
  "Talk to NPC-4 for the next steps in the tutorial!\n\nHave a good tick!"
  
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
  
  s0:add(s01, dialogObject:format("Ok!"));
  s0:setHook(giveGravityHook);
  s0:addReaction(giveGravityHook, -1, s0);
  s0:addReaction(giveGravityHook, 0, s0);
  s0:addReaction(giveGravityHook, 1, s0);
  
  
  s01:add(s02, dialogObject:format("I understand."));
  s02:add(s03, dialogObject:format("Alright!"));
  s03:add(s1, dialogObject:format("I'm ready!"));
  
  s1:setHook(moveToHook);
  moveToHook:setStartState("s1");
  moveToHook:setEndState("s1");
  s1:addReaction(moveToHook, -1, s1);
  s1:addReaction(moveToHook, 0, s1);
  s1:addReaction(moveToHook, 1, s1);
  
  s1:add(sEnd, "You should not see this ->(sEnd)");
  s1:add(s2, "You should not see this ->(sEnd)");
  
  s1:add(okEntry2, "Let's do it!!");
  
  okEntry2:setHook(tutHook);
  tutHook:setStartState("s2");
  tutHook:setEndState("s2");
  
  tutHook:setFollowUp(actPA1);
  tutHook:setCondition(alwaysTrueHook);
  actPA1:setFollowUp(actPA2);
  actPA1:setCondition(alwaysTrueHook);
  actPA2:setFollowUp(actPB1);
  actPA2:setCondition(alwaysTrueHook);
  actPB1:setFollowUp(actPB2);
  actPB1:setCondition(alwaysTrueHook);
  
  
  
  actPA1:setStartState("s2");
  actPA2:setStartState("s2");
  actPB1:setStartState("s2");
  actPB2:setStartState("s2");
  actPA1:setEndState("s2");
  actPA2:setEndState("s2");
  actPB1:setEndState("s2");
  actPB2:setEndState("s2");
 
  
  s2:add(s3, dialogObject:format("I'm listening!"));
  s3:add(s4, dialogObject:format("What kind of new weapons can I create?"));
  
  s4:add(okEntry4, dialogObject:format("I'm ready!"));
  okEntry4:setHook(doorOpenHook);
  
  doorOpenHook:setFollowUp(doorOpenHook2);
  doorOpenHook:setCondition(alwaysTrueHook);
  doorOpenHook:setStartState("sEnd");
  doorOpenHook:setEndState("sEnd");
  
  doorOpenHook2:setFollowUp(doorOpenHook3);
  doorOpenHook2:setCondition(alwaysTrueHook);
  
  doorOpenHook3:setFollowUp(tutHook2);
  doorOpenHook3:setCondition(alwaysTrueHook);
  tutHook2:setStartState("sEnd");
  tutHook2:setEndState("sEnd");
 
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
