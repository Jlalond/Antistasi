// 10 minutes
params ["_veh"];
_group = group (driver _veh);
_interval = diag_tickTime + (10 * 60);
_hqMarker = getMarkerPos "FIA_HQ";
waitUntil { (_veh distance _hqMarker < 40) || (time > _interval)};
if(_veh distance _hqMarker < 40) then
{
	_arr = itemCargo _veh + weaponCargo _veh + magazineCargo _veh + backpackCargo _veh;
	_weapons = _arr arrayIntersect allWeapons;
	_weapons apply {
		_mag = getArray (configFile / "CfgWeapons" / _x / "magazines");
		_magChoise = _mag call BIS_fnc_selectRandom;
		hqItemCrate addItemCargoGlobal[_magChoise, 10];
	};
	_arr apply {hqItemCrate addItemCargoGlobal[_x, 1]}; 
	for "_i" from 0 to 10 do {
		hqItemCrate addItemCargoGlobal[explosives call BIS_fnc_selectRandom, random [0, 5]]
	};
	"Some resources have been left at the base" remoteExec ["hint", -2]; 
};

_units = units driver _veh;
_units apply {deleteVehicle vehicle _x};
// twice, as units are vehicles, this will delete the vehicle they're in, then them.
_units apply {deleteVehicle _x};
