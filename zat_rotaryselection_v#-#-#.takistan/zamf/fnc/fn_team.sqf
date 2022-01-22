/*
    Author: Phoenix of Zulu-Alpha

    Description:
        Sets the unit to the given gear and Group ID

    Params:
        0 : OBJECT - The unit to apply gear and ID to.
        1 : STRING - The type of Gear to be outfitted (see zamf\loadout\gear.sqf for choices). Use non string (false by convention) to skip kitting out.
        2 : STRING - The Group ID of the player

    Returns:
        (NUL)
*/

params ["_unit", "_gear", "_gid"];

_unit setGroupId [_gid];

if (typeName _gear == (typeName "") and !(_gear in ["arsenal", "custom"])) then {
    [_unit, _gear] spawn zamf_fnc_gear;
};
