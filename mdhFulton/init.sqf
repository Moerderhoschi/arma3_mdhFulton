///////////////////////////////////////////////////////////////////////////////////////////////////
// MDH FULTON RECOVERY MOD(by Moerderhoschi) - v2025-03-16
// github: https://github.com/Moerderhoschi/arma3_mdhFulton
// https://steamcommunity.com/sharedfiles/filedetails/?id=746299408
///////////////////////////////////////////////////////////////////////////////////////////////////
if (!hasInterface) exitWith {};
0 spawn
{
	///////////////////////////////////////////////////////////////////////////////////////////////////
	// DIARYRECORD
	///////////////////////////////////////////////////////////////////////////////////////////////////
	_diary =
	{
		waitUntil {!(isNull player)};
		_c = true;
		_t = "Fulton Recovery";
		if (player diarySubjectExists "MDH Mods") then
		{
			{
				if (_x#1 == _t) then {_c = false}
			} forEach (player allDiaryRecords "MDH Mods");
		}
		else
		{
			player createDiarySubject ["MDH Mods","MDH Mods"];
		};

		if(_c) then
		{
			player createDiaryRecord
			[
				"MDH Mods",
				[
					_t,
					(
						'<br/>Fulton Recovery is a mod, created by Moerderhoschi for Arma 3, to enable a fulton recovery like in MGSV for units and vehicles. '
					  + 'If you have any question you can contact me at the steam workshop page.<br/>'
					  + '<br/>'
					  + 'To activate Fulton Recovery to some specific units only, put the following into the initfield of the units:<br/>'
					  + '<br/>'
					  + 'this setVariable [ "mdhFulton" , [] ]<br/>'
					  + 'or<br/>'
					  + 'this setVariable [ "mdhFulton" , ["actionTitle"] ]<br/>'
					  + 'or<br/>'
					  + 'this setVariable [ "mdhFulton" , ["actionTitle",5] ]<br/>'
					  + 'or<br/>'
					  + 'this setVariable [ "mdhFulton" , ["actionTitle",5,"setThisVarTrueWhenFulton"] ]<br/>'
					  + '<br/>'
					  + 'For the Recoverypoint make a marker anywhere on the map an name it fulton'
					  + '<br/>'
					  + 'If no marker named fulton is on the map the lifted vehicle will be deleted'
					  + '<br/>'
					  + '<img image="mdhFulton\fulton.paa"/>'
					  + '<br/>'
					  + 'Credits and Thanks:<br/>'
					  + 'Robert Edison Fulton, Jr. for the developement of Fulton system<br/>'
					  + 'Hideo Kojima - for the great idea to use the fulton recovery in MGSV<br/>'
					  + 'Armed-Assault.de Crew - For many great ArmA moments in many years<br/>'
					  + 'BIS - For ArmA3<br/>'
					)
				]
			]
		};
		true
	};
	
	///////////////////////////////////////////////////////
	// set fulton function
	///////////////////////////////////////////////////////
	_fulton =
	{
		_u = _this select 0; // object to fulton
		_t = _this select 1; // title
		_d = _this select 2; // duration
		_a = _this select 3; // var to set to true
	
		[
			_u,                                 // target: Object - Object the action is attached to 
			_t,                                 // title: String - Title of the action shown in the action menu
			"mdhFulton\fulton.paa",             // idleIcon: String - Idle icon shown on screen
			"mdhFulton\fulton.paa",             // progressIcon: String - Progress icon shown on screen
			("vehicle player == player && {player distance _target < 9} && {!(_target getVariable ['mdhFultonActive',false])}"), // condShow: String - Condition for the action to be shown. Special variables passed to the script code are _target (unit to which action is attached to) and _this (caller/executing unit)
			"true",                             // condProgress: String - Condition for the action to progress.If false is returned action progress is halted; arguments passed into it are: _target, _caller, _id, _arguments
			{},                                 // codeStart: Code - Code executed when action starts.
													// 0: Object - target (_this select 0) - the object which the action is assigned to
													// 1: Object - caller (_this select 1) - the unit that activated the action
													// 3: Number - ID (_this select 2) - ID of the activated action (same as ID returned by addAction)
													// 4: Array - arguments (_this select 3) - arguments given to the script if you are using the extended syntax	
			{},                           	    // codeProgress: Code - Code executed on every progress tick; arguments [target, caller, ID, arguments, currentProgress]; max progress is always 24
			{                                   
				0 =
				[
					_this select 0,
					_this select 3
				]
				spawn
				{
					_u = _this select 0;
					_a = _this select 1 select 0;
					_u setVariable ["mdhFultonActive",true];
					_p = "B_Parachute_02_F" createVehicle getPos _u;
					_p setDir getDir _u;
					_p setPos getPos _u;
					_p attachTo [_u, getCenterOfMass _u ];
					sleep 4; 
					_h = 100; 
					_h = 4000; 
					_v = 1;
					if (_a != "") then {call compile format [" %1 = true; publicVariable '%1' ",_a]};
					detach _p;
					_u attachTo [_p, [-(getCenterOfMass _u select 0),-(getCenterOfMass _u select 1),-(getCenterOfMass _u select 2)] ];
					_sleep = 0.02;
					//_sPBT = 0;
					while {(getPos _p select 2) < _h} do
					{
						_p setVelocity [0,0,_v];
						//if (_sPBT >= 1) then
						//{
							[_p, 0, 0] call BIS_fnc_setPitchBank;
						//};
						_v = _v + 1;
						//_sPBT = _sPBT + _sleep;
						sleep _sleep;
					};

					_m = "";
					{
						_s = "_USER_DEFINED #" + getPlayerID player;
						if (_x find _s > -1) then
						{
							if (toLower(markerText _x) find "fulton" > -1) exitWith
							{
								_m = _x;
							};
						};
					} forEach allMapMarkers;

					if (_m == "") then
					{
						{
							if (toLower(markerText _x) find "fulton" > -1) exitWith
							{
								_m = _x;
							};
						} forEach allMapMarkers;
					};

					if (_m != "") then
					{
						_d = getMarkerPos _m;
						_r = random 10 - random 10;
						_c = _d findEmptyPosition [5, 100, (typeOf _u)];
						if (str(_c) != "[]") then
						{
							_p setPos [_c select 0, _c select 1, _h];
						}
						else
						{
							_p setPos [(_d select 0)+_r, (_d select 1)+_r, _h];
						};

						_u allowDamage false;
						while {(getPos _p select 2) > 1} do  
						{
							if (getPos _p select 2 < 50) then
							{
								_v = (getPos _p select 2);
							};
							//if (_sPBT >= 1) then
							//{
								[_p, 0, 0] call BIS_fnc_setPitchBank;
							//};
							_v = _v - 1;
							if (_v < 6) then {_v = 6};
							//_sPBT = _sPBT + _sleep;
							_p setVelocity [0,0,-_v];
							sleep _sleep;
						};
						deTach _u;
						_uPos = getPos _u;
						_u setPos [_uPos select 0, _uPos select 1, 0];
						_u setVariable ["mdhFultonActive",nil];
						sleep 2;
						_u allowDamage true;
					}
					else
					{
						detach _u;
						_u setVariable ["mdhFultonActive",nil];
						{_u deleteVehicleCrew _x} forEach crew _u;
						sleep 0.5;
						deleteVehicle _p;
						if (_u in allPlayers) then
						{
							removeBackpackGlobal _u;
							_u addBackpackGlobal "B_Parachute";
						}
						else
						{
							if (count crew _u > 0) then
							{
								{
									removeBackpackGlobal _x;
									_x addBackpackGlobal "B_Parachute";
									sleep 0.5;
									moveOut _x;
								} forEach crew _u;
								
							};

							sleep 0.5;
							deleteVehicle _u;
						};
					};
				}; 
			}, 									// codeCompleted: Code - Code executed on completion; arguments [target, caller, ID, arguments]
			{},                                 // codeInterupted: Code - Code executed on interrupted; arguments [target, caller, ID, arguments]
			[_a],                               // arguments: Array - Arguments passed to the scripts
			_d,                                 // duration: Number - Action duration; how much time it takes to complete the action
			-19,                                // priority: Number - Priority; actions are arranged in descending order according to this value
			false,                              // removeCompleted: BOOL - Remove on completion (default: true)
			false,                              // showUncon: BOOL -Show in unconscious state (default: false)
			false                               // showWindow: Boolean - (Optional, default true) show on screen; if false action needs to be selected from action menu to appear on screen
		] call BIS_fnc_holdActionAdd;
	};
	
	///////////////////////////////////////////////////////
	// loop
	///////////////////////////////////////////////////////
	_mdhFultonAssignedExplicit = false;
	while {hasInterface} do
	{
		uiSleep 0.9;
		call _diary;
		sleep 0.5;

		//systemChat (str(time) + " -- gather _list start");
		_list = vehicles;
		_list = _list + allUnits;
		_list = _list + allDead;
		//systemChat (str(time) + " -- gather _list end");
	
		//systemChat (str(time) + " -- chekFultonAssigned start");
		_mdhFultonAssignedExplicitCheck = ({"false" != str(_x getVariable ["mdhFulton",false])} count _list > 0);
		if (_mdhFultonAssignedExplicitCheck) then
		{
			_mdhFultonAssignedExplicit = true;
		};
		//systemChat (str(time) + " -- chekFultonAssigned end");
	
		//systemChat (str(time) + " -- go trough _list");
		{
			if (_mdhFultonAssignedExplicit) then
			{
				_mdhFultonAssigned = ("false" != str(_x getVariable ["mdhFulton",false]));
				_mdhFultonAlreadySet = (_x getVariable ["mdhFultonSet",false]);
				if (_mdhFultonAssigned && !_mdhFultonAlreadySet) then
				{
					_typeName = (typeName (_x getVariable ["mdhFulton",false]));
					if (_typeName == "ARRAY") then
					{
						_arr = (_x getVariable ["mdhFulton",false]);
						_w = "Fulton Recovery";
						_t = (if (count _arr > 0) then {if (typeName (_arr select 0) == "STRING") then {_arr select 0} else {_w}} else {_w}); // title
						_w = 3;
						_d = (if (count _arr > 1) then {if (typeName (_arr select 1) == "SCALAR") then {_arr select 1} else {_w}} else {_w}); // duration
						_w = "";
						_a = (if (count _arr > 2) then {if (typeName (_arr select 2) == "STRING") then {_arr select 2} else {_w}} else {_w}); // var to set to true

						_x setVariable ["mdhFultonSet",true];
						0 = [_x,_t,_d,_a] call _fulton;
					}
					else
					{
						systemChat
						(
							"mdhFulton false parameter set --> " + str(_x) + " --> falseParam: " + str(_x getVariable ["mdhFulton",false])
							+ ' --> correct Parameter format is ["actionTitle",5,"myVarToSetToTrueWhenFulton"]'
						);
						
					};
				};
			}
			else
			{
				//_mdhFultonAlreadySet = (_x getVariable ["mdhFultonSet",false]);
				_found = false;
				_u = _x;
				{
					if( ((_u actionParams _x) select 0) find "Fulton" > -1 ) then
					{
						_found = true;
					}
				}forEach actionIDs _u;
				if
				(
					//!_mdhFultonAlreadySet && 
					_x != player && 
					!_found
				)then
				{
					//_x setVariable ["mdhFultonSet",true];
					0 = [_x,"Attach Fulton",4,""] call _fulton;
				};
			};
		} forEach _list;

		sleep 5;
		sleep random 1;
	};
};