
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
  dialogObject:format("A real awesome thing you can do is docking your ships!\n"..
  "You can use a turret docking block or a normal docking block for that.\n"..
  "Just aim your docking beam (it comes equipped with every ship core), at the docking block.\n\n"..
  "You can increase the docking area by connecting docking enhancers to the docking blocks,\n"..
  "but keep in mind that they all have to touch, as only the largest group counts.\n\n"..
  "You can also give your ship or turret an Artificial Intelligence. Make sure the ship or turret has your faction signature\n"..
  "by placing and activating a faction block. Then place down a bobby AI block and activate it. You can also\n"..
  "activate AI for turrets directly in the structure panel of the ship the turrets are docked to.")
  
  , 2000 );
  factory:setRootEntry(entry);

 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
