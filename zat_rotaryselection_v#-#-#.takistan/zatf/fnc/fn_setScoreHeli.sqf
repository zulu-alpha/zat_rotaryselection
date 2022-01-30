/*
	Author: Nawu of Zulu-Alpha

	Description:
		Builds a formatted string representing the score result of an exercise
		Returns the score block as a string

	Params:
		0 : OBJECT - The exercise vehicle object
		1 : STRING - The name of the exercise
		2 : OBJECT - The player that completed the exercise
		3 : STRING - The name of the Directing Staff member that administered the exercise
		4 : INT - The total time that the exercise took in seconds
		5 : INT - The number of passengers (non-player ai) in the vehicle (if applicable)
		6 : NUMBER - The percentage damage of the vehicle
		7 : NUMBER - The percentage damage of the crew
		8 : INT - The entry speed to the exercise
		9 : INT - Result (0 = failed, 1 = passed, 2 = merit)

	Returns:
		(STRING)
*/

params ["_heli", "_exercise", "_player", "_ds", "_time", "_pax", "_vehicleDamage", "_crewDamage", "_entrySpeed", "_result"];


// Set the formatted time string
private _formattedTime = [_time, "MM:SS.MS"] call BIS_fnc_secondstoString;

// Get result text
private _resultText = "";
switch (_result) do {
	case 0: {
		_resultText = format ["Result: <t color='#e80000'>%1</t><br/>", 'Failed'];
	};
	case 1: {
		_resultText = format ["Result: <t color='#00bf16'>%1</t><br/>", 'Passed'];
	};
	case 2: {
		_resultText = format ["Result: <t color='#FFD700'>%1</t><br/>", 'Merit'];
	};
	default { };
};

// Set each line of the score block
// Seperated to enable logic to be added later if required
private _exerciseText = format ["<br/>%1 Score<br/>", _exercise];
private _playerText = format ["Pilot: <t color='#ffff00'>%1</t><br/>", _player];
private _dsText = format ["DS: <t color='#ffff00'>%1</t><br/>", _ds];
private _timeText = format ["Time: <t color='#ffff00'>%1</t><br/>", _formattedTime];
private _paxText = format ["Pax: <t color='#ffff00'>%1</t><br/>", _pax];
private _vehicleDamageText = format ["Damage: <t color='#ffff00'>%1%2</t><br/>", _vehicleDamage, "%"];
private _crewDamageText = format ["Crew Damage: <t color='#ffff00'>%1%2</t><br/>", _crewDamage, "%"];
private _entrySpeedText = format ["Entry Speed: <t color='#ffff00'>%1Km/h</t><br/>", _entrySpeed];

if (_entrySpeed == 0) then {
	_entrySpeedText = "";
};

// Combine the lines into a single string
_result = format ["%1%2%3%4%5%6%7%8%9", _exerciseText, _playerText, _dsText, _timeText, _paxText, _vehicleDamageText, _crewDamageText, _entrySpeedText, _resultText];

// Set variable on heli
_heli setVariable ["scoreText", _result, true];

// Return result
_result;
