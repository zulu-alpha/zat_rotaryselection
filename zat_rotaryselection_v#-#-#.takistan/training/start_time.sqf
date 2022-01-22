params ["_timer_exercise", "_timer_target_heli"];

if !(local _timer_target_heli) exitWith {};

_timer_target_heli setVariable ["timer_exercise", _timer_exercise, true];

_current_time = if (isMultiplayer) then {serverTime} else {diag_ticktime};
_timer_target_heli setVariable ["time_start", _current_time, true];
_timer_target_heli setVariable ["timer_running", true, true];
_start_speed = speed _timer_target_heli;
_timer_target_heli setVariable [
	"start_speed_text",
	format ["<br/>Entry Speed: %1 Km/h", _start_speed],
	true
];
