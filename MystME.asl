state("scummvm", "GOG"){
	int heldPage: "scummvm.exe", 0x004ED32C, 0x74, 0x8;
	int age: "scummvm.exe", 0x004ED32C, 0x74, 0x4;
	int isFading: "SDL2.dll", 0x000F26DC, 0x0;
}
//
state("scummvm", "Steam/DVD"){
	int heldPage: "scummvm.exe", 0x0052C34C, 0x74, 0x8;
	int age: "scummvm.exe", 0x0052C34C, 0x74, 0x4;
	int isFading: "SDL2.dll", 0x000F26DC, 0x0;
}

init{
	//i robbed this md5 code from CptBrian's RotN autosplitter
	//shoutouts to him
	byte[] exeMD5HashBytes = new byte[0];
	using (var md5 = System.Security.Cryptography.MD5.Create())
	{
		using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
		{
			exeMD5HashBytes = md5.ComputeHash(s); 
		} 
	}
	var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("MD5Hash: " + MD5Hash.ToString()); //Lets DebugView show me the MD5Hash of the game executable, which is actually useful.
	
	if(MD5Hash == "05DE98AFC709B66092EDF7395197308B"){
		print("From GOG, with love.");
		version = "GOG";
	}else if(MD5Hash == "C67ADFE717BE09C7FFDBB8D71F150110"){
		print("Steam/DVD Version.");
		version = "Steam/DVD";
	}
	
	//also this
	vars.firstEntry = 0;
}

startup{
	settings.Add("pages",true,"Split on handing in all non-library pages.");
	settings.Add("libpages",false,"Include library pages.", "pages");
	settings.Add("tr",true,"Split on entry and exit of every Age");
	settings.Add("fe", true, "Split on only first entry to any Age.","tr");
	settings.Add("exit", false, "Split on exit of every non-Myst Age.","tr");
}

split{
	if(settings["pages"]){
		//we want to skip pages 0, 1, 7, and 13 in myst library
		if((old.heldPage !=0) && (old.heldPage % 6 != 1) && (current.heldPage == 0)){
			if(current.age == 2){
				return true;
			}
		//we want to lose 13 in kveer
		}else if(old.heldPage == 13 && current.heldPage == 0){
			if(current.age == 6){
				return true;
			}
		}else if(settings["libpages"] && (old.heldPage == 1 || old.heldPage == 7) && (current.heldPage == 0)){
			//just in case
			if(current.age == 2){
				return true;
			}
		}
	}
	
	if(settings["tr"]){
		if(old.isFading==0 && current.isFading == 1){
			if(settings["fe"]){
				if(vars.firstEntry == 0){
					//should only work once
					vars.firstEntry = 1;
					return true;
				}else{
					return false;
				}
			}else if(settings["exit"] && current.age != 2){
				return true;
			}else{
				return true;
			}
		}
	}
	
	return false;
}

start{
	if(old.isFading==0 && current.isFading == 1){
		vars.firstEntry = 0;
		return true;
	}
}
