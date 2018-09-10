

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
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {20,9,8} );
  isAtBlockHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {20,9,8} );
  moveToHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {8,9,8} );
  isAtBlockHook2          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {8,9,8} );
  moveToHook3             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {4,9,8} );
  isAtBlockHook3          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {4,9,8} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {6,9,8, false} );
  doorCloseHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {6,9,8, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  grvTutHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics01ActivateGrav"} );
  grvTutHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics01-B-Talk"} );
  
  alwaysTrueHook          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "alwaysTrueHookFunc", {} );
  
  giveGravityHook         = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveGravityHookFunc", {true} );
  giveTypeHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {1,100});
  
  factory = dSys:getFactory(bindings);
 

  s0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Ah, great! That's much better!\n\n" ..
  "Now let's go over some basics:\n"..
  "As long as you are talking or a tutorial window is open, you can't perform any actions.\n"..
  "However, there will be plenty of interactive steps where you can freely move around and try things out.\n"..
  "You will see that an interactive step is coming up if \"(press next to take control)\" appears\n"..
  "in the tutorial window.\n\n")
  
  , 2000 );
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  
  dialogObject:format("We saved all the stuff you had in your inventory, you'll get it back when you complete or exit the tutorial.\n".. 
  "We're going to give you some things along the way too.\n\n".. 
  "Those are placed either in your quick bar, or when that is full, in your inventory.\n".. 
  "You can open the inventory with 'I' and drag blocks\n".. 
  "and items into your quick bar at the bottom.\n".. 
  "Then you can either use the mouse wheel or keyboard numbers to select the\n"  ..
  "item you want to use.\n" )
  
  , 2000 );
  
  
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  "We've got some more tests to run before you're space worthy\n" ..
  "so follow me and we'll go meet NPC-1!"
  
  , 2000 );
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I've taught you everything I know.\n" ..
  "Talk to NPC-1 to start the next part of this tutorial!\n\nHave a good tick!")
  
  , 2000 );
  
  okEntry0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  
  s0:setEntryMarking("s0");
  s1:setEntryMarking("s1");
  s2:setEntryMarking("s2");s2:setAwnserEntry(false);
  sEnd:setEntryMarking("sEnd");sEnd:setAwnserEntry(false);
  
  s0:add(s1, "Ok!");
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
  
  s1:add(s2, "You should not see this ->(s2)");
  s1:add(sEnd, "You should not see this ->(sEnd)");
  
  s1:add(okEntry1, dialogObject:format("I understand!"));
  okEntry1:setHook(grvTutHook);
  grvTutHook:setStartState("s1");
  grvTutHook:setEndState("s2");
  
  
  s2:add(okEntry2, dialogObject:format("All right, show me the way!"));
  okEntry2:setHook(moveToHook2);
  
  moveToHook2:setStartState("sEnd");
  moveToHook2:setEndState("sEnd");
 
  moveToHook2:setFollowUp(grvTutHook2);
  moveToHook2:setCondition(alwaysTrueHook);
  grvTutHook2:setStartState("sEnd");
  grvTutHook2:setEndState("sEnd");
 
 -- NPC is at door and opening it
  
  grvTutHook2:setFollowUp(doorOpenHook);
  grvTutHook2:setCondition(isAtBlockHook2);
 
 
  doorOpenHook:setFollowUp(moveToHook3);
  doorOpenHook:setCondition(isAtBlockHook2);
  doorOpenHook:setStartState("sEnd");
  doorOpenHook:setEndState("sEnd");
  
 -- NPC Is behind the door (not closing so player can come too)
  moveToHook3:setFollowUp(moveToHook4)
  moveToHook3:setCondition(isAtBlockHook3);
  
  moveToHook3:setStartState("sEnd");
  moveToHook3:setEndState("sEnd");

  -- NPC is at the end of the tutorial. sEnd will tell the player a finishedMessage
  
  moveToHook4:setStartState("sEnd");
  moveToHook4:setEndState("sEnd");
  
  
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
