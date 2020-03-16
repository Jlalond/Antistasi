if(!isServer) exitWith{true};

_artilleryRounds = ["Sh_82mm_AMOS"];

waitUntil {server getVariable["prestigeCSAT", 0] > 50};
_intervalAmount = (5 * 60);
while{true} do {
	sleep _intervalAmount;

	_players = []; 
	{  
		if(((_x distance (getMarkerPos "FIA_HQ")) > 100) && (!(captive _x))) then { 
			_players pushBack _x; 
		}; 
	} forEach allPlayers; 

	if(count _players > 0) then {
		sleep 20;
		_targetPlayer = position _players call BIS_fnc_selectRandom;
		_target = [_targetPlayer select 0 + random [50, 500], _targetPlayer select 1 + random[50, 500]]; 
		_roundType = _artilleryRounds call BIS_fnc_selectRandom;
		_radius = random [200, 500];
		_roundNum = random 5;
		[_target, _roundType, _radius, _roundNum, 10] spawn BIS_fnc_fireSupportVirtual;
		_intervalAmount = 600; // check again in 10 minutes
	} else {
		_intervalAmount = 60; // check again in 1 minute.
	};

};
