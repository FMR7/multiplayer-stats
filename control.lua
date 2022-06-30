local function count(player, prototypes)
    for k, v in pairs(prototypes) do
        local count = player.force.kill_count_statistics.get_input_count(k)
        if count > 0 then
            return {
                count = count,
                localised_name = v.localised_name,
                order = v.order
            }
        end
    end

    return null
end

local function get_kill_info(player)
    local kill_counts = {}

    local prototypes = game.get_filtered_entity_prototypes({{
        filter = "type",
        type = "unit"
    }})
    local enemies = count(player, prototypes)
    if enemies ~= null then
        kill_counts[enemies.localised_name] = enemies
        player.print("enemies: " .. enemies.count)
    end

    prototypes = game.get_filtered_entity_prototypes({{
        filter = "type",
        type = "unit-spawner"
    }})
    local spawners = count(player, prototypes)
    if spawners ~= null then
        kill_counts[spawners.localised_name] = spawners
        player.print("spawners: " .. spawners.count)
    end

    prototypes = game.get_filtered_entity_prototypes({{
        filter = "type",
        type = "turret"
    }})
    local turrets = count(player, prototypes)
    if turrets ~= null then
        kill_counts[turrets.localised_name] = turrets
        player.print("turrets: " .. turrets.count)
    end

    table.sort(kill_counts, function(left, right)
        return left.order < right.order
    end)
    return kill_counts
end

script.on_event(defines.events.on_tick, function(event)
    if event.tick % 60 == 0 then
        for _, player in pairs(game.players) do
            -- player.print(dump(get_kill_info(player)))
            player.print(player.name)
            get_kill_info(player)
        end
    end
end)
