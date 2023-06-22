InitTrapList()
{
	//Add all our trap defs here
	//CreateTrap( "Tomahawk Drop Trap", ::TomahawkDrop_Activate, ::TomahawkDrop_Build );
	//CreateTrap( "Flame Burst Trap", ::Flame_Activate, ::Flame_Build );
	CreateTrap( "Disappearing Floor Trap", ::FakeFloor_Activate, ::FakeFloor_Build );
	CreateTrap( "Rocket Rain Trap", ::RocketTrap_Activate, ::RocketTrap_Build );
	CreateTrap( "Checkerboard Trap", ::Checkerboard_Activate, ::Checkerboard_Build );
	CreateTrap( "Falling Floor Trap", ::FallingFloor_Activate, ::FallingFloor_Build );
	CreateTrap( "Mine Pit Trap", ::K9_Activate, ::K9_Build );
	CreateTrap( "Fling Trap", ::FlingTrap_Activate, ::FlingTrap_Build );
	CreateTrap( "Rotating Floor Trap", ::FloorRoller_Activate, ::FloorRoller_Build );
	CreateTrap( "Bounce Trap", ::Bounce_Activate, ::Bounce_Build );
	CreateTrap( "Grenade Drop Trap", ::NadeDrop_Activate, ::NadeDrop_Build );
	CreateTrap( "Sucker Punch Trap", ::StrafeTrap_Activate, ::StrafeTrap_Build );
	CreateTrap( "Death Wall Trap", ::DeathWall_Activate, ::DeathWall_Build );
	CreateTrap( "Barrel Trap", ::Barrel_Activate, ::Barrel_Build );
}

BuildTraps()
{
	level.DeathRunTraps = [];
	level.DeathRunTriggers = [];
	CreateTriggers();
	InitTrapList();
	level.DeathRunTraps = array_randomize( level.DeathRunTraps );
	for( i = 0; i < level.DeathRunTriggers.size && i < level.DeathRunTraps.size; i++ )
	{
		level.DeathRunTriggers[i] thread RegisterTrap( level.DeathRunTraps[i] );
	}
	level.DeathRunTriggers[ level.DeathRunTriggers.size - 1].trap thread WatchForWinner();
}

Trap_Trigger(Trigger, Trap)
{
	clearLowerMessage(.25);
	while( !Trap.Triggered )
	{
		while(Distance(self.origin, Trigger GetOrigin()) >= 100)
		   wait .2;
		if( Trap.Triggered )
		  	return;
		setLowerMessage("Press [{+usereload}] To Activate " + Trap.Name + "!");
		while(Distance(self.origin, Trigger GetOrigin()) < 100 && !Trap.Triggered)
		{
			if(self UseButtonPressed())
			{
				Trap.Triggered = true;
				clearLowerMessage(.25);
				setLowerMessage(Trap.Name+" ^3Activated^7!");
				Trap thread TrapActivateCallback( Trigger );
				wait .5;
				clearLowerMessage(.25);
				return;
			}
			wait.05;
		}
		clearLowerMessage(.25);
	}
}

RegisterTrap( trap )
{
	level.Activator thread Trap_Trigger( self, trap );
	trap.Trigger = self;
	trap thread [[ trap.PositionTrap ]]();
	trap thread MakeDefaultTrapBridge( self GetOrigin()[1] );
	self.trap = trap;
}


CreateTrap( name, activation, buildmethod )
{
	trap = spawnstruct();
	trap.Name = name;
	trap.Activate = activation;
	trap.Triggered = false;
	trap.PositionTrap = buildmethod; 
	level.DeathRunTraps[ level.DeathRunTraps.size ] = trap;
}

CreateTriggers()
{
	level.DeathRunMapping.triggerflooring = [];
	start = level.DeathRunspawnpoint + (0,354,0);
	for( i = 0; i < level.NumberOfTriggers * 4; i++)
	{
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( start + (270,(i+1) * 354,25) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( start + (270,(i+1) * 354,250) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
	}
	level.DeathRunMapping.triggers = [];
	for( y = 256; y <= (level.NumberOfTriggers * 354 * 4); y += 512 )
		level.DeathRunMapping.collisions[ level.DeathRunMapping.collisions.size ] = spawncollision( "collision_clip_wall_512x512x10", "collider", (start + (202,y,150) ) , (0,90,0) );
	for( i = 0; i < level.NumberOfTriggers; i++ )
	{
		level.DeathRunMapping.triggers[ i ] = spawn( "script_model", ( start + ( 225, ( ( (i * 4) + 1) * 354), 177) ), 1);
		level.DeathRunMapping.triggers[ i ] setmodel( "t6_wpn_supply_drop_trap" );	
		level.DeathRunMapping.triggers[ i ].bombcase = spawn( "script_model", ( start + ( 225, ( ( (i * 4) + 1) * 354), 192) ), 1);
		level.DeathRunMapping.triggers[ i ].bombcase.angles = (0,180,0);
		level.DeathRunMapping.triggers[ i ].bombcase setmodel( "t6_wpn_briefcase_bomb_view" );
		level.DeathRunTriggers[ i ] = level.DeathRunMapping.triggers[ i ];
	}
	//Front Wall
	for( y = -354; y <= 354; y += 354 )
	{
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (y,((level.NumberOfTriggers * 354 * 4)  + 244.5),117) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1].angles = (0,90,0);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (y,((level.NumberOfTriggers * 354 * 4)  + 244.5),250) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1].angles = (0,90,0);
	}
}

TrapActivateCallback( trigger )
{
	trigger setModel("t6_wpn_supply_drop_axis");
	trigger.bombcase SetModel("prop_suitcase_bomb");
	trigger.bombcase.angles = (0,270,0);
	self thread [[ self.Activate ]]();
}

WatchForWinner()
{
	while(level.inprematchperiod || !level.DeathRunInitialized || !level.DeathRunInProgress )
		wait 1;
	while( StillAllPlayersTrying( self ) )
	{
		wait 1.5;
	}
	foreach( player in level.Runners )
		if( Isalive( player ) )
		{
			player enableweapons();
			player giveweapon("knife_mp");
			player switchtoweapon("knife_mp");
		}
	level.Activator SetMoveSpeedScale( .75 );
	level.Activator DisableInvulnerability();
	array_delete( level.DeathRunMapping.collisions );
	foreach( player in level.players )
	{
		if( isDefined( player.runner ) )
			player thread maps/mp/gametypes/_hud_message::hintmessage( "KILL THE ACTIVATOR" );
		else
			player thread maps/mp/gametypes/_hud_message::hintmessage( "YOU DONE FUCKED UP" );
	}
	while( isAlive( level.Activator ) )
		wait 1;
	thread maps/mp/gametypes/_globallogic::forceend(0);
}







