params ["_heli"];

// initialise variables
_exercise = _heli getVariable ["exercise", ""];
_trigger = _heli getVariable ["trigger", ""];
_isStarted = _heli getVariable ["controlIsStarted", false];
_driver = name (driver _heli);
_copilot = _heli turretUnit [0];
_copilot_name = name (_copilot);

if (!isPlayer _copilot) then {
    _copilot_name = "";
};


// Heli Pads
_pos1 = _heli getVariable ["controlPos1", false];
_pos2 = _heli getVariable ["controlPos2", false];
_pos3 = _heli getVariable ["controlPos3", false];
_pos4 = _heli getVariable ["controlPos4", false];

PAPABEAR = [west, "airbase"];

_fnc_set_pax = {
    params ["_n"];
    [_heli, _n] remoteExec ["zatf_fnc_setHeliPax", 0];
};

_fnc_pax_count = {
	_i = 0;
	{
		if (!isPlayer _x) then {
			_i = _i + 1;
		}
	} forEach crew _heli;
	_i;
};

_fnc_get_scores = {
	private _startTime = _heli getVariable ["control_start_time", 0];
	private _endTime = _heli getVariable ["control_end_time", 0];
	private _time = _endTime - _startTime;
	private _damage = _heli getVariable ["damage", 0.0];
	private _crew_damage = _heli getVariable ["crew_damage", 0.0];
    private _pax = call _fnc_pax_count;

	// Set result to 0 (failed)
	_result = 0;

	if (_damage == 0.0 and _crew_damage == 0.0) then {
		// Normal Pass
        if (_time > 180) then {
            ["TaskSucceeded", ["Success", "You passed this exercise", 10]] call BIS_fnc_showNotification;
            _heli setVariable ["ControlPassed", true, true];
            _result = 1;
        };

        // Merit Pass
        if (_time <= 180) then {
            ["TaskSucceeded", ["Merit", "You passed this exercise with merit!", 10]] call BIS_fnc_showNotification;
            _heli setVariable ["ControlPassed", true, true];
            _heli setVariable ["ControlPassedWithMerit", true, true];
            _result = 2;
        };
	} else {
	    // Damage fail
		["TaskFailed", ["Fail","Exercise failed. No crew or airframe damage allowed.", 10]] call BIS_fnc_showNotification;
    };

    // Set score text
	[_heli, _exercise, _driver, _copilot_name, _time, _pax, _damage, _crew_damage, 0, _result] remoteExec ["zatf_fnc_setScoreHeli", 0];
	
    sleep 5;
	// Add score to player's task list
	["TaskUpdated", ["Score", _heli getVariable ["scoreText", ""], 1]] call BIS_fnc_showNotification;
};

// Play a sound n number of times
_fnc_play_sound = {
	params ["_sound", "_count"];
	for "_i" from 1 to _count do {
		playSound3D [_sound, player];
		sleep 1;
	};
};

_fnc_cleanup_heli = {
	[1] call _fnc_set_pax;
};

_fnc_start_timer = {
    _current_time = if (isMultiplayer) then {
        servertime
    } else {
        diag_ticktime
    };
	_heli setVariable ["time_start", _current_time, true];
    _heli setVariable ["timer_running", true, true];
	["a3\missions_f_oldman\data\sound\beep.ogg", 1] call _fnc_play_sound;   
};

// LZ trigger
if ((_trigger == "LZ1" or _trigger == "LZ2" or _trigger == "LZ3" or _trigger == "LZ4") and _isStarted) then {

	switch (_trigger) do {
		case "LZ1": { if (!_pos1) then { call _fnc_start_timer;};};
		case "LZ2": { if (!_pos2) then { call _fnc_start_timer;};};
		case "LZ3": { if (!_pos3) then { call _fnc_start_timer;};};
		case "LZ4": { if (!_pos4) then { call _fnc_start_timer;};};
		default { };
	};
};

// Start Trigger
if (_trigger == "Start" and !_isStarted) then {
    // Add pax if needed
    [2] call _fnc_set_pax;

    // Stop the timer if it was running
    _heli setVariable ["timer_running", false, true];
    _heli setVariable ["timer_value", 0, true];
    // _heli setVariable ["scoreText", "", true];

    // Wait to give player a chance to settle before starting round
    sleep 2;

    // notify player to start with on-screen text and audible beep
    titleText ["START!", "PLAIN", 0.2];
    ["a3\sounds_f\air\Heli_Attack_02\alarm.wss", 1] call _fnc_play_sound;

    // Update variables
    _heli setVariable ["controlIsStarted", true, true];
    _heli setVariable ["controlPos1", false, true];
    _heli setVariable ["controlPos2", false, true];
    _heli setVariable ["controlPos3", false, true];
    _heli setVariable ["controlPos4", false, true];

    // Get the current time
    _start_time = if (isMultiplayer) then {
        servertime
    } else {
        diag_ticktime
    };

    // set the time to start the round
    _heli setVariable ["control_start_time", _start_time, true];

    // notify side chat of player start
    _chattext = format ["%1 Control Exercise Started!", _driver];
    PAPABEAR sideChat _chattext;
    sleep 5;
};

// End Trigger
if (_trigger == 'End' and _isStarted) then {
    // if all landings are completed
    if (_pos1 and _pos2 and _pos3 and _pos4) then {
        // Get the end time
        _end_time = if (isMultiplayer) then {
            servertime
        } else {
            diag_ticktime
        };

        _heli setVariable ["controlIsStarted", false, true];
        _heli setVariable ["control_end_time", _end_time, true];

        // Show round end to player
        titleText ["Exercise Completed!", "PLAIN", 0.2];

        // Show task complete to side chat
        _chattext = format ["%1 Control Exercise Completed!", _driver];
        PAPABEAR sideChat _chattext;

        call _fnc_get_scores;
        call _fnc_cleanup_heli;
    };
};
