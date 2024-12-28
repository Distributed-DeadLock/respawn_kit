--- RESPAWN KIT ---
-- a Luanti/Minetest Mod --
-- provides a craftable chest, that can be filled with a players personal respawn kit.
-- whatever the player puts in the chest, will be duplicated and put into the players main-inventory when he dies.

-- based on work by minefaco & MeseCraft



-- Register the respawn-kit-chest.
minetest.register_node("respawn_kit:respawn_chest", {
	description = "" ..core.colorize("#229944","Respawn Chest\n") ..core.colorize("#FFFFFF", "Items stored in here will be issued on respawn."),
	tiles = {"respawn_kit_top.png", "respawn_kit_top.png", "respawn_kit_side.png",
		"respawn_kit_side.png", "respawn_kit_side.png", "respawn_kit_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,7]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;respawn_chest;0,0.3;8,2;]"..
				"list[current_player;main;0,2.85;8,1;]" ..
				"list[current_player;main;0,4.08;8,3;8]" ..
				"listring[current_player;respawn_kit:respawn_chest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,2.85))

		meta:set_string("infotext", "Respawn Chest")
	end,	
})


-- Register crafting recipie.

	minetest.register_craft({
		output = 'respawn_kit:respawn_chest',
		recipe = {
			{'default:steelblock','default:mese','default:steelblock'},
			{'default:steelblock','default:chest','default:steelblock'},
			{'default:steelblock','default:diamondblock','default:steelblock'}
		}
	})
	

-- Create a respawn chest inventory when players connect.
minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("respawn_chest", 8*2)
end)


-- Register the "give player stuff from Kit-Inventory on respawn" function
minetest.register_on_respawnplayer(function(player) 
    local maininv = player:get_inventory()
	if not maininv:is_empty("respawn_chest") then		
		local stack
		for i=1,(maininv:get_size("respawn_chest")) do
			stack = maininv:get_stack("respawn_chest", i)
			if stack:get_count() > 0 then
				maininv:add_item("main", stack)
			end
		end
	end
end)

