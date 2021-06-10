local S = minetest.get_translator("mcl_shepherd_crook")

local MAX_MOB_NAME_LENGTH = 30

-- Shows helpful debug info above each mob
local mobs_debug = minetest.settings:get_bool("mobs_debug", false)

local function update_tag(self)
	local tag
	if mobs_debug then
		tag = "nametag = '"..tostring(self.nametag).."'\n"..
		"state = '"..tostring(self.state).."'\n"..
		"order = '"..tostring(self.order).."'\n"..
		"attack = "..tostring(self.attack).."\n"..
		"health = "..tostring(self.health).."\n"..
		"breath = "..tostring(self.breath).."\n"..
		"gotten = "..tostring(self.gotten).."\n"..
		"tamed = "..tostring(self.tamed).."\n"..
		"horny = "..tostring(self.horny).."\n"..
		"hornytimer = "..tostring(self.hornytimer).."\n"..
		"runaway_timer = "..tostring(self.runaway_timer).."\n"..
		"following = "..tostring(self.following)
	else
		tag = self.nametag
	end
	self.object:set_properties({
		nametag = tag,
	})

end

local function begin_naming(self)
	if not self.ignores_nametag then
		local tag = "Pet #" .. math.random(1, 99999999)
		if tag ~= "" then
			if string.len(tag) > MAX_MOB_NAME_LENGTH then
				tag = string.sub(tag, 1, MAX_MOB_NAME_LENGTH)
			end
			self.nametag = tag

			update_tag(self)
			return true
		end
	end
	return false
end

local function on_use_crook(itemstack, user, pointed_thing)
	local name = user:get_player_name()
	local pos = pointed_thing.above

	local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1.5)
	for k, obj in pairs(objs) do
		local entity = obj:get_luaentity()
		if entity ~= nil then
			minetest.chat_send_player(name, "Found a " .. entity.name)
			local index = string.find(entity.name, "mobs_mc:")
			if index == 1 then
				begin_naming(entity)
			end
		end
	end
end

minetest.register_tool("mcl_shepherd_crook:shepherd_crook", {
	description = S("Shepherd Crook"),
	_tt_help = S("Give a mob an auto-generated name to prevent despawning."),
	_doc_items_longdesc = S("Give a mob an auto-generated name to prevent despawning.  Like a nametag but cheaper."),
	_doc_items_usagehelp = S("Right-click on the ground under a mob with this item to give the mob a 'name'."),
	inventory_image = "mcl_shepherd_crook.png",
	wield_image = "mcl_shepherd_crook.png",
	wield_scale = { x = 1.8, y = 1.8, z = 1 },
	on_place = on_use_crook,
	groups = { tool=1 },
	tool_capabilities = {
		full_punch_interval = 1,
		damage_groups = { fleshy = 1, },
		punch_attack_uses = 16,
	},
	_repair_material = "group:wood",
	_mcl_toollike_wield = true,
})

minetest.register_craft({
	output = "mcl_shepherd_crook:shepherd_crook",
	recipe = {
		{"mcl_core:stick", "mcl_core:stick"},
		{"mcl_core:stick", ""},
		{"mcl_core:stick", ""},
	},
})

minetest.register_craft({
	output = "mcl_shepherd_crook:shepherd_crook",
	recipe = {
		{"mcl_core:stick", "mcl_core:stick"},
		{"", "mcl_core:stick"},
		{"", "mcl_core:stick"},
	},
})