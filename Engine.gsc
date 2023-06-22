/// #TODO: ?? Profit


GameEngine()
{
	setmatchtalkflag( "EveryoneHearsEveryone", 1 );
	MapInit();
	GameIntro();
	thread OpenGates();
	level.DeathRunInitialized = true;
	array = [];
	array = getentarray();
	level.players[0] thread DeathRun_Notifications();
}

DeathRun()
{
	self FreezeControlsAllowLook(false);
	self FreezeControls(false);
	self thread DeathBarrierMonitor();
	self waittill("death");
	if( self == level.Activator )
		return;
	level.RunnersNum--;
	foreach( Runner in level.Runners )
		if( isAlive( Runner ) )
		{
			Runner.survived++;
			Runner iprintlnbold("+1");
		}
	level.LastDeath = self.name;
	level notify("DeathNotification");
}

GameIntro()
{
	level.DeathRunWelcome = [];
	///Huds
	level.DeathRunWelcome["CLoaderScreen"] = createRectangle("CENTER", "CENTER", 0, 0, 999, 999, (0,0,0), "white", 9, 0, true);
	level.DeathRunWelcome["TitleText"] = level drawText("", "bigfixed", 1.1, "LEFT", "TOP", -175, 20, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.DeathRunWelcome["SubTitleText"] = level drawText("Created by Extinct and SeriousHD-", "objective", 1.35, "CENTER", "TOP", 0, 50, (1,1,1), 0, (0,.35,.35), 0, -1);
	
	level.DeathRunWelcome["MainText0"] = level drawText("Death Run is a gamemode that was originally created for GMOD, We decided it would be a fun gamemode to play on BO2", "objective", 1.55, "CENTER", "TOP", 0, 100, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.DeathRunWelcome["MainText1"] = level drawText("The gamemode objective is there is one activator and the rest are runners", "objective", 1.55, "CENTER", "TOP", 0, 120, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.DeathRunWelcome["MainText2"] = level drawText("the runners need to dodge all the traps the activator activates, the activator needs to stop the runners from getting to him", "objective", 1.55, "CENTER", "TOP", 0, 140, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.DeathRunWelcome["MainText3"] = level drawText("Goodluck, Hosted By "+level.hostname, "objective", 1.55, "CENTER", "TOP", 0, 180, (1,1,1), 0, (0,.35,.35), 0, -1);
	
	level.DeathRunWelcome["MainText4"] = level drawText("www.youtube.com/c/ExtinctMods", "objective", 1.6, "CENTER", "TOP", 0, 210, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.DeathRunWelcome["MainText5"] = level drawText("www.youtube.com/anthonything", "objective", 1.6, "CENTER", "TOP", 0, 230, (1,1,1), 0, (0,.35,.35), 0, -1);
	///Animations
	while( level.inprematchperiod )
	{
		foreach( DeathRun in level.players )
		{
			DeathRun FreezeControls(false);
			DeathRun EnableInvulnerability();
			DeathRun SetMoveSpeedScale( 2 );
			DeathRun setclientuivisibilityflag( "hud_visible", 0 );
		}
		wait 1;
	}
	if( GetDvar("ChangedMap") != "" )
	{
		setDvar("ChangedMap","");
		maps\mp\gametypes\_hostmigration::callback_hostmigration();
	}
	maps\mp\gametypes\_globallogic_utils::pausetimer();
	foreach( DeathRun in level.players )
	{
		DeathRun FreezeControls(true);
		DeathRun DisableInvulnerability();
		DeathRun SetMoveSpeedScale( 1 );
		DeathRun setclientuivisibilityflag( "hud_visible", 0 );
	}
	level.DeathRunWelcome["CLoaderScreen"] affectElement("alpha", .5, 1);
	level.DeathRunWelcome["TitleText"] affectElement("alpha", .5, 1);
	wait .5;
	level.DeathRunWelcome["TitleText"] affectElement("alpha", 1, 0);
	level notify("dotDot_endon");
	wait 1;
	level.DeathRunWelcome["TitleText"] destroy();
	level.DeathRunWelcome["TitleText"] = level drawText("", "bigfixed", 1.1, "CENTER", "TOP", 0, 20, (1,1,1), 0, (0,.35,.35), 0, -1);
	level.WelcomeTextChanged = true;
	level.DeathRunWelcome["TitleText"].fontscale = 1.9;
	level.DeathRunWelcome["TitleText"] setSafeText("Welcome to Death Run");
	level.DeathRunWelcome["TitleText"] affectElement("alpha", .75, 1);
	wait .75;
	level.DeathRunWelcome["SubTitleText"] affectElement("alpha", .75, 1);
	wait .75;
	for(Ext = 0; Ext < 6; Ext++)
	{
		level.DeathRunWelcome["MainText"+Ext] affectElement("alpha", .75, 1);
		wait .75;
	}
	TeamInit();
	BuildTraps(); //We should have all the players we need
	SpawnPlayers();
	foreach( DeathRunPlayer in level.players )
		DeathRunPlayer thread PlayerInitializations();
	wait 3;
	level.DeathRunWelcome["TitleText"] affectElement("alpha", 1.75, 0);
	level.DeathRunWelcome["SubTitleText"] affectElement("alpha", 1.75, 0);
	for(Ext = 0; Ext < 6; Ext++)
		level.DeathRunWelcome["MainText"+Ext] affectElement("alpha", 1.75, 0);
	wait 1;
	level.DeathRunWelcome["CLoaderScreen"] affectElement("alpha", 1.75, 0);
	wait 1.75;
	self destroyAll(level.DeathRunWelcome);
	level.DeathRunIntroDone = true;
}

PlayerInitializations()
{
	self takeallweapons();
	self disableweapons();
	self disableUsability();
	while( ! level.DeathRunIntroDone )
		wait .25;
	self thread PersonalObjective();
}

TeamInit()
{
/*
	Spawn size must be at least 250x400
*/
	level.Runners = arraycopy(level.players);
	index = RandomIntRange( 0, level.Runners.size );
	level.Activator = level.Runners[ index ];
	arrayremovevalue( level.Runners, level.Activator );
	ActivatorTeam = level.Activator.team;
	RunnerTeam = "axis";
	if( ActivatorTeam == "axis" )
		RunnerTeam = "allies";
	foreach( runner in level.Runners )
	{
		if( level.teambased && runner.team != RunnerTeam )
		{
			runner.team = RunnerTeam;
			runner.sessionteam = RunnerTeam;
			runner.pers["team"] = RunnerTeam;
		}
		runner.runner = true;
	}
	level.Activator.activator = true;
}

SpawnPlayers()
{
	SpawnPoints = [];
	for( x = -175; x <= 175; x += 70 )
	{
		for( y = -75; y <= 75; y += 75 )
		{
			spawnpoints = add_to_array( SpawnPoints, (level.DeathRunspawnpoint + (x,y,150) ), 0);
		}	
	}
	SpawnPoints = Array_Randomize( SpawnPoints );
	for( i = 0; i < level.Runners.size; i++ )
		level.Runners[i] SetOrigin( SpawnPoints[i] );
	level.Activator SetOrigin( level.ActivatorSpawn );
	level.Activator EnableInvulnerability();
	level.Activator SetMoveSpeedScale( 1.5 );
	level.DeathRunInProgress = 1;
}

PersonalObjective()
{
	if( isDefined( self.runner ) )
		self thread maps/mp/gametypes/_hud_message::hintmessage( "SURVIVE THE DEATHRUN" );
	else
		self thread maps/mp/gametypes/_hud_message::hintmessage( "USE TRAPS TO KILL RUNNERS" );
}


DeathBarrierMonitor()
{
	while( isAlive( self ) )
	{
		if( ( self GetOrigin() )[2] < 8000 )
			self dodamage( 9999, self getOrigin(), level.Activator, level.Activator, "none", "MOD_FALLING", 0, "none" );
		wait 2;
	}
}






