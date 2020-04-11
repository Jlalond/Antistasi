activeACE = !isNil "ace_common_fnc_isModLoaded";
activeACEhearing = false;
activeACEMedical = false;
if (activeACE) then {
	{unlockedItems pushBack _x} foreach ["ACE_EarPlugs","ACE_RangeCard","ACE_Clacker","ACE_M26_Clacker","ACE_DeadManSwitch","ACE_DefusalKit","ACE_MapTools","ACE_Flashlight_MX991","ACE_Sandbag_empty","ACE_wirecutter","ACE_RangeTable_82mm","ACE_EntrenchingTool","ACE_Cellphone","ACE_CableTie","ACE_SpottingScope","ACE_Tripod","ACE_Chemlight_HiWhite","ACE_Chemlight_HiRed"];
	unlockedBackpacks pushBackUnique "ACE_TacticalLadder_Pack";
	unlockedWeapons pushBackUnique "ACE_VMH3";
	{unlockedMagazines pushback _x} foreach ["ACE_HandFlare_White","ACE_HandFlare_Red"];
	genItems = genItems + ["ACE_Kestrel4500","ACE_ATragMX"];

	if ("ACE_Hearing" call ace_common_fnc_isModLoaded) then {
		activeACEhearing = true;
	};
	if ("ACE_Medical" call ace_common_fnc_isModLoaded) then {
		activeACEMedical = true;

		{unlockedItems pushback _x} foreach ["ACE_fieldDressing","ACE_bodyBag"];
	};
};

diag_log "Init: ACE detection done.";