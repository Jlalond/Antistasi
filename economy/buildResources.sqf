// getMarkerPos "FIA_HQ" 
// 30 minutes;
if(!isServer) exitWith {};
_intervalAmount = 10 * 60;
_interval =  _intervalAmount;
_hqMarkerPos = getMarkerPos "FIA_HQ";
hqItemCrate = createVehicle ["I_CargoNet_01_ammo_F", _hqMarkerPos findEmptyPosition[0, 40]];
hqItemCrate call emptyCrate; 
publicVariable "hqItemCrate";
_armorItems = [];
publicVariable "explosives";
_armors = "((configName (_x)) isKindof ['Vest_Camo_Base', configFile >> 'cfgWeapons']) && (getText (_x >> 'author') != 'Bohemia Interactive')" configClasses (configFile >> "cfgWeapons");
allWeapons = lockedWeapons - vanillaWeapons;
publicVariable "allWeapons";
_weapons = allWeapons;
_items = gear_allAccessories  - vanillaAccessories;  
_armorItems = _armors apply {configName _x};
_armorItems;
while {true} do {
		waitUntil { time > _interval };
			"Resource Convoys Dispatched" remoteExec ["hint", -2];
			_hqMarkerPos = getMarkerPos "FIA_HQ";
			if(isNull hqItemCrate) then {
				hqItemCrate = createVehicle ["I_CargoNet_01_ammo_F", _hqMarkerPos findEmptyPosition[0, 40]];
				hqItemCrate call emptyCrate; 
				publicVariable "hqItemCrate";
			};
			_distance = getPos hqItemCrate distance _hqMarkerPos;
			if(_distance > 50) then {
				hqItemCrate setPos (_hqMarkerPos findEmptyPosition[0, 40]);
				publicVariable "hqItemCrate";
			};
			
			_factories = fabricas - mrkAAF;
			{ 
				_randomNumOfIterations = random[1, 1, 3];
				_cargoArr = [];
				for "_j" from 0 to _randomNumOfIterations do {
					_randomAmount = random [1, 2, 5]; 
					_weapon = lockedWeapons call BIS_fnc_selectRandom;
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
					_randomArmor = _armorItems call BIS_fnc_selectRandom;
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
					_randomItem = _items call BIS_fnc_selectRandom;
					for "_i" from 0 to _randomAmount do {
						_itemArr pushBack _randomItem;
					};
				};
				_markerPos = getMarkerPos _x;
				[_itemArr, _markerPos] call AS_shipArray;
			} forEach _resources;

		
		_interval = time + _intervalAmount;
};
