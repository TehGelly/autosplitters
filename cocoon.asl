state("universe")
{
	int percentage : "UnityPlayer.dll", 0x01A68008, 0x28, 0x20, 0xB8, 0x158, 0x20, 0x20, 0x10;
}

startup {
	//vars.percDict = new Dictionary<int, int>();
	int[] literlPercs = { 0, 2, 3, 5, 6, 8,10,11,13,14,16,17,19,21,22,24,25,27,29, 30, 32, 33, 35, 37, 38, 40, 41, 43, 44, 46, 48, 49, 51, 52, 54, 56, 57, 59, 60, 62, 63, 65, 67, 68, 70, 71, 73, 75, 76, 78, 79, 81, 83, 84, 86, 87, 89, 90, 92, 94, 95, 97, 98,100};
	vars.litPercs = literlPercs;
	int[] memoryPercs = {10,20,27,40,42,45,50,52,55,57,60,70,71,80,90,91,93,94,96,100,110,113,120,130,131,133,136,138,140,142,148,150,152,154,160,170,172,174,175,176,180,190,195,197,199,200,210,211,215,216,220,223,230,233,235,238,250,260,263,280,281,284,290,300};
	vars.memPercs = memoryPercs;
	vars.speciallyPercentally = new Dictionary<int, String>()
	{
		{16, "(Boss 1)"},
		{30, "(Boss 2)"},
		{54, "(Boss 3)"},
		{71, "(Boss 4)"},
		{79, "(Final 1)"},
		{83, "(Final 2)"},
		{90, "(Final 3)"}
	};
	settings.Add("pcenties", true, "Percentaroonies");
	settings.SetToolTip("pcenties", "Choose which percentaroni to split on.");
	String tmp = "";
	for(int i = 0; i < vars.litPercs.Length; i++){
		int lp = vars.litPercs[i];
		int mp = vars.memPercs[i];
		settings.Add(mp.ToString(), 
		true, 
		String.Format("{0}% {1}" , lp,(vars.speciallyPercentally.TryGetValue(lp, out tmp) ? tmp : "")), 
		"pcenties");
	}
	
	//i think i'm overcomplicating the current best percentage shit
	vars.best_perc = 0;
	//i don't know how to access OnReset this is so beyond my paygrade dude
	//OnReset += (s,e) => vars.best_perc = 0;
}

init
{
}

update
{
	//print(current.percentage.ToString());
}

start
{
	if((old.percentage == 10) && (current.percentage == 20)){
		vars.best_perc = 20;
		return true;
	}
}

split
{
	//check if it's increased and the current memory value is a percentage split and if we haven't reached it before and the tickbox it set to split on this.
	if(old.percentage < current.percentage 
	&& (Array.IndexOf(vars.memPercs,current.percentage) != -1) 
	&& vars.best_perc < current.percentage
	&& settings[current.percentage.ToString()]){
		vars.best_perc = current.percentage;
		return true;
	}
}

