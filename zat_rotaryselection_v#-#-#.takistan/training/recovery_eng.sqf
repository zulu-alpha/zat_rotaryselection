params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_target", "_dam"];

_heli = nil;
switch (_target) do {
    case "Heli 1": {_heli = heli_1;};
    case "Heli 2": {_heli = heli_2;};
    default { };
};


if (isEngineOn _heli and _dam == 1) then {
	_heli engineOn false;
};
_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), _dam];

if (!isEngineOn _heli and _dam == 0) then {
    _heli engineOn true;
};
