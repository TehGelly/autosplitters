state("Obduction-Win64-Shipping", "GOG 1.7.0")
{
	//value is 2 when loading anything, 1 when not
	int isLoading : "Obduction-Win64-Shipping.exe", 0x0309CB18, 0x188, 0x48, 0x10, 0x30, 0xA0, 0x68, 0xC;
}

state("Obduction-Win64-Shipping", "Steam 1.7.0")
{
	//value is 2 when loading anything, 1 when not
	int isLoading : "Obduction-Win64-Shipping.exe", 0x030FDC98, 0x188, 0x40, 0x10, 0x30, 0xA0, 0x68, 0xC;
}

state("Obduction-Win64-Shipping", "Steam 1.0")
{
	//value is 2 when loading saves, 1 when not
	int isLoading : "Obduction-Win64-Shipping.exe", 0x02951438, 0x188, 0x48, 0x10, 0x30, 0xA0, 0x68, 0xC;
	//value is 256 when loading physical transitions, 0 when not
	int isLoadingTree : "Obduction-Win64-Shipping.exe", 0x0298C300, 0x48, 0x7E0;
	//value is 1 when doing seed transitions, 0 when not (always has a last offset of 0x13C8)
	int isLoadingSeed : "Obduction-Win64-Shipping.exe", 0x027E83E8, 0x440, 0x840, 0x13C8;
	//value is 0 in heart, 1 or 4 in intro, 2 or ??? in kaptar/maray, 3 or 7 in hunrath/soria
	int ID : "Obduction-Win64-Shipping.exe", 0x027A5310;
}

state("Obduction-Win64-Shipping", "Steam 1.8.1")
{
	//value is 2 when loading anything, 1 when not
	int isLoading : "Obduction-Win64-Shipping.exe", 0x0312DA48, 0x70, 0x80, 0xC0, 0x18, 0x10, 0x60, 0x8;
}

state("Obduction-Win64-Shipping", "GOG 1.8.1")
{
	//value is 2 when loading anything, 1 when not
	int isLoading : "Obduction-Win64-Shipping.exe", 0x0318EBC8, 0x70, 0x80, 0xC0, 0x18, 0x10, 0x60, 0x8;
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
	//print("MD5Hash: " + MD5Hash.ToString()); //Lets DebugView show me the MD5Hash of the game executable, which is actually useful.
	
	if(MD5Hash == "1C70A1DD6CEA8193CFDC08A4DDA99B4A"){
		print("Version is 1.0, Steam.");
		version = "Steam 1.0";
	}else if(MD5Hash == "4899435C4FD1DCDA20E83743768C24D7"){
		print("Version is 1.7.0, Steam.");
		version = "Steam 1.7.0";
	}else if(MD5Hash == "FC437547668B2CEE3F19EBF8E25983A8"){
		print("Version is 1.7.0, GOG.");
		version = "GOG 1.7.0";
	}else if(MD5Hash == "ABD391AFBE1AE14B710084844CE7CFA1"){
		print("Version is 1.8.1, Steam.");
		version = "Steam 1.8.1";
	}else if(MD5Hash == "99DC6EFA852097910A7A7ABB9D1FC5F5"){
		print("Version is 1.8.1, GOG.");
		version = "GOG 1.8.1";
	}else{
		print(MD5Hash);
		print("Version not implemented.");
		version = "Unknown Version";
	}
}

isLoading{

	//1.0 requires different handling
	if(version == "Steam 1.0"){
		if(current.isLoading == 2 || current.isLoadingSeed == 1){
			return true;
		}else if((current.ID != 1 && current.ID != 4) && (current.isLoadingTree != 0)){
			return true;
		}else{
			return false;
		}
	}else{
		return (current.isLoading == 2);
	}
	
}
