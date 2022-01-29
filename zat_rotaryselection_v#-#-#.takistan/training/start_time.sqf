params ["_exercise", "_heli"];

if !(local _heli) exitwith {};

playSound3D ["a3\sounds_f\air\Heli_Light_01\warning.wss", _heli, true, _heli, 1, 1, 5, 0, false];

_heli setVariable ["exercise", _exercise, true];

_current_time = if (isMultiplayer) then {
    servertime
} else {
    diag_ticktime
};
_heli setVariable ["time_start", _current_time, true];
_heli setVariable ["timer_running", true, true];

// if (_exercise == "LZ-1" || _exercise == "LZ-2") then {
// 	_start_speed = speed _heli;
// 	_heli setVariable [
// 		"start_speed_text",
// 		format ["<br/>Entry speed: <t color='#ffff00'>%1 Km/h</t>", _start_speed],
// 		true
// 	];
// }
