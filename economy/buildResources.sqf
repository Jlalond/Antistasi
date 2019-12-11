server setVariable["convoyScriptRunning", true];
while {true} do {
	sleep 60;
	
	"Resource Convoys Dispatched" remoteExec ["hint", -2];
	_hqMarkerPos = getMarkerPos "FIA_HQ";
	_factories = fabricas - mrkAAF;
	{ 
		_randomNumOfIterations = random[1, 1, 3];
		_cargoArr = [];
		for "_j" from 0 to _randomNumOfIterations do {
			_randomAmount = random [1, 2, 5]; 
			_weapon = allWeapons call BIS_fnc_selectRandom;
			_magazines = getArray (configFile / "CfgWeapons" / _weapon / "magazines");
			_magCount = 10 * _randomAmount;
			for "_i" from 0 to _randomAmount do {
				_cargoArr pushBack _weapon;
			};
		};
		[_cargoArr, getMarkerPos _x] call AS_shipArray;
	} forEach _factories;

	_ports = puertos - mrkAAF;
	{ 
		_randomNumOfIterations = random[3, 5, 7];
		_armorArr = [];
		for "_j" from 0 to _randomNumOfIterations do {
			
			_randomAmount = random [1, 2, 5]; 
			_randomArmor = armorItems call BIS_fnc_selectRandom;
			for "_i" from 0 to _randomAmount do {
				_armorArr pushBack _randomArmor;
			};
		};
		[_armorArr, getMarkerPos _x] call AS_shipArray;
	} forEach _ports;

	_resources = recursos - mrkAAF;
	{
		_itemArr = [];
		_randomNumOfIterations = random[1, 1, 3];
		for "_j" from 0 to _randomNumOfIterations do {
			_randomAmount = random [1, 2, 5]; 
			_randomItem = allItems call BIS_fnc_selectRandom;
			for "_i" from 0 to _randomAmount do {
				_itemArr pushBack _randomItem;
			};
		};
		_markerPos = getMarkerPos _x;
		[_itemArr, _markerPos] call AS_shipArray;
	} forEach _resources;

	
	_text = format ["Should see more resources at about %1 minutes" , 60];
	_text remoteExec ["hint", -2];
};
