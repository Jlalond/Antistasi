params ["_marker"];

_pos = objNull;
_xMod = 1000;
_yMod = 1000;
_spotNotFound = true;

while{_spotNotFound} do {
	_mrkPos = getMarkerPos _marker;
	_mrkX = _mrkPos select 0;
	_mrkY = _mrkPos select 1;
	_xCoord = random[_mrkX - _xMod, _mrkX, _mrkX + _xMod];
	_yCoord = random[_mrkY - _yMod, _mrkY, _mrkY + _yMod];

	_newPos = [_xCoord, _yCoord];
	_farEnoughFromPlayers = true;
	{
		if(_x distance _newPos < 500) then {
			_farEnoughFromPlayers = false;
		};
	} forEach allPlayers;
	
	if(_farEnoughFromPlayers) then
	{
		_pos = _newPos;
		_spotNotFound = true;
	};
};


_opt = time random 10;
_group = objNull;
if(_opt < 7) then {
	_group = [_pos] call AS_createEnemyInfantryGroup;
} 
else 
{
	_group = [_pos] call AS_createEnemyAirGroup;
};

_group move _pos;
_group setCombatMode "RED";

[_group] spawn AS_dynamicDespawn;
