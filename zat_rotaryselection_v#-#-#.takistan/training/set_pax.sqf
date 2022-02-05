params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_heli", "_number"];

[_heli, _number] remoteExec ["zatf_fnc_setHeliPax", 0];
