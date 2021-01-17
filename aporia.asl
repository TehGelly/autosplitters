state("Aporia")
{
	int loading: "CryRenderD3D11.dll", 0x3C88A8, 0xC8, 0x0, 0x18, 0xB8, 0x10, 0xB4C;
}

isLoading{
	return current.loading!=2;
}

start{
	return old.loading == 0 && current.loading != 0;
}
