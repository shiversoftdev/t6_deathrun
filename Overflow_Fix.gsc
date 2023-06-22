overflowfix()
{
	level endon("host_migration_begin");
	
	level.test = createServerFontString("default", 1);
	level.test setText("xTUL");
	level.test.alpha = 0;
	
	if(getDvar("g_gametype") == "sd")//if gametype is search and destroy
		A = 45; //A = 220;
	else 				  // > change if using rank.gsc
		A = 55; //A = 230;

	for(;;)
	{
		level waittill("textset");

		if(level.result >= A)
		{
			level.test ClearAllTextAfterHudElem();
			level.result = 0;
			
			foreach(player in level.players)
			{
				if(isDefined(level.DeathRunWelcome["MainText0"]))
				{
					if(!level.WelcomeTextChanged)
						level.DeathRunWelcome["TitleText"] setSafeText("The game will begin shortly, please wait");
					else
						level.DeathRunWelcome["TitleText"] setSafeText("Welcome to Death Run");
					level.DeathRunWelcome["SubTitleText"] setSafeText("Created by Extinct and SeriousHD-");
					level.DeathRunWelcome["MainText0"] setSafeText("Death Run is a gamemode that was originally created for GMOD, We decided it would be a fun gamemode to play on BO2");
					level.DeathRunWelcome["MainText1"] setSafeText("The gamemode objective is there is one activator and the rest are runners");
					level.DeathRunWelcome["MainText2"] setSafeText("the runners need to dodge all the traps the activator activates, the activator needs to stop the runners from getting to him");
					level.DeathRunWelcome["MainText3"] setSafeText("Goodluck, Hosted By "+level.hostname);
					level.DeathRunWelcome["MainText4"] setSafeText("www.youtube.com/c/ExtinctMods");
					level.DeathRunWelcome["MainText5"] setSafeText("www.youtube.com/anthonything");
				}
				if(isDefined(player.Notifys))
				{
					level.DeathRunNotify["NotifyTextTop"] setSafeText("^2"+level.LastDeath+" ^7Has Been Eliminated By "+"^2"+level.ActivatorName);
					level.DeathRunNotify["NotifyTextBottom"] setSafeText("Number Of Runners Remaining: ^2 "+level.RunnersNum);
				}
				player iprintln("Fixing Overflows");
			}
		}
		wait 0.01;    
	}
}

setSafeText(text)
{
	level.result += 1;
	level notify("textset");
	self setText(text);
}



