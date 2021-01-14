state("scummvm", "GOG") {
	ushort cardID: "scummvm.exe", 0x004ED32C, 0xB4, 0x10;
	ushort sfxID: "scummvm.exe", 0x004ED32C, 0x6C, 0xC;
	int heldPage: "scummvm.exe", 0x004ED32C, 0x74, 0x8;
	int age: "scummvm.exe", 0x004ED32C, 0x74, 0x4;
	int clockBridge: "scummvm.exe", 0x004ED32C, 0x74, 0x48;
	int isFading: "SDL2.dll", 0x000F26DC, 0x0;
	byte32 markerSwitches: "scummvm.exe", 0x004ED32C, 0x74, 0x1C;
}

state("scummvm", "Steam/DVD") {
	ushort cardID: "scummvm.exe", 0x0052C34C, 0xB4, 0x10;
	ushort sfxID: "scummvm.exe", 0x0052C34C, 0x6C, 0xC;
	int heldPage: "scummvm.exe", 0x0052C34C, 0x74, 0x8;
	int age: "scummvm.exe", 0x0052C34C, 0x74, 0x4;
	int clockBridge: "scummvm.exe", 0x0052C34C, 0x74, 0x48;
	int isFading: "SDL2.dll", 0x000F26DC, 0x0;
	byte32 markerSwitches: "scummvm.exe", 0x0052C34C, 0x74, 0x1C;
}

init {
	//i robbed this md5 code from CptBrian's RotN autosplitter
	//shoutouts to him
	byte[] exeMD5HashBytes = new byte[0];
	using (var md5 = System.Security.Cryptography.MD5.Create()) {
		using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)) {
			exeMD5HashBytes = md5.ComputeHash(s); 
		} 
	}
	var MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("MD5Hash: " + MD5Hash.ToString()); //Lets DebugView show me the MD5Hash of the game executable, which is actually useful.
	
	if (MD5Hash == "05DE98AFC709B66092EDF7395197308B") {
		print("From GOG, with love.");
		version = "GOG";
	} else if (MD5Hash == "C67ADFE717BE09C7FFDBB8D71F150110") {
		print("Steam/DVD Version.");
		version = "Steam/DVD";
	}
	
	//also this
	vars.firstLink = 0;
	vars.markerSwitchManager = 0;
}

startup {
	settings.Add("pages", true, "Split on handing in all non-library pages.");
	settings.Add("libpages", false, "Include library pages.", "pages");
	settings.Add("any", false, "Any% splits");
	settings.Add("fireplace", false, "Split on closing of the fireplace.", "any");
	settings.Add("clockbridge", false, "Split on raising of the clocktower bridge.", "any");
	settings.Add("switches", false, "Split on every marker switch being flipped.", "any");
	settings.Add("link", true, "Split when linking to another Age.");
	settings.Add("firstLink", true, "...but only the very first.", "link");
	settings.Add("returnToMyst", false, "...but only when linking back to Myst Island.", "link");
}

split {
	if (settings["pages"]) {
		// Held page changed on Myst Island, didn't drop white page
		if (current.age == 2 && old.heldPage != 0 && old.heldPage != 13 && current.heldPage == 0) {
			// Skip the library pages if user doesn't want to split for them
			if (settings["libpages"] || (old.heldPage != 1 && old.heldPage != 7)) {
				return true;
			}
		}
	}
	
	if (settings["link"]) {
		if ((old.isFading == 0 || old.isFading == 65537) && current.isFading == 1) {
			if (settings["firstLink"]) {
				if (vars.firstLink == 0) {
					//should only work once
					vars.firstLink = 1;
					return true;
				}
			} else if (settings["returnToMyst"] && current.age != 2) {
				return true;
			} else {
				return true;
			}
		}
	}
	
	if (settings["any"]) {
		if (settings["fireplace"] && current.age == 2 && old.cardID != 4162 && current.cardID == 4162) {
			return true;
		}	
	
		if (settings["clockbridge"] && old.clockBridge == 0 && current.clockBridge == 1) {
			return true;
		}
	
		if (settings["switches"]) {
			//this is the only time i've managed to be sorta clever
			//marker switch flip state is stored in an int
			for (int i = 0; i < 8; i++) {
				if (((vars.markerSwitchManager & (1 << i)) == 0) && current.markerSwitches[4 * i] == 1) {
					vars.markerSwitchManager |= (1 << i);
					return true;
				}	
			}
		}
	}
		
	// Always split upon handing in white page in K'veer
	if (old.heldPage == 13 && current.heldPage == 0 && current.age == 6) {
		return true;
	}
}

start {
	if (current.cardID == 5 && old.sfxID == 0 && current.sfxID == 5) {
		vars.firstLink = 0;
		vars.markerSwitchManager = 0;
		return true;
	}
}
