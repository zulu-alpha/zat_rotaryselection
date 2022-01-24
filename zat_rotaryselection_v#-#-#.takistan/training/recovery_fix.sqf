_heli = _this select 0;

_heli setdamage 0;
_heli setfuel 1;

{
	[_x] call ace_medical_treatment_fnc_fullHealLocal;
	_x setdamage 0;
} foreach crew _heli;

 PAPABEAR = [West, "airbase"];
 _str = format["%1 repaired, refuled and it's crew healed", _heli getVariable ["name", str _heli]];
 PAPABEAR SideChat _str;
 