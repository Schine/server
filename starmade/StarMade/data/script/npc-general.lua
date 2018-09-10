function unhireHookFunc(dialogObject)
  return dialogObject:unhireConverationPartner();
end

function hireHookFunc(dialogObject)
  return dialogObject:hireConverationPartner();
end

function create(dialogObject, bindings)
  
  dSysClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogSystem" );
  dSysFactoryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactory" );
  dSysEntryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactoryEntry" );
  hookClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua" );
  
  dSys = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", dialogObject );
  
  hireHook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "hireHookFunc", {} );
  unhireHook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "unhireHookFunc", {} );
  
  factory = dSys:getFactory(bindings);
 
  entry = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Greetings space traveller!\n\n" ..
  "My name is %s, I'm currently part of %s,\n"..
  "and under the command of %s in the faction: %s.\n",
  dialogObject:getConverationParterName(), dialogObject:getConverationPartnerAffinity(), dialogObject:getConverationPartnerOwnerName(), dialogObject:getConverationPartnerFactionName()), 2000 );
  factory:setRootEntry(entry);
  if dialogObject:isConverationPartnerInTeam() then
  
     entryUnCrewSuccess = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Yes, commander!"), 2000 );
     entryUnCrewFailed = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("No, commander!"), 2000 );
  
     entryCrew = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently calculating."), 2000 );
     entryCrew:setHook(unhireHook);
     entryCrew:addReaction(unhireHook, 0, entryUnCrewSuccess);
     entryCrew:addReaction(unhireHook, -1, entryUnCrewFailed);
    
     entry:add(entryCrew, dialogObject:format("I want you off my team. Stay where you are!"));
  else
    entryCrewFailed = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("You don't have enough money!"), 2000 );
    entryCrewFailed2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("You can't have more crew!"), 2000 );
    entryCrewFailed3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("I won't follow you."), 2000 );
    entryCrewSuccess = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("I'm honoured to work with you, commander!"), 2000 );
  
  
    entryCrew = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently calculating."), 2000 );
    entryCrew:setHook(hireHook);
    
    entryCrew:addReaction(hireHook, 0, entryCrewSuccess);
    entryCrew:addReaction(hireHook, -1, entryCrewFailed);
    entryCrew:addReaction(hireHook, -2, entryCrewFailed2);
    entryCrew:addReaction(hireHook, -3, entryCrewFailed3);
  
    entry:add(entryCrew, dialogObject:format("I want you in my team."));
  end
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
