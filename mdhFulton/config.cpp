//#include "ui\mdhFulton_ui_controls1.cpp"

class CfgPatches 
{
	class mdhFulton
	{
		author = "Moerderhoschi";
		name = "Fulton Recovery";
		url = "http://moerderhoschi.bplaced.net";
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		version = "1.20160815";
		versionStr = "1.20160815";
		versionAr[] = {1,20160816};
		authors[] = {};
	};
};

class CfgFunctions
{
	class mdh
	{
		class mdhFunctions
		{
			class mdhFulton
			{
				file = "mdhFulton\init.sqf";
				postInit = 1;
			};
		};
	};
};

class CfgMods
{
	class mdhFulton
	{
		dir = "@mdhFulton";
		name = "Fulton Recovery";
		picture = "a3\air_f_beta\Parachute_01\Data\ui\map_parachute_01_ca.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "http://moerderhoschi.bplaced.net";
	};
};