private ["_posHQ"];
_posHQ = getMarkerPos guer_respawn;
waitUntil {repairRunning == false};
repairRunning = true;
publicVariable "repairRunning";
{
	if (((side _x == side_blue) OR (side _x == civilian)) AND (_x distance _posHQ < 100)) then {
		if (activeACEMedical) then {
			[_x, _x] call ace_medical_fnc_treatmentAdvanced_fullHeal;
    	} else {
      		_x setDamage 0;
		};
	};
} forEach allUnits;

{if ((side _x == side_blue) AND (_x distance _posHQ < 30)) then {_x setVariable ["compromised",0];}} forEach (allPlayers - entities "HeadlessClient_F");


{
	if (_x distance _posHQ < 100 AND {alive _x}) then {
		 reportedVehs = reportedVehs - [_x];
		_x setDamage 0;
		if(fuel _x < 0.005) then {_x setFuel 0.005};
		if(count (weapons _x) > 1) then {
			if(heavy_weapon_ammo > 0) then
			{
				heavy_weapon_ammo = heavy_weapon_ammo - 1;
				[_x,1] remoteExec ["setVehicleAmmo",_x];
			} 
			else
			{
				hint format ["Not enough heavy weapon ammo to rearm %1" className _x];
			}
		}
		else
		{
			[_x,1] remoteExec ["setVehicleAmmo",_x];
		};
	};
} forEach vehicles;

publicVariable "heavy_weapon_ammo";
repairRunning = false;
publicVariable "repairRunning";

publicVariable "reportedVehs";

hint localize "STR_HINTS_HNR_ALL";