convoyScriptRunning = true;
publicVariable "convoyScriptRunning";
allWeapons = lockedWeapons - vanillaWeapons;
publicVariable "allWeapons";
_gear = gear_allAccessories - vanillaAccessories;
while {true} do {
	sleep 1800; // 30 min
	publicVariable "allWeapons";
	publicVariable "convoyScriptRunning";
	"Resource Convoys Dispatched" remoteExec ["hint", -2];
	_hqMarkerPos = getMarkerPos "FIA_HQ";

	_allPos = fabricas + puertos + recursos + aeropuertos - mrkAAF;
	_totalCount = count _allPos;
	{ 
		[getMarkerPos _x] call AS_shipArray;
	} forEach _allPos;

	
	_text = format ["%1 convoys dispatched", _totalCount];
	_text remoteExec ["hint", -2];
};
