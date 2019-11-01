state("ManifoldGarden"){
	int currentLevel: "UnityPlayer.dll", 0x01507C68, 0x8, 0x38, 0xA8, 0x58, 0x118, 0x5C;
}

start{
	if(current.currentLevel == 64 && old.currentLevel == -1){
		return true;
	}
}

reset{
	return current.currentLevel == -1;
}

split{
	if(old.currentLevel != current.currentLevel){
		return true;
	}
}
