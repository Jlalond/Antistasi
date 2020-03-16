params ["_crate"];
_fiaSkill = server getVariable ["skillFIA",0];

_itemsToDeposit = [];
_randomSum = random[20, 101];
_multiple = _fiaSkill mod 5;
_temp = _randomSum * _multiple;
while {_temp > 0} do {
	_option = random[0, 3];
	// 1 give ace stuff
	// 2 give weapons
	// 3 give armor
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
		for "_i" from 0 to _total do
		{
			_item = producableAceItems call BIS_fnc_selectRandom;
			_crate addItemCargoGlobal[_item, 20];
		};
	}
	else if(_option == 1) then
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

		_crate addItemCargoGlobal[_weapon, random[1, 5]];
		_magazines = getArray (configFile / "CfgWeapons" / _weapon / "magazines");
		_crate addMagazineCargoGlobal [_magazines select 0, random[6, 15]];
	}
}