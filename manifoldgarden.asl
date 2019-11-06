state("ManifoldGarden"){
	int level: "UnityPlayer.dll", 0x01507C68, 0x8, 0x38, 0xA8, 0x58, 0x118, 0x5C;
}

startup{
	settings.Add("mandala",true,"Split when entering a mandala scene.");
	settings.Add("nonmandala",true,"Split on non-mandala transitions.");
	settings.Add("norepeats",false,"Split on the first encounter of each level");
	
	vars.prev = new List<int>();
	vars.prev.Add(64);
}

start{
	if(current.level == 64 && old.level == -1){
		vars.prev.Clear();
		vars.prev.Add(64);
		return true;
	}
}

reset{
	return current.level == -1;
}

split{
	if(old.level != current.level){
		if(settings["mandala"] && current.level > 8 && current.level < 16){
			return true;
		}else if(settings["nonmandala"]){
			if(settings["norepeats"]){
				if(!vars.prev.Contains(current.level)){
					vars.prev.Add(current.level);
					print("" + vars.prev.Count + ": " + current.level);
					return true;
				}else{
					return false;
				}
			}else{
				return true;
			}
		}
	}
}
