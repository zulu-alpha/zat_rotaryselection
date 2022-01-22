params ["_timer_target_heli"];

if !(local _timer_target_heli) exitWith {};

_timer_target_heli setVariable ["timer_running", false, true];
