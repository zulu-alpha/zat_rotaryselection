params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_target", "_number"];

_heli = nil;
switch (_target) do {
    case "Heli 1": {_heli = heli_1;};
    case "Heli 2": {_heli = heli_2;};
    default { };
};

[_heli, _number] remoteExec ["zatf_fnc_setHeliPax", 0];
