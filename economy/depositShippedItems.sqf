params ["_crate"];
_fiaSkill = server getVariable ["skillFIA",1];

_text = format["Create: %1, skill FIA: %2", _crate, _fiaSkill];
diag_log _text;
_itemsToDeposit = [];
_randomSum = random [20, 50, 101];
_multiple = _fiaSkill / 5;
_temp = _randomSum * _multiple;
_iterations = 0;
while {_temp > 0} do {
	_option = floor random [0, 1, 4];
	diag_log format ["random value for shipped item selection: %1", _option];
	// 0 give ace stuff
	// 1 give weapons
	// 2 give armor
	_total = 0;
	if(_temp < 20) then
	{
		_total = _temp;
		_temp = 0;
	}
	else
	{
		_total = 20;
		_temp = _temp - 20;
	};

	if(_option == 0) then 
	{
		_item = producableAceItems call BIS_fnc_selectRandom;
		diag_log format ["%1 item selected", _item];
		_crate addItemCargoGlobal[_item, _temp];
	};
	if(_option == 1) then
	{
		_weapon = objNull;
		if(_fiaSkill > 10) then 
		{
			// get any arbitrary weapon
			_weapon = allWeapons call BIS_fnc_selectRandom;
		}
		else 
		{
			_weapon = basicWeapons call BIS_fnc_selectRandom;
		};

		_crate addItemCargoGlobal[_weapon, random[1, 2, 3]];
		_magazines = getArray (configFile / "CfgWeapons" / _weapon / "magazines");
		_crate addMagazineCargoGlobal [_magazines call BIS_fnc_selectRandom, random[6, 8, 15]];
	};
	
	if(_option == 2) then
	{
		_crate addItemCargoGlobal[AllArmors call BIS_fnc_selectRandom, random[1, 1, 2]];
	}
	else
	{
		heavy_weapon_ammo = heavy_weapon_ammo + 1;
		publicVariable "heavy_weapon_ammo";
	};

	_crate addItemCargoGlobal[gear_allAccessories call BIS_fnc_selectRandom, random[0, 1, 2]];
	_iterations = _iterations + 1;
};

diag_log format ["Finished deposit shipped items script ran %1 iterations", _iterations];