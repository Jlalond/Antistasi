params ["_pos"];

_group = createGroup east;
_fiaSkill = server getVariable["skillFIA", 1];
_csatPrestiege = server getVariable["prestigeCSAT", 1];

_severity = random [0, _csatPrestiege max _fiaSkill, _csatPrestiege];

while {_severity > 0} do {
	_opt = time random 3;
	if(_opt == 1) then {
		_sum = time random _csatPrestiege;
		for "_i" from 0 to _sum do {
			_type = opInfantryTypes call BIS_fnc_selectRandom;
			_group createUnit [_type, [_pos, 0, 100] call BIS_fnc_findSafePos];
		};
	};

	if(_opt == 2) then {
		_veh = createVehicle [opIFV call BIS_fnc_selectRandom, [_pos, 0, 200] call BIS_fnc_findSafePos];
		_group addVehicle _veh;
	}
	else
	{
		_veh = createVehicle [opArtillery, [_pos, 0, 200] call BIS_fnc_findSafePos];
		_group addVehicle _veh;
	};

	
	_severity = _severity - 10;
};

// we need to return the group reference.
_group;