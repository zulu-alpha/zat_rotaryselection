if !(hasInterface) exitwith {};	

// Session timer
_fnc_session_timer = {
    params ["_heli"];
    if (_heli getVariable ["session_timer_running", false]) then {
        private _start_time = _heli getVariable ["session_time_start", 0];
        private _current_time = if (isMultiplayer) then {
            servertime
        } else {
            diag_ticktime
        };

        private _time = _current_time - _start_time;
        _heli setVariable ["session_timer_value", _time, true];

        private _formattedtime = [_time, "MM:SS.MS"] call BIS_fnc_secondstoString;

        _heli setVariable ["session_timer_text", format ["<t color='#ffff00'>%1</t>", _formattedtime], true];
    };
};

// Timer
_fnc_timer = {
	params ["_heli"];
	if (_heli getVariable ["timer_running", false]) then {
        private _start_time = _heli getVariable ["time_start", 0];
        private _current_time = if (isMultiplayer) then {
            servertime
        } else {
            diag_ticktime
        };
        private _time = _current_time - _start_time;
        _heli setVariable ["timer_value", _time];
	};
};

// Run continuously
while {sleep 0.1; true; } do {

	// Only run if player is inside a vehicle
	if !(isNull objectParent player) then {
		private _heli = objectParent player;

		// Start Timers
		[_heli] call _fnc_timer;
		[_heli] call _fnc_session_timer;

		// Disable engine on auto hover
		if (isAutoHoverOn _heli) then {
			_heli setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), 1];
        	_heli engineOn false;
		};		

		// Weight
		private _weight_array = weightRTD _heli;
		private _weight = 0;
		{
			_weight = _weight + _x;
		} foreach _weight_array;

		// Crew and Pax
		private _crew = [];
		private _pax = 0;
		{
			if (isPlayer _x) then {
				_crew set [count _crew, name _x];
			} else {
				_pax = _pax + 1;
			};
		} foreach crew _heli;

		// Damage colours
		private _damage_colour = '#ffff00';
		private _crew_damage_colour = '#ffff00';

		// Heli Damage
		private _heli_damage = ((damage _heli) * 100);

		// Crew Damage
		private _crew_damage = 0;
		private _h_i = (count _crew) + _pax;
		if (_h_i > 0) then {
			{
				_crew_damage = _crew_damage + (damage _x);
			} foreach crew _heli;
			_crew_damage = (_crew_damage * 100) / _h_i;
		};

		// Set damage colours
		if (_heli_damage > 0) then {
			_damage_colour = '#e80000';
		} else {
			_damage_colour = '#ffff00';
		};

		if (_crew_damage > 0) then {
			_crew_damage_colour = '#e80000';
		} else {
			_crew_damage_colour = '#ffff00';
		};

		// Speed
		private _speed = round (speed _heli);

		// Altitude (converted to feet)
		private _altitude = round(((getPosASL _heli) select 2) * 3.28084);

		private _timer_addon_str = "";

		// Get formatted timer value
		private _formatted_time = [_heli getVariable ["timer_value", 0], "MM:SS.MS"] call BIS_fnc_secondstoString;
		switch (_heli getVariable ["exercise", ""]) do {
			case "LZ-1": { };
			case "LZ-2": { };
			case "Precision": {
				if (_heli getVariable ["precisionIsStarted", false]) then {
					_timer_addon_str = format ["(Lap: %1/5)", _heli getVariable ["precisionLapcount", 0]];
				};
			};
			case "Control": {
				if (_heli getVariable ["timer_running", false] and _heli getVariable ["timer_value", 0] >= 20 and _heli getVariable ["controlIsStarted", false]) then {
					_heli setVariable ["timer_running", false, true];
					_heli setVariable ["timer_value", 20, true];
					_trigger = _heli getVariable ["trigger", ""];
					switch (_trigger) do {
						case "LZ1": {
							_heli setVariable ["controlPos1", true, true];
							titleText [format ["%1 Completed!", _trigger], "PLAIN", 0.2];
							};
						case "LZ2": {
							if (_heli getVariable ["controlPos1", false]) then {
								_heli setVariable ["controlPos2", true, true];
								titleText [format ["%1 Completed!", _trigger], "PLAIN", 0.2];
							} else {
								titleText ["You must complete LZ1 first!", "PLAIN", 0.2];
							};
						};
						case "LZ3": {
							if (_heli getVariable ["controlPos2", false]) then {
								_heli setVariable ["controlPos3", true, true];
								titleText [format ["%1 Completed!", _trigger], "PLAIN", 0.2];
							} else {
								titleText ["You must complete LZ2 first!", "PLAIN", 0.2];
							};
						};
						case "LZ4": {
							if (_heli getVariable ["controlPos3", false]) then {
								_heli setVariable ["controlPos4", true, true];
								titleText [format ["%1 Completed!", _trigger], "PLAIN", 0.2];
							} else {
								titleText ["You must complete LZ3 first!", "PLAIN", 0.2];
							};
						};
						default { };
					};
					playSound3D ["a3\sounds_f\air\Heli_Attack_02\alarm.wss", player];
					_formatted_time = [20, "MM:SS.MS"] call BIS_fnc_secondstoString;
				};
				// Get control lz's		
				private _p1 = _heli getVariable ["controlPos1", false];
				private _p2 = _heli getVariable ["controlPos2", false];
				private _p3 = _heli getVariable ["controlPos3", false];
				private _p4 = _heli getVariable ["controlPos4", false];

				private _txt_p1 = if (_p1) then {"<t color='#00bf16'>LZ1</t>"} else {"<t color='#B8B8B8'>LZ1</t>"};
				private _txt_p2 = if (_p2) then {"<t color='#00bf16'>LZ2</t>"} else {"<t color='#B8B8B8'>LZ2</t>"};
				private _txt_p3 = if (_p3) then {"<t color='#00bf16'>LZ3</t>"} else {"<t color='#B8B8B8'>LZ3</t>"};
				private _txt_p4 = if (_p4) then {"<t color='#00bf16'>LZ4</t>"} else {"<t color='#B8B8B8'>LZ4</t>"};

				_timer_addon_str = format ["(%1 %2 %3 %4)", _txt_p1, _txt_p2, _txt_p3, _txt_p4];
			};
			default { };
		};

		// Get all heli pilots
		private _pilot_names = [];
		{
			if !(isNull objectParent _x) then {
				private _ghost = objectParent _x;
				if (_ghost isKindOf "Helicopter" and _x == driver _ghost) then {
					private _str = format ["%1 (%2) [%3, %4ft, %5Km/h]", 
						_ghost getVariable ["name", ""],					// Heli name 
						name _x, 											// Pilot name
						_ghost getVariable ["exercise", "None"], 			// Exercise
						round(((getPosASL _ghost) select 2) * 3.28084),		// Altitude
						round (speed _ghost)								// Speed
					];
					_pilot_names set [count _pilot_names, _str];
				};
			};
		} foreach allPlayers;

		_pilot_names sort true;

		// Set text lines
		private _txt_align_left = "<t align='left'>";		
		private _txt_name = format ["%1 <t color='#ffff00'>(%2Kg)</t> <t color='#ffff00' align='right'>%3</t>", _heli getVariable ["name", ""], round _weight, _heli getVariable ["session_timer_text", "00:00.000"]];
		private _txt_crew = format ["<br/>Crew: <t color='#ffff00'>%1</t>", _crew joinString ", "];
		private _txt_pax = format ["<br/>Pax: <t color='#ffff00'>%1</t>", _pax];
		private _txt_damage = format ["<br/>Damage: [<t color='%1'>%2%3</t>, <t color='%4'>%5%3</t>]", _damage_colour, _heli_damage toFixed 2, '%', _crew_damage_colour, _crew_damage toFixed 2];
		private _txt_speed = format ["<br/>Speed: <t color='#ffff00'>%1 Km/h</t>", _speed];
		private _txt_altitude = format ["<br/>Altitude: <t color='#ffff00'>%1 ft</t>", _altitude];
		private _txt_exercise = format ["<br/>Exercise: <t color='#ffff00'>%1</t>", _heli getVariable ["exercise", ""]];
		private _txt_timer = format ["<br/>Timer: <t color='#ffff00'>%1 %2</t>", _formatted_time, _timer_addon_str];
		private _txt_entry_speed = format ["%1", _heli getVariable ["start_speed_text", ""]];
		private _txt_score = format ["<br/>%1", _heli getVariable ["scoreText", ""]];
		private _txt_pilots = format ["<br/><br/><br/><br/>Pilots:<br/><t color='#ffff00'>%1</t>", _pilot_names joinString "<br/>"];
		private _txt_close_align_left = "</t>";

		// Combine format strings into one
		private _txt = parseText format ["%1%2%3%4%5%6%7%8%9%10%11%12",
			_txt_align_left, 
			_txt_name, 
			_txt_crew, 
			_txt_pax, 
			_txt_damage, 
			_txt_speed, 
			_txt_altitude, 
			_txt_exercise,
			_txt_timer,
			_txt_entry_speed,
			_txt_score,
			_txt_pilots,
			_txt_close_align_left
		];

		// Show hint text on screen
		hintSilent _txt;
	} else {
		hintSilent "";
	};
};
