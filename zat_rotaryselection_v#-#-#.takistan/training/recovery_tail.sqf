params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_heli", "_dam"];

_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitVRotor" >> "name"), _dam];
