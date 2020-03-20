params["_group"];

_startTime = diag_tickTime;
_maxTime = 600;
while{true} do
{
	_unit = leader _group;
	_farEnoughFromAll = true;
	{
		if(_unit distance _x < 800) then
		{
			_farEnoughFromAll = false;
		};
	} forEach allPlayers;

	if(_farEnoughFromAll) exitWith {
		{
			// it would delete the vehicle x is in, then again.
			deleteVehicle _x;
			if(objNull != _x) then 
			{
				deleteVehicle _x;
			};
		} forEach units _group;
	};

	if(diag_tickTime > _startTime + _maxTime) exitWith 
	{
		_pos = getPos leader _group;
		_newPos = [_pos + time random[-2000, 2000], _pos + time random[-2000, 2000]];
		_group move _newPos;
		waitUntil 
		{
			_unit = leader _group;
			_farEnoughFromAll = true;
			{
				if(_unit distance _x < 800) exitWith {false};
			} forEach allPlayers;
		};

				{
			// it would delete the vehicle x is in, then again.
			deleteVehicle _x;
			if(objNull != _x) then 
			{
				deleteVehicle _x;
			};
		} forEach units _group;
	};

	sleep 30;
};
