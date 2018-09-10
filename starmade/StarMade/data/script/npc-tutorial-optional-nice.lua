
function create(dialogObject, bindings)
  print(bindings)
  print(dialogObject)
  
  dSysClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogSystem" );
  dSysFactoryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactory" );
  dSysEntryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactoryEntry" );
  hookClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua" );
  
  
  dSys = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", dialogObject );
  
  print(dSys);
  
  
  
  factory = dSys:getFactory(bindings);
 
  hook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "hookFunc", {} );

  entry = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Hi, I hope you enjoy your stay in this world!\n"..
  "It has a lot to offer.")
  , 2000 );
  factory:setRootEntry(entry);

 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
