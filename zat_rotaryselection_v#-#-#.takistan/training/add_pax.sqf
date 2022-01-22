_heli = _this select 0;

if !(local _heli) exitwith {};
// Probably not needed as idempotent?

// Get current number of cargo units
_cargo_count = count crew _heli;

_payload_count = 6 - _cargo_count;

if (_payload_count > 0) then {
    _group = creategroup west;
    for [{
        _i = 0
    }, {
        _i < _payload_count
    }, {
        _i = _i + 1
    }] do {
    _x = _group createUnit ["B_Soldier_F", [0, 0, 0], [], 0, "NONE"];
    // [_x] call zamf_fnc_disableAI;
};

{
    _x assignAsCargo _heli;
    _x moveInCargo [_heli, _forEachindex + 2];
} forEach units _group;
_group;

PAPABEAR = [west, "airbase"];
_str = format["%1 added %2 Pax", _heli getVariable ["name", str _heli], _payload_count];
PAPABEAR sideChat _str;
};