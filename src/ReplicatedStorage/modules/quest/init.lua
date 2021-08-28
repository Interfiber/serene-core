--[[
    File name: init.lua
    Description: main module code for the serene quest system
    Author: oldmilk
--]]

local module = {}
local class = require(script.class)
local ridge = require(game.ReplicatedStorage.modules.ridge)
--importFromModule: import a quest from a module script
module.importFromModule = function(path)
    if not path:IsA("ModuleScript") then
        error("Failed to load quest data: given Instance must be of class ModuleScript")
    end
    local questData = require(path)
    local coreData = {
        questData = require(path),
        modulePath = path
    }
    setmetatable(coreData, class)
    return coreData
end
--loadQuestData: execute events when the player joins the game for quests
module.loadQuestData = function(player)
    local playerQuestStore = ridge.loadPlayerDatastore("playerCurrentQuests", player)
    local quests = playerQuestStore:getAsync()
    if quests == nil then
        print("nothing to update, player is not doing any quests.")
    else
        for questIndex, quest in pairs(quests) do
            local questModule = require(game.ReplicatedStorage.questLookup:FindFirstChild(questIndex))
            -- execute player join event
            local events = questModule["events"]
            if events["playerStartedQuest"] ~= nil then
                local returnValue = events.playerStartedQuest(player)
                if returnValue["client"] ~= nil then
                    returnValue.client:FireClient(player)
                end
            end
            -- remove quest module
            questModule = nil
        end
    end
end

return module