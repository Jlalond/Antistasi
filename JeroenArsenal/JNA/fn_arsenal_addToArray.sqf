/*
By: Jeroen Notenbomer
Add amounts of same name togetter
Use amount (-1) to set to unlimited
Inputs:
1: list [name1",amount1],name2",amount2]]
2: item "name1" or name1",amount1] or [name1",amount1],name2",amount2]]
Outputs
list = Input1+Input2
*/
params["_list","_add"];
_list = +_list;
if(typeName _add isEqualTo "STRING")then{_add = [_add,1];};
if(typeName (_add select 0) isEqualTo "STRING")then{_add = [_add]};
{
private _index = _forEachIndex;
private _name = _x select 0;
private _amount = _x select 1;
if!(_name isEqualTo "")then{//skip empty
private _found = false;
private _unlockCount = 8;
//uses indices from gearList.sql
switch (_name call jn_fnc_arsenal_itemType) do {
//customize count per arsenal category here:
case 0: {_unlockCount = 12000}; // primary
case 1: {_unlockCount = 12000}; // secondary
case 2: {_unlockCount = 12000}; // handgun
case 3: {_unlockCount = 12000}; // uniform
case 4: {_unlockCount = 12000}; // vest
case 5: {_unlockCount = 12000}; // backpack
case 6: {_unlockCount = 12000}; // helmet
case 7: {_unlockCount = 12000}; // goggle
case 8: {_unlockCount = 12000}; // nightvision
case 9: {_unlockCount = 12000}; // binocular
case 10: {_unlockCount = 1}; // map
case 11: {_unlockCount = 1}; // gps
case 12: {_unlockCount = 1}; // radio
case 13: {_unlockCount = 1}; // compass
case 14: {_unlockCount = 1}; // watch
case 18: {_unlockCount = 12000}; // optic
case 19: {_unlockCount = 12000}; // muzzle
case 20: {_unlockCount = 12000}; // accessory
case 21: {_unlockCount = 12000}; // bipod
case 22: {_unlockCount = 10000}; // grenade
case 23: {_unlockCount = 10000}; // mine
case 24: {_unlockCount = 10000}; // misc
case 26: {_unlockCount = 12000}; /* ammunition (50 means 50 bullets, not 50 magazines.
Alter with care, because also (single-piece-counted) launcher missles are affected by this)*/
default {_unlockCount = 12000}; // default value for everything else; should not be needed, just to be sure
};
{
private _index2 = _forEachIndex;
private _name2 = _x select 0;
private _amount2 = _x select 1;
if(_name isEqualTo _name2)exitWith{
_found = true; //found it, now update amount
if(_amount == -1 || _amount2 == -1)then{ //stays unlocked
_list set [_index2, [_name,-1]];
}else{
if((_amount + _amount2) >= _unlockCount)then{
_list set [_index2, [_name,-1]]; //unlock
}else {
_list set [_index2, [_name,(_amount2 + _amount)]];
}
};
};
}forEach _list;
if(!_found)then{
if(_amount >= _unlockCount)then { //unlock
_amount = -1;
};
_list pushBack [_name, _amount]; //not found add new
};
};
}forEach _add;
_list; //return