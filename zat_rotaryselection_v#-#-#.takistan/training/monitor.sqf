params ["_heli_1", "_heli_2"];

if !(hasinterface) exitwith {};
_fnc_timer = {
    params ["_heli"];
    if (_heli getVariable ["timer_running", false]) then {
        private _start_time = _heli getVariable ["time_start", 0];
        _current_time = if (isMultiplayer) then {
            servertime
        } else {
            diag_ticktime
        };
        _time = _current_time - _start_time;
        _heli setVariable ["timer_value", _time];

        _formattedtime = [_time, "MM:SS.MS"] call BIS_fnc_secondstoString;
        _exercise = _heli getVariable ["exercise", ""];

        // format for LZ-1 and LZ-2
        _timer_text = format ["<br/>%2 Timer: <t color='#ffff00'>%1</t>", _formattedtime, _exercise];

        // format for precision (includes lap counter)
        if (_exercise == "precision" and _heli getVariable ["precisionIsStarted", false]) then {
            _timer_text = format ["<br/>%2 Timer: <t color='#ffff00'>%1 (Lap: %3/5)</t>", _formattedtime, _exercise, _heli getVariable ["precisionLapcount", 0]];
        };

        // format for Control (timer stops on 20 seconds)
        if (_exercise == "Control") then {
            if ((_current_time - _start_time) >= 20.0 and _heli getVariable ["controlIsStarted", false]) then {
                _heli setVariable ["timer_running", false, true];
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
                _timer_text = format ["<br/>%2 %3 Timer: <t color='#ffff00'>%1</t>", "00:20.000", _exercise, _trigger];
                playSound3D ["a3\sounds_f\air\Heli_Attack_02\alarm.wss", player];
            };
        };
        _heli setVariable ["timer_text", _timer_text, true];
    };
};

while {
    sleep 0.1;
    true
} do {
    private ["_target_0", "_target_1"];

    waitUntil {
        _target_0 = call compile format ["%1", _heli_1];
        _target_1 = call compile format ["%1", _heli_2];
        !(isNull _target_0) and !(isNull _target_1)
    };

    // Weight
    _target_0_weight_array = weightRTD _target_0;
    _target_1_weight_array = weightRTD _target_1;

    _target_0_weight = 0;
    {
        _target_0_weight = _target_0_weight + _x;
    } forEach _target_0_weight_array;

    _target_1_weight = 0;
    {
        _target_1_weight = _target_1_weight + _x;
    } forEach _target_1_weight_array;

    // Heli 1 Crew
    _target_0_crew = [];
    {
        if (isPlayer _x) then {
            _target_0_crew set [count _target_0_crew, name _x];
        }
    } forEach crew _target_0;

    // Heli 1 Pax
    _target_0_pax_count = 0;
    {
        if (!isPlayer _x) then {
            _target_0_pax_count = _target_0_pax_count + 1;
        }
    } forEach crew _target_0;

    // Heli 1 Damage
    _target_0_avg_crew_dam = 0;
    _t_0_i = (count _target_0_crew) + _target_0_pax_count;
    if (_t_0_i > 0) then {
        {
            _target_0_avg_crew_dam = _target_0_avg_crew_dam + (damage _x);
        } forEach crew _target_0;
        _target_0_avg_crew_dam = (_target_0_avg_crew_dam * 100) / _t_0_i;
    };

    // Heli 2 Crew
    _target_1_crew = [];
    {
        if (isPlayer _x) then {
            _target_1_crew set [count _target_1_crew, name _x];
        }
    } forEach crew _target_1;

    // Heli 2 Pax
    _target_1_pax_count = 0;
    {
        if (!isPlayer _x) then {
            _target_1_pax_count = _target_1_pax_count + 1;
        }
    } forEach crew _target_1;


    // Heli 2 Damage
    _target_1_avg_crew_dam = 0;
    _t_1_i = (count _target_1_crew) + _target_1_pax_count;
    if (_t_1_i > 0) then {
        {
            _target_1_avg_crew_dam = _target_1_avg_crew_dam + (damage _x);
        } forEach crew _target_1;
        _target_1_avg_crew_dam = (_target_1_avg_crew_dam * 100) / _t_1_i;
    };


    // Start timers
    [_target_0] call _fnc_timer;
    [_target_1] call _fnc_timer;


    // Calculate damages
    _target_0_dam = ((damage _target_0) * 100);
    _target_1_dam = ((damage _target_1) * 100);
    
    // Calculate speeds
    _target_0_speed = round (speed _target_0);
    _target_1_speed = round (speed _target_1);

    // Set Heli 1 damage
    _target_0 setVariable ["damage", _target_0_dam, true];
    _target_0 setVariable ["crew_damage", _target_0_avg_crew_dam, true];

    // Set Heli 2 damage
    _target_1 setVariable ["damage", _target_1_dam, true];
    _target_1 setVariable ["crew_damage", _target_1_avg_crew_dam, true];

    // Calculate Altitude
    // Convert to Feet (meters * 3.28084)
    _target_0_alt = round (((getPosASL _target_0) select 2) * 3.28084);
    _target_1_alt = round (((getPosASL _target_1) select 2) * 3.28084);


    // Heli 1 Autohover punishment
    if ((isAutoHoverOn _target_0)) then {
        _target_0 setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), 1];
        _target_0 engineOn false;
        private _sucker_0 = _target_0_crew select 0;
        _sucker_0 = format ["<t color='#ff2684'>%1 (L)</t>", _sucker];
        _target_0_crew set [0, _sucker];
    };

    // Heli 2 Autohover punishment
    if ((isAutoHoverOn _target_1)) then {
        _target_1 setHit [getText(configfile >> "CfgVehicles" >> "B_Heli_Light_01_F" >> "HitPoints" >> "HitEngine" >> "name"), 1];
        private _sucker_1 = _target_1_crew select 0;
        _sucker_1 = format ["<t color='#ff2684'>%1 (L)</t>", _sucker];
        _target_1_crew set [0, _sucker];
    };

    // Build text string
    hintSilent parsetext format ["
        <t align='left'>Heli: <t color='#ffff00'>%2 (%22Kg)</t>
        <br/>Crew: <t color='#ffff00'>%3</t>
        <br/>Pax: <t color='#ffff00'>%18</t>
        <br/>Damage: <t color='#ffff00'>[%4%1, %5%1]</t>
        <br/>Speed: <t color='#ffff00'>%6 Km/h</t>
        <br/>Altitude: <t color='#ffff00'>%7 ft</t>
        %14
        %16
        <br/>
        %20
        <br/>
        <br/>Heli: <t color='#ffff00'>%8 (%23Kg)</t>
        <br/>Crew: <t color='#ffff00'>%9</t>
        <br/>Pax: <t color='#ffff00'>%19</t>
        <br/>Damage: <t color='#ffff00'>[%10%1, %11%1]</t>
        <br/>Speed: <t color='#ffff00'>%12 Km/h</t>
        <br/>Altitude: <t color='#ffff00'>%13 ft</t>
        %15
        %17
        <br/>%21",
        "%",                                            // 1  (Percentage Sign)
        _target_0 getVariable ["name", str _target_0],  // 2  (Heli 1 Name)
        _target_0_crew joinString  ", ",                // 3  (Heli 1 Crew Names)
        _target_0_dam,                                  // 4  (Heli 1 Damage)
        _target_0_avg_crew_dam,                         // 5  (Heli 1 Crew Damage)
        _target_0_speed,                                // 6  (Heli 1 Speed)
        _target_0_alt,                                  // 7  (Heli 1 Altitude (Feet))
        _target_1 getVariable ["name", str _target_1],  // 8  (Heli 2 Name)
        _target_1_crew joinString ", ",                 // 9  (Heli 2 Crew Names)
        _target_1_dam,                                  // 10 (Heli 2 Damage)
        _target_1_avg_crew_dam,                         // 11 (Heli 2 Crew Damage)
        _target_1_speed,                                // 12 (Heli 2 Speed)
        _target_1_alt,                                  // 13 (Heli 2 Altitude (Feet))
        _target_0 getVariable ["timer_text", ""],       // 14 (Heli 1 Timer Text)
        _target_1 getVariable ["timer_text", ""],       // 15 (Heli 2 Timer Text)
        _target_0 getVariable ["start_speed_text", ""], // 16 (Heli 1 Start Speed Text)
        _target_1 getVariable ["start_speed_text", ""], // 17 (Heli 2 Start Speed Text)
        _target_0_pax_count,                            // 18 (Heli 1 Pax Count)
        _target_1_pax_count,                            // 19 (Heli 2 Pax Count)
        _target_0 getVariable ["scoreText", ""],        // 20 (Heli 1 Score Text)
        _target_1 getVariable ["scoreText", ""],        // 21 (Heli 2 Score Text)
        round _target_0_weight,                         // 22 (Heli 1 Weight)
        round _target_1_weight                          // 23 (Heli 2 Weight)
    ];
};
/*
waitUntil {
    (!isNull heli_1) and (!isNull heli_2)
};
// Monitor Exam Littlebirds
[heli_1, heli_2] execVM "training\monitor.sqf";