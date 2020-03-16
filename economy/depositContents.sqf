// 10 minutes
params ["_veh"];
_group = group (driver _veh);
_interval = diag_tickTime + (10 * 60);
_hqMarker = getMarkerPos "FIA_HQ";
waitUntil { (_veh distance _hqMarker < 40) || (time > _interval)};
if(_veh distance _hqMarker < 40) then
{
	_hqitemCrate = server getVariable["hqItemCrate", objNull];
			
	if(isNull _hqitemCrate) then {
		_hqitemCrate = createVehicle ["I_CargoNet_01_ammo_F", _hqMarker findEmptyPosition[0, 40]];
		_hqitemCrate call emptyCrate; 
		server setVariable["hqItemCrate", _hqitemCrate];
	};
	
	_distance = getPos _hqitemCrate distance _hqMarker;
	if(_distance > 50) then {
		_hqitemCrate setPos (_hqMarker findEmptyPosition[0, 40]);
		publicVariable "hqItemCrate";
	};

	[_hqitemCrate] call AS_depositShippedItems;
	
	"Some resources have been left at the base" remoteExec ["hint", -2]; 
};

_units = units driver _veh;
_units apply {deleteVehicle vehicle _x};
// twice, as units are vehicles, this will delete the vehicle they're in, then them.
_units apply {deleteVehicle _x};
