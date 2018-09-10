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
  dialogObject:format("Hi! I'll tell you how to navigate in this universe!\n\n"..
  "Once you have a ship, open up the galaxy map with P, and you will see the whole galaxy.\n"..
  "The Universe is subdivided into sectors, systems (16x16x16 sectors), and galaxies (128x128x128 systems).\n"..
  "So one galaxy is pretty big already, but there are quadrillions of them, not lying.\n"..
  "It's very important to know your way around.\n\n"..
  "You can check all the objects close to you in the navigation panel and set manual way points to any sector.\n"..
  "The navigation also has a function that lets you track the last ship you were in.\n\n")
  
  , 2000 );
  factory:setRootEntry(entry);

 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
