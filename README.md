RESPAWN KIT - a Luanti/Minetest Mod

-- provides a craftable chest, that can be filled with a players personal respawn kit.

-- whatever the player puts in the chest, will be duplicated and put into the players main-inventory when he respawns after dying.

-- use either a Blacklist(default) or a Whitelist to control what can be put in the chest. Both lists will be created in the worldpath on first startup of the world:

BlackList = worldpath/respawn_kit_blacklist.txt

WhiteList = worldpath/respawn_kit_whitelist.txt 

Both lists must contain the item-names of the black/white-listed items, one name per line.

BlackList comes preconfigured with all mt-default ores.

WhiteList comes preconfigured with 2 example items.

-----


default recipe for the "respawn_kit:respawn_chest"

'default:steelblock',  'default:mese',          'default:steelblock'

'default:steelblock',  'default:chest',         'default:steelblock'

'default:steelblock',  'default:diamondblock',  'default:steelblock'
