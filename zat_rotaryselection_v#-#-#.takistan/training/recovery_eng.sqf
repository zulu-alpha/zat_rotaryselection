_heli = _this select 0;
_dam = _this select 1;

if (isEngineOn _heli and _dam == 1) then {
	_heli engineOn false;
};
_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), _dam];

if (!isEngineOn _heli and _dam == 0) then {
    _heli engineOn true;
	_heli setWantedRPMRTD [2200, 1, -1];
};