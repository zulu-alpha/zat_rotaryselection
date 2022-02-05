params ["_target", "_caller", "_actionId", "_arguments"];
_arguments params ["_heli", "_action"];

switch (_action) do {
	case "start": { 
		private _current_time = if (isMultiplayer) then {
            servertime
        } else {
            diag_ticktime
        };
		_heli setVariable ["session_time_start", _current_time, true];
		_heli setVariable ["session_timer_running", true, true];
	};
	case "stop": {
		_heli setVariable ["session_timer_running", false, true];
	};
	default { };
};
