_heli = _this select 0;

{
    _heli deletevehicleCrew _x;
} forEach crew _heli;

PAPABEAR = [west, "airbase"];
_str = format["%1 Removed 4 Pax", _heli getVariable ["name", str _heli]];
PAPABEAR sideChat _str;