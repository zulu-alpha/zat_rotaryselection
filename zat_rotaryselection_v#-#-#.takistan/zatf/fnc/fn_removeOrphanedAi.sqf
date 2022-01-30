/*
	Author: Nawu of Zulu-Alpha

	Description:
		Deletes any ai that belongs to a helicopter (based on the variable 'belongs_to') that is not currently in a helicopter.
		This will not delete any ai that was placed by Zeus.

	Params:
		None

	Returns:
		(null)
*/

{
	private _belongs_to = _x getVariable ["belongs_to", ""];
	private _orphaned = isNull objectParent _x;

	if ((_belongs_to == "Heli 1" or _belongs_to == "Heli 2") && _orphaned) then {
		deleteVehicle _x;
	};
} forEach allUnits;
