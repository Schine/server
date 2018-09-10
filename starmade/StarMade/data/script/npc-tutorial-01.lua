

function isAtBlock(dialogObject, x, y, z)
  return dialogObject:isAtBlock(x,y,z);
end

function callTutorialHookFunc(dialogObject, turorial)
  return dialogObject:callTutorial(turorial);
end

function unhireHookFunc(dialogObject)
  return dialogObject:unhireConverationPartner();
end

function hireHookFunc(dialogObject)
  return dialogObject:hireConverationPartner();
end
function alwaysTrueHookFunc(dialogObject)
  return true;
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
  moveToHook              = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {-6,9,7} );
  isAtBlockHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {-6,9,7} );
  moveToHook2             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {8,9,8} );
  isAtBlockHook2          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {8,9,8} );
  moveToHook3             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {4,9,8} );
  isAtBlockHook3          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "isAtBlock", {4,9,8} );
  doorOpenHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {-6,9,13, false} );
  doorCloseHook           = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "activateBlockHookFunc", {6,9,8, true} );
  moveToHook4             = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "moveToHookFunc", {0,9,8} );
  shipFlyTutHook          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "callTutorialHookFunc", {"TutorialBasics02ShipBasics"} );
  
  alwaysTrueHook          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "alwaysTrueHookFunc", {} );
  
  giveGravityHook         = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveGravityHookFunc", {true} );
  giveTypeHook            = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTypeHookFunc", {1,100});
  
  factory = dSys:getFactory(bindings);
 

  s0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Greetings %s, I'm \"NPC-01\"!\n\n" ..
  "I will teach you about one of the most important things in the StarMade Universe: Ships!\n", dialogObject:getEntity():getName())
  
  , 2000 );
  
  s1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Block count is not all that matters, the architecture and design also has an important role on the effectiveness\n".. 
  "and efficiency of every structure in StarMade.\n\n".. 
  "For now we are only talking about Ships.\n")
  
  , 2000 );
  
  
  s2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Every ship has a core. A core is the heart of a ship, and without it the ship will not\n"..
  "function, so be sure to protect it at any cost.\n\n" .. 
  "Additionally the core block will serve as your vessel's point of control,\n" .. 
  "so be sure you keep that in mind when building.\n" )
  
  , 2000 );
  
   s3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format( "That over there is a small pre-built ship. The core is at the centre.\n"..
  "You can enter the core by pressing 'R', and take control of the ship.\n\n" )
  
  , 2000 );
  
  -- enter tutorial state. let player fly over to other player
  
  sEnd = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("I've taught you everything I know.\n" ..
  "Talk to NPC-02 for the next steps in the tutorial!\n\nHave a good time!")
  
  , 2000 );
  
  okEntry0 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  okEntry3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.CancelDialogEntry", dialogObject:format("Ok"), 2000 );
  
  s0:setEntryMarking("s0");
  s1:setEntryMarking("s1");
  s2:setEntryMarking("s2");
  s3:setEntryMarking("s3");
  sEnd:setEntryMarking("sEnd");sEnd:setAwnserEntry(false);
  
  s0:add(s1, dialogObject:format("Tell me about ships!"));
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
  
  s1:add(s2, dialogObject:format("I see!"));
  
  
  s2:add(s3, dialogObject:format("The Ship Core is important, got it!"));
  s3:add(okEntry3, "Ok!");
  
  
  okEntry3:setHook(doorOpenHook);
  
  doorOpenHook:setFollowUp(shipFlyTutHook);
  doorOpenHook:setCondition(alwaysTrueHook);
  doorOpenHook:setStartState("sEnd");
  doorOpenHook:setEndState("sEnd");
  
  shipFlyTutHook:setStartState("sEnd");
  shipFlyTutHook:setEndState("sEnd");
 

  
  factory:setRootEntry(s0);
  

  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
