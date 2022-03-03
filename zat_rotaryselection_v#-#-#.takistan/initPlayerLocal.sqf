// [] spawn {
//    while {true} do {
		
// 		// Ensure that DS addActions are present
// 		if (player in (call BIS_fnc_listCuratorPlayers)) then {
// 			waitUntil {!alive player};

// 			waitUntil {alive player};
// 			[player] execVM "training\ds_init.sqf";
// 		};
//         sleep 0.2;
//     };
// };

// [] spawn {
// 	while {sleep 10; true;} do {
// 		if (player in (call BIS_fnc_listCuratorPlayers)) then {
// 			[player] execVM "training\ds_init.sqf";
// 		};
// 	};
// };
