params ["_pos"];

_group = createGroup east;
_fiaSkill = server getVariable["skillFIA", 1];
_csatPrestiege = server getVariable["prestigeCSAT", 1];

_severity = random [0, _csatPrestiege max _fiaSkill, _csatPrestiege];

while {_severity > 0} do {
	_opt = time random 2;
	if (_opt == 1) then {
		_veh = createVehicle [opCASFW call BIS_fnc_selectRandom, _pos, [], 0, "FLY"];
		_group addVehicle _veh;
	}
	else 
	{
		_veh = createVehicle [opGunship, _pos, [], 0, "FLY"];
		_group addVehicle _veh;
	};

	_severity = _severity - 10;
};

// return the group
_group;