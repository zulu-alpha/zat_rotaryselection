_heli = _this select 0;
_heli_name = _heli getVariable ["name", ""];
{
    _belongsto = _x getVariable ["belongs_to_heli_crew", ""];
    if (_belongsto == _heli_name) then {
        _heli deletevehicleCrew _x;
        deletevehicle _x;
    };
} forEach allunits;

PAPABEAR = [west, "airbase"];
_str = format["%1 Removed 4 Pax", _heli getVariable ["name", str _heli]];
PAPABEAR sideChat _str;
