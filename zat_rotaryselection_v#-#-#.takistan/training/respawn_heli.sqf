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
_heli setVariable ["timer_value", 0, true];
_heli setVariable ["start_speed_text", "", true];
_heli setVariable ["timer_text", "", true];
_heli setVariable ["exercise", "", true];

private _dsHelis = [
    "Heli 1",
    "Heli 2"
];

private _trainingHelis = [
    "Heli 3", 
    "Heli 4",
    "Heli 5",
    "Heli 6",
    "Heli 7",
    "Heli 8"
];

if (_name in _dsHelis) then {
    [_heli, [0,"a3\air_f\heli_light_01\data\skins\heli_light_01_ext_vrana_co.paa"]] remoteExec ["setObjectTextureGlobal", 0, true];
};

if (_name in _trainingHelis) then {
    [_heli, [0,"a3\air_f\heli_light_01\data\skins\heli_light_01_ext_light_co.paa"]] remoteExec ["setObjectTextureGlobal", 0, true];
};

[_heli, ["Repair", "training\recovery_fix.sqf", [_heli], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Disable Engine", "training\recovery_eng.sqf", [_heli,1], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Disable Tail Rotor", "training\recovery_tail.sqf", [_heli,1], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Add Pax", "training\set_pax.sqf", [_heli,6], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Remove Pax", "training\set_pax.sqf", [_heli,1], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Start Timer", "training\session_timer.sqf", [_heli,"start"], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Stop Timer", "training\session_timer.sqf", [_heli,"stop"], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];
[_heli, ["Reset Exercise", "training\reset_exercise.sqf", [_heli], 1.5, true, true, "", "!(isNull objectParent player)", 5]] remoteExec ["addAction",0, true];

call _fnc_cleanup_control;
call _fnc_cleanup_precision;
call _fnc_cleanup_lz1;
call _fnc_cleanup_lz2;
