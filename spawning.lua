local allbiomes = minetest.registered_biomes
local oceanbiomes = {}
local shorebiomes = {}
local forestbiomes = {}
local otherbiomes = {}
for biome, entry in ipairs(allbiomes) do
    if string.find(biome, 'ocean') then
        table.insert(oceanbiomes, biome)
    elseif string.find(biome, 'shore') or string.find(biome, 'dune') then
        table.insert(shorebiomes, biome)
    elseif string.find(biome, 'forest') then
        table.insert(forestbiomes, biome)
    elseif string.find(biome, 'under') then
        -- skip, no mobs spawn here
    else
        table.insert(otherbiomes)
    end
end
local mob_list = {
    -- create item for every mob with fine tuned settings here
    brachiosaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland', 'grassland_dunes', 'deciduous_forest_shore'}, near = {'default:dirt_with_grass','default:river_water_source'}},
    carnotaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland'}, near = {'default:dirt_with_grass'}},
    dire_wolf = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'snowy_grassland', 'coniferous_forest', 'deciduous_forest'}, near = {'default:dirt_with_grass','default:dirt_with_rainforest_litter'}},
    dunkleosteus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = oceanbiomes, near = {'default:water_source'}},
    elasmotherium = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'icesheet', 'taiga', 'snowy_grassland'}, near = {'default:dirt_with_grass'}}, --unicorn!
    mammoth = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'icesheet', 'taiga', 'snowy_grassland'}, near = {'default:dirt_with_grass','default:snowblock','default:ice','default:dirt_with_snow','default:permafrost_with_stones'}},
    mosasaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = oceanbiomes, near = {'default:water_source'}},
    plesiosaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = oceanbiomes, near = {'default:water_source'}},
    procoptodon = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland'}, near = {'default:dirt_with_grass'}},
    pteranodon = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'tundra_highland'}, near = {'default:dirt_with_grass'}},
    quetzalcoatlus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'tundra_highland'}, near = {'default:dirt_with_grass'}},
    sarcosuchus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland_dunes', 'coniferous_forest_dunes', 'deciduous_forest_shore'}, near = {'default:river_water_source','default:sand'}},
    smilodon = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'icesheet', 'taiga', 'snowy_grassland'}, near = {'default:dirt_with_grass'}},
    spinosaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'snowy_grassland'}, near = {'default:dirt_with_grass'}},
    stegosaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland'}, near = {'default:dirt_with_grass'}},
    thylacoleo = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'snowy_grassland'}, near = {'default:dirt_with_grass'}},
    triceratops = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland'}, near = {'default:dirt_with_grass'}},
    tyrannosaurus = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'grassland'}, near = {'default:dirt_with_grass'}},
    velociraptor = {intrvl = 25, chance = 0.5, reduction = 0, biomes = {'coniferous_forest', 'deciduous_forest'}, near = {'default:dirt_with_grass','default:dirt_with_dry_grass','default:dry_dirt_with_dry_grass','default:dirt_with_coniferous_litter','default:dirt_with_rainforest_litter'}},
}
-- after defining these mobs, we can add mod dependant materials to the near array like this:
if minetest.get_modpath('ethereal') then
    table.insert(mob_list.tyrannosaurus.biomes, 'mushroom')
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local radius = 32 -- I expect the radius to be the same for every mob, if not we can add it as an item in the mob definitions array above, which would be accessed below as def.radius
for mob, def in ipairs(mob_list) do
    minetest.register_globalstep(function(dtime)
        local spawnpos = mobkit.get_spawn_pos_abr(dtime, def.intrvl, radius, def.chance, def.reduction)
        if spawnpos then
            -- either search for a single matching node in radius or find all nodes that match in an area
            -- local pos1 = {x = spawnpos.x + radius, y = spawnpos.y + radius, z = spawnpos.z + radius}
            -- local pos2 = {x = spawnpos.x - radius, y = spawnpos.y - radius, z = spawnpos.z - radius}
            -- if minetest.find_nodes_in_area(pos1, pos2, def.near) then
            -- if minetest.find_node_near(spawnpos, radius, def.near, true)
            local biome = minetest.get_biome_data(spawnpos)
            local allowed_biomes = {}
            for i, biome_name in ipair(def.biomes) do
                allowed_biomes[i] = minetest.get_biome_id(biome_name)
            end
            if has_value(allowed_biomes, biome.id)
                minetest.add_entity(spawnpos, "paleotest:"..mob)
            end
        end
    end)
end