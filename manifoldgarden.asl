state("ManifoldGarden"){
	//much credit to preshing for working out the kinks in the previous version to make it work
	// This pointer path works with:
	// Manifold Garden 1.0.29.12830 (Dec. 18, 2019)
	// Manifold Garden 1.0.29.12781 (Dec. 11, 2019)
	int level: "UnityPlayer.dll", 0x01507BE0, 0x0, 0x928, 0x38, 0x30, 0xB0, 0x118, 0x5C;
}

startup{
	settings.Add("mandala",true,"Split when entering a mandala scene.");
	settings.Add("nonmandala",true,"Split on non-mandala transitions.");
	settings.Add("norepeats",false,"Split on the first encounter of each level");
	
	vars.prev = new List<int>();
	vars.prev.Add(64);
	vars.endCounter = 0;
}

start{
	if(current.level == 64 && old.level == -1){
		vars.prev.Clear();
		vars.prev.Add(64);
		vars.endCounter = 0;
		return true;
	}
}

reset{
	return current.level == -1;
}

split{
	if(old.level != current.level && current.level != 0 && old.level != 0){
		if(settings["mandala"] && current.level > 8 && current.level < 16){
			return true;
		}else if(settings["nonmandala"]){
			if(settings["norepeats"]){
				if(!vars.prev.Contains(current.level)){
					vars.prev.Add(current.level);
					print("" + vars.prev.Count + ": " + current.level);
					if(vars.level == 110){
						vars.endCounter++;
					}
					return true;
				}
			}else{
				return true;
			}
		}
	}
	
	if(vars.endCounter > 0){
		if(vars.endCounter == 66){
			vars.endCounter = 0;
			return true;
		}else{
			vars.endCounter++;
			return false;
		}
	}
	
}
