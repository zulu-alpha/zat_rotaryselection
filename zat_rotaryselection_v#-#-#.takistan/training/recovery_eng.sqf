_target = (_this select 3) select 0;
_dam = (_this select 3) select 1;

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
	_heli setWantedRPMRTD [2200, 0.2, -1];
};