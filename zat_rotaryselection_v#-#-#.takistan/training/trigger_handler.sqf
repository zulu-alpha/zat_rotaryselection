params ["_exercise", "_trigger", "_heli"];

// Run only on user machines
if !(local _heli) exitwith {};

// Run only on the pilot's machine
if !(player == driver _heli) exitwith {};

_heli setVariable ["exercise", _exercise, true];
_heli setVariable ["trigger", _trigger, true];

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

// Send to correct handler, based on the exercise
switch (_exercise) do {
    case "Precision": {
        call _fnc_cleanup_control;
        call _fnc_cleanup_lz1;
        call _fnc_cleanup_lz2;
        [_heli] execVM "training\precision\precision_handler.sqf";
    };
    case "Control": {
        call _fnc_cleanup_precision;
        call _fnc_cleanup_lz1;
        call _fnc_cleanup_lz2;
        [_heli] execVM "training\control\control_handler.sqf";
    };
    case "LZ-1": {
        call _fnc_cleanup_control;
        call _fnc_cleanup_precision;
        call _fnc_cleanup_lz2;
        [_heli] execVM "training\lz1\lz1_handler.sqf";
    };
    case "LZ-2": {
        call _fnc_cleanup_control;
        call _fnc_cleanup_precision;
        call _fnc_cleanup_lz1;
        [_heli] execVM "training\lz2\lz2_handler.sqf";
    };
    default {};
};