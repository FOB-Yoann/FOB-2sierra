/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Mission init
Author: Whiztler
Script version: 1.14

Game type: n/a
File: initServer.sqf
****************************************************************
Executed on the server at mission start. NOT executed on any
(player) clients and not on JIP.
****************************************************************/

diag_log "ADF RPT: Init - executing initServer.sqf"; // Reporting. Do NOT edit/remove

// add mission data to RPT log
diag_log text ""; diag_log text ""; diag_log text ""; 
diag_log text format["####################   %1   ####################", missionName]; // stamp mission name in RPT log
diag_log text "";

// Include Mary comp
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_objectMarker.sqf";
#include "Scr\SOD_mary_comp.sqf" // St. Mary composition
// Init
private ["_ADF_debug_testALL","_ADF_maryCreate"];
_ADF_debug_testALL	= false;

ADF_maryLoc = ["mObj1","mObj2","mObj3","mObj4"] call BIS_fnc_selectRandom;
publicVariable "ADF_maryLoc";

// Test all compositions
if (_ADF_debug_testALL) exitWith {
	private ["_p","_pos","_d","_c","_n","_m","_i","_r"];
	for "_i" from 1 to 4 do {
		_p = format ["mObj%1",_i];
		_pos = getMarkerPos _p;
		_d = markerDir _p;
		_c = _stMaryComp;	
		diag_log format ["Marker: %1 --- Composition: %2",_p,_c];
		[_pos,_d,_c] call BIS_fnc_ObjectsMapper;
		_n = format ["MaryDebug_%1",_i];
		_m = createMarker [_n, getMarkerPos _p];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_objective";
		_m setMarkerColor "ColorGreen";
		sleep 1;	
	};	
	hint "Mary comps's spawned...";
};

_ADF_maryCreate = {
	// init
	params ["_ADF_maryComp"];
	private ["_ADF_maryLocPos","_ADF_maryLocDir"];
	_ADF_maryLocPos = getMarkerPos ADF_maryLoc;
	_ADF_maryLocDir = markerDir ADF_maryLoc;
	
	// Spawn the base of operations
	[_ADF_maryLocPos,_ADF_maryLocDir,_ADF_maryComp] call BIS_fnc_ObjectsMapper;
	
	// Clear the comp array vars from memory
	_stMaryComp = nil;
	
	// Move and position the spawn trigger
	tObj setPos _ADF_maryLocPos;
	tObj setDir _ADF_maryLocDir;
	
	// Create the St Mary's location marker
	_m = createMarker ["mObjPos", getPos oMary];
	_m setMarkerSize [.7, .7];
	_m setMarkerShape "ICON";
	_m setMarkerType "n_med";
	_m setMarkerColor "ColorWhite";
	_m setMarkerDir 0;
	_m setMarkerText " ST. MARY";
	
	diag_log	"-----------------------------------------------------";
	diag_log format ["TWO SIERRA: St. Mary's created. Position: %1,%2",round(_ADF_maryLocPos select 0),round(_ADF_maryLocPos select 1)];
	diag_log	"-----------------------------------------------------";
	true
};

//debug
if (ADF_debug) then {
	_m = createMarker ["MarybugArea", getMarkerPos ADF_maryLoc];
	_m setMarkerShape "rectangle";
	_m setMarkerDir (markerDir ADF_maryLoc);
	_m setMarkerType "EMPTY";
	_m setMarkerSize [25,20];
	_m setMarkerColor "ColorGreen";
	_m setMarkerBrush "DiagGrid";
	_m setMarkerAlpha 0.5;
};

[_stMaryComp] call _ADF_maryCreate;

[] spawn {waitUntil {time > 0}; enableEnvironment FALSE;};	

if (isDedicated) then {
	#include "Core\ADF_init_rpt.sqf"
};

//  Execute Core Third Party SERVER scripts: (comment out if not applicable)
_mmObjArray = [
"Land_fortified_nest_big",
"Land_HBarrierTower_F",
"Land_HBarrierBig_F",
"Land_fortified_nest_small_EP1",
"Land_Fort_Watchtower_EP1",
"Land_HBarrier_large",
"Land_HBarrier_5_F",
"Land_HBarrier_3_F",
"Land_HBarrierWall_corridor_F",
"Land_HBarrierWall_corner_F",
"Land_HBarrierWall4_F",
"Land_HBarrierWall6_F",
"US_WarfareBFieldhHospital_Base_EP1",
"US_WarfareBBarracks_Base_EP1",
"Land_Barrack2_EP1",
"MASH_EP1",
"StorageBladder_01_fuel_sand_F",
"Land_Ind_TankSmall2_EP1",
"PowGen_Big_EP1",
"US_WarfareBVehicleServicePoint_Base_EP1",
"US_WarfareBUAVterminal_Base_EP1",
"US_WarfareBAntiAirRadar_Base_EP1",
"Land_Hangar_2",
"Land_BagBunker_Large_F",
"Land_Cargo40_military_green_F",
"Land_Cargo40_sand_F",
"Land_Cargo20_military_green_F",
"Land_Cargo20_sand_F",
"Land_ReservoirTank_Airport_F",
"Land_u_Barracks_V2_F",
"Land_i_Barracks_V1_F",
"Land_Cargo_House_V3_F",
"Land_Cargo_House_V1_F",
"Land_Cargo_Patrol_V1_F",
"Land_Cargo_Patrol_V3_F",
"Land_Cargo_Tower_V1_F",
"Land_Cargo_Tower_V3_F",
"Land_TentHangar_V1_F",
"Land_CncBarrier_stripes_F"
];

// Obj Map markerAlpha
[_mmObjArray,	"mFargo",500] call ADF_fnc_objectMarker;

// Re-create critical markers
{[_x] call ADF_fnc_reMarker} forEach ["mMed","mFargo"];