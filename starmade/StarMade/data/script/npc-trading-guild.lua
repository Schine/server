function hookFunc(dialogObject)
  
  price = 50000
  return dialogObject:spawnCrew(price);
  
end

priceLaser          = 100000;
priceSniper         = 500000;
priceRocketLauncher = 1000000;
priceHelmet         = 50000;
priceHealingBeam    = 100000;
pricePowerBeam      = 5000;
priceMarkerBeam     = 100000;
priceGrappleBeam     = 100000;
priceTorchBeam     = 100000;
priceBuildProhibiter     = 1000000;
priceFlashLight     = 3000;
priceTransporterBeacon     = 100000;

function giveFlashLightHookFunc(dialogObject)
  return dialogObject:giveFlashLight(priceFlashLight);
end
function giveTransporterBeaconFunc(dialogObject)
  return dialogObject:giveTransporterMarkerBeam(priceTransporterBeacon);
end
function giveBuildProhibiterHookFunc(dialogObject)
  return dialogObject:giveBuildProhibiter(priceBuildProhibiter);
end

function giveTorchBeamHookFunc(dialogObject)
  return dialogObject:giveTorchBeam(priceTorchBeam);
end

function giveGrappleBeamHookFunc(dialogObject)
  return dialogObject:giveGrappleBeam(priceGrappleBeam);
end

function giveHelmetHookFunc(dialogObject)
  return dialogObject:giveHelmet(priceHelmet);
end

function giveRocketLauncherHookFunc(dialogObject)
  return dialogObject:giveRocketLauncher(priceRocketLauncher);
end

function giveSniperRifleHookFunc(dialogObject)
  return dialogObject:giveSniperRifle(priceSniper);
end

function giveLaserWeaponHookFunc(dialogObject)
  return dialogObject:giveLaserWeapon(priceLaser);
end
function giveHealingBeamHookFunc(dialogObject)
  return dialogObject:giveHealingBeam(priceHealingBeam);
end
function givePowerSupplyBeamHookFunc(dialogObject)
  return dialogObject:givePowerSupplyBeam(pricePowerBeam);
end
function giveMarkerBeamHookFunc(dialogObject)
  return dialogObject:giveMarkerBeam(priceMarkerBeam);
end


function crateTradingGuildInfo(from, dialogObject)
  mainInfo = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("The traiding guild is the biggest trading company of the known universe.\n"..
  "On your travels you will probably encounter us in one or another way.\n"..
  "We have shops where we buy and sell various goods, but we also utilize a fleet to restock\n"..
  "shops, and defend ourselves. \n\n"..
  "While we are by priciple neutral, we will respond if you fire at our shops, or breach the shields\n"..
  "of our vessels. But don't worry: we won't be mad at you for long should you survive.\n")
  , 2000 );
  
  
  
  from:add(mainInfo, dialogObject:format("I want to know more about the traiding guild"));  
  mainInfo:add(from, dialogObject:format("I want to know something else"));
end
function cratePirateInfo(from, dialogObject)
   mainInfo = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("The pirates are the pest of the universe.\n"..
  "It's better to not engage then unless you absolutely must. Use your navigator often to check for hostiles.\n"..
  "There are rumors that they build their own bases, and even copy ship blueprints,\n"..
  "but only few have survived to tell the story. \n\n"..
  "You can outrun the pirates and they usually stop pursuing if you get 1-2 sector clicks away.\n"..
  "\n")
  , 2000 );
  
  
  
  from:add(mainInfo, dialogObject:format("Tell me about pirates"));  
  mainInfo:add(from, dialogObject:format("I want to know something else"));
end
function crateShopInfo(from, dialogObject)
  
  mainInfo = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("This is an advaced shop.\n"..
  "The more common version of shops are not manned by member of the trading guild,\n"..
  "but utilize a fully automatic shop system. You can also buy your own shopping block right here,\n"..
  "to use the same technique on your own stations\n\n"..
  "Here you can also buy recipes for various purposes. Either to create a block, or a fixed recipe\n"..
  "to convert blocks. \n\nFeel free to browse (press 'B' after this converation has ended)\n"..
  "\n")
  , 2000 );
  
  from:add(mainInfo, dialogObject:format("I want to know more about shops"));  
  mainInfo:add(from, dialogObject:format("I want to know something else"));
end

function create(dialogObject, bindings)
  
  dSysClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogSystem" );
  dSysFactoryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactory" );
  dSysEntryClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogStateMachineFactoryEntry" );
  hookClass = luajava.bindClass( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua" );
  giveHelmetHook          = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveHelmetHookFunc", {} );
  giveRocketLauncherHook  = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveRocketLauncherHookFunc", {} );
  giveSniperRifleHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveSniperRifleHookFunc", {} );
  giveLaserWeaponHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveLaserWeaponHookFunc", {} );
  giveHealingBeamHook     = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveHealingBeamHookFunc", {} );
  givePowerSupplyBeamHook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "givePowerSupplyBeamHookFunc", {} );
  giveMarkerBeamHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveMarkerBeamHookFunc", {} );
  giveGrappleBeamHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveGrappleBeamHookFunc", {} );
  giveTorchBeamHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTorchBeamHookFunc", {} );
  giveBuildProhibiterHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveBuildProhibiterHookFunc", {} );
  giveFlashLightHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveFlashLightHookFunc", {} );
  giveTransporterBeaconHook      = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "giveTransporterBeaconFunc", {} );
  
  dSys = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", dialogObject );
  
  print(dSys);
  
  
  
  factory = dSys:getFactory(bindings);
 
  hook = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogTextEntryHookLua", "hookFunc", {} );

  entry = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", 
  dialogObject:format("Greetings, space traveler.\n\n" ..
  "My name is %s, and I'm a member of the intergalactic traiding Guild.\n"..
  "You can get information, quests, and more.\n\n"..
  "How can I help you?\n", dialogObject:getConverationParterName())
  , 2000 );
  factory:setRootEntry(entry);

  
  
  entry1 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("What kind of information do you need?"), 2000 );
  crateTradingGuildInfo(entry1, dialogObject);
  crateShopInfo(entry1, dialogObject);
  cratePirateInfo(entry1, dialogObject);
  
  
  entry:add(entry1, dialogObject:format("I need information!"));  
  
  entry2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("This will cost you 50,000 credits. Are you sure?"), 2000 );
 
  
  entry:add(entry2, dialogObject:format("I want to hire crew!"));  
  
  entryCrewFailed = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("You don't have enough money"), 2000 );
  entryCrewFailed2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("You can't have more crew"), 2000 );
  entryCrewSuccess = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Thank you"), 2000 );

  entryCrew = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryCrew:setHook(hook);
  
  entryCrew:addReaction(hook, 0, entryCrewSuccess);
  entryCrew:addReaction(hook, -1, entryCrewFailed);
  entryCrew:addReaction(hook, -2, entryCrewFailed2);
 
  
  entry2:add(entryCrew, dialogObject:format("Yes"));
  entry2:add(entry, dialogObject:format("No"));
  
  entry3 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("What do you need"), 2000 );
  entrySuit = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("What do you need"), 2000 );
  entryWeapon = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("What do you need"), 2000 );
  entrySupport = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("What do you need"), 2000 );
  
  entry:add(entry3, dialogObject:format("I need some personal equipment!")); 
  
  entryWepFailed = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("You don't have enough money!"), 2000 );
  entryWepFailed2 = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Sorry, your inventory is full!"), 2000 );
  entryWepSuccess = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Thank you!"), 2000 );
  
  entryLaser = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryLaser:setHook(giveLaserWeaponHook);
  
  entryHealing = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryHealing:setHook(giveHealingBeamHook);
  
  entryHelmet = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryHelmet:setHook(giveHelmetHook);
  
  entryPowerbeam = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryPowerbeam:setHook(givePowerSupplyBeamHook);
  
  entrySniperRifle = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entrySniperRifle:setHook(giveSniperRifleHook);
  
  entryMarkerbeam = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryMarkerbeam:setHook(giveMarkerBeamHook);

  entryRocketLauncher = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryRocketLauncher:setHook(giveRocketLauncherHook);
  
   
  entryGrappleBeam = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryGrappleBeam:setHook(giveGrappleBeamHook);

  entryTorchBeam = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryTorchBeam:setHook(giveTorchBeamHook);

  entryBuildProhibiter = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryBuildProhibiter:setHook(giveBuildProhibiterHook);
   
  entryFlashLight = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryFlashLight:setHook(giveFlashLightHook);

  entryTransporterBeacon = luajava.newInstance( "org.schema.game.common.data.player.dialog.TextEntry", dialogObject:format("Please wait! I'm currently Calculating"), 2000 );
  entryTransporterBeacon:setHook(giveTransporterBeaconHook);
   
  entryWepFailed:add(entry3, dialogObject:format("I want something else."));  
  entryWepFailed2:add(entry3, dialogObject:format("I want something else."));  
  entryWepSuccess:add(entry3, dialogObject:format("I want something else."));  
  
  entry3:add(entrySuit, dialogObject:format("I need something for my suit"));
  entry3:add(entryWeapon, dialogObject:format("I need a weapon"));
  entry3:add(entrySupport, dialogObject:format("I need a support tool"));
  
  entrySuit:add(entryHelmet, dialogObject:format("Helmet (Cost: %s)", priceHelmet));
  entrySuit:add(entry3, dialogObject:format("I want something else."));
  
  entrySupport:add(entryFlashLight, dialogObject:format("Flashlight (Cost: %s)", priceFlashLight));
  entrySupport:add(entryTransporterBeacon, dialogObject:format("Transporter Beacon (Cost: %s)", priceTransporterBeacon));
  entrySupport:add(entryHealing, dialogObject:format("Healing Beam (Cost: %s)", priceHealingBeam));
  entrySupport:add(entryPowerbeam, dialogObject:format("Power Supply Beam (Cost: %s)", pricePowerBeam));
  entrySupport:add(entryMarkerbeam, dialogObject:format("Marker Beam (Cost: %s)",priceMarkerBeam));
  entrySupport:add(entryGrappleBeam, dialogObject:format("Grapple Beam (Cost: %s)", priceGrappleBeam));
  entrySupport:add(entryBuildProhibiter, dialogObject:format("Build Inhibiter (Cost: %s)", priceBuildProhibiter));
  entrySupport:add(entry3, dialogObject:format("I want something else."));
  
  entryWeapon:add(entryLaser, dialogObject:format("Laser Pistol (Random color) (Cost: %s)",priceLaser));
  entryWeapon:add(entryRocketLauncher, dialogObject:format("Rocket Launcher (Cost: %s)", priceRocketLauncher));
  entryWeapon:add(entrySniperRifle, dialogObject:format("Sniper Rifle (Cost: %s)", priceSniper));
  entryWeapon:add(entryTorchBeam, dialogObject:format("Torch Beam (Cost: %s)", priceTorchBeam));
  entryWeapon:add(entry3, dialogObject:format("I want something else."));
  
  
  entryTorchBeam:addReaction(giveTorchBeamHook, 0, entryWepSuccess);
  entryTorchBeam:addReaction(giveTorchBeamHook, -1, entryWepFailed);
  entryTorchBeam:addReaction(giveTorchBeamHook, -2, entryWepFailed2);
  
  entryBuildProhibiter:addReaction(giveBuildProhibiterHook, 0, entryWepSuccess);
  entryBuildProhibiter:addReaction(giveBuildProhibiterHook, -1, entryWepFailed);
  entryBuildProhibiter:addReaction(giveBuildProhibiterHook, -2, entryWepFailed2);
  
  entryFlashLight:addReaction(giveFlashLightHook, 0, entryWepSuccess);
  entryFlashLight:addReaction(giveFlashLightHook, -1, entryWepFailed);
  entryFlashLight:addReaction(giveFlashLightHook, -2, entryWepFailed2);
  
  entryTransporterBeacon:addReaction(giveTransporterBeaconHook, 0, entryWepSuccess);
  entryTransporterBeacon:addReaction(giveTransporterBeaconHook, -1, entryWepFailed);
  entryTransporterBeacon:addReaction(giveTransporterBeaconHook, -2, entryWepFailed2);
  
  entryGrappleBeam:addReaction(giveGrappleBeamHook, 0, entryWepSuccess);
  entryGrappleBeam:addReaction(giveGrappleBeamHook, -1, entryWepFailed);
  entryGrappleBeam:addReaction(giveGrappleBeamHook, -2, entryWepFailed2);
  
  entryHelmet:addReaction(giveHelmetHook, 0, entryWepSuccess);
  entryHelmet:addReaction(giveHelmetHook, -1, entryWepFailed);
  entryHelmet:addReaction(giveHelmetHook, -2, entryWepFailed2);
  
  entryLaser:addReaction(giveLaserWeaponHook, 0, entryWepSuccess);
  entryLaser:addReaction(giveLaserWeaponHook, -1, entryWepFailed);
  entryLaser:addReaction(giveLaserWeaponHook, -2, entryWepFailed2);
  
  entryHealing:addReaction(giveHealingBeamHook, 0, entryWepSuccess);
  entryHealing:addReaction(giveHealingBeamHook, -1, entryWepFailed);
  entryHealing:addReaction(giveHealingBeamHook, -2, entryWepFailed2);
  
  entryPowerbeam:addReaction(givePowerSupplyBeamHook, 0, entryWepSuccess);
  entryPowerbeam:addReaction(givePowerSupplyBeamHook, -1, entryWepFailed);
  entryPowerbeam:addReaction(givePowerSupplyBeamHook, -2, entryWepFailed2);
  
  entrySniperRifle:addReaction(giveSniperRifleHook, 0, entryWepSuccess);
  entrySniperRifle:addReaction(giveSniperRifleHook, -1, entryWepFailed);
  entrySniperRifle:addReaction(giveSniperRifleHook, -2, entryWepFailed2);
  
  entryMarkerbeam:addReaction(giveMarkerBeamHook, 0, entryWepSuccess);
  entryMarkerbeam:addReaction(giveMarkerBeamHook, -1, entryWepFailed);
  entryMarkerbeam:addReaction(giveMarkerBeamHook, -2, entryWepFailed2);
  
  entryRocketLauncher:addReaction(giveRocketLauncherHook, 0, entryWepSuccess);
  entryRocketLauncher:addReaction(giveRocketLauncherHook, -1, entryWepFailed);
  entryRocketLauncher:addReaction(giveRocketLauncherHook, -2, entryWepFailed2);
  
 
  
  entryCrewFailed:add(entry, dialogObject:format("I want something else."));  
  entryCrewFailed2:add(entry, dialogObject:format("I want something else."));  
  entryCrewSuccess:add(entry, dialogObject:format("I want something else."));  
  entryCrew:add(entry, dialogObject:format("I want something else."));  
  entry1:add(entry, dialogObject:format("I want something else."));  
  entry3:add(entry, dialogObject:format("I want something else."));  
  
 
  
  dSys:add(factory)

  return dSys

--frame = luajava.newInstance( "org.schema.game.common.data.player.dialog.DialogSystem", "Texts" );
--frame:test()
end
