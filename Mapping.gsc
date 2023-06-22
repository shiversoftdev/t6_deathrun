MapInit()
{	
	PrepareAssets();
	InitializeLevelVariables();
	CreateMap();
}
PrepareAssets()
{
	if(!isDefined(level.incEntSpace))
 	{
  		level.incEntSpace = true;
	  	array = [];
	  	array = getentarray();
	  	dog = getent( "talon", "targetname" );
  		foreach( ent in array )
  		{
  			if( ent != dog )
  				ent delete();
  		}
	}
}

InitializeLevelVariables()
{
	level.DeathRunOrigin = (0,0,10000);
	level.DeathRunspawnpoint = level.DeathRunOrigin - (250,0,0);
	level.ActivatorSpawn = level.DeathRunspawnpoint + (270,581,140);
	level.NumberOfTriggers = 10;
	level.RunnersNum = 0;
	level.LastDeath = "";
	level.ActivatorName = "";
	level.DeathRunNotify = [];
}

CreateMap()
{
	///	Spawnpoint crates
	level.DeathRunMapping = spawnstruct();
	level.DeathRunMapping.startareamodels = [];
	/// Flooring
	level.DeathRunMapping.collisions = [];
	level.DeathRunMapping.Flooring = [];
	level.DeathRunMapping.StartAreaFallers = [];
	level.DeathRunMapping.StartAreaOverhang = [];
	for( y = -354; y <= 0; y += 354 )
	{
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (270,y,25) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (270,y,250) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
	}
	level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (270,354,25) ), 1);
	level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
	level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (270,354,250) ), 1);
	level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
	level.DeathRunMapping.StartAreaOverhang[0] = spawn( "script_model", ( level.DeathRunspawnpoint + (514.5,242.804,250) ), 1);
	level.DeathRunMapping.StartAreaOverhang[0] setModel("p6_dockside_container_lrg_orange");
	level.DeathRunMapping.StartAreaOverhang[0].angles = (0,90,0);
	level.DeathRunMapping.StartAreaOverhang[1] = spawn( "script_model", ( level.DeathRunspawnpoint + (868.5,242.804,250) ), 1);
	level.DeathRunMapping.StartAreaOverhang[1] setModel("p6_dockside_container_lrg_orange");
	level.DeathRunMapping.StartAreaOverhang[1].angles = (0,90,0);
	for( x = -270; x <= 135; x += 135 ) 
	{
		for( y = -354; y <= 0; y += 354 )
		{
			level.DeathRunMapping.Flooring[ level.DeathRunMapping.Flooring.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (x,y,0) ), 1);
			level.DeathRunMapping.Flooring[ level.DeathRunMapping.Flooring.size - 1] setModel("p6_dockside_container_lrg_orange");
		}	
	}
	for( x = -270; x <= 135; x += 135 ) 
	{
		for( y = 354; y <= 354; y += 354 )
		{
			level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (x,y,0) ), 1);
			level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
		}	
	}
	for( y = -512; y <= 512; y += 512 )
		level.DeathRunMapping.collisions[ level.DeathRunMapping.collisions.size ] = spawncollision( "collision_clip_wall_512x512x10", "collider", ( level.DeathRunspawnpoint + (202,y,150) ) , (0,90,0) );
	///Wall Left 
	for( y = -354; y <= 0; y += 354 )
	{	
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (-395,y,117) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (-395,y,250) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
	
	}
	for( y = 354; y <= ( (level.NumberOfTriggers * 4 * 354) + 354 ); y += 354 )
	{
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (-395,y,117) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (-395,y,250) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
	}
	///Wall Right
	for( y = -354; y <= 0; y += 354 )
	{
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (405,y,135) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
	}
	for( y = 354; y <= ( (level.NumberOfTriggers * 4 * 354) + 354 ); y += 354 )
	{
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (405,y,135) ), 1);
		level.DeathRunMapping.startareamodels[ level.DeathRunMapping.startareamodels.size - 1] setModel("p6_dockside_container_lrg_orange");
	}
	///Back Spawn Wall
	for( y = -354; y <= 354; y += 354 )
	{
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (y,-500,117) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] rotateYaw(90, .01);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size ] = spawn( "script_model", ( level.DeathRunspawnpoint + (y,-500,250) ), 1);
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] setModel("p6_dockside_container_lrg_orange");
		level.DeathRunMapping.StartAreaFallers[ level.DeathRunMapping.StartAreaFallers.size - 1] rotateYaw(90, .01);
	}
	///Gates
	self.DeathRunGate = modelSpawner((-311.304, 175.304, 10136), "p6_metal_fence_gate", (0,180,0));
	self.DeathRunGateRight = modelSpawner((-114.304, 175.304, 10136), "p6_metal_fence", (0,180,0));
	self.DeathRunGateRight2 = modelSpawner((156.304, 175.304, 10144), "p6_metal_fence", (0,180,0));
	self.DeathRunGateLeft = modelSpawner((-508.304, 175.304, 10136), "p6_metal_fence", (0,180,0));
	self.DeathRunGateCollision = spawncollision( "collision_clip_wall_256x256x10", "collider", ( self.DeathRunGate.origin ) , (0,180,0) );
	spawncollision( "collision_clip_wall_128x128x10", "collider", ( self.DeathRunGateRight.origin ) , (0,180,0) );
	spawncollision( "collision_clip_wall_128x128x10", "collider", ( self.DeathRunGateLeft.origin ) , (0,180,0) );
}

OpenGates()
{
	///Movements
	level.DeathRunMapping.StartAreaFallers[0] movez(90, .05);
 	level.DeathRunMapping.StartAreaFallers[2] movez(90, .05);
	wait 7.5;
	self.DeathRunGate movex(-260, 1);
	self.DeathRunGateCollision movex(-260, 1);
	foreach( player in level.players )
		player thread maps/mp/gametypes/_hud_message::hintmessage( "THE DEATHRUN HAS STARTED" );
	self thread GateClose();
}

Debugging()
{
	while( level.debugDeathRun )
	{
		if(self useButtonPressed())
			exitLevel(true);
		if(self jumpButtonPressed())
			self setorigin(level.DeathRunMapping.startareamodels[380].origin+(0,0,350));
		self iprintlnbold("X: "+self.origin[0]+" Y: "+self.origin[1]+" Z: "+self.origin[2]);	
		wait .3;
	}
}

GateClose()
{
	wait 15;
	self.DeathRunGate movex(260, 10);
	self.DeathRunGateCollision movex(260, 10);
	wait 10;
	foreach( model in level.DeathRunMapping.Flooring)
		model moveZ( -200, 1 );
	wait 1.2;
	foreach( model in level.DeathRunMapping.Flooring )
		model PhysicsLaunch();
	foreach( model in level.DeathRunMapping.StartAreaFallers )
		model PhysicsLaunch();
	spawncollision( "collision_clip_wall_128x128x10", "collider", ( self.DeathRunGateRight2 GetOrigin() + (135,0,0) ) , (0,180,0) );
	self.DeathRunGateRight2 moveX( -135, 1 );
	level.DeathRunMapping.StartAreaOverhang[0] MoveX( -708, 2 );
	level.DeathRunMapping.StartAreaOverhang[1] MoveX( -708, 2 );
	wait 5;
	foreach( model in level.DeathRunMapping.Flooring )
		model delete();
	foreach( model in level.DeathRunMapping.StartAreaFallers )
		model Delete();
}

