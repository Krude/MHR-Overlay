local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local env_creature;
local player_info;
local time;
local abnormal_statuses;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

this.list = {
	burst = nil,
	kushala_daora_soul = nil,
	intrepid_heart = nil,
	dereliction = nil,
	latent_power = nil,
	wind_mantle = nil,
	grinder_s = nil,
	counterstrike = nil,
	affinity_sliding = nil,
	coalescence = nil,
	adrenaline_rush = nil,
	wall_runner = nil,
	offensive_guard = nil,
	hellfire_cloak = nil,
	agitator = nil,
	furious = nil,
	heaven_sent = nil,
	heroics = nil,
	resuscitate = nil,
	maximum_might = nil,
	bloodlust = nil,
	frenzied_bloodlust = nil,
	peak_performance = nil,
	dragonheart = nil,
	resentment = nil
};

local skill_data_list = {
	-- 1 	Pl_EquipSkill_000 	Attack Boost
	-- 2 	Pl_EquipSkill_001 	Agitator
	-- 3 	Pl_EquipSkill_002 	Peak Performance
	peak_performance =	{ id = 3,	level = 0, is_equipped = false },
	-- 4 	Pl_EquipSkill_003 	Resentment
	resentment =		{ id = 4,	level = 0, is_equipped = false },
	-- 5 	Pl_EquipSkill_004 	Resuscitate
	resuscitate =		{ id = 5,	level = 0, is_equipped = false },
	-- 6 	Pl_EquipSkill_005 	Critical Eye
	-- 7 	Pl_EquipSkill_006 	Critical Boost
	-- 8 	Pl_EquipSkill_007 	Weakness Exploit
	-- 9 	Pl_EquipSkill_008 	Latent Power
	-- 10 	Pl_EquipSkill_009 	Maximum Might
	maximum_might =		{ id = 10,	level = 0, is_equipped = false },
	-- 11 	Pl_EquipSkill_010 	Critical Element
	-- 12 	Pl_EquipSkill_011 	Master's Touch
	-- 13 	Pl_EquipSkill_012 	Fire Attack
	-- 14 	Pl_EquipSkill_013 	Water Attack
	-- 15 	Pl_EquipSkill_014 	Ice Attack
	-- 16 	Pl_EquipSkill_015 	Thunder Attack
	-- 17 	Pl_EquipSkill_016 	Dragon Attack
	-- 18 	Pl_EquipSkill_017 	Poison Attack
	-- 19 	Pl_EquipSkill_018 	Paralysis Attack
	-- 20 	Pl_EquipSkill_019 	Sleep Attack
	-- 21 	Pl_EquipSkill_020 	Blast Attack
	-- 22 	Pl_EquipSkill_021 	Handicraft
	-- 23 	Pl_EquipSkill_022 	Razor Sharp
	-- 24 	Pl_EquipSkill_023 	Spare Shot
	-- 25 	Pl_EquipSkill_024 	Protective Polish
	-- 26 	Pl_EquipSkill_025 	Mind's Eye
	-- 27 	Pl_EquipSkill_026 	Ballistics
	-- 28 	Pl_EquipSkill_027 	Bludgeoner
	-- 29 	Pl_EquipSkill_028 	Bow Charge Plus
	-- 30 	Pl_EquipSkill_029 	Focus
	-- 31 	Pl_EquipSkill_030 	Power Prolonger
	-- 32 	Pl_EquipSkill_031 	Marathon Runner
	-- 33 	Pl_EquipSkill_032 	Constitution
	-- 34 	Pl_EquipSkill_033 	Stamina Surge
	-- 35 	Pl_EquipSkill_034 	Guard
	-- 36 	Pl_EquipSkill_035 	Guard Up
	-- 37 	Pl_EquipSkill_036 	Offensive Guard
	-- 38 	Pl_EquipSkill_037 	Critical Draw
	-- 39 	Pl_EquipSkill_038 	Punishing Draw
	-- 40 	Pl_EquipSkill_039 	Quick Sheathe
	-- 41 	Pl_EquipSkill_040 	Slugger
	-- 42 	Pl_EquipSkill_041 	Stamina Thief
	-- 43 	Pl_EquipSkill_042 	Affinity Sliding
	-- 44 	Pl_EquipSkill_043 	Horn Maestro
	-- 45 	Pl_EquipSkill_044 	Artillery
	-- 46 	Pl_EquipSkill_045 	Load Shells
	-- 47 	Pl_EquipSkill_046 	Special Ammo Boost
	-- 48 	Pl_EquipSkill_047 	Normal/Rapid Up
	-- 49 	Pl_EquipSkill_048 	Pierce Up
	-- 50 	Pl_EquipSkill_049 	Spread Up
	-- 51 	Pl_EquipSkill_050 	Ammo Up
	-- 52 	Pl_EquipSkill_051 	Reload Speed
	-- 53 	Pl_EquipSkill_052 	Recoil Down
	-- 54 	Pl_EquipSkill_053 	Steadiness
	-- 55 	Pl_EquipSkill_054 	Rapid Fire Up
	-- 56 	Pl_EquipSkill_055 	Defense Boost
	-- 57 	Pl_EquipSkill_056 	Divine Blessing
	-- 58 	Pl_EquipSkill_057 	Recovery Up
	-- 59 	Pl_EquipSkill_058 	Recovery Speed
	-- 60 	Pl_EquipSkill_059 	Speed Eating
	-- 61 	Pl_EquipSkill_060 	Earplugs
	-- 62 	Pl_EquipSkill_061 	Windproof
	-- 63 	Pl_EquipSkill_062 	Tremor Resistance
	-- 64 	Pl_EquipSkill_063 	Bubbly Dance
	-- 65 	Pl_EquipSkill_064 	Evade Window
	-- 66 	Pl_EquipSkill_065 	Evade Extender
	-- 67 	Pl_EquipSkill_066 	Fire Resistance
	-- 68 	Pl_EquipSkill_067 	Water Resistance
	-- 69 	Pl_EquipSkill_068 	Ice Resistance
	-- 70 	Pl_EquipSkill_069 	Thunder Resistance
	-- 71 	Pl_EquipSkill_070 	Dragon Resistance
	-- 72 	Pl_EquipSkill_071 	Blight Resistance
	-- 73 	Pl_EquipSkill_072 	Poison Resistance
	-- 74 	Pl_EquipSkill_073 	Paralysis Resistance
	-- 75 	Pl_EquipSkill_074 	Sleep Resistance
	-- 76 	Pl_EquipSkill_075 	Stun Resistance
	-- 77 	Pl_EquipSkill_076 	Muck Resistance
	-- 78 	Pl_EquipSkill_077 	Blast Resistance
	-- 79 	Pl_EquipSkill_078 	Botanist
	-- 80 	Pl_EquipSkill_079 	Geologist
	-- 81 	Pl_EquipSkill_080 	Partbreaker
	-- 82 	Pl_EquipSkill_081 	Capture Master
	-- 83 	Pl_EquipSkill_082 	Carving Master
	-- 84 	Pl_EquipSkill_083 	Good Luck
	-- 85 	Pl_EquipSkill_084 	Speed Sharpening
	-- 86 	Pl_EquipSkill_085 	Bombardier
	-- 87 	Pl_EquipSkill_086 	Mushroomancer
	-- 88 	Pl_EquipSkill_087 	Item Prolonger
	-- 89 	Pl_EquipSkill_088 	Wide-Range
	-- 90 	Pl_EquipSkill_089 	Free Meal
	-- 91 	Pl_EquipSkill_090 	Heroics
	heroics =			{ id = 91,	level = 0, is_equipped = false },
	-- 92 	Pl_EquipSkill_091 	Fortify
	-- 93 	Pl_EquipSkill_092 	Flinch Free
	-- 94 	Pl_EquipSkill_093 	Jump Master
	-- 95 	Pl_EquipSkill_094 	Carving Pro
	-- 96 	Pl_EquipSkill_095 	Hunger Resistance
	-- 97 	Pl_EquipSkill_096 	Leap of Faith
	-- 98 	Pl_EquipSkill_097 	Diversion
	-- 99 	Pl_EquipSkill_098 	Master Mounter
	-- 100 	Pl_EquipSkill_099 	Chameleos Blessing
	-- 101 	Pl_EquipSkill_100 	Kushala Blessing
	-- 102 	Pl_EquipSkill_101 	Teostra Blessing
	-- 103 	Pl_EquipSkill_102 	Dragonheart
	dragonheart =		{ id = 103,	level = 0, is_equipped = false },
	-- 104 	Pl_EquipSkill_103 	Wirebug Whisperer
	-- 105 	Pl_EquipSkill_104 	Wall Runner
	-- 106 	Pl_EquipSkill_105 	Counterstrike
	-- 107 	Pl_EquipSkill_106 	Rapid Morph
	-- 108 	Pl_EquipSkill_107 	Hellfire Cloak
	-- 109 	Pl_EquipSkill_108 	Wind Alignment
	-- 110 	Pl_EquipSkill_109 	Thunder Alignment
	-- 111 	Pl_EquipSkill_110 	Stormsoul
	-- 112 	Pl_EquipSkill_200 	Blood Rite
	-- 113 	Pl_EquipSkill_201 	Dereliction
	dereliction =		{ id = 113, level = 0, is_equipped = false },
	-- 114 	Pl_EquipSkill_202 	Furious
	-- 115 	Pl_EquipSkill_203 	Mail of Hellfire
	-- 116 	Pl_EquipSkill_204 	Coalescence
	-- 117 	Pl_EquipSkill_205 	Bloodlust
	bloodlust =			{ id = 117,	level = 0, is_equipped = false },
	-- 118 	Pl_EquipSkill_206 	Defiance
	-- 119 	Pl_EquipSkill_207 	Sneak Attack
	-- 120 	Pl_EquipSkill_208 	Adrenaline Rush
	-- 122 	Pl_EquipSkill_209 	Redirection
	-- 123 	Pl_EquipSkill_210 	Spiribird's Call
	-- 124 	Pl_EquipSkill_211 	Charge Master
	-- 125 	Pl_EquipSkill_212 	Foray
	-- 126 	Pl_EquipSkill_213 	Tune-Up
	-- 127 	Pl_EquipSkill_214 	Grinder (S)
	-- 128 	Pl_EquipSkill_215 	Bladescale Hone
	-- 129 	Pl_EquipSkill_216 	Wall Runner (Boost)
	-- 133 	Pl_EquipSkill_217 	Quick Breath
	-- 130 	Pl_EquipSkill_218 	Element Exploit
	-- 131 	Pl_EquipSkill_219 	Burst
	-- 132 	Pl_EquipSkill_220 	Guts
	-- 134 	Pl_EquipSkill_221 	Status Trigger
	-- 135 	Pl_EquipSkill_222 	Intrepid Heart
	-- 136 	Pl_EquipSkill_223 	Buildup Boost
	-- 121 	Pl_EquipSkill_224 	Embolden
	-- 138 	Pl_EquipSkill_225 	Wind Mantle
	-- 139 	Pl_EquipSkill_226 	Powder Mantle
	-- 137 	Pl_EquipSkill_227 	Berserk
	-- 145 	Pl_EquipSkill_228 	Strife
	-- 140 	Pl_EquipSkill_229 	Frostcraft
	-- 141 	Pl_EquipSkill_230 	Dragon Conversion
	-- 142 	Pl_EquipSkill_231 	Heaven-Sent
	-- 143 	Pl_EquipSkill_232 	Frenzied Bloodlust
	-- 144 	Pl_EquipSkill_233 	Blood Awakening
	-- 146 	Pl_EquipSkill_234 	Shock Absorber
	-- 147 	Pl_EquipSkill_235 	Inspiration
}

local burst_breakpoint = 5;
local kushara_daora_soul_breakpoint = 5;
local intrepid_heart_minimal_value = 400;
local dereliction_breakpoints = {100, 50};

local maximum_might_delay_timer = nil;
local maximum_might_previous_timer_value = 0;

local frenzied_bloodlust_duration = 0;
local frenzied_bloodlust_sheathed_duration = 0;

local dragonheart_breakpoints = {0.5, 0.5, 0.7, 0.7, 0.8};

local wind_mantle_duration = 15;
local wind_mantle_breakpoints = { 20, 10 }; -- Sword & Shield, Lance, Hammer, Switch Axe, Insect Glaive, Long Sword, Hunting Horn
local wind_mantle_special_breakpoints = {
	[0]  = { 10,  5 }, -- Great Sword
	[3]  = { 60, 30 }, -- Light Bowgun
	[4]  = { 60, 30 }, -- Heavy Bowgun
	[6]  = { 30, 15 }, -- Gunlance
	[9]  = { 40, 20 }, -- Dual Blades
	[11] = { 30, 15 }, -- Charge Blade
	[13] = { 60, 30 }, -- Bow
}

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_player_data_method = player_manager_type_def:get_method("get_PlayerData");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Burst
local rengeki_power_up_count_field = player_data_type_def:get_field("_RengekiPowerUpCnt");
local rengeki_power_up_timer_field = player_data_type_def:get_field("_RengekiPowerUpTimer");
-- Kushala Daora Soul
local hyakuryu_dragon_power_up_count_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpCnt");
local hyakuryu_dragon_power_up_timer_field = player_data_type_def:get_field("_HyakuryuDragonPowerUpTimer");
-- Intrepid Heart
local equip_skill_223_accumulator_field = player_data_type_def:get_field("_EquipSkill223Accumulator");
-- Derelection
local symbiosis_skill_lost_vital_field = player_data_type_def:get_field("_SymbiosisSkillLostVital");
-- Grinder (S)
local brand_new_sharpness_adjust_up_timer_field = player_data_type_def:get_field("_BrandNewSharpnessAdjustUpTimer");
-- Counterstrike
local counterattack_powerup_timer_field = player_data_type_def:get_field("_CounterattackPowerupTimer");
-- Affinity Sliding
local sliding_powerup_timer_field = player_data_type_def:get_field("_SlidingPowerupTimer");
-- Coalescence
local disaster_turn_powerup_timer_field = player_data_type_def:get_field("_DisasterTurnPowerUpTimer");
-- Adrenaline Rush
local equip_skill_208_atk_up_field = player_data_type_def:get_field("_EquipSkill208_AtkUpTimer");
-- Wall Runner
local wall_run_powerup_timer_field = player_data_type_def:get_field("_WallRunPowerupTimer");
-- Offensive Guard
local equip_skill_036_timer_field = player_data_type_def:get_field("_EquipSkill_036_Timer");
-- Hellfire Cloak
local onibi_powerup_timer_field = player_data_type_def:get_field("_OnibiPowerUpTiemr");
-- Agitator
local challenge_timer_field = player_data_type_def:get_field("_ChallengeTimer");
-- Furious
local furious_skill_stamina_buff_second_timer_field = player_data_type_def:get_field("_FuriousSkillStaminaBuffSecondTimer");
-- Maximum Might
local whole_body_timer_field = player_data_type_def:get_field("_WholeBodyTimer");
-- Frenzied Bloodlust
local equip_skill_231_wire_num_timer_field = player_data_type_def:get_field("_EquipSkill231_WireNumTimer");
local equip_skill_231_wp_off_timer_field = player_data_type_def:get_field("_EquipSkill231_WpOffTimer");
-- Resentment
local r_vital_field = player_data_type_def:get_field("_r_Vital");
-- Status Trigger
local equip_skill_222_timer_field = player_data_type_def:get_field("_EquipSkill222_Timer");



local player_base_type_def = sdk.find_type_definition("snow.player.PlayerBase");
local player_weapon_type_field = player_base_type_def:get_field("_playerWeaponType");
local get_player_skill_list_method = player_base_type_def:get_method("get_PlayerSkillList");

-- Latent Power
local power_freedom_timer_field = player_base_type_def:get_field("_PowerFreedomTimer");
-- Protective Polish
local sharpness_gauge_boost_timer_field = player_base_type_def:get_field("_SharpnessGaugeBoostTimer");
-- Heroics
local is_predicament_power_up_method = player_base_type_def:get_method("isPredicamentPowerUp");
-- Resuscitate
local is_debuff_state_method = player_base_type_def:get_method("isDebuffState");


local player_skill_list_type_def = get_player_skill_list_method:get_return_type();
local get_skill_data_method = player_skill_list_type_def:get_method("getSkillData");

local skill_data_type_def = get_skill_data_method:get_return_type();
local skill_lv_field = skill_data_type_def:get_field("SkillLv");

local player_quest_base_type_def = sdk.find_type_definition("snow.player.PlayerQuestBase");
-- Wind Mantle
local equip_skill_226_attack_count_field = player_quest_base_type_def:get_field("_EquipSkill226AttackCount");
local equip_skill_226_attack_off_timer_field = player_quest_base_type_def:get_field("_EquipSkill226AttackOffTimer");
-- Heaven-Sent
local is_active_equip_skill_230_method = player_quest_base_type_def:get_method("isActiveEquipSkill230");
-- Frenzied Bloodlust
local get_hunter_wire_skill_231_num_method = player_quest_base_type_def:get_method("get_HunterWireSkill231Num");

local qeree = {};

function this.update(player, player_data)
	--local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	--if item_parameter == nil then
	--	error_handler.report("skills.update", "Failed to access Data: item_parameter");
	--	return;
	--end

	-- local fields = player_quest_base_type_def:get_fields();

	-- xy = "Player:\n";
	-- for i = 1, 999 do
	-- 	local field = fields[i];
	-- 	if field == nil then
	-- 		break;
	-- 	end

	-- 	local value = field:get_data(player);

	-- 	if qeree[field] == nil then
	-- 		qeree[field] = value;
	-- 	end

	-- 	if qeree[field] ~= value then
	-- 		xy = string.format("%s%d %s = %s\n", xy, i, field:get_name(), tostring(value));
	-- 	end
	-- end

	-- fields = player_data_type_def:get_fields();

	-- xy = xy .. "Player Data:\n";
	-- for i = 1, 999 do
	-- 	local field = fields[i];
	-- 	if field == nil then
	-- 		break;
	-- 	end

	-- 	local value = field:get_data(player_data);

	-- 	if qeree[field] == nil then
	-- 		qeree[field] = value;
	-- 	end

	-- 	if qeree[field] ~= value then
	-- 		xy = string.format("%s%d %s = %s\n", xy, i, field:get_name(), tostring(value));
	-- 	end
	-- end

	this.update_equipped_skill_data(player);

	this.update_dereliction(player_data);
	this.update_wind_mantle(player);
	this.update_maximum_might(player_data);
	this.update_bloodlust();
	this.update_frenzied_bloodlust(player, player_data);
	this.update_peak_performance();
	this.update_dragonheart();
	this.update_resentment(player_data);

	this.update_generic_number_value_field("burst", player_data,
		rengeki_power_up_count_field, rengeki_power_up_timer_field, false, nil, burst_breakpoint);

	this.update_generic_number_value_field("kushala_daora_soul", player_data,
		hyakuryu_dragon_power_up_count_field, hyakuryu_dragon_power_up_timer_field, false, nil, kushara_daora_soul_breakpoint);

	this.update_generic_number_value_field("intrepid_heart", player_data, equip_skill_223_accumulator_field, nil, true, intrepid_heart_minimal_value);
	this.update_generic_timer("latent_power", player, power_freedom_timer_field);
	this.update_generic_timer("protective_polish", player, sharpness_gauge_boost_timer_field);
	this.update_generic_timer("grinder_s", player_data, brand_new_sharpness_adjust_up_timer_field);
	this.update_generic_timer("counterstrike", player_data, counterattack_powerup_timer_field);
	this.update_generic_timer("affinity_sliding", player_data, sliding_powerup_timer_field);
	this.update_generic_timer("coalescence", player_data, disaster_turn_powerup_timer_field);
	this.update_generic_timer("adrenaline_rush", player_data, equip_skill_208_atk_up_field);
	this.update_generic_timer("wall_runner", player_data, wall_run_powerup_timer_field);
	this.update_generic_timer("offensive_guard", player_data, equip_skill_036_timer_field);
	this.update_generic_timer("hellfire_cloak", player_data, onibi_powerup_timer_field);
	this.update_generic_timer("agitator", player_data, challenge_timer_field, true);
	this.update_generic_timer("furious", player_data, furious_skill_stamina_buff_second_timer_field);
	this.update_generic_timer("status_trigger", player_data, equip_skill_222_timer_field);

	this.update_generic_boolean_value_method("heaven_sent", player, is_active_equip_skill_230_method);
	this.update_generic_boolean_value_method("heroics", player, is_predicament_power_up_method);
	this.update_generic_boolean_value_method("resuscitate", player, is_debuff_state_method);
end

function this.update_equipped_skill_data(player)
	local player_skill_list = get_player_skill_list_method:call(player);
	if player_skill_list == nil then
		error_handler.report("skills.update_equipped_skill_data", "Failed to access Data: player_skill_list");
		return;
	end

	-- xy = ""
	-- for i = 0, 999 do 
	-- 	local has_skill = has_skill_method:call(player_skill_list, i, 1);
	-- 	if has_skill then
	-- 		xy = string.format("%s%d = %s\n", xy, i, tostring(has_skill));
	-- 	end
	-- end

	for skill_key, skill_data in pairs(skill_data_list) do
		local re_skill_data = get_skill_data_method:call(player_skill_list, skill_data.id);
		if re_skill_data == nil then
			goto continue;
		end

		local skill_level = skill_lv_field:get_data(re_skill_data);
		if skill_level == nil then
			error_handler.report("skills.update_equipped_skill_data", string.format("Failed to access Data: %s -> skill_level", skill_key));
			goto continue;
		end


		if skill_level <= 0 then
			skill_data.is_equipped = false;
			skill_data.level = 0;
			goto continue;
		end

		skill_data.is_equipped = true;
		skill_data.level = skill_level;

		::continue::
	end
end

function this.update_generic_timer(skill_key, timer_owner, timer_field, is_infinite)
	if is_infinite == nil then is_infinite = false; end

	local skill_data = skill_data_list[skill_key];
	if skill_data ~= nil and not skill_data.is_equipped then
		this.list[skill_key] = nil;
		return;
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("skills.update_generic_timer", string.format("Failed to access Data: %s_timer", skill_key));
			return;
		end

		if utils.number.is_equal(timer, 0) then
			this.list[skill_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(skill_key, 1, timer);
end

function this.update_generic_number_value_field(skill_key, timer_owner, value_field, timer_field, is_infinite, minimal_value, level_breakpoint)
	if minimal_value == nil then minimal_value = 1; end
	level_breakpoint = level_breakpoint or 1000000;
	if is_infinite == nil then is_infinite = false; end

	local skill_data = skill_data_list[skill_key];
	if skill_data ~= nil and not skill_data.is_equipped then
		this.list[skill_key] = nil;
		return;
	end

	local level = 1;

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("skills.update_generic_number_value_field", string.format("Failed to access Data: %s_value", skill_key));
			return;
		end

		if value < minimal_value then
			this.list[skill_key] = nil;
			return;
		end

		if value >= level_breakpoint then
			level = 2;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("skills.update_generic_number_value_field", string.format("Failed to access Data: %s_timer", skill_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[skill_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(skill_key, level, timer);
end

function this.update_generic_boolean_value_field(skill_key, timer_owner, value_field, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	local skill_data = skill_data_list[skill_key];
	if skill_data ~= nil and not skill_data.is_equipped then
		this.list[skill_key] = nil;
		return;
	end

	if value_field ~= nil then
		local value = value_field:get_data(timer_owner);
		
		if value == nil then
			error_handler.report("skills.update_generic_boolean_value_field", string.format("Failed to access Data: %s_value", skill_key));
			return;
		end

		if value < minimal_value then
			this.list[skill_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("skills.update_generic_boolean_value_field", string.format("Failed to access Data: %s_timer", skill_key));
			return;
		end

		if value_field == nil and utils.number.is_equal(timer, 0) then
			this.list[skill_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(skill_key, 1, timer);
end

function this.update_generic_number_value_method(skill_key, timer_owner, value_method, timer_field, is_infinite, minimal_value, level_breakpoint)
	if minimal_value == nil then minimal_value = 1; end
	level_breakpoint = level_breakpoint or 1000000;
	if is_infinite == nil then is_infinite = false; end

	local skill_data = skill_data_list[skill_key];
	if skill_data ~= nil and not skill_data.is_equipped then
		this.list[skill_key] = nil;
		return;
	end

	local level = 1;

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		
		if value == nil then
			error_handler.report("skills.update_generic_number_value_method", string.format("Failed to access Data: %s_value", skill_key));
			return;
		end

		if value < minimal_value then
			this.list[skill_key] = nil;
			return;
		end

		if value >= level_breakpoint then
			level = 2;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("skills.update_generic_number_value_method", string.format("Failed to access Data: %s_timer", skill_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[skill_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(skill_key, level, timer);
end

function this.update_generic_boolean_value_method(skill_key, timer_owner, value_method, timer_field, is_infinite, minimal_value)
	if minimal_value == nil then minimal_value = true; end
	if is_infinite == nil then is_infinite = false; end

	local skill_data = skill_data_list[skill_key];
	if skill_data ~= nil and not skill_data.is_equipped then
		this.list[skill_key] = nil;
		return;
	end

	if value_method ~= nil then
		local value = value_method:call(timer_owner);
		
		if value == nil then
			error_handler.report("skills.update_generic_boolean_value_method", string.format("Failed to access Data: %s_value", skill_key));
			return;
		end

		if value ~= minimal_value then
			this.list[skill_key] = nil;
			return;
		end
	end

	local timer = nil;
	if timer_field ~= nil then
		timer = timer_field:get_data(timer_owner);
		if timer == nil then
			error_handler.report("skills.update_generic_boolean_value_method", string.format("Failed to access Data: %s_timer", skill_key));
			return;
		end

		if value_method == nil and utils.number.is_equal(timer, 0) then
			this.list[skill_key] = nil;
			return;
		end

		if is_infinite then
			timer = nil;
		else
			timer = timer / 60;
		end
	end

	this.update_generic(skill_key, 1, timer);
end

function this.update_generic(skill_key, level, timer, duration)
	duration = duration or timer;

	local skill = this.list[skill_key];
	if skill == nil then
		local name = language.current_language.skills[skill_key];
		
		skill = buffs.new(buffs.types.skill, skill_key, name, level, duration);
		this.list[skill_key] = skill;
	else
		skill.level = level;

		if timer ~= nil then
			buffs.update_timer(skill, timer);
		end
	end
end

function this.update_dereliction(player_data)
	if not skill_data_list.dereliction.is_equipped then
		this.list.dereliction = nil;
		return;
	end

	local dereliction_value = symbiosis_skill_lost_vital_field:get_data(player_data);
	if dereliction_value == nil then
		error_handler.report("skills.update_derelection", "Failed to access Data: dereliction_value");
		return;
	end

	if dereliction_value == 0 then
		this.list.dereliction = nil;
		return;
	end

	local level = 1;
	for index, breakpoint in ipairs(dereliction_breakpoints) do
		if dereliction_value >= breakpoint then
			level = 4 - index;
			break;
		end
	end

	local skill = this.list.dereliction;
	if skill == nil then
		local name = language.current_language.skills.dereliction;

		skill = buffs.new(buffs.types.skill, "dereliction", name, level);
		this.list.dereliction = skill;
	else
		skill.level = level;
	end
end

function this.update_wind_mantle(player)
	local wind_mantle_timer = equip_skill_226_attack_off_timer_field:get_data(player);
	if wind_mantle_timer == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to access Data: wind_mantle_timer");
		return;
	end

	if utils.number.is_equal(wind_mantle_timer, 0) then
		this.list.wind_mantle = nil;
		return;
	end

	local wind_mantle_value = equip_skill_226_attack_count_field:get_data(player);
	if wind_mantle_value == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to access Data: wind_mantle_value");
		return;
	end

	local weapon_type = player_weapon_type_field:get_data(player);
	if player == nil then
		error_handler.report("skills.update_wind_mantle", "Failed to access Data: weapon_type");
		return;
	end

	local breakpoints = wind_mantle_breakpoints;
	for weapon_type_index, special_breakpoints in pairs(wind_mantle_special_breakpoints) do
		if weapon_type == weapon_type_index then
			breakpoints = special_breakpoints;
			break;
		end
	end

	local level = 1;
	for index, breakpoint in ipairs(breakpoints) do
		if wind_mantle_value >= breakpoint then
			level = 4 - index;
			break;
		end
	end

	local skill = this.list.wind_mantle;
	if skill == nil then
		local name = language.current_language.skills.wind_mantle;

		skill = buffs.new(buffs.types.skill, "wind_mantle", name, level, wind_mantle_duration);
		this.list.wind_mantle = skill;
	else
		skill.level = level;
		buffs.update_timer(skill, wind_mantle_duration - (wind_mantle_timer / 60));
	end
end

function this.update_maximum_might(player_data)
	if not skill_data_list.maximum_might.is_equipped then
		this.list.maximum_might = nil;
		return;
	end

	local whole_body_timer = whole_body_timer_field:get_data(player_data);
	if whole_body_timer == nil then
		error_handler.report("skills.update_maximum_might", "Failed to access Data: whole_body_timer");
		return;
	end

	if player_info.list.max_stamina == -1 then
		return;
	end

	local skill = this.list.maximum_might;
	local is_timer_zero = utils.number.is_equal(whole_body_timer, 0);

	if player_info.list.stamina ~= player_info.list.max_stamina then
		if skill ~= nil and whole_body_timer < maximum_might_previous_timer_value then
			this.list.maximum_might = nil;
		end

	elseif skill == nil then
		local name = language.current_language.skills.maximum_might;

		if whole_body_timer < maximum_might_previous_timer_value then
			skill = buffs.new(type, "maximum_might", name, 1);
			this.list.maximum_might = skill;

		elseif is_timer_zero then
			if maximum_might_delay_timer == nil then
				maximum_might_delay_timer = time.new_delay_timer(function()
					maximum_might_delay_timer = nil;

					skill = buffs.new(type, "maximum_might", name, 1);
					this.list.maximum_might = skill;
				end, 3.5);
			end

		else
			time.remove_delay_timer(maximum_might_delay_timer);
		end
	end

	maximum_might_previous_timer_value = whole_body_timer;
end

function this.update_bloodlust()
	if not skill_data_list.bloodlust.is_equipped then
		this.list.bloodlust = nil;
		return;
	end

	if not abnormal_statuses.list.frenzy_infection
	and not abnormal_statuses.list.frenzy_overcome then
		this.list.bloodlust = nil;
		return;
	end

	if this.list.bloodlust == nil then
		local name = language.current_language.skills.bloodlust;
		this.list.bloodlust = buffs.new(buffs.types.skill, "bloodlust", name, 0);
	end
end

function this.update_frenzied_bloodlust(player, player_data)
	local hunter_wire_skill_231_num = get_hunter_wire_skill_231_num_method:call(player);
	if hunter_wire_skill_231_num == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to access Data: hunter_wire_skill_231_num");
		return;
	end

	if hunter_wire_skill_231_num == 0 then
		this.list.frenzied_bloodlust = nil;
		frenzied_bloodlust_duration = 0;
		frenzied_bloodlust_sheathed_duration = 0;
		return;
	end

	local equip_skill_231_wire_num_timer = equip_skill_231_wire_num_timer_field:get_data(player_data);
	if equip_skill_231_wire_num_timer == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to access Data: equip_skill_231_wire_num_timer");
		return;
	end

	local equip_skill_231_wp_off_timer = equip_skill_231_wp_off_timer_field:get_data(player_data);
	if equip_skill_231_wp_off_timer == nil then
		error_handler.report("skills.update_frenzied_bloodlust", "Failed to access Data: equip_skill_231_wp_off_timer");
		return;
	end

	local is_wire_num_timer_zero = utils.number.is_equal(equip_skill_231_wire_num_timer, 0);
	if is_wire_num_timer_zero then
		this.list.frenzied_bloodlust = nil;
		return;
	end

	if equip_skill_231_wire_num_timer > frenzied_bloodlust_duration then
		frenzied_bloodlust_duration = equip_skill_231_wire_num_timer;
	end

	if equip_skill_231_wp_off_timer > frenzied_bloodlust_sheathed_duration then
		frenzied_bloodlust_sheathed_duration = equip_skill_231_wp_off_timer;
	end
	
	local is_wp_off_timer_max = utils.number.is_equal(equip_skill_231_wp_off_timer, frenzied_bloodlust_sheathed_duration);

	local timer = equip_skill_231_wire_num_timer;
	if not is_wp_off_timer_max then
		timer =	equip_skill_231_wp_off_timer;
	end

	this.update_generic("frenzied_bloodlust", 1, timer / 60);

	local skill = this.list.frenzied_bloodlust;
	if is_wp_off_timer_max then
		skill.duration = frenzied_bloodlust_duration / 60;
	else
		skill.duration = frenzied_bloodlust_sheathed_duration / 60;
	end
end

function this.update_peak_performance()
	if not skill_data_list.peak_performance.is_equipped then
		this.list.peak_performance = nil;
		return;
	end

	if player_info.list.health ~= player_info.list.max_health then
		this.list.peak_performance = nil;
		return;
	end

	this.update_generic("peak_performance", 1);
end

function this.update_dragonheart()
	if not skill_data_list.dragonheart.is_equipped then
		this.list.dragonheart = nil;
		return;
	end

	local breakpoint = dragonheart_breakpoints[skill_data_list.dragonheart.level];
	local health_percentage = 1;

	local max_health = player_info.list.max_health;

	if max_health ~= 0 then
		health_percentage = player_info.list.health / max_health;
	end

	if health_percentage > breakpoint then
		this.list.dragonheart = nil;
		return;
	end

	this.update_generic("dragonheart", 1);
end

function this.update_resentment(player_data)
	if not skill_data_list.resentment.is_equipped then
		this.list.resentment = nil;
		return;
	end

	local r_vital = r_vital_field:get_data(player_data);
	if r_vital == nil then
		error_handler.report("skills.update_resentment", "Failed to access Data: r_vital");
		return;
	end

	if player_info.list.health >= r_vital then
		this.list.resentment = nil;
		return;
	end

	this.update_generic("resentment", 1);
end

function this.init_names()
	for skill_key, skill in pairs(this.list) do
		local name = language.current_language.skills[skill_key];

		if name == nil then
			name = skill_key;
		end

		skill.name = name;
	end
end

function this.init_dependencies()
	buffs = require("MHR_Overlay.Buffs.buffs");
	config = require("MHR_Overlay.Misc.config");
	utils = require("MHR_Overlay.Misc.utils");
	buff_UI_entity = require("MHR_Overlay.UI.UI_Entities.buff_UI_entity");
	singletons = require("MHR_Overlay.Game_Handler.singletons");
	players = require("MHR_Overlay.Damage_Meter.players");
	language = require("MHR_Overlay.Misc.language");
	error_handler = require("MHR_Overlay.Misc.error_handler");
	env_creature = require("MHR_Overlay.Endemic_Life.env_creature");
	player_info = require("MHR_Overlay.Misc.player_info");
	time = require("MHR_Overlay.Game_Handler.time");
	abnormal_statuses = require("MHR_Overlay.Buffs.abnormal_statuses");
end

function this.init_module()
end

return this;