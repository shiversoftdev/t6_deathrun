PlaceHolder_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

PlaceHolder_Activate()
{

}

FakeFloor_Activate()
{
	foreach( model in self.platform )
		model delete();
	wait 3;
	[[ self.PositionTrap ]]();
}

FakeFloor_Build()
{
	self.startOrigin = ( self.trigger getOrigin() )[1];
	self.platform = [];
	for( y = 0; y < 2; y++ )
	{
		for( x = 0; x < 4; x++ )
		{
			self.platform[ self.platform.size ] = spawn( "script_model",  ( (x * 135) + level.DeathRunspawnpoint[0] - 270, (y * 354) + self.startOrigin, level.DeathRunspawnpoint[2] ), 1);
			self.platform[ self.platform.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
		}
	}
}

TomahawkDrop_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

TomahawkDrop_Activate()
{
	customCoords = ( level.DeathRunspawnpoint[0], ( self.trigger GetOrigin() )[1], level.DeathRunspawnpoint[2]);
	level.Activator thread CleanupTomahawks();
	for ( i = 0; i < 30; i++ )
	{
		time = 1.5 + i / 6 + randomfloat(0.1);
		level.Activator MagicGrenadeType("hatchet_mp", customCoords+(0,0,100), getRandomHatchetSpeed(), time);
	}
	wait 5;
	level.Activator.nadecollection = false;
}

NadeDrop_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

NadeDrop_Activate()
{
	customCoords = ( level.DeathRunspawnpoint[0], ( self.trigger GetOrigin() )[1], level.DeathRunspawnpoint[2]);
	for ( i = 0; i < 30; i++ )
	{
		time = 1.5 + i / 6 + randomfloat(0.1);
		level.Activator MagicGrenadeType("frag_grenade_mp", customCoords+(0,0,100), getRandomHatchetSpeed(), time);
	}
}

CleanupTomahawks()
{
	hawks = [];
	self.nadecollection = true;
	while( self.nadecollection )
	{
		self waittill("grenade_fire", grenade );
		hawks[ hawks.size ] = grenade;
	}
	foreach( hawk in hawks )
		hawk notify("death");
	array_delete( hawks );
}

getRandomHatchetSpeed() 
{
	yaw = randomFloat( 360 );
	pitch = randomFloatRange( 65, 85 );
	amntz = sin( pitch );
	cospitch = cos( pitch );
	amntx = cos( yaw ) * cospitch;
	amnty = sin( yaw ) * cospitch;
	speed = randomFloatRange( 400, 600);
	velocity = (amntx, amnty, amntz) * speed;
	return velocity;
}

RocketTrap_Activate()
{
	start = undefined;
	for( y = 0; y < (2 * 354); y += 75 )
	{
		for( x = (-2 * 135); x < (2 * 135); x += 75 )
		{
			start = ( ( x + level.DeathRunspawnpoint[0] ), ( y + (self.trigger GetOrigin())[1] ) , level.DeathRunspawnpoint[2] + 200 );
			magicBullet( "usrpg_mp", start, ( start - (0,0,10) ), level.Activator );
			wait .1;
		}
		wait .5;
	}

}

RocketTrap_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

Checkerboard_Activate()
{
	self.platform[ 0 ] movex( 135, .5 );
	self.platform[ 1 ] movex( 135, .5 );
	self.platform[ 2 ] movex( -135, .5 );
	self.platform[ 3 ] movex( -135, .5 );
	wait .5;
	self.platform[ 0 ] movex( -135, .5 );
	self.platform[ 1 ] movex( -135, .5 );
	self.platform[ 2 ] movex( 135, .5 );
	self.platform[ 3 ] movex( 135, .5 );
	wait 2.5;
	self.platform[ 0 ] movex( 135, .25 );
	self.platform[ 1 ] movex( 135, .25 );
	self.platform[ 2 ] movex( -135, .25 );
	self.platform[ 3 ] movex( -135, .25 );
}

Checkerboard_Build()
{
	self.platform = [];
	x = -2;
	for( y = 0; y < 2; y++ )
	{
		if( y != 0 )
			x = -1;
		for( ; x < 2; x += 2 )
		{
			self.platform[ self.platform.size ] = spawn( "script_model",  ( (x * 135) + level.DeathRunspawnpoint[0], (y * 354) + ( self.trigger GetOrigin() )[1], level.DeathRunspawnpoint[2] ), 1);
			self.platform[ self.platform.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
		}
	}
}

FallingFloor_Activate()
{
	foreach( part in self.platform )
	{
		part movez( -200, .5 );
	}
	wait .75;
	foreach( part in self.platform )
		part PhysicsLaunch();
	wait 5;
	foreach( part in self.platform )
		part delete();
	[[ self.PositionTrap ]]();
}

FallingFloor_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

K9_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

K9_Activate()
{
	level.dog_abort = 0;
	foreach( part in self.platform )
	{
		part movez( -135, .25 );
	}
	wait .25;
	self.mines = [];
	foreach( box in self.platform )
	{
		self.mines[ self.mines.size ] = modelSpawner( (box GetOrigin() + (0,0,137) ), "t6_wpn_c4_world");
		self.mines[ self.mines.size - 1] thread TouchExplode();
	}
	self.crosswalk = [];
	for( y = (( self.trigger GetOrigin() )[1] - 150); y < ( ( self.trigger GetOrigin() )[1] + (354 * 2) ); y += 150)
	{
		self.crosswalk[ crosswalk.size ] = modelSpawner( (level.DeathRunspawnpoint[0], y, level.DeathRunspawnpoint[2] + 100), "t6_wpn_supply_drop_axis");
	}
	self.walls = [];
	self.walls[0] = modelSpawner( (level.DeathRunspawnpoint[0] - 405, ( self.trigger GetOrigin() )[1], level.DeathRunspawnpoint[2]), "p6_dockside_container_lrg_orange");
	self.walls[1] = modelSpawner( (level.DeathRunspawnpoint[0] - 405, ( self.trigger GetOrigin() )[1] + 354, level.DeathRunspawnpoint[2]), "p6_dockside_container_lrg_orange");
	self.walls[2] = modelSpawner( (level.DeathRunspawnpoint[0] + 270, ( self.trigger GetOrigin() )[1], level.DeathRunspawnpoint[2]), "p6_dockside_container_lrg_orange");
	self.walls[3] = modelSpawner( (level.DeathRunspawnpoint[0] + 270, ( self.trigger GetOrigin() )[1] + 354, level.DeathRunspawnpoint[2]), "p6_dockside_container_lrg_orange");
	PlayersLeft = true;
	while( PlayersLeft )
	{
		PlayersLeft = false;
		foreach( player in Level.Runners )
		{
			if( isAlive( player ) && !player IsTouchingBridge( self ) )
				PlayersLeft = true;
		}
		if( level.Runners.size < 1 )
			break;
		wait .1;
	}
	wait 2;
	array_delete( self.crosswalk );
	array_delete( self.walls );
	array_delete( self.mines );
	foreach( part in self.platform )
	{
		part movez( 135, .25 );
	}
}

TouchExplode()
{
	while( isDefined( self ) )
	{
		foreach( player in level.runners )
		{
			if( isAlive(player) && player.origin[2] < (self GetOrigin())[2] )
			{
				self playsound( "wpn_trophy_alert" );
				wait .2;
				self playsound( "wpn_trophy_alert" );
				wait .2;
				self playsound( "wpn_trophy_alert" );
				wait .2;
				self playsound( "wpn_trophy_alert" );
				wait .2;
				self playsound( "wpn_trophy_alert" );
				wait .2;
				MagicBullet( "usrpg_mp", player Getorigin(), self Getorigin(), level.Activator );
			}
		}
		wait 1.5;
		self playsound( "wpn_trophy_alert" );
	}
}

Barrel_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
	BarrleCoords = ( level.DeathRunspawnpoint[0], (( self.trigger GetOrigin() )[1] + 177), level.DeathRunspawnpoint[2] + 240);
	self.DeathRun_BarrelTrap = [];
	for(Ext = 0; Ext < 3; Ext++)
	{
		self.DeathRun_BarrelTrap[self.DeathRun_BarrelTrap.size] = modelSpawner(BarrleCoords + (100,-100+Ext*100,135), "com_barrel_biohazard_rust", (randomintrange(0,360), randomintrange(0,360), randomintrange(0,360)));//Bottom Front Barrels
		self.DeathRun_BarrelTrap[self.DeathRun_BarrelTrap.size] = modelSpawner(BarrleCoords + (-30,-100+Ext*100,135), "com_barrel_biohazard_rust", (randomintrange(0,360), randomintrange(0,360), randomintrange(0,360)));//Bottom Back Barrels
		self.DeathRun_BarrelTrap[self.DeathRun_BarrelTrap.size] = modelSpawner(BarrleCoords + (-100,-100+Ext*100,135), "com_barrel_biohazard_rust", (randomintrange(0,360), randomintrange(0,360), randomintrange(0,360)));//TOP Barrels
	}
}

Barrel_Activate()
{
	for(Ext = 0; Ext < 9; Ext++)
	{
		self.DeathRun_BarrelTrap[Ext] thread Physics_DeathRun();
		self.DeathRun_BarrelTrap[Ext] thread Barrel_Monitor(50, self);
	}
	PlayersLeft = true;
	while( PlayersLeft )
	{
		PlayersLeft = false;
		foreach( player in Level.Runners )
		{
			if( isAlive( player ) && !player IsTouchingBridge( self ) )
				PlayersLeft = true;
		}
		if( level.Runners.size < 1 )
			break;
		wait .1;
	}
	wait 2;
	array_delete( self.DeathRun_BarrelTrap );
}

Physics_DeathRun()
{
	if(isDefined(self))
		self physicsLaunch();
	for( i = 0; i < 15; i++ )
	{
		self rotatePitch(360, .5);
		self rotateRoll(360, .5);
		self rotateYaw(360, .5);
		wait .6;
	}
}

Barrel_Monitor(Ext, owner)
{
	self endon("disconnect");
	level endon("Stop_MonitorBarrels");
	
	while(isDefined(self))
	{
		foreach(dude in level.Runners)
		{
			if(isAlive(dude) && dude IsTouching( self ) )
			{
				dude doDamage(dude.health + 1, dude.origin, level.Activator, self, "none", "MOD_HIT_BY_OBJECT", 0, "supplydrop_mp" );
				dude playsound("phy_impact_supply");
			}
		}
		wait .05;
	}
}

FlingTrap_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

FlingTrap_Activate()
{
	self.platform[0] rotateRoll( 180, 1);
	self.platform[1] rotateRoll( -180, 1);
	self.platform[2] rotateRoll( 180, 1);
	self.platform[3] rotateRoll( -180, 1);
	self.platform[4] rotateRoll( -180, 1);
	self.platform[5] rotateRoll( 180, 1);
	self.platform[6] rotateRoll( -180, 1);
	self.platform[7] rotateRoll( 180, 1);
	wait 2.5;
	self.platform[0] rotateRoll( 180, 1);
	self.platform[1] rotateRoll( -180, 1);
	self.platform[2] rotateRoll( 180, 1);
	self.platform[3] rotateRoll( -180, 1);
	self.platform[4] rotateRoll( -180, 1);
	self.platform[5] rotateRoll( 180, 1);
	self.platform[6] rotateRoll( -180, 1);
	self.platform[7] rotateRoll( 180, 1);
}

FloorRoller_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

FloorRoller_Activate()
{
	self.platform[0] rotateYaw( 360, 2.5);
	self.platform[1] rotateYaw( -360, 2.5);
	self.platform[2] rotateYaw( 360, 2.5);
	self.platform[3] rotateYaw( -360, 2.5);
	self.platform[4] rotateYaw( -360, 2.5);
	self.platform[5] rotateYaw( 360, 2.5);
	self.platform[6] rotateYaw( -360, 2.5);
	self.platform[7] rotateYaw( 360, 2.5);
	wait 2.5;
	for(i = 0; i < 10 && StillPlayersTrying( self ); i++ )
	{
		self.platform[0] rotateYaw( 360, 2.5);
		self.platform[1] rotateYaw( -360, 2.5);
		self.platform[2] rotateYaw( 360, 2.5);
		self.platform[3] rotateYaw( -360, 2.5);
		self.platform[4] rotateYaw( -360, 2.5);
		self.platform[5] rotateYaw( 360, 2.5);
		self.platform[6] rotateYaw( -360, 2.5);
		self.platform[7] rotateYaw( 360, 2.5);
		wait 2.5;
	}
}

Bounce_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

Bounce_Activate()
{
	FlingPlayers();
	foreach( box in self.platform )
	{
		box MoveZ( 500, .3 );
	}
	wait .4;
	foreach( box in self.platform )
		box MoveZ( -500, 3 );
}

FlingPlayers()
{
	foreach( player in level.players )
	{
		if( player GetOrigin()[2] >= (self.Trigger GetOrigin()[2] - 177) && player GetOrigin()[2] < ((self.bridge[0] GetOrigin())[2] - 177) )
		{
			player setorigin( player getorigin() );
			player SetVelocity( player getvelocity() + (-350,-350,999) );
			for( i = 0; i < 10; i++ )
			{
				player SetVelocity( player getvelocity() + (-350,-350,999) );
				wait .01;
			}
			player Dodamage( 9999, player getorigin(), level.Activator);
		}
	}
}

Flame_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

Flame_Activate()
{
	self.Flames = []; 
	level.FlameTrap = loadfx( "weapon/talon/fx_muz_talon_rocket_flash_1p" );
	for( j = 0; j < 5; j++ )
	{
		for(i = 0; i < 5; i++ )
		{
			self.Pos = i*100;
			for(Ext = 0; Ext < 30; Ext++)
			{
				self.Flames[(i * 30) + Ext] = spawnFx(level.FlameTrap, ((self.trigger GetOrigin()) + (-405,-172, -23)) + (self.Pos,Ext*10, 20));
				triggerFx(self.Flames[(i * 30) + Ext]);
				self.Flames[(i * 30) + Ext] thread Flame_Monitor();
			}
		}
		
		wait 1;
		array_delete(self.Flames);
		self.Flames = []; 
	}
	array_delete(self.Flames);
}
	
Flame_Monitor()
{
	foreach(Extinct in level.Runners)
	{
		if(isDefined( self ) && isAlive(Extinct) && distance(self GetOrigin(), Extinct Getorigin() ) < 50)
		{
			player thread maps/mp/_burnplayer::burnedtodeath();
			Extinct doDamage(Extinct.health + 1, Extinct.origin, Level.Activator, Level.Activator, "none", "MOD_BURNED", 0, "none" );
		}
	}
}


StrafeTrap_Build()
{
	pos = (self.trigger GetOrigin())[1];
	self.platform = [];
	self.platform[ self.platform.size ] = spawn( "script_model",  ( (-355) + level.DeathRunspawnpoint[0], (354) + pos, level.DeathRunspawnpoint[2] ), 1);
	self.platform[ self.platform.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
	self.platform[ self.platform.size ] = spawn( "script_model",  ( (-355) + level.DeathRunspawnpoint[0], (0) + pos, level.DeathRunspawnpoint[2] ), 1);
	self.platform[ self.platform.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
}

StrafeTrap_Activate()
{
	self.packages = [];
	pos = [];
	for( i = 0; i < 531; i += randomIntRange(70,130) )
	{
		for( j = 1; j < randomIntRange(2,4); j++ )
		{
			pos = ((-370) + level.DeathRunspawnpoint[0], i + (self.trigger GetOrigin())[1], level.DeathRunspawnpoint[2] + 135 + (j * randomintrange(25, 35) ));
			self.packages[ self.packages.size ] = spawn( "script_model", pos);
			self.packages[ self.packages.size - 1 ] setmodel( "t6_wpn_supply_drop_axis" );
			self.packages[ self.packages.size - 1 ].angles = (0,90,0);
		}	
	}
	
	self.packages = array_randomize(self.packages);
	
	foreach( package in self.packages )
	{
		package thread DelayedPunch();
	}
	wait 10;
	foreach( package in self.packages )
	{
		package MoveX(100, .1 );
	}
	wait 1;
	foreach( package in self.packages )
	{
		package MoveX(-100, 1 );
	}
	wait 1.5;
	foreach( package in self.packages )
		package delete();
}
DelayedPunch()
{
	wait RandomFloatRange( 0, 1.75);
	self MoveX( 100, RandomFloatRange( .1, .4) );
	wait .5;
	self MoveX( -100, 1);
	wait 1.1;
	wait RandomFloatRange( 0, 1.75);
	self MoveX( 100, RandomFloatRange( .1, .4) );
	wait .5;
	self MoveX( -100, 1);
	wait 1.1;
	wait RandomFloatRange( 0, 1.75);
	self MoveX( 100, RandomFloatRange( .1, .4) );
	wait .5;
	self MoveX( -100, 1);
}

DeathWall_Build()
{
	self MakeDefaultPlatform( ( self.trigger GetOrigin() )[1] );
}

DeathWall_Activate()
{
	wait 2;
	self.badtouchwall = [];
	self.badtouchwall[0] = modelSpawner( ( (self.trigger GetOrigin())[0] - 200, (3 * 354) + (self.trigger GetOrigin())[1], level.DeathRunspawnpoint[2] + 270), "p6_dockside_container_lrg_orange", (0,90,0) );
	self.badtouchwall[1] = modelSpawner( ( (self.trigger GetOrigin())[0] - 554, (3 * 354) + (self.trigger GetOrigin())[1], level.DeathRunspawnpoint[2] + 270), "p6_dockside_container_lrg_orange", (0,90,0) );
	self.badtouchwall[2] = modelSpawner( ( (self.trigger GetOrigin())[0] - 200, (3 * 354) + (self.trigger GetOrigin())[1], level.DeathRunspawnpoint[2] + 135 ), "p6_dockside_container_lrg_orange", (0,90,0) );
	self.badtouchwall[3] = modelSpawner( ( (self.trigger GetOrigin())[0] - 554, (3 * 354) + (self.trigger GetOrigin())[1], level.DeathRunspawnpoint[2] + 135 ), "p6_dockside_container_lrg_orange", (0,90,0) );
	foreach( badwall in self.badtouchwall )
	{
		badwall thread KillOnTouched();
		badwall movey( -1162, 3);
	}
	wait 5.1;
	array_delete(self.badtouchwall);
}

KillOnTouched()
{
	while( isDefined( self ) )
	{
		foreach( runner in level.runners )
		{
			if( isAlive( runner ) && runner isTouching( self ) )
				runner doDamage(9999, runner.origin, level.Activator, self, "none", "MOD_HIT_BY_OBJECT", 0, "none" );
		}
		wait .05;
	}
}
