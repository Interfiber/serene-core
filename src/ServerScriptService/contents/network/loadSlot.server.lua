local network = require(game.ReplicatedStorage.modules.network)
local slot = require(game.ReplicatedStorage.modules.characterSlot)
local teleportServer = require(game.ReplicatedStorage.modules.teleportServer)
network.event("loadCharacterSlot", function(player, characterSlotId)
    print("Update: Slot id")
    slot.updateSlotId(player, characterSlotId)
    print("Load: character data")
    local lastPlace = teleportServer.getCurrentPlace(player)
    teleportServer.teleportPlayer(player, lastPlace, {})
end)
