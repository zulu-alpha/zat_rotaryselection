_heli = _this select 0;
_dam = _this select 1;

_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitVRotor" >> "name"), _dam];
