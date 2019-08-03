state("realMyst")
{
  int isLoading : "realMyst.exe", 0x00CF6798, 0x38, 0xF8, 0x18, 0x690;
	float turnVelocity : "realMyst.exe", 0x00D578A8, 0x38, 0x8, 0x218, 0x208;
	int isClassic : "realMyst.exe", 0x00CF4568, 0x68, 0xA0, 0x134;
	int moving : "realMyst.exe", 0x00D9EB68, 0x10, 0xA8, 0x154;
	float xpos : "realMyst.exe", 0x00D578A8, 0x110, 0x1D0, 0x58, 0x224;
	int heldPage : "realMyst.exe", 0x00CF6A90, 0x0, 0x10, 0x98, 0x218, 0x10, 0x10, 0x28, 0x80, 0x10;
	//float fade : "realMyst.exe", 0x00D03B58, 0x0, 0x20, 0xA0, 0x280, 0x1C0, 0xF0, 0x640;
	int levelID : "realMyst.exe", 0x00C832A0;
}

//Settings stuff - don't sweat it
startup{

	settings.Add("pages", true, "Split on handing in pages");
	settings.Add("reds", false, "Red Pages (Sirrus)", "pages");
	settings.Add("blues", false, "Blue Pages (Achenar)", "pages");
	settings.Add("white", true, "White Page (Atrus)", "pages");
	settings.Add("age", true, "Split on entering an Age");
	settings.Add("ageenter", true, "Split on entering not-Myst", "age");
	settings.Add("ageenterfirst", true, "For only the first time", "ageenter");
	settings.Add("ageleave", true, "Split on entering Myst", "age");
	
	vars.ageenter = 0;
	refreshRate = 120; //look don't judge me
}

start{
	//isClassic is a 0x1000101 if in classic, 0x1 if in free-roam, and 0x0 on initialization
	if(current.isClassic == 0x1){
  
    //turnVelocity is a float for turning velocity
    // default is 1.0
		return (old.turnVelocity == 1.0 && current.turnVelocity != 1.0);
    
	}else if(current.isClassic == 0x01000101){
  
		//floating point comparisons are the one thing that keeps this soul from releasing into the afterlife
		return (current.moving - old.moving == 1 && //am i moving?
		(current.xpos-45.7196 > 0.00001 || current.xpos-45.7196 < -0.00001) && //not the weird non-origin default?
		(current.xpos-38.32993 > 0.00001 || current.xpos-38.32993 < -0.00001)); //not the starting position?
    
	}
}

split{
	
	
	if(settings["reds"] == true && old.heldPage == 3 && current.heldPage == 0){
		return true;
	}
	
	if(settings["blues"] == true && old.heldPage == 4 && current.heldPage == 0){
		return true;
	}
	
	if(settings["white"] == true && old.heldPage == 5 && current.heldPage == 0){
		return true;
	}
	
	/* all of the fucking pointers for book fade are at least 8 fucking offsets 
		and work "when they want to"
		burn in fucking hell, you unity cucks
	if(settings["age"] == true){
		//we check for fade stuff
		//in particular, a rising edge
		if(current.isFadingOnMyst == 1 && old.isFadingOnMyst == 0){
			//we're entering a book
			//so, let's make sure we're entering the right book according to settings
			
			//if we're leaving myst, we better be in myst
			if(settings["ageenter"] == true && current.levelID == 1){
				vars.ageenter += 1;
				return ((settings["ageenterfirst"] == false) || (vars.ageenter == 1));
			}
		}
		
		if(false){
			//if we're heading to myst, we better be in not-myst
			if(settings["ageleave"] == true && current.levelID != 1){
				return true;
			}
		}
	}
	*/
}

isLoading{
	return (current.isLoading != 0);
}
