

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
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {78,9,-3} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {88,9,3, false} );
  doorCloseHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {6,9,8, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  tutHook                 = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics08Crafting"} );
  
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
  dialogObject:format("This is the last and most important lesson: Crafting\n" ..
  "It's the best way to make money and anything you'll need in this world.\n\n" ..
  "The crafting is based on a tree, with raw resources at the bottom. Almost every block has a recipe,\n"..
  "that is based on those raw resources. There are two main types of raw materials: crystal shards and ore.\n"..
  "You can process them into generic materials and capsules:\n\n"..
  "- Generic materials are alloyed metal meshes and crystal circuits. They can be used to make anything basic.\n"..
  "- Advanced materials are capsules. They are specific and needed for the more advanced recipes.\n")
  
  , 2000 );
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("You can mine resources by hand just fine, but it's a lot more efficient using a salvage ship.\n".. 
  "Also, you can process raw resources with your tools embedded in your astronaut suit.\n"..
  "It's much more efficient to use a factory block for that though!\n\n"..
  "Especially when refining raw resources, you won't get any capsules and less generic materials\n"..
  "if you don't use the Capsule Refinery block for that.\n\n")
  
   , 2000 );
   
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("You can produce the basic factory block with your suit's tools as well.\n\n".. 
  "The basic factory makes the capsule refinery as well as the standard factory for\n"..
  "more advanced crafting. There is even an advanced factory, which in turn is produced\n"..
  "in the standard factory.\n\n".. 
  "Should you not have a power block for your factories, you can use your power supply tool to power\n"..
  "it, so you can make a few blocks in emergencies . That's what we are going to do now: Produce a power\n"..
  "block from scratch!")
  
  , 2000 );
  
 
  
 
  
  
  -- enter tutorial state. let player fly over to other player
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I've taught you everything I know.\n" ..
  "Check around the station. There are still a lot of NPCs around that will tell you\n"..
  "useful information!"..
  "When you are done, just hit ESC and hit the 'Exit Tutorial' button.")
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
  
  s0:add(s1, dialogObject:format("Understood!"));
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
  
  s1:add(okEntry2, dialogObject:format("Let's craft!"));
  okEntry2:setHook(tutHook);
  
  tutHook:setStartState("sEnd");
  tutHook:setEndState("sEnd");
  tutHook:setFollowUp(doorOpenHook);
  tutHook:setCondition(alwaysTrueHook);
  doorOpenHook:setStartState("sEnd");
  doorOpenHook:setEndState("sEnd");
 
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
