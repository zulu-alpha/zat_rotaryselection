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
private _resultName = "";
switch (_result) do {
	case 0: {
		_resultText = format ["<t color='#4d4dff'>Result:</t> <t color='#e80000'>%1</t><br/>", 'Failed'];
		_resultName = format ["<t color='#e80000'>%1</t>", 'Failed'];
	};
	case 1: {
		_resultText = format ["<t color='#4d4dff'>Result:</t> <t color='#00bf16'>%1</t><br/>", 'Passed'];
		_resultName = format ["<t color='#00bf16'>%1</t>", 'Passed'];
	};
	case 2: {
		_resultText = format ["<t color='#4d4dff'>Result:</t> <t color='#FFD700'>%1</t><br/>", 'Merit'];
		_resultName = format ["<t color='#FFD700'>%1</t>", 'Merit'];
	};
	default { };
};

// Get the system date and time
private _systemDateTimeArray = systemTime apply {if (_x < 10) then {"0" + str _x} else {str _x}};
private _systemDateTime = format ["%1-%2-%3 %4:%5:%6", _systemDateTimeArray select 0, _systemDateTimeArray select 1, _systemDateTimeArray select 2, _systemDateTimeArray select 3, _systemDateTimeArray select 4, _systemDateTimeArray select 5];

// Set each line of the score block
// Seperated to enable logic to be added later if required
private _exerciseText = format ["<br/><t color='#4d4dff'>%1 Score </t> <t color='#ffff00'>%2</t><br/>", _exercise, _systemDateTime];
private _playerText = format ["<t color='#4d4dff'>Pilot:</t> <t color='#ffff00'>%1</t><br/>", _player];
private _dsText = format ["<t color='#4d4dff'>DS:</t> <t color='#ffff00'>%1</t><br/>", _ds];
private _timeText = format ["<t color='#4d4dff'>Time:</t> <t color='#ffff00'>%1</t><br/>", _formattedTime];
private _paxText = format ["<t color='#4d4dff'>Pax:</t> <t color='#ffff00'>%1</t><br/>", _pax];
private _vehicleDamageText = format ["<t color='#4d4dff'>Damage:</t> <t color='#ffff00'>%1%2</t><br/>", _vehicleDamage, "%"];
private _crewDamageText = format ["<t color='#4d4dff'>Crew Damage:</t> <t color='#ffff00'>%1%2</t><br/>", _crewDamage, "%"];

private _entrySpeedText = "";
if (_entrySpeed != 0) then {
	_entrySpeedText = format ["<t color='#4d4dff'>Entry Speed:</t> <t color='#ffff00'>%1Km/h</t><br/>", _entrySpeed];
};

// Combine the lines into a single string
_txt_result = format ["%1%2%3%4%5%6%7%8%9", _exerciseText, _playerText, _dsText, _timeText, _paxText, _vehicleDamageText, _crewDamageText, _entrySpeedText, _resultText];

// Set variables on heli
_heli setVariable ["scoreText", _txt_result, true];
_heli setVariable ["exercise_time", _formattedTime, true];
_heli setVariable ["exercise_result", _resultName, true];

// TODO: Persist scores with Pythia

// Return result
_txt_result;
