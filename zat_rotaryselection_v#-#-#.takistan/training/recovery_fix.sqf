params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_heli"];

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
