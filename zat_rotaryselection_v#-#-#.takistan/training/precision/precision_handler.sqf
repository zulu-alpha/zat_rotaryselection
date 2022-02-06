params ["_heli"];

// Inilialise variables
_exercise = _heli getVariable ["exercise", ""];
_trigger = _heli getVariable ["trigger", ""];
_lapCount = _heli getVariable ["precisionLapCount", 0];
_isStarted = _heli getVariable ["precisionIsStarted", false];
_landingCount = _heli getVariable ["precisionLandingCount", 0];
_driver = name (driver _heli);
_copilot = _heli turretUnit [0];
_copilot_name = name (_copilot);

if (!isPlayer _copilot) then {
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

_fnc_stop_fail = {
	params ["_reason"];

	// Update variables
	_heli setVariable ["precisionIsStarted", false, true];
	_heli setVariable ["timer_running", false, true];
	_heli setVariable ["precisionLandingCount", 0, true];

	// Clean up heli
	call _fnc_cleanup_heli;

	// Play warning sound 3 times
	["a3\sounds_f\air\Heli_Light_01\warning.wss", 3] call _fnc_play_sound;

	// Show task fail message to player
	["TaskFailed", ["Height", format ["Exercise Failed! Course rule violation: %1", _reason]]] call BIS_fnc_showNotification;

	// Show task fail to side chat
	_chatText = format ["%1 Precision Exercise Failed! Course rule violation: %2", name (driver _heli), _reason];
	PAPABEAR sideChat _chatText;	
};

_fnc_stop_success = {

	// Update variables
	_heli setVariable ["timer_running", false, true];
	_heli setVariable ["precisionIsStarted", false, true];
	
	// Play sound
	["a3\sounds_f\air\Heli_Light_01\warning.wss", 1] call _fnc_play_sound;

	// Show round end to player
	titleText ["Exercise Completed!", "PLAIN", 0.2];

	// Show task complete to side chat
	_chatText = format ["%1 Precision Exercise Completed!", name (driver _heli)];
	PAPABEAR sideChat _chatText;
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
	_time = _heli getVariable ["timer_value", 0];
	_damage = _heli getVariable ["damage", 0.0];
	_crew_damage = _heli getVariable ["crew_damage", 0.0];
	_pax = call _fnc_pax_count;

	// Set result to 0 (failed)
	_result = 0;
	
	private _formattedTime = [_time, "MM:SS.MS"] call BIS_fnc_secondstoString;
	titleText [_formattedTime, "PLAIN", 0.5];
	
	if (_damage == 0.0 and _crew_damage == 0.0) then {

		// Normal Pass
		if (_time <= 220 and _time > 190) then {
			["TaskSucceeded", ["Success","You passed this exercise.", 10]] call BIS_fnc_showNotification;
			_result = 1;
		};

		// Merit Pass
		if (_time <= 190) then {
			["TaskSucceeded", ["Merit","Congratulations, you passed this exercise with merit!", 10]] call BIS_fnc_showNotification;		
			_result = 2;
		};

		// Fail
		if (_time > 220) then {
			["TaskFailed", ["Fail","Exercise failed. You must complete the exercise within 03:40", 10]] call BIS_fnc_showNotification;		
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


// Lap count trigger
if (_trigger == "lap_count_trigger") then {

	// On first pass through gate, reset lap counter and landing count
	if (!_isStarted) then {
		_heli setVariable ["precisionLapCount", 0, true];
		_heli setVariable ["precisionLandingCount", 0, true];
	};

	// Increment lap counter up to 5
	if (_isStarted and _lapCount < 5) then {
		_heli setVariable ["precisionLapCount", (_lapCount + 1), true];
	};
};

// Roof landing trigger
if (_trigger == "roof_landing_trigger") then {

	// Increment landing counter up to 5
	if (_isStarted and _lapCount == (_landingCount + 1) and _landingCount < 5) then {
		_landingCount = _landingCount + 1;
		_heli setVariable ["precisionLandingCount", _landingCount, true];

		// Play alarm sound
		["a3\sounds_f\air\Heli_Attack_02\alarm.wss", 1] call _fnc_play_sound;
		
		// Display lap counter on screen for 2 seconds
		_txt = format ["Landing: %1", _landingCount];
		titleText [_txt, "PLAIN", 0.2];
	};
};

// Altitude trigger
if (_trigger == "altitude_trigger" and _isStarted) then {
	["Altitude Limit Exceeded"] call _fnc_stop_fail;
};

// Shed Landing Zone trigger
if (_trigger == "shed_lz_trigger") then {

	// Start of exercise
	if (!_isStarted and _lapCount == 0) then {
		
		_heli setVariable ["scoreText", "", true];
		// Add pax if needed
		[2] call _fnc_set_pax;
		
		// Wait to give player a chance to settle before starting round
		sleep 1;

		// Notify player to start with on-screen text and audible beep
		titleText ["START!", "PLAIN", 0.2];
		["a3\sounds_f\air\Heli_Attack_02\alarm.wss", 1] call _fnc_play_sound;

		// Update variables
		_heli setVariable ["precisionLapCount", 1, true];
		_heli setVariable ["precisionIsStarted", true, true];

		// Get the current time 
		_current_time = if (isMultiplayer) then {
			servertime
		} else {
			diag_ticktime
		};

		// Update start time variable and start timer
		// This will trigger the monitor.sqf script to start the timer
		_heli setVariable ["time_start", _current_time, true];
		_heli setVariable ["timer_running", true, true];

		// Notify side chat of player start
		_chatText = format ["%1 Precision Exercise Started!", name (driver _heli)];
		PAPABEAR sideChat _chatText;
	};

	// End of exercise
	// Will only fire if 5 laps and 5 landings have been completed
	if (_isStarted and _lapCount >= 5 and _landingCount >= 5) then {
		call _fnc_stop_success;
		call _fnc_get_scores;
		call _fnc_cleanup_heli;
	};
};
