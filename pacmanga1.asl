state("PacMan"){
	int loading : "PacMan.exe", 0x3C210C;
}

isLoading{
	return current.loading == 0;
}
