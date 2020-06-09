state("PacMan"){
	int loading : "PacMan.exe", 0x3C210C;
	int loading2: "PacMan.exe", 0x2F2A60;
	int level : "PacMan.exe", 0x2E9BB8;
}

isLoading{
	return (current.loading == 0 && current.loading2 == 0 && current.level==0);
}
