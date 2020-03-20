if(!isServer) exitWith {};

while{true} do {
	_mrker = objNull;
	waitUntil
	{
		{
			_mrker = _x;
			_count = 0;
			{
				if(_x distance _mrker < 1100 && !(captive _x)) then 
				{
					_count = _count + 1;
				};

				if(_count > (count allPlayers / 4)) exitWith {true};
			} forEach allPlayers;
		} forEach mrkAAF;
	};

	[_mrker] call AS_dynamicEnemyResponse;

	_vmf = server getVariable["prestigeCSAT", 1];
	sleep (random [60, 500, 1000 - (_vmf * 25)]);
};