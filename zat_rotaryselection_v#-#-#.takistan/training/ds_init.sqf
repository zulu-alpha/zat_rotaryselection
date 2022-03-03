params ["_ds"];

// call{null = [_ds, "ds", "DS"] call zamf_fnc_team;
// [_ds, _curator_ds] call zamf_fnc_zeus_ensureUnit;};
// _ds addAction ["",{}];

// {
// 	if !(isNull objectParent _x) then {
// 		private _heli = objectParent _x;
// 		private _menu_txt = format ["Monitor %1 (%2)", name _x, _heli getVariable ["name", ""]];
// 		_ds addAction [_menu_txt, "training\ds_monitor.sqf", [_x]];
// 	};
// } forEach allPlayers;

// _ds addAction ["Heli 1 Repair", "training\recovery_fix.sqf", ["Heli 1"]];
// _ds addAction ["Heli 1 Disable Engine", "training\recovery_eng.sqf", ["Heli 1",1]];
// _ds addAction ["Heli 1 Disable Tail Rotor", "training\recovery_tail.sqf", ["Heli 1",1]];
// _ds addAction ["Heli 1 Add Pax", "training\set_pax.sqf", ["Heli 1",6]];
// _ds addAction ["Heli 1 Remove Pax", "training\set_pax.sqf", ["Heli 1",1]];
// _ds addAction ["Heli 1 Start Timer", "training\session_timer.sqf", ["Heli 1","start"]];
// _ds addAction ["Heli 1 Stop Timer", "training\session_timer.sqf", ["Heli 1","stop"]];
// _ds addAction ["Heli 2 Repair", "training\recovery_fix.sqf", ["Heli 2"]];
// _ds addAction ["Heli 2 Disable Engine", "training\recovery_eng.sqf", ["Heli 2",1]];
// _ds addAction ["Heli 2 Disable Tail Rotor", "training\recovery_tail.sqf", ["Heli 2",1]];
// _ds addAction ["Heli 2 Add Pax", "training\set_pax.sqf", ["Heli 2",6]];
// _ds addAction ["Heli 2 Remove Pax", "training\set_pax.sqf", ["Heli 2",1]];
// _ds addAction ["Heli 2 Start Timer", "training\session_timer.sqf", ["Heli 2","start"]];
// _ds addAction ["Heli 2 Stop Timer", "training\session_timer.sqf", ["Heli 2","stop"]];