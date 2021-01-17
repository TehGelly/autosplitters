state("Aporia")
{
	int loading: "CryRenderD3D11.dll", 0x43D10C;
}

isLoading{
	return current.loading!=0;
}

start{
	return old.loading != 0 && current.loading == 0;
}

split{
	return old.loading == 0 && current.loading != 0;
}
