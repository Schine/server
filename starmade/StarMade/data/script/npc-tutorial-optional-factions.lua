
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
  dialogObject:format("Hello there.\n"..
  "I really love being in the trading guild, but there are other awesome factions out there!\n\n"..
  "You can even create your own in the faction panel.\n"..
  "Having a faction is especially useful when you are in the same universe as other humans like you.\n"..
  "You have news posts, ranks, settings, and what is most important: A home base.\n"..
  "Home bases can't be destroyed normally, so it's the perfect place to dock your ship to,\n"..
  "as it will get the same protection as the base.\n\n"..
  "Each faction can only have one home base though, so choose its location carefully.\n\n"..
  "But, home bases are not the only great thing about factions. You can also claim whole star systems as your\n"..
  "territory. Mining in your territory will give you a 12x mining yield bonus and you'll also receive a message\n"..
  "every time a human enters one of your systems. Your scan range is increased as well!\n\n"..
  "Territory doesn't come for free though. You have to pay for them with Faction Points [FP]. Check out the faction\n"..
  "point reports in your faction panel. You can later also use faction points to create missions and temporarily protect stations other\n"..
  "than your own home base. If you spend too many on territory or your faction members die too often, you will lose territory\n"..
  "and in the end even your home base can become vulnerable, but that rarely happens if you don't take a risk.\n"..
  "The first territory is also free!")
  
  , 2000 );
  factory:setRootEntry(entry);

 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
