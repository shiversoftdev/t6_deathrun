drawText(text, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
	hud = undefined;
	if( self == level )
		hud = level createServerFontString(font, fontScale);
	else
		hud = self createFontString(font, fontScale);
    hud setPoint(align, relative, x, y);
	hud.color = color;
	hud.alpha = alpha;
	hud.glowColor = glowColor;
	hud.glowAlpha = glowAlpha;
	if( sort == -1 )
	{
		hud.foreground = true;
		sort = 999;
	}
	hud.sort = sort;
	hud.alpha = alpha;
	hud setSafeText(text);
	hud.hideWhenInMenu = true;
	hud.archived = false;
	return hud;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, isLevel)
{
 	if(!isDefined(isLevel))
  		hud = newClientHudElem(self);
 	else
  		hud = newHudElem();
    hud.elemType = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud setPoint(align, relative, x, y);
 	hud.archived = false;
 	hud.hideWhenInMenu = true;
    return hud;
}

affectElement(type, time, value)
{
    if(type == "x" || type == "y")
        self moveOverTime(time);
    else
        self fadeOverTime(time);
 
    if(type == "x")
        self.x = value;
    if(type == "y")
        self.y = value;
    if(type == "alpha")
        self.alpha = value;
    if(type == "color")
        self.color = value;
}

dotDot(text)
{
	level endon("dotDot_endon");
	while(isDefined(self))
	{	
		self setText(text);
		wait .4;
		self setText(text+".");
		wait .4;
		self setText(text+"..");
		wait .4;
		self setText(text+"...");
		wait .4;
	}
}

destroyAll(array)
{
	keys = getArrayKeys(array);
	for(a=0;a < keys.size;a++)
	{
  		temp = keys[a];
  		if(isDefined(array[temp][0]))
  		{
   			for(e=0;e < array[temp].size;e++)
    			array[temp][e] destroy();
  		}
  		else
    		array[temp] destroy();
	}
}

createString(input, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort, isLevel, isValue)
{
  	if(!isDefined(isLevel))
    	hud = self createFontString(font, fontScale);
 	else
    	hud = level createServerFontString(font, fontScale);
    if(!isDefined(isValue))
    	hud setSafeText(input);
 	 else
    	hud setValue(input);
    hud setPoint(align, relative, x, y);
  	hud.color = color;
  	hud.alpha = alpha;
  	hud.glowColor = glowColor;
  	hud.glowAlpha = glowAlpha;
  	hud.sort = sort;
 	 hud.alpha = alpha;
 	hud.archived = false;
 	hud.hideWhenInMenu = true;
 	return hud;
}

DeathRun_Notifications()
{	
	//Notify Huds
	if(!isDefined(level.NotifysGUI))
	{
		level.NotifysGUI = true;
		level.DeathRunNotify["NotifyBackground"] = createRectangle("RIGHT", "TOP", 770, 75, 330, 50, (0,0,0), "gradient", 1, 1);
		level.DeathRunNotify["NotifyTextTop"] = createString("", "objective", 1.4, "RIGHT", "TOP", 420, 67, (1,1,1), 1, (0,0,0), 0, 5);
		level.DeathRunNotify["NotifyTextBottom"] = createString("", "objective", 1.4, "RIGHT", "TOP", 420, 83, (1,1,1), 1, (0,0,0), 0, 5);
	}
	
	foreach(Runner in level.Runners)
		level.RunnersNum++;
		
	for(;;)
	{
		level waittill("DeathNotification");
		if(!isDefined(level.Notifys))
		{
			level.Notifys = "Active";
			level.DeathRunNotify["NotifyTextTop"] setSafeText("^2"+level.LastDeath+" ^7Has Been Eliminated By "+"^2"+level.Activator.Name);
			level.DeathRunNotify["NotifyTextBottom"] setSafeText("Number Of Runners Remaining: ^2 "+level.RunnersNum);
			
			level.DeathRunNotify["NotifyBackground"] affectElement("x", .2, 375);//Moving To Show
			level.DeathRunNotify["NotifyTextTop"] affectElement("x", .2, 385);//Moving To Show
			level.DeathRunNotify["NotifyTextBottom"] affectElement("x", .2, 385);//Moving To Show
			wait 4;
			level.DeathRunNotify["NotifyBackground"] affectElement("x", .2, 770);//Moving To Hids
			level.DeathRunNotify["NotifyTextTop"] affectElement("x", .2, 770);//Moving To Hids
			level.DeathRunNotify["NotifyTextBottom"] affectElement("x", .2, 770);//Moving To Hids
			wait .2;
			level.Notifys = undefined;
		}
		wait .05;
	}	
}
