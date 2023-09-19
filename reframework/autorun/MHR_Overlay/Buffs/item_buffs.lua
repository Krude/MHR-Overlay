local this = {};

local buffs;
local buff_UI_entity;
local config;
local singletons;
local players;
local utils;
local language;
local error_handler;
local endemic_life_buffs;

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
	demondrug = nil,
	mega_demondrug = nil,
	armorskin = nil,
	mega_armorskin = nil,
	-- might_seed = nil,
	-- adamant_seed = nil,
	demon_powder = nil,
	hardshell_powder = nil,
	immunizer = nil,
	-- dash_juice = nil,
	gourmet_fish = nil,
};

local item_ids = {
	demondrug = 68157917,
	mega_demondrug = 68157918,
	armorskin = 68157922,
	mega_armorskin = 68157923,
	--might_seed = 68157919,
	--adamant_seed = 68157924,
	demon_powder = 68157920,
	hardshell_powder = 68157925,
	--immunizer = 68157911,
	--dash_juice = 68157913,
	gourmet_fish = 68157909,
	demon_ammo = 68157595,
	armor_ammo = 68157596
}

local item_buffs_type_name = "item_buffs";

local player_manager_type_def = sdk.find_type_definition("snow.player.PlayerManager");
local get_ref_item_parameter_method = player_manager_type_def:get_method("get_RefItemParameter");

local player_user_data_item_parameter_type_def = get_ref_item_parameter_method:get_return_type();

local demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_DemondrugAtkUp");
local great_demondrug_atk_up_field = player_user_data_item_parameter_type_def:get_field("_GreatDemondrugAtkUp");

local armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_ArmorSkinDefUp");
local great_armorskin_def_up_field = player_user_data_item_parameter_type_def:get_field("_GreatArmorSkinDefUp");

local player_data_type_def = sdk.find_type_definition("snow.player.PlayerData");
-- Demondrug/Mega Demondrug
local atk_up_alive_field = player_data_type_def:get_field("_AtkUpAlive");
-- Armorskin/Mega Armorskin
local def_up_alive_field = player_data_type_def:get_field("_DefUpAlive");
-- Demon Powder
local atk_up_item_second_field = player_data_type_def:get_field("_AtkUpItemSecond");
local atk_up_item_second_timer_field = player_data_type_def:get_field("_AtkUpItemSecondTimer");
-- Hardshell Powder
local def_up_item_second_field = player_data_type_def:get_field("_DefUpItemSecond");
local def_up_item_second_timer_field = player_data_type_def:get_field("_DefUpItemSecondTimer");
-- Gourmet Fish
local fish_regene_enable_field = player_data_type_def:get_field("_FishRegeneEnableTimer");
-- Demon Ammo
local kijin_bullet_timer_field = player_data_type_def:get_field("_KijinBulletTimer");
-- Armor Ammo
local kouka_bullet_timer_field = player_data_type_def:get_field("_KoukaBulletTimer");

local data_shortcut_type_def = sdk.find_type_definition("snow.data.DataShortcut");
local get_name_method = data_shortcut_type_def:get_method("getName(snow.data.ContentsIdSystem.ItemId)");

function this.update(player_data)
	if singletons.player_manager == nil then
		error_handler.report("item_buffs.update", "Failed to access Data: player_manager");
		return;
	end

	local item_parameter = get_ref_item_parameter_method:call(singletons.player_manager);
	if item_parameter == nil then
		error_handler.report("item_buffs.update", "Failed to access Data: item_parameter");
		return;
	end

	local cached_language = language.current_language;

	this.update_demondrug(player_data, item_parameter);
	this.update_armorskin(player_data, item_parameter);
	
	buffs.update_generic_buff(this.list, item_buffs_type_name, "demon_powder", this.get_item_buff_name,
		player_data, atk_up_item_second_field, player_data, atk_up_item_second_timer_field);
	
	buffs.update_generic_buff(this.list, item_buffs_type_name, "hardshell_powder", this.get_item_buff_name,
		player_data, def_up_item_second_field, player_data, def_up_item_second_timer_field);

	buffs.update_generic_buff(this.list, item_buffs_type_name, "gourmet_fish", this.get_item_buff_name,
		nil, nil, player_data, fish_regene_enable_field);

	buffs.update_generic_buff(this.list, item_buffs_type_name, "demon_ammo", this.get_item_buff_name,
		nil, nil, player_data, kijin_bullet_timer_field);

	buffs.update_generic_buff(this.list, item_buffs_type_name, "armor_ammo", this.get_item_buff_name,
		nil, nil, player_data, kouka_bullet_timer_field);
end

function this.update_demondrug(player_data, item_parameter)
	local demondrug_value = atk_up_alive_field:get_data(player_data);
	if demondrug_value == nil then
		error_handler.report("item_buffs.update_demondrug", "Failed to access Data: demondrug_value");
		return;
	end

	if demondrug_value == 0 then
		this.list.demondrug = nil;
		this.list.mega_demondrug = nil;
		return;
	end

	local demondrug_const_value = demondrug_atk_up_field:get_data(item_parameter);
	if demondrug_const_value == nil then
		error_handler.report("item_buffs.update_demondrug", "Failed to access Data: demondrug_const_value");
		return;
	end

	local mega_demondrug_const_value = great_demondrug_atk_up_field:get_data(item_parameter);
	if mega_demondrug_const_value == nil then
		error_handler.report("item_buffs.update_demondrug", "Failed to access Data: mega_demondrug_const_value");
		return;
	end

	local item_key;
	if demondrug_value == demondrug_const_value then
		item_key = "demondrug";
		this.list.mega_demondrug = nil;
	
	elseif demondrug_value == mega_demondrug_const_value then
		item_key = "mega_demondrug";
		this.list.demondrug = nil;
	end

	buffs.update_generic(this.list, item_buffs_type_name, item_key, this.get_item_buff_name);
end

function this.update_armorskin(player_data, item_parameter)
	local armorskin_value = def_up_alive_field:get_data(player_data);
	if armorskin_value == nil then
		error_handler.report("item_buffs.update_armorskin", "Failed to access Data: armorskin_value");
		return;
	end

	if armorskin_value == 0 then
		this.list.armorskin = nil;
		this.list.mega_armorskin = nil;
		return;
	end

	local armorskin_const_value = armorskin_def_up_field:get_data(item_parameter);
	if armorskin_const_value == nil then
		error_handler.report("item_buffs.update_armorskin", "Failed to access Data: armorskin_const_value");
		return;
	end

	local mega_armorskin_const_value = great_armorskin_def_up_field:get_data(item_parameter);
	if mega_armorskin_const_value == nil then
		error_handler.report("item_buffs.update_armorskin", "Failed to access Data: mega_armorskin_const_value");
		return;
	end

	local item_key;
	if armorskin_value == armorskin_const_value then
		item_key = "armorskin";
		this.list.mega_armorskin = nil;
	
	elseif armorskin_value == mega_armorskin_const_value then
		item_key = "mega_armorskin";
		this.list.armorskin = nil;
	end

	buffs.update_generic(this.list, item_buffs_type_name, item_key, this.get_item_buff_name);
end

function this.get_item_buff_name(item_key)
	local item_buff_name = get_name_method:call(nil, item_ids[item_key]);
	if item_buff_name == nil then
		error_handler.report("item_buffs.get_item_buff_name", string.format("Failed to access Data: %s_name", item_key));
		return item_key;
	end

	return item_buff_name;
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
	endemic_life_buffs = require("MHR_Overlay.Buffs.endemic_life_buffs");
end

function this.init_module()
end

return this;