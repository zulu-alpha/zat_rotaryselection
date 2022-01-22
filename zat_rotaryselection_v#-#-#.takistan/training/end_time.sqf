params ["_timer_target_heli"];

if !(local _timer_target_heli) exitwith {};

_timer_target_heli setVariable ["timer_running", false, true];
playSound3D ["a3\sounds_f\air\Heli_Attack_02\alarm.wss", player];