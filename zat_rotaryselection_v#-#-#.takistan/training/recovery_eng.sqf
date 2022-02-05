params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_heli", "_dam"];

if (isEngineOn _heli and _dam == 1) then {
	_heli engineOn false;
};
_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), _dam];

if (!isEngineOn _heli and _dam == 0) then {
    sleep 1;
    _heli engineOn true;
};
