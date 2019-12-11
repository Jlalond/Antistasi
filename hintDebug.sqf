params["_text"];

_debugEnabled = server getVariable["debugEnabled", false];
if(_debugEnabled) then 
{
	_text remoteExec["hint", -2];
};