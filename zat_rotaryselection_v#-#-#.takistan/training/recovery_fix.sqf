_target = (_this select 3) select 0;

_heli = nil;
switch (_target) do {
    case "Heli 1": {_heli = heli_1;};
    case "Heli 2": {_heli = heli_2;};
    default { };
};

_heli setDamage 0;
_heli setFuel 1;

{
    [_x] call ace_medical_treatment_fnc_fullHeallocal;
    _x setDamage 0;
} forEach crew _heli;

if (!isEngineOn _heli) then {
    _heli engineOn true;
	_heli setWantedRPMRTD [2200, 0.2, -1];
};

PAPABEAR = [west, "airbase"];
_str = format["%1 repaired, refueled and it's crew healed", _heli getVariable ["name", str _heli]];
PAPABEAR sideChat _str;
