state("TheSwapper"){
	//TODO: find a valid x velocity pointer
	float xvel: "swapper.exe", 0x099345, 0x0, 0xB4D;
}

//this asl takes heavy influence from the talos script
//thanks, darkid

startup{
	//gonna assume some magic up in here
	vars.settingsList = new List<string>();
	string tempPath = "C:\\Users";
	string[] subdirec = Directory.GetDirectories(tempPath);
	foreach(string subdir in subdirec){
		if(Directory.Exists(subdir + "\\Documents\\Facepalm Games\\The Swapper 1000")){
			settings.Add(subdir.Substring(9),false);
			settings.SetToolTip(subdir.Substring(9),"Pick this user for your savefile directory.");
			vars.settingsList.Add(subdir.Substring(9));
		}
	}
}

init{
	vars.consoleList = new Dictionary<string, bool>{
		{"#c#area1_console", false} //starting area
	};
	
	//TODO: Add autosearch functionality
	var logPath  = "";
	foreach(string user in vars.settingsList){
		//this just picks the first one that's true bc i'm lazy
		if(settings[user]){
			logPath = "C:\\Users\\" + user + "\\Documents\\Facepalm Games\\The Swapper 1000";
			string[] fileList = Directory.GetFiles(logPath);
			foreach(string filename in fileList){
				int length = filename.Length;
				string ext = filename.Substring(length-3);
				if(string.Compare( ext , "ini" )==0){
					logPath = filename;
					break;
				}
			}
			break;
		}
	}
	vars.reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
	vars.eventCount = 0;
}

start{
	//rewind to file beginning every time
	vars.reader.DiscardBufferedData();
	vars.reader.BaseStream.Seek(0, System.IO.SeekOrigin.Begin);
	var newEventCount = Int32.Parse(vars.reader.ReadLine());
	if(newEventCount == 7){
		return true;
	}
	return false;
}

split{
	//rewind to file beginning every time
	vars.reader.DiscardBufferedData();
	vars.reader.BaseStream.Seek(0, System.IO.SeekOrigin.Begin);
	var newEventCount = Int32.Parse(vars.reader.ReadLine());
	if(newEventCount > vars.eventCount){
		vars.eventCount = newEventCount;
		//now we run through the next eventcount amount of lines
		for(int i = 0; i < newEventCount; i++){
			var line = vars.reader.ReadLine();
			if(vars.consoleList.ContainsKey(line)){
				if(!vars.consoleList[line]){
					vars.consoleList[line] = true;
					return true;
				}
			}else{
				print("oops" + line);
			}
		}
	}
	
	return false;
}
