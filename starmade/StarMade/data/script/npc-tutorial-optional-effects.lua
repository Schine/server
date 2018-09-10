
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
  dialogObject:format("You learned about combinations back there. NPC-03 thinks it's such a secret, but in reality everybody knows it!\n\n"..
  "In fact, he doesn't even know everything about it. There is actually a second system you can connect to your weapons\n"..
  "in the same way you are combining weapons: Effects!\n\n"..
  "Now, you can place effects and use them as a defensive standalone system, they can harden your shields,\n"..
  "increase top speed and much more.\n\n"..
  "You can also connect them to your weapons, which then will give that weapon an effect amongst others like armour efficiency, power drain\n"..
  "and even physical effects like push, pull, and stop, so you can make your very own tractor beam!\n\n"..
  "Oh and one last tip: You can colour your weapon projectiles or beams by connecting a coloured light to them. Easy as that!\n")
  
  , 2000 );
  factory:setRootEntry(entry);

 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
