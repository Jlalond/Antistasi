private ["_allVehicles","_vehicle"];
diag_log "InitVar.sqf: start";
//Antistasi var settings
//If some setting can be modified it will be commented with a // after it.
//Make changes at your own risk!!
//You do not have enough balls to make any modification and after making a Bug report because something is wrong. You don't wanna be there. Believe me.
//Not commented lines cannot be changed.
//Don't touch them.
antistasiVersion = localize "STR_MISSION_NAME_INITVAR_SQF";

servidoresOficiales = ["Antistasi Official: Main","Antistasi Official: Hardcore", "Antistasi Official: USA"];//No longer effect

debug = false;//debug variable, not useful for everything..

cleantime = 3600; //time to delete dead bodies, vehicles etc..
distanciaSPWN = 1000;//initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
musicON = false;
civPerc = 0.02;//initial % civ spawn rate
minimoFPS = 15;//initial FPS minimum.
autoHeal = true;
allowPlayerRecruit = true;
server setvariable ["flag_allowRoleSelection",true,true];  //Stef
recruitCooldown = 0;
planesAAFcurrent = 0;
helisAAFcurrent = 0;
APCAAFcurrent = 0;
tanksAAFcurrent= 0;
flag_savingClient = false;
incomeRep = false;
closeMarkersUpdating = 0;
static_playerSide = "B";

//get enableRestart from server's parameters in multiplayer
freshstart = !(isMultiplayer) OR {("AS_enableCampaignReset" call BIS_fnc_getParamValue) != 0};
membership = !(isMultiplayer) OR {("AS_enableServerMember" call BIS_fnc_getParamValue) != 0};
commanderswitch = !(isMultiplayer) OR {("AS_enableSwitchComm" call BIS_fnc_getParamValue) != 0};

status_templatesLoaded = false;
activeJNA = true; //It can't be disabled because of loss of compatibility
if (activeJNA) then {
	jna_dataList = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
	server setVariable ["jna_mrestricted",false,true];
};

missionPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

AS_customGroups = false;
if (isClass (configFile >> "CfgPatches" >> "javelinTest")) then {
	AS_customGroups = true;
};

/*
 	Gear initialisation
 	- all weapons provided by mods will be detected
 	- by default, only vanilla and RHS weapons are fully integrated and will be utilised properly
 	- additional weapons can be acquired through the weapons dealer
*/
[] call AS_fnc_setupGearDB;

/*
 	RHS detection/initialisation
 	- SQM defines whether FIA is BLUFOR or GUER
 	- RHS USAF replaces NATO
 	- RHS AFRF replaces AAF/CSAT
*/
[] call AS_fnc_detectRHS;
waitUntil {status_templatesLoaded};

/*
 	ACE detection/initialisation
 	- adds some items to be unlocked by default
 	- if ACE medical is active, additional medical items will be unlocked
 	- ACE settings can be adjusted through mission parameters or a serverconfig.hpp
*/
[] call AS_fnc_detectACE;

call compile preprocessFileLineNumbers "Lists\basicLists.sqf";
#include "Compositions\spawnPositions.sqf"
#include "Scripts\SHK_Fastrope.sqf"

if (!isServer and hasInterface) exitWith {};

AAFpatrols = 0;//0
skillAAF = 0;
smallCAmrk = [];
smallCApos = [];
reducedGarrisons = [];

// camps
campsFIA = [];
campList = [];
campNames = ["Camp Spaulding","Camp Wagstaff","Camp Firefly","Camp Loophole","Camp Quale","Camp Driftwood","Camp Flywheel","Camp Grunion","Camp Kornblow","Camp Chicolini","Camp Pinky",
			"Camp Fieramosca","Camp Bulldozer","Camp Bambino","Camp Pedersoli","Camp Twusty"];
usedCN = [];
cName = "";
cList = false;

// roadblocks and watchposts
FIA_RB_list = [];
FIA_WP_list = [];

expCrate = ""; // Devin's crate

if (!isServer) exitWith {};

server setVariable ["milActive", 0, true];
server setVariable ["civActive", 0, true];
server setVariable ["expActive", false, true];
server setVariable ["blockCSAT", false, true];
server setVariable ["jTime", 0, true];

server setVariable ["genLMGlocked",true,true];
server setVariable ["genGLlocked",true,true];
server setVariable ["genSNPRlocked",true,true];
server setVariable ["genATlocked",true,true];
server setVariable ["genAAlocked",true,true];

//Pricing values for soldiers, vehicles
{server setVariable [_x,50,true]} forEach [guer_sol_RFL,guer_sol_R_L,guer_sol_UN];
{server setVariable [_x,100,true]} forEach [guer_sol_MED,guer_sol_ENG,guer_sol_EXP,guer_sol_TL,guer_sol_AM];
{server setVariable [_x,200,true]} forEach [guer_sol_AR,guer_sol_GL,guer_sol_MRK,guer_sol_LAT]; // Stef Temporarnely increase to balance the not requirement
{server setVariable [_x,100,true]} forEach [guer_sol_SL,guer_sol_OFF,guer_sol_SN,guer_sol_AA];
{server setVariable [_x,100,true]} forEach infList_regular;
{server setVariable [_x,20,true]} forEach infList_auto;
{server setVariable [_x,150,true]} forEach infList_crew;
{server setVariable [_x,150,true]} forEach infList_pilots;
{server setVariable [_x,200,true]} forEach infList_special;
{server setVariable [_x,200,true]} forEach infList_NCO;
{server setVariable [_x,200,true]} forEach infList_sniper;


{server setVariable [_x,400,true]} forEach [guer_stat_MGH,guer_veh_dinghy,guer_veh_engineer];
{server setVariable [_x,800,true]} forEach [guer_stat_mortar,guer_stat_AT,guer_stat_AA];
server setVariable [vfs select 0,300,true];
server setVariable [vfs select 1,600,true];
server setVariable [vfs select 2,6000,true];
server setVariable [vfs select 3,50,true];
server setVariable [vfs select 4,200,true];
server setVariable [vfs select 5,450,true];
server setVariable [vfs select 6,700,true];
server setVariable [vfs select 7,400,true];
server setVariable [vfs select 8,800,true];
server setVariable [vfs select 9,800,true];
server setVariable [vfs select 10,800,true];
server setVariable [vfs select 13,400,true];
server setVariable [vfs select 14,12000,true];

server setVariable [twustyVefs select 1, 12000, true];
server setVariable [twustyVefs select 0, 400, true];

if (activeAFRF) then {
	server setVariable [vfs select 2,6000,true];
	server setVariable [vfs select 11,5000,true];
	server setVariable [vfs select 12,600,true];
	server setVariable [vehTruckAA, 800, true];

};

server setVariable ["hr",8,true];//initial HR value
server setVariable ["resourcesFIA",200,true];//Initial FIA money pool value
server setVariable ["resourcesAAF",0,true];//Initial AAF resources
server setVariable ["skillFIA",0,true];//Initial skill level for FIA soldiers
server setVariable ["prestigeNATO",5,true];//Initial Prestige NATO
server setVariable ["prestigeCSAT",5,true];//Initial Prestige CSAT

server setVariable ["enableFTold",false,true]; // extended fast travel mode
server setVariable ["enableMemAcc",false,true]; // simplified arsenal access
server setVariable ["enableWpnProf",true,true]; // class-based weapon proficiences, MP only

server setVariable ["easyMode",false,true]; // higher income
server setVariable ["hardMode",false,true];
server setVariable ["testMode",false,true];

server setVariable ["allItems", []];

staticsToSave = []; publicVariable "staticsToSave";
staticsData = []; publicVariable "staticsData";
prestigeOPFOR = 50;//Initial % support for AAF on each city
if (not cadetMode) then {prestigeOPFOR = 75};//if you play on vet, this is the number
prestigeBLUFOR = 0;//Initial % FIA support on each city
planesAAFmax = 0;
helisAAFmax = 0;
APCAAFmax = 0;
tanksAAFmax = 0;
cuentaCA = 600;//600
prestigeIsChanging = false;
cityIsSupportChanging = false;
resourcesIsChanging = false;
flag_savingServer = false;
flag_chopForest = false;
misiones = [];
revelar = false;

vehInGarage = ["C_Van_01_transport_F","C_Offroad_01_F","C_Offroad_01_F",guer_veh_quad,guer_veh_quad,guer_veh_quad]; // initial motorpool
destroyedBuildings = []; publicVariable "destroyedBuildings";
reportedVehs = [];

activeXLA = false;
if !(isnil "XLA_fnc_addVirtualItemCargo") then {
	activeXLA = true;
};

[] call AS_fnc_detectTFAR;

FIA_texturedVehicles = [];
FIA_texturedVehicleConfigs = [];
_allVehicles = configFile >> "CfgVehicles";
for "_i" from 0 to (count _allVehicles - 1) do {
    _vehicle = _allVehicles select _i;
    if (toUpper (configName _vehicle) find "DGC_FIAVEH" >= 0) then {
    	FIA_texturedVehicles pushBackUnique (configName _vehicle);
    	FIA_texturedVehicleConfigs pushBackUnique _vehicle;
    };
};

activeBE = false;
#include "Scripts\BE_modul.sqf"
[] call fnc_BE_initialize;
if !(isNil "BE_INIT") then {activeBE = true; publicVariable "activeBE"};

allItems = genItems + genOptics + genVests + genHelmets;
[unlockedWeapons, "unlockedMagazines"] call AS_fnc_MAINT_missingAmmo;

publicVariable "unlockedWeapons";
publicVariable "unlockedRifles";
publicVariable "unlockedItems";
publicVariable "unlockedOptics";
publicVariable "unlockedBackpacks";
publicVariable "unlockedMagazines";
publicVariable "membersPool";
publicVariable "vehInGarage";
publicVariable "reportedVehs";
publicVariable "activeACE";
publicVariable "activeTFAR";
publicVariable "activeXLA";
publicVariable "activeACEhearing";
publicVariable "activeACEMedical";
publicVariable "skillAAF";
publicVariable "misiones";
publicVariable "revelar";
publicVariable "FIA_texturedVehicles";
publicVariable "FIA_texturedVehicleConfigs";
publicVariable "activeBE";
publicVariable "FIA_WP_list";
publicVariable "FIA_RB_list";
publicVariable "reducedGarrisons";
publicVariable "replaceFIA";
publicVariable "static_playerSide";

_armors = "((configName (_x)) isKindof ['Bag_Base', configFile >> 'cfgVehicles'])" configClasses (configFile >> "cfgVehicles");
armorItems = _armors apply {configName _x};
allWeapons = lockedWeapons - vanillaWeapons;
allItems = gear_allAccessories  - vanillaAccessories;  


publicVariable "allWeapons";
publicVariable "allItems";
publicVariable "armorItems";


if (isMultiplayer) then {[[petros,"locHint","STR_HINTS_INITVAR"],"commsMP"] call BIS_fnc_MP;};

diag_log "InitVar.sqf: end";
