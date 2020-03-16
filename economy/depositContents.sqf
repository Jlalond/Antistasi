// 10 minutes
params ["_veh"];
_group = group (driver _veh);
_interval = diag_tickTime + (10 * 60);
_hqMarker = getMarkerPos "FIA_HQ";
waitUntil { (_veh distance _hqMarker < 40) || (time > _interval)};
if(_veh distance _hqMarker < 40) then
{
	_hqitemCrate = server getVariable["hqItemCrate", objNull];
			
	if(isNull _hqitemCrate) then {
		_hqitemCrate = createVehicle ["I_CargoNet_01_ammo_F", _hqMarker findEmptyPosition[0, 40]];
		_hqitemCrate call emptyCrate; 
		server setVariable["hqItemCrate", _hqitemCrate];
	};
	
	_distance = getPos _hqitemCrate distance _hqMarker;
	if(_distance > 50) then {
		_hqitemCrate setPos (_hqMarker findEmptyPosition[0, 40]);
		publicVariable "hqItemCrate";
	};
	_arr = itemCargo _veh + weaponCargo _veh + magazineCargo _veh + backpackCargo _veh;
	_weapons = _arr arrayIntersect allWeapons;
	_arr apply 
	{ _magazines = getArray (configFile / "CfgWeapons" / _x / "magazines");
	  _hqitemCrate addItemCargoGlobal[_magazines call BIS_fnc_selectRandom, 10];
	};
	_hqitemCrate addMagazineCargoGlobal[explosiveRounds call BIS_fnc_selectRandom, 10];
	
	_arr apply {_hqitemCrate addItemCargoGlobal[_x, 1]}; 
	"Some resources have been left at the base" remoteExec ["hint", -2]; 
};

_units = units driver _veh;
_units apply {deleteVehicle vehicle _x};
// twice, as units are vehicles, this will delete the vehicle they're in, then them.
_units apply {deleteVehicle _x};
