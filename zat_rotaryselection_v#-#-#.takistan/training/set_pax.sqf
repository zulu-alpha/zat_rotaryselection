_target = (_this select 3) select 0;
_number = (_this select 3) select 1;

_heli = nil;
switch (_target) do {
    case "Heli 1": {_heli = heli_1;};
    case "Heli 2": {_heli = heli_2;};
    default { };
};

[_heli, _number] remoteExec ["zatf_fnc_setHeliPax", 0];
