/*
	Author: Nawu of Zulu-Alpha

	Description:
		Adds or removes ai passengers for the helicopter
		This is a declarative function, meaning that it will always attempt to set the total number of occupants to the provided number
		Pax will either be added or removed as required
		Remember, only ai passengers will be added/removed
		First pax will be loaded into the copilot seat
		Any further pax will be loaded as crew/cargo

	Params:
		0 : OBJECT - The vehicle object
		1 : INT - The desired number of occupants (including players)

	Returns:
		(null)
*/

params ["_heli", "_count"];

// Remove crew function
_fnc_remove_crew = {
	params ["_n"];
	if (_n > 0 && count _pax_array > 0) then {
		reverse _pax_array;
		for "_i" from 0 to (_n - 1) do {
			_x = _pax_array select _i;
			_heli deleteVehicleCrew _x;
		};
	};
};

// Add crew function
_fnc_add_crew = {
	params ["_n"];
	private _group = creategroup west;
	for "_i" from 0 to _n do {
		_x = _group createUnit ["B_Soldier_F", [0, 0, 0], [], 0, "NONE"];
        _x setVariable ["belongs_to", _heli_name, true];
	};
	{
        _x assignAsCargo _heli;
        _x moveInCargo [_heli, _forEachindex];
    } forEach units _group;	
};

_fnc_add_copilot = {
	private _group = creategroup west;
	private _unit = _group createUnit ["B_Soldier_F", [0, 0, 0], [], 0, "NONE"];
	_unit setVariable ["belongs_to", _heli_name, true];
	_unit assignAsTurret [_heli, [0]];
	_unit moveInTurret [_heli, [0]];
};


// Get the heli name
private _heli_name = _heli getVariable ["name", ""];

// Get the current crew count
private _occupants_count = count crew _heli;

// Get the players and ai
private _crew_count = 0;
private _pax_array = [];
{
	if (isPlayer _x) then {
		_crew_count = _crew_count + 1;
	} else {
		_pax_array set [count _pax_array, _x];
	};
} forEach crew _heli;

private _pax_count = count _pax_array;

private _added = 0;
private _removed = 0;

// Remove players from calculation
_count = _count - _crew_count;

// If there is only 1 player in the heli, then add first ai to copilot seat
if (_crew_count == 1 && _count > _pax_count) then {
	call _fnc_add_copilot;
	_count = _count - 1;
	_added = _added + 1;
};

// If the desired number of occupants is less than the current crew count, remove some
if (_count < _pax_count && _pax_count > 0) then {
	[(_pax_count - _count)] call _fnc_remove_crew;
	_removed = _removed + (_pax_count - _count);
};

// If the desired number of occupants is greater than the current crew count, add some
if (_count > _pax_count) then {
	[(_count - _pax_count)] call _fnc_add_crew;
	_added = _added + (_count - _pax_count);
};

// If the desired number of occupants is equal to the current crew count, do nothing
if (_count == _pax_count) then {
	// Do nothing
};

private _actioned = "";
private _actionedCount = 0;
if (_added > 0) then {
	_actioned = "added";
	_actionedCount = _added;
};
if (_removed > 0) then {
	_actioned = "removed";
	_actionedCount = _removed;
};

if (_actionedCount > 0) then {
	PAPABEAR = [west, "airbase"];
	private _str = format["%1 %2 %3 Pax", _heli_name, _actioned, _actionedCount];
	PAPABEAR sideChat _str;
};
