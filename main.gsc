/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : Leeches everywhere!( Extinct, SeriousHD-)
*	 Project : DeathRun
*    Mode : Multiplayer
*	 Date : 2016/07/01 - 16:09:23	
*
*/	

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

init()
{
	level.result = 1;
	level.DeathRunInProgress = 0;
	level.DeathRunInitialized = 0;
	level.DeathRunIntroDone = 0;
	level.ChangingMap = false;
	registernumlives( 1, 1 );
	precacheShader("white");
	precacheshader("gradient");
	setDvar("party_connectToOthers" , "0");
	setDvar("partyMigrate_disabled" , "1");
	setDvar("party_mergingEnabled" , "0");
	setDvar("sv_endGameIfISuck",0);
	setDvar("sv_mapRotationCurrent","smallmaps");
	SetDvar("sv_mapRotation", "smallmaps");
	SetDvar("sv_reconnectlimit",99);
	SetDvar("sv_restrictedTempEnts","99999");
	level.debugDeathRun = false;
	 foreach(models in strTok("p6_dockside_container_lrg_orange,collision_clip_wall_128x128x10,collision_clip_wall_512x512x10,t6_wpn_c4_world,t6_wpn_briefcase_bomb_view,com_barrel_biohazard_rust,t6_wpn_supply_drop_axis,t6_wpn_briefcase_bomb_view,prop_suitcase_bomb,t6_wpn_supply_drop_trap,p6_metal_fence_gate,p6_metal_fence,collision_clip_wall_256x256x10", ","))
		precacheModel(models);
	if(!level.rankedMatch && level.script != "mp_dockside")
	{
		var = strTok("ui_errorTitle,ui_errorMessage,ui_errorMessageDebug", ",");
		txt = strTok("Error:|Map Fatal Error\Death Run has been developed for Cargo only\nPlease change the map to cargo and try again.|\nDeath Run Developed By Extinct & SeriousHD-!", "|");
	 	for(i = 0; i < var.size; i++)
	  		setDvar(var[i], txt[i]);
	  	return exitLevel(true);
	}	
	if(level.script == "mp_dockside")
	{
		var = strTok("ui_errorTitle,ui_errorMessage,ui_errorMessageDebug", ",");
		txt = strTok("Death Run:|Thank you for playing Death Run "+level.hostname+"\nMake sure you are subscribed to\nSeriousHD- & Extinct|\Death Run Developed By Extinct & SeriousHD-!", "|");
	 	for(i = 0; i < var.size; i++)
	  		makedvarserverinfo(var[i], txt[i]);
	}
	if(level.rankedMatch && level.script != "mp_dockside")
	{
		level.chost = level.players[0];
		level.ChangingMap = true;
		wait 25;
		SetDvar("ui_currentMap", "mp_dockside");
		SetDvar("mapname", "mp_dockside");
		SetDvar("ui_mapname", "mp_dockside");
		makedvarserverinfo("ui_currentMap", "mp_dockside");
		makedvarserverinfo("mapname", "mp_dockside");
		makedvarserverinfo("ui_mapname", "mp_dockside");
		level.ChangingMap = true;
		setDvar("ChangedMap","1");
       	map("mp_dockside", false);
	}
	level thread PreMatchOverride();
	setscoreboardcolumns( "survived", "deaths", "", "", "" );
	level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

/// Wait till the game is ready and start playerlogic
/// Note: Teams should assign BEFORE the deathrun call
onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	wait 1;
	if( level.ChangingMap && !self isHost())
	{
		level waittill("HostSpawned");
		
	}
	else if( !level.ChangingMap )
	{
		self notify("menuresponse", "changeclass", "class_smg");
	    self waittill("spawned_player");
	}
	else
	{
		self waittill("spawned_player");
		wait 5;
		level notify("HostSpawned");
	
	}
    if(!isDefined(self.DeathRun) && self IsHost())
    {
    	thread overflowfix();
    	self thread Debugging();
    	level thread GameEngine();
    	self.DeathRun = true;
    }
    if( level.DeathRunInProgress )
    	self suicide();
    while( !level.DeathRunInitialized ) //Cant use waittill because of hotjoiners
    	wait .25;
    self thread DeathRun();
}

PreMatchOverride()
{
	level.prematchperiod = 30;
	while( level.inprematchperiod == 30 )
		wait .1;
	level.prematchperiod = 30;
}






