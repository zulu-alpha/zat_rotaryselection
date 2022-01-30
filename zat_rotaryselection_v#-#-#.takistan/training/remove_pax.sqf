_heli = _this select 0;
_heli_name = _heli getVariable ["name", ""];
{
    _belongsto = _x getVariable ["belongs_to", ""];
    if (_belongsto == _heli_name) then {
        _heli deleteVehicleCrew _x;
        deleteVehicle _x;
    };
} forEach allUnits;

PAPABEAR = [west, "airbase"];
_str = format["%1 Removed Pax", _heli getVariable ["name", str _heli]];
PAPABEAR sideChat _str;
