params ["_heli"];

// Initialise variables
_exercise = _heli getVariable ["exercise", ""];
_trigger = _heli getVariable ["trigger", ""];
_isStarted = _heli getVariable ["lz1IsStarted", false];
_lzLanded = _heli getVariable ["lz1Landed", false];
_driver = name (driver _heli);
_copilot = _heli turretUnit [0];
_copilot_name = name _copilot;

if (!(isPlayer _copilot)) then {
    _copilot_name = "";
};

PAPABEAR = [west, "airbase"];

// Play a sound n number of times
_fnc_play_sound = {
	params ["_sound", "_count"];
	for "_i" from 1 to _count do {
		playSound3D [_sound, player];
		sleep 1;
	};
};

_fnc_set_pax = {
    params ["_n"];
    [_heli, _n] remoteExec ["zatf_fnc_setHeliPax", 0];
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
	["a3\sounds_f\air\Heli_Light_01\warning.wss", 1] call _fnc_play_sound;
};

_fnc_get_scores = {
	_time = _heli getVariable ["timer_value", 0];
	_damage = _heli getVariable ["damage", 0.0];
	_crew_damage = _heli getVariable ["crew_damage", 0.0];
	_entry_speed = _heli getVariable ["lz1EntrySpeed", 0.0];

	// Set result to 0 (failed)
	_result = 0;

	private _formattedTime = [_time, "MM:SS.MS"] call BIS_fnc_secondstoString;
	titleText [_formattedTime, "PLAIN", 0.5];

	if (_damage == 0.0 and _crew_damage == 0.0 and _entry_speed >= 190 and _entry_speed <= 210) then {

		// Normal Pass
		if (_time <= 73 and _time > 63) then {
			["TaskSucceeded", ["Success","You passed this exercise.", 10]] call BIS_fnc_showNotification;
			_result = 1;
		};

		// Merit Pass
		if (_time <= 63) then {
			["TaskSucceeded", ["Merit","Congratulations, you passed this exercise with merit!", 10]] call BIS_fnc_showNotification;		
			_result = 2;
		};

		// Time Fail
		if (_time > 73) then {
			["TaskFailed", ["Fail","Exercise failed. You must complete the exercise within 01:13", 10]] call BIS_fnc_showNotification;		
		};
	};

	// Damage fail
	if (_damage > 0.0 or _crew_damage > 0.0) then {
		["TaskFailed", ["Fail","Exercise failed. No crew or airframe damage allowed.", 10]] call BIS_fnc_showNotification;
	};

	// Entry speed fail
	if (_entry_speed > 210 or _entry_speed < 190) then {
		["TaskFailed", ["Fail","Exercise failed. Your entry speed must be within 10Km/h of 200Km/h.", 10]] call BIS_fnc_showNotification;
	};

	// Set score text
	[_heli, _exercise, _driver, _copilot_name, _time, 4, _damage, _crew_damage, _entry_speed, _result] remoteExec ["zatf_fnc_setScoreHeli", 0];
	
	sleep 5;
	// Add score to player's task list
	["TaskUpdated", ["Score", _heli getVariable ["scoreText", ""], 1]] call BIS_fnc_showNotification;
};

// Start trigger
if (_trigger == "ip_1_trigger") then {
	if (!_isStarted) then {
		_heli setVariable ["scoreText", "", true];
		_speed = speed _heli;
		call _fnc_start_timer;
		_heli setVariable ["lz1EntrySpeed", _speed, true];
		_heli setVariable ["lz1IsStarted", true, true];
		_heli setVariable ["lz1Landed", false, true];
		_heli setVariable ["start_speed_text", format ["<br/>Entry speed: <t color='#ffff00'>%1 Km/h</t>", _speed], true];
		[6] call _fnc_set_pax;
	};
};

// Landing trigger
if (_trigger == "lz_1_trigger") then {
	if (_isStarted) then {
		_heli setVariable ["lz1Landed", true, true];
		[2] call _fnc_set_pax;
	};

	if (!_isStarted) then {
		titleText ["You must start the exercise by flying through the target at IP-1 first!", "PLAIN", 0.5];
	};
};

// End trigger
if (_trigger == "ep_1_trigger") then {
	if (_isStarted and _lzLanded) then {
		_heli setVariable ["timer_running", false, true];
		_heli setVariable ["lz1IsStarted", false, true];
		
		// Play sound
		["a3\sounds_f\air\Heli_Light_01\warning.wss", 1] call _fnc_play_sound;
		call _fnc_get_scores;
		call _fnc_cleanup_heli;
	};

	if (_isStarted and !_lzLanded) then {
		titleText ["You must land at LZ-1 first!", "PLAIN", 0.2];
	};

	if (!_isStarted) then {
		titleText ["You must start the exercise by flying through the target at IP-1 first!", "PLAIN", 0.5];
	};
};
