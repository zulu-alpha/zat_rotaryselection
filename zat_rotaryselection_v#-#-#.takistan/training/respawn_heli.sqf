params ["_heli", "_name"];


_fnc_cleanup_control = {
    _heli setVariable ["controlIsStarted", false, true];
    _heli setVariable ["controlPos1", false, true];
    _heli setVariable ["controlPos2", false, true];
    _heli setVariable ["controlPos3", false, true];
    _heli setVariable ["controlPos4", false, true];
    _heli setVariable ["control_start_time", 0, true];
    _heli setVariable ["control_end_time", 0, true];
};

_fnc_cleanup_precision = {
    _heli setVariable ["precisionIsStarted", false, true];
    _heli setVariable ["precisionLapCount", 0, true];
	_heli setVariable ["precisionLandingCount", 0, true];
};

_fnc_cleanup_lz1 = {
    _heli setVariable ["lz1EntrySpeed", 0, true];
	_heli setVariable ["lz1IsStarted", false, true];
	_heli setVariable ["lz1Landed", false, true];
};

_fnc_cleanup_lz2 = {
    _heli setVariable ["lz2EntrySpeed", 0, true];
	_heli setVariable ["lz2IsStarted", false, true];
	_heli setVariable ["lz2Landed", false, true];
};

_heli setVariable ["name", _name, true];
_heli setVariable ["timer_running", false, true];
_heli setVariable ["start_speed_text", "", true];
_heli setVariable ["timer_text", "", true];

_heli addAction ["Repair", "training\recovery_fix.sqf", [_name], 1.5, true, true, "", "!(isNull objectParent player)", 10];
_heli addAction ["Disable Engine", "training\recovery_eng.sqf", [_name,1], 1.5, true, true, "", "!(isNull objectParent player)", 10];
_heli addAction ["Disable Tail Rotor", "training\recovery_tail.sqf", [_name,1], 1.5, true, true, "", "!(isNull objectParent player)", 10];
_heli addAction ["Add Pax", "training\set_pax.sqf", [_name,6], 1.5, true, true, "", "!(isNull objectParent player)", 10];
_heli addAction ["Remove Pax", "training\set_pax.sqf", [_name,1], 1.5, true, true, "", "!(isNull objectParent player)", 10];

call _fnc_cleanup_control;
call _fnc_cleanup_precision;
call _fnc_cleanup_lz1;
call _fnc_cleanup_lz2;

{
    _belongsto = _x getVariable ["belongs_to", ""];
    if (_belongsto == _name) then {
        _heli deletevehicleCrew _x;
        deletevehicle _x;
    };
} forEach allunits;
