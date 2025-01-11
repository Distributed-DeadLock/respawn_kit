--- RESPAWN KIT ---
-- a Luanti/Minetest Mod --
-- provides a craftable chest, that can be filled with a players personal respawn kit.
-- whatever the player puts in the chest, will be duplicated and put into the players main-inventory when he dies.

-- based on work by 1faco & MeseCraft


local world_path = core.get_worldpath()
local mod_path = core.get_modpath("respawn_kit")
local use_whitelist = core.settings:get_bool("respawn_kit.use_whitelist") or false

-- read whitelist , create it if not existing
local whitelist_path = world_path .. "/respawn_kit_whitelist.txt"
local whitelist_file = io.open(whitelist_path, "r")
local whitelist = {}
if (whitelist_file == nil) then
	local output = io.open(whitelist_path, "w")
	output:write("default:cobble", "\n")
	output:write("default:stone", "\n")
	io.close(output)
else
	io.close(whitelist_file)
end
for line in io.lines(whitelist_path) do
	table.insert(whitelist, line)
end


-- read blacklist , create it if not existing
local blacklist_path = world_path .. "/respawn_kit_blacklist.txt"
local blacklist_template_path = mod_path .. "/respawn_kit_blacklist.txt"
local blacklist_file = io.open(blacklist_path, "r")
local blacklist = {}
if (blacklist_file == nil) then

    local inpfile = assert(io.open(blacklist_template_path, "rb"))
    local outfile = assert(io.open(blacklist_path, "wb"))
    local data = inpfile:read("*all")
    outfile:write(data)    
    assert(outfile:close())
	assert(inpfile:close())
else
	io.close(blacklist_file)
end
for line in io.lines(blacklist_path) do
	table.insert(blacklist, line)
end
data = nil

-- Register the respawn-kit-chest.
core.register_node("respawn_kit:respawn_chest", {
	description = "" ..core.colorize("#229944","Respawn Chest\n") ..core.colorize("#FFFFFF", "Items stored in here will be issued on respawn."),
	tiles = {"respawn_kit_top.png", "respawn_kit_top.png", "respawn_kit_side.png",
		"respawn_kit_side.png", "respawn_kit_side.png", "respawn_kit_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = core.get_meta(pos)
		meta:set_string("formspec",
				"size[8,7]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;respawn_kit:respawn_chest;0,0.3;8,2;]"..
				"list[current_player;main;0,2.85;8,1;]" ..
				"list[current_player;main;0,4.08;8,3;8]" ..
				"listring[current_player;respawn_kit:respawn_chest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,2.85))

		meta:set_string("infotext", "Respawn Chest")
	end,	
})


-- Register crafting recipie.

	core.register_craft({
		output = 'respawn_kit:respawn_chest',
		recipe = {
			{'default:steelblock','default:mese','default:steelblock'},
			{'default:steelblock','default:chest','default:steelblock'},
			{'default:steelblock','default:diamondblock','default:steelblock'}
		}
	})
	

-- Create a respawn chest inventory when players connect.
core.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("respawn_kit:respawn_chest", 8*2)
end)


-- Register the "give player stuff from Kit-Inventory on respawn" function
core.register_on_respawnplayer(function(player) 
    local maininv = player:get_inventory()
	if not maininv:is_empty("respawn_kit:respawn_chest") then		
		local stack
		for i=1,(maininv:get_size("respawn_kit:respawn_chest")) do
			stack = maininv:get_stack("respawn_kit:respawn_chest", i)
			if stack:get_count() > 0 then
				maininv:add_item("main", stack)
			end
		end
	end
end)


--Register the white/black-list limiting function
core.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	if (action == "move") then
		if (inventory_info.to_list == "respawn_kit:respawn_chest") then
			local stack = inventory:get_stack(inventory_info.from_list, inventory_info.from_index)
			local moveitem = stack:get_name()
			if use_whitelist then
				local found = false
				for i,line in ipairs(whitelist) do
					if (line == moveitem) then
						found = true
					end
				end
				if not found then
					return 0
				end
			else
				for i,line in ipairs(blacklist) do
					if (line == moveitem) then
						return 0
					end
				end
			end
		end
	end
end)