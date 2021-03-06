/*
	Author: original by Vampire, completely rewritten by IT07

	Description:
	spawns VEMFr AI using given _pos and unit/group count. Handles their inventory and transfers them to a client

	Params:
	_this select 0: POSITION - where to spawn the units around
	_this select 1: SCALAR - how many groups to spawn
	_this select 2: SCALAR - how many units to put in each group
	_this select 3: SCALAR - AI mode
	_this select 4: STRING - exact config name of mission
	_this select 5: SCALAR - (optional) altitude to create units at
	_this select 6: SCALAR - (optional) spawn radius

	Returns:
	ARRAY with group(s)
*/

private ["_spawned","_allUnits","_pos"];
_spawned = [];
_allUnits = [];
_pos = param [0, [], [[]]];
if (_pos isEqualTypeArray [0,0,0]) then
{
	scopeName "outer";
	private ["_grpCount"];
	_grpCount = param [1, 1, [0]];
	if (_grpCount > 0) then
	{
		private ["_unitsPerGrp"];
		_unitsPerGrp = param [2, 1, [0]];
		if (_unitsPerGrp > 0) then
		{
			private ["_mode","_missionName"];
			_mode = param [3, -1, [0]];
			_missionName = param [4, "", [""]];
			if (_missionName in ("missionList" call VEMFr_fnc_getSetting) OR _missionName isEqualTo "Static") then
			{
				_altitude = param [5, 0, [0]];
				if not(_altitude isEqualTo 0) then
				{
					_pos = [_pos select 0, _pos select 1, _altitude];
				};
				_spawnRadius = param [6, 20, [0]];
				private [
					"_sldrClass","_hc","_aiDifficulty","_skills","_accuracy","_aimShake","_aimSpeed","_stamina","_spotDist","_spotTime","_courage","_reloadSpd","_commanding","_general","_units"
				];
				_sldrClass = "unitClass" call VEMFr_fnc_getSetting;
				_hc = "headLessClientSupport" call VEMFr_fnc_getSetting;
				_aiDifficulty = [["aiSkill"],["difficulty"]] call VEMFr_fnc_getSetting param [0, "Veteran", [""]];
				_skills = [["aiSkill", _aiDifficulty],["accuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"]] call VEMFr_fnc_getSetting;
				_accuracy = _skills select 0;
				_aimShake = _skills select 1;
				_aimSpeed = _skills select 2;
				_stamina = _skills select 3;
				_spotDist = _skills select 4;
				_spotTime = _skills select 5;
				_courage = _skills select 6;
				_reloadSpd = _skills select 7;
				_commanding = _skills select 8;
				_general = _skills select 9;

				_units = []; // Define units array. the for loops below will fill it with units
				for "_g" from 1 to _grpCount do // Spawn Groups near Position
				{
					private ["_groupSide"];
					_groupSide = ("unitClass" call VEMFr_fnc_getSetting) call VEMFr_fnc_checkSide;
					if not isNil"_groupSide" then
					{
						private["_grp"];
						_grp = createGroup _groupSide;
						_grp setBehaviour "AWARE";
						_grp setCombatMode "RED";
						_grp allowFleeing 0;
						for "_u" from 1 to _unitsPerGrp do
						{
							private ["_unit"];
							_unit = _grp createUnit [_sldrClass, _pos, [], _spawnRadius, "FORM"]; // Create Unit There
							_allUnits pushBack _unit;
							_unit addMPEventHandler ["mpkilled","if (isDedicated) then { [_this select 0, _this select 1] spawn VEMFr_fnc_aiKilled }"];

							// Set skills
							_unit setSkill ["aimingAccuracy", _accuracy];
							_unit setSkill ["aimingShake", _aimShake];
							_unit setSkill ["aimingSpeed", _aimSpeed];
							_unit setSkill ["endurance", _stamina];
							_unit setSkill ["spotDistance", _spotDist];
							_unit setSkill ["spotTime", _spotTime];
							_unit setSkill ["courage", _courage];
							_unit setSkill ["reloadSpeed", _reloadSpd];
							_unit setSkill ["commanding", _commanding];
							_unit setSkill ["general", _general];
							_unit setRank "Private"; // Set rank
							if (_u isEqualTo _unitsPerGrp) then
							{
								_grp selectLeader _unit; // Leader Assignment
							};
						};
						_grp enableAttack true;
						_spawned pushBack _grp;
					} else
					{
						["fn_spawnVEMFrAI", 0, "failed to retrieve _groupSide"] spawn VEMFr_fnc_log;
						breakOut "outer";
					};
				};

				private ["_invLoaded"];
				_invLoaded = [_allUnits, _missionName, _mode] call VEMFr_fnc_loadInv; // Load the AI's inventory
				if not _invLoaded then
				{
					_spawned = false;
					["fn_spawnVEMFrAI", 0, "failed to load AI's inventory..."] spawn VEMFr_fnc_log;
					breakOut "outer";
				};
			} else
			{
				["fn_spawnVEMFrAI", 0, format["(%1) is not in missionList!"]] spawn VEMFr_fnc_log;
				breakOut "outer";
			};
		};
	};
};

_spawned
