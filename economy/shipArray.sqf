params ["_array", "_position"];

_vehicles = [_position] call AS_getCargoConvoy;

_cargoVeh = _vehicles select 0;
_cargoVeh setVehicleLock "LOCKED";
_array apply {_cargoVeh addItemCargoGlobal[_x, 1]};
_group = createGroup [west, true];
_eng = _group createUnit [guer_sol_ENG, _position, [], 0, "FORM"];
_eng moveInDriver _cargoVeh;

if(count _vehicles > 1) then {
	_escort = _vehicles select 1;
	_escort setVehicleLock "LOCKED";
	_driver = _group createUnit [guer_sol_ENG, _position, [], 0, "FORM"];
	_gunner = _group createUnit [guer_sol_ENG, _position, [], 0, "FORM"];
	_driver moveInDriver _escort;
	_gunner moveInGunner _escort;
};

[_cargoVeh] spawn AS_depositContents;
_group setSpeedMode "FULL";
_group setBehaviour "SAFE";
_group move getMarkerPos "FIA_HQ";