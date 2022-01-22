params ["_timer_exercise", "_timer_target_heli"];

if !(local _timer_target_heli) exitwith {};

playSound3D ["a3\sounds_f\air\Heli_Light_01\warning.wss", player];

_timer_target_heli setVariable ["timer_exercise", _timer_exercise, true];

_current_time = if (isMultiplayer) then {
    servertime
} else {
    diag_ticktime
};
_timer_target_heli setVariable ["time_start", _current_time, true];
_timer_target_heli setVariable ["timer_running", true, true];

if (_timer_exercise == "LZ-1" || _timer_exercise == "LZ-2") then {
	_start_speed = speed _timer_target_heli;
	_timer_target_heli setVariable [
		"start_speed_text",
		format ["<br/>Entry speed: <t color='#ffff00'>%1 Km/h</t>", _start_speed],
		true
	];
}
