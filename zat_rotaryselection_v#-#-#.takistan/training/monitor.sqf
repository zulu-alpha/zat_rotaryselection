params ["_heli_1", "_heli_2"];

if !(hasInterface) exitWith {};

_fnc_timer = {
    params ["_heli"];
    if (_heli getVariable ["timer_running", false]) then {
        private _start_time = _heli getVariable ["time_start", 0];
        _current_time = if (isMultiplayer) then {serverTime} else {diag_ticktime};
        _time = [(_current_time - _start_time), "MM:SS.MS"] call BIS_fnc_secondstoString;
        _timer_exercise = _heli getVariable ["timer_exercise", ""];
        _timer_time = format ["<br/>%2 Timer: %1", _time, _timer_exercise];
        _heli setVariable ["timer_text",_timer_time, true];
    };
};

while {sleep 0.1; true} do {
    private ["_target_0", "_target_1"];

    
    waitUntil {
        _target_0 = call compile format ["%1", _heli_1];
        _target_1 = call compile format ["%1", _heli_2];
        !(isNull _target_0) && !(isNull _target_1)
    };
    
    _target_0_crew = [];
    {
        _target_0_crew set [count _target_0_crew, name _x];
    } forEach crew _target_0;
    
    _target_0_avg_crew_dam = 0;
    _t_0_i = count _target_0_crew;
    if (_t_0_i > 0) then {
        {
            _target_0_avg_crew_dam = _target_0_avg_crew_dam + (damage _x);
        } forEach crew _target_0;
        _target_0_avg_crew_dam = (_target_0_avg_crew_dam * 100) / _t_0_i;
    };
    
    _target_1_crew = [];
    {
        _target_1_crew set [count _target_1_crew, name _x];
    } forEach crew _target_1;
    
    _target_1_avg_crew_dam = 0;
    _t_1_i = count _target_1_crew;
    if (_t_1_i > 0) then {
        {
            _target_1_avg_crew_dam = _target_1_avg_crew_dam + (damage _x);
        } forEach crew _target_1;
        _target_1_avg_crew_dam = (_target_1_avg_crew_dam * 100) / _t_1_i;
    };

    [_target_0] call _fnc_timer;
    [_target_1] call _fnc_timer;
    
    _target_0_dam = ((damage _target_0) * 100);
    _target_1_dam = ((damage _target_1) * 100);
    _target_0_speed = round (speed _target_0);
    _target_1_speed = round (speed _target_1);
    _target_0_alt = round ((getPosASL _target_0) select 2);
    _target_1_alt = round ((getPosASL _target_1) select 2);
    
    hintSilent parsetext format ["
        <t align='left'>Heli: <t color='#ffff00'>%2</t>
        <br/>Crew: <t color='#ffff00'>%3</t>
        <br/>Damage: <t color='#ffff00'>%4%1</t>
        <br/>Crew Dam: <t color='#ffff00'>%5%1</t>
        <br/>Speed: <t color='#ffff00'>%6Km/h</t>
        <br/>Altitude: <t color='#ffff00'>%7m
		%14
		%16</t>
        <br/>
        <br/>
        <br/>Heli: <t color='#ffff00'>%8</t>
        <br/>Crew: <t color='#ffff00'>%9</t>
        <br/>Damage: <t color='#ffff00'>%10%1</t>
        <br/>Crew Dam: <t color='#ffff00'>%11%1</t>
        <br/>Speed: <t color='#ffff00'>%12Km/h</t>
        <br/>Altitude: <t color='#ffff00'>%13m
		%15
		%17</t>
        
        </t>",
        "%",
        _target_0 getVariable ["name", str _target_0],  // 2
        _target_0_crew,  // 3
        _target_0_dam,  // 4
        _target_0_avg_crew_dam,  // 5
        _target_0_speed,  // 6
        _target_0_alt,  // 7
        _target_1 getVariable ["name", str _target_1],  // 8
        _target_1_crew,  // 9
        _target_1_dam,  // 10
        _target_1_avg_crew_dam,  // 11
        _target_1_speed,  // 12
        _target_1_alt,  // 13
        _target_0 getVariable ["timer_text", ""],  // 14
        _target_1 getVariable ["timer_text", ""],  // 15
        _target_0 getVariable ["start_speed_text", ""],  // 16
        _target_1 getVariable ["start_speed_text", ""]  // 17
    ];

};
/*
waitUntil {
    (!isNull heli_1) && (!isNull heli_2)
};
// Monitor Exam Littlebirds
[heli_1, heli_2] execVM "training\monitor.sqf";