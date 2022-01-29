params ["_heli"];

if !(local _heli) exitwith {};

_heli setVariable ["timer_running", false, true];
playSound3D ["a3\sounds_f\air\Heli_Attack_02\alarm.wss", _heli, true, _heli, 1, 1, 5, 0, false];