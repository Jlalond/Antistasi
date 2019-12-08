/* must return cargo vehicle as the first item */
params ["_location"];
_vehicleArr = [];
_vehicle = createVehicle ["rhsgref_ins_g_ural_work_open", _location findEmptyPosition[5, 50]];
_vehicleArr pushBackUnique _vehicle;
_escort = createVehicle [guer_veh_technical, (position _vehicle) findEmptyPosition[10, 50]];
_vehicleArr pushBackUnique _escort;

//return;
_vehicleArr;