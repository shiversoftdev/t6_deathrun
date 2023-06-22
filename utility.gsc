MakeDefaultPlatform( pos )
{
	self.platform = [];
	for( y = 0; y < 2; y++ )
	{
		for( x = -2; x < 2; x++ )
		{
			self.platform[ self.platform.size ] = spawn( "script_model",  ( (x * 135) + level.DeathRunspawnpoint[0], (y * 354) + pos, level.DeathRunspawnpoint[2] ), 1);
			self.platform[ self.platform.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
		}
	}
}

modelSpawner(origin, model, angles)
{
	obj = spawn("script_model", origin);
	obj setModel(model);
	if(isDefined(angles))
		obj.angles = angles;
	return obj;
}


MakeDefaultTrapBridge( pos )
{
	self.bridge = [];
	for( y = 0; y < 2; y++ )
	{
		for( x = -2; x < 2; x++ )
		{
			self.bridge[ self.bridge.size ] = spawn( "script_model",  ( (x * 135) + level.DeathRunspawnpoint[0], ((y + 2) * 354) + pos, level.DeathRunspawnpoint[2] ), 1);
			self.bridge[ self.bridge.size - 1] setmodel( "p6_dockside_container_lrg_orange" );
		}
	}
}

StillPlayersTrying( trap )
{
	PlayersLeft = false;
	foreach( player in Level.Runners )
	{
		if( isAlive( player ) && !player IsTouchingBridge( trap ) )
			PlayersLeft = true;
	}
	if( level.Runners.size < 1 )
		return false;
	return PlayersLeft;	
}

StillAllPlayersTrying( trap )
{
	foreach( player in Level.Runners )
	{
		if( isAlive( player ) && player IsTouchingBridge( trap ) && player.origin > 9500 )
			return false;
	}
	if( level.Runners.size < 1 )
		return false;
	return true;	
}

IsTouchingBridge( trap )
{
	foreach( box in trap.bridge )
		if( self isTouching( box ) )
			return true;
	if( (self Getorigin())[1] >= ((trap.bridge[0] Getorigin())[1] - 177) )
		return true; //We went past the bridge already
	return false;
}

isTouchingPlatform( trap )
{
	foreach( box in trap.platform )
	{
		if( box isTouching( self ) )
			return true;	
	}
	return false;
}




