// _target = (_this select 3) select 0;
params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_target"];

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
};

PAPABEAR = [west, "airbase"];
_str = format["%1 repaired, refueled and it's crew healed", _heli getVariable ["name", str _heli]];
PAPABEAR sideChat _str;
