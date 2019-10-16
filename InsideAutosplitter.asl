state("INSIDE"){
	float xval: "mono.dll", 0x00294BA8, 0x20, 0xF28, 0x0, 0x440;
	float yval: "mono.dll", 0x00294BA8, 0x20, 0xF28, 0x0, 0x444;
	float menuFade: "mono.dll", 0x00294BA8, 0x20, 0x2F0, 0x30, 0xA4;
	//this is within the "ForcePushManager" class
	float waveTimer: "mono.dll", 0x294BA8, 0x20, 0xA70, 0x10, 0xAC;
	//both of these are within the "SecretWirePull" class
	int isWireBroken: "mono.dll", 0x2B9360, 0x498, 0x8, 0xB68, 0xC0, 0x284;
	float wirePullTimer: "mono.dll", 0x2B9360, 0x498, 0x8, 0xB68, 0xC0, 0x290;
	//this comes from my ass
	short boxBreak: "INSIDE.exe", 0xF4E8B0, 0x330, 0x6A0, 0x4E8, 0x440, 0x698, 0xA;
}

startup{
	vars.splitLength = 18;
	settings.Add("forest",true,"Split when the flashlight is turned off in the river.(Forest)");
	settings.Add("barn",true,"Split when jumping off the barn.(Barn)");
	settings.Add("window",true,"Split when opening the window.(Window)");
	settings.Add("city",true,"Split when exiting the elevator post-Sentinels.(City)");
	settings.Add("lineup",true,"Split when jumping into the helmet post-lineup.(Lineup)");
	settings.Add("search",true,"Split when closing the trapdoor under the searchlights.(Search)");
	settings.Add("dogs",true,"Split when landing on the ledge before the submersible.(Dogs)");
	settings.Add("sub",true,"Split when closing the door on the watergirl.(Sub)");
	settings.Add("mine",false,"Split when the box breaks in the shockwave section.(Mine) UNRELIABLE");
	settings.Add("clock",true,"Split when landing in the water under the shockwave elevator.(Clock)");
	settings.Add("breathe",true,"Split when falling from the chain to the intended watergirl drowning.(Breathe)");
	settings.Add("underwater",true,"Split when diving into the tank after avoiding the searchlight.(Underwater)");
	settings.Add("puzzles",true,"Split when entering the last pool of water containing freaks.(Puzzles)");
	settings.Add("office",true,"Split when leaving the office elevator room with enough freaks.(Office)");
	settings.Add("inside",true,"Split when getting sucked into the pool containing the blob.(Inside)");
	settings.Add("rampage",true,"Split when crushing the CEO, or landing after letting him live.(Rampage)");
	settings.Add("huddle",true,"Split when breaking the wall, ending the game.(Huddle)");
	settings.Add("disconnect",true,"Split when pulling the plug in the secret ending.(Disconnect)");
}
//
start{
	if(old.menuFade == 1.00 && current.menuFade < 1.0){
		return true;
	}
}

init{
	vars.splitList = new bool[vars.splitLength];
	for(int i = 0; i < vars.splitLength; i++){
		vars.splitList[i] = false;
	}
}

split{
	//going to run through all of the splits
	for(int i = 0; i < vars.splitLength; i++){
		if(!vars.splitList[i]){
			switch(i){
				case 0:
					//forest - cross a line
					//wide range just in case
					if(settings["forest"] && current.xval > -35.5 && current.xval < -33.5){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 1:
					//barn - cross vertical line in horiz range
					if(settings["barn"] && current.xval > 274 && current.xval < 275){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 2:
					//window - cross a line
					if(settings["window"] && current.xval > 550 && current.xval < 551){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 3:
					//city - cross a line
					if(settings["city"] && current.xval > 846.5 && current.xval < 847.5){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 4:
					//lineup - cross a line
					if(settings["lineup"] && current.xval > 1020 && current.xval < 1021){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 5:
					//search - cross vertical line in horiz range
					if(settings["search"] && current.xval > 1271 && current.xval < 1273 && current.yval < -286){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 6:
					//dogs/submarine - cross vertical line in horiz range
					if(settings["dogs"] && current.xval > 1490 && current.xval < 1500 && current.yval < -364){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 7:
					//sub proper - TODO
					if(settings["sub"] && old.waveTimer > 5.95 && current.waveTimer < 0.05){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 8:
					//mine - uses a weird value to determine stuff
					if(settings["mine"] && current.xval > 2173 && current.xval < 2179 && 
						old.boxBreak != current.boxBreak){
							vars.splitList[i] = true;
							return true;
					}
					break;
				case 9:
					//clock - cross vertical line in horiz range
					//intentionally wide range due to oob
					if(settings["clock"] && current.xval > 2482 && current.xval < 2497 && current.yval < -650){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 10:
					//breathe - cross vertical line in horiz range
					if(settings["breathe"] && current.xval > 2852 && current.xval < 2853 && current.yval > -643.5){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 11:
					//underwater - cross vertical line in horiz range
					if(settings["underwater"] && current.xval > 3088 && current.xval < 3100 && current.yval > -760){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 12:
					//puzzles - cross vertical line in horiz range
					if(settings["puzzles"] && current.xval > 3244 && current.xval < 3250 && current.yval < -727){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 13:
					//office - cross a line
					if(settings["office"] && current.xval > 3400 && current.xval < 3401){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 14:
					//inside - going up lmfao
					if(settings["inside"] && current.xval < 3635.5 && current.xval > 3631 && 
								 current.yval > -806   && current.yval < -810 ){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 15:
					//CEO - cross a vertical line in a horiz range
					if(settings["rampage"] && current.xval > 3523 && current.xval < 3541 && current.yval < -878){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 16:
					//huddle - cross the wooden barrier, my dude
					if(settings["huddle"] && current.xval > 4004.5){
						vars.splitList[i] = true;
						return true;
					}
					break;
				case 17:
					//disconnect - based on the secretwirepull struct/class
					if(settings["disconnect"] && current.isWireBroken == 1 &&
					old.wirePullTimer == current.wirePullTimer && current.wirePullTimer > 1.9){
						vars.splitList[i] = true;
						return true;
					}
					break;
				
			}
		}
	}
}
