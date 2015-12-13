if (ADF_isHC) exitWith {};

// Clients
if (hasInterface) then {
	ADF_fnc_CacheDestroyed = {
		ADF_cacheCnt = ADF_cacheCnt + 1;
		if (ADF_cacheCnt == 1) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. Found and destroyed one BULLDOG. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. One BULLDOG destroyed. Keep searching for other stray dogs. Out."] call ADF_fnc_MessageParser;		
		};
		if (ADF_cacheCnt == 2) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. Found and destroyed another BULLDOG. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. Two BULLDOGS destroyed. Excellent job. Keep looking. Out."] call ADF_fnc_MessageParser;
		};
		if (ADF_cacheCnt == 3) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. Destroyed BULLDOG number three. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. Three BULLDOGS history.<br/><br/>If you're up for it you can keep searching for more BULLDOGS.<br/><br/>If not, you may head home. Either case, mission accomplished!"] call ADF_fnc_MessageParser; 
		};
		if (ADF_cacheCnt == 4) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. We decided to keep looking. Just found and destroyed another BULLDOG. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. BULLDOG number four is history. Out"] call ADF_fnc_MessageParser;	
		};
		if (ADF_cacheCnt == 5) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. BULLDOG number 5 destroyed. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. RTB. That's an order! Out"] call ADF_fnc_MessageParser; 	
		};		
		if (ADF_cacheCnt == 6) exitWith {
			sleep random 5;
			["2S","","FAIRCHILD this is TWO SIERRA. BULLDOG number 6 destroyed. How copy?"] call ADF_fnc_MessageParser; sleep 13;
			["ACO","ACO","FAIRCHILD: Copy TWO SIERRA. Appreciate the additional effort. Time to come home.<br /><br />RTB TWO SIERRA. Now! Out."] call ADF_fnc_MessageParser; 	
		};		
	};

	ADF_endMissionMsg = {
		if !(hasInterface) exitWith {};
		sleep 10;	
		["ACO","ACO","FAIRCHILD: Job well don TWO SIERRA.<br/><br/>MOTHER said we delivered quite a blow by destroying those weapons caches.<br/><br/>Hot coffee and cold ones waiting in the mess."] call ADF_fnc_MessageParser; 
		sleep 20;

		_l = ["tLayer"] call BIS_fnc_rscLayer; 
		_l cutText ["", "BLACK", 20];
		["<img size= '10' shadow='false' image='Img\intro_TwoSierra.paa'/><br/><br/><t size='.7' color='#FFFFFF'>Day 06 | Bulldogs</t>",0,0,9,8] spawn BIS_fnc_dynamicText;		
		['END1',true,22] call BIS_fnc_endMission;
	};		
};


// Server
if (!isServer) exitWith {};
_ADF_debug_testALL = false;

{_x addEventHandler ["killed", {remoteExec ["ADF_fnc_CacheDestroyed", 0, true];}]} forEach [cacheObj1,cacheObj2,cacheObj3,cacheObj4,cacheObj5,cacheObj6];

{	
	_x allowDamage false;
	_x addEventHandler ["Killed",{[_this select 0] spawn ADF_fnc_CacheExplosion}];
} forEach [cacheObj1,cacheObj2,cacheObj3,cacheObj4,cacheObj5,cacheObj6];

// Test all compositions
if (_ADF_debug_testALL) exitWith {
	private ["_p","_pos","_d","_c","_n","_m","_i"];
	for "_i" from 1 to 24 do {
		_p = format ["mObj%1",_i];
		_pos = getMarkerPos _p;
		_pos = [_pos select 0, _pos select 1, .30];
		_d = markerDir _p;
		diag_log format ["Cache: %1",_p];
		_c = createVehicle ["Box_FIA_Ammo_F", _pos, [], 0, "NONE"];
		_c allowDamage false;
		_c setVectorUp surfaceNormal position _c;
		_c setDir _d;
		_c allowDamage true;
		_n = format ["CacheDebug_%1",_i];
		_m = createMarker [_n, getMarkerPos _p];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_dot";
		_m setMarkerColor "ColorGreen";
		sleep .1;	
	};	
	hint "All caches created...";
};

// Create random Weapoms Caches
_cachePosArr = ["mObj1","mObj2","mObj3","mObj4","mObj5","mObj6","mObj7","mObj8","mObj9","mObj10","mObj11","mObj12","mObj13","mObj14","mObj15","mObj16","mObj17","mObj18","mObj19","mObj20","mObj21","mObj22","mObj23","mObj24"];
diag_log	"-----------------------------------------------------";
{
	private ["_cacheMarkerPos","_idx","_p","_pos","_d","_mName","_m"];
	_cacheMarkerPos = _cachePosArr call BIS_fnc_selectRandom;
	_idx = _cachePosArr find _cacheMarkerPos;
	_cachePosArr deleteAt _idx;
	
	_p = getMarkerPos _cacheMarkerPos;
	_pos = [_p select 0, _p select 1, 1];
	_d = markerDir _cacheMarkerPos;
	
	// Move Cache item to random selected position
	_x setPosATL _pos;
	_x setDamage 0;
	_x setVectorUp surfaceNormal position _x;
	_x setDir _d;
	_x allowDamage true;

	diag_log format ["TWO SIERRA: cache objective %1 at marker %2 (position: %3 %4",_x,_cacheMarkerPos,round (_pos select 0), round (_pos select 1)];

	if (ADF_debug) then {
		_mName = format ["debug_%1",_cacheMarkerPos];
		_m = createMarker [_mName,_p];
		_m setMarkerSize [1,1];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_dot";
		_m setMarkerColor "ColorGreen";
		_m setMarkerText format ["%1: %2",_x,_cacheMarkerPos];
	};
} forEach [cacheObj1,cacheObj2,cacheObj3,cacheObj4,cacheObj5,cacheObj6];

if (ADF_debug) then {
	{
		private ["_p"];
		_p = getPos _x;
		_mn = format ["debug%1",_x];
		_m = createMarker [_mn,_p];
		_m setMarkerSize [50,50];
		_m setMarkerShape "ELLIPSE";
		_m setMarkerColor "ColorRed";
	} forEach [cacheObj1,cacheObj2,cacheObj3,cacheObj4,cacheObj5,cacheObj6];
};

ADF_fnc_CacheExplosion = {
	params ["_cachePos"];
	private ["_p"];
	_p = getPos _cachePos;
	"Bo_GBU12_LGB" createVehicle _p; sleep random 1;
	"2Rnd_Mk82" createVehicle _p; sleep random 1;
	"Bo_GBU12_LGB" createVehicle _p; sleep random 1;
	"M_RPG32_AA_F" createVehicle _p; sleep random 1;
	"HelicopterExploSmall" createVehicle _p; sleep random 1;
	"Bo_GBU12_LGB" createVehicle _p; sleep random 1;
	"2Rnd_Mk82" createVehicle _p; sleep random 1;
	"Bo_GBU12_LGB" createVehicle _p; sleep random 1;
	"M_RPG32_AA_F" createVehicle _p; sleep random 1;
	"HelicopterExploSmall" createVehicle _p; sleep 1;
	"Bo_GBU12_LGB" createVehicle _p; sleep 1;
	"Bo_GBU12_LGB" createVehicle _p;
	ADF_cacheCount = ADF_cacheCount + 1;
	publicVariable "ADF_cacheCount";
};

waitUntil {time > 120};

// Extra AO Defence Team at actual cache locations
for "_i" from 1 to 6 do {
	private ["_g","_p","_spawnPos","_defArr"];
	_p			= format ["cacheObj%1",_i];
	_spawnPos	= call compile format ["%1",_p];
	_spawnPos	= getPos _spawnPos;
	
	_g = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
	{[_x] call ADF_fnc_redressRebel} forEach units _g;
	
	_defArr = [_g, _spawnPos, 150, 2, true];
	_defArr call ADF_fnc_defendArea;
	//_g setVariable ["ADF_HC_garrison_ADF",true];
	//_g setVariable ["ADF_HC_garrisonArr",_defArr];	
};

// Foot patrols cache locations
for "_i" from 1 to 5 do {
	private ["_p","_g","_spawnPos"];
	_p			= format ["cacheObj%1",_i];
	_spawnPos	= call compile format ["%1",_p];
	_spawnPos	= getPos _spawnPos;
	
	_g = [_spawnPos, EAST, (configFile >> "CfgGroups" >> "EAST" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
	{[_x] call ADF_fnc_redressRebel} forEach units _g;

	[_g, _spawnPos, 150, 3, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_footPatrol;
};

// End mission
waitUntil {sleep 30; ADF_cacheCount == 3};
ADF_endMission = true; publicVariable "ADF_endMission";
