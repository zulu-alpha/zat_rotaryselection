params ["_heli"];

// Clean up exercise variables
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

if (_heli getVariable ["exercise", ""] != "") then {
	private _exercise = _heli getVariable ["exercise", ""];
	PAPABEAR = [west, "airbase"];

	switch (_exercise) do {
		case "LZ-1": { call _fnc_cleanup_lz1; };
		case "LZ-2": { call _fnc_cleanup_lz2; };
		case "Control": { call _fnc_cleanup_control; };
		case "Precision": { call _fnc_cleanup_precision; };
		default { };
	};

	_chattext = format ["%1 %2 Exercise Reset!", name (driver _heli), _exercise];
    PAPABEAR sideChat _chattext;
};