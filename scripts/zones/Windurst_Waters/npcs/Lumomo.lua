-----------------------------------
-- Area: Windurst Waters
--  NPC: Lumomo
-- Type: Standard NPC
-- !pos -55.770 -5.499 18.914 238
--  638  818 820    822  823
-- Auto-Script: Requires Verification (Verfied By Brawndo)
-----------------------------------
local ID = require("scripts/zones/Windurst_Waters/IDs");
require("scripts/globals/settings");
require("scripts/globals/quests");
require("scripts/globals/keyitems");
require("scripts/globals/titles");
-----------------------------------

function onTrade(player,npc,trade)
end;

function onTrigger(player,npc)

    local ecoWarWindurst = player:getQuestStatus(WINDURST,dsp.quest.id.windurst.ECO_WARRIOR_WIN);
    local ecoWarActiveNation = player:getVar("ECO_WARRIOR_ACTIVE");
    if (player:hasKeyItem(dsp.ki.INDIGESTED_MEAT) and ecoWarActiveNation == 238) then
        player:startEvent(822); -- quest done
    elseif (ecoWarActiveNation < 1 and player:getFameLevel(WINDURST) >= 1 and player:getVar("ECO-WAR_ConquestWeek") ~= getConquestTally()) then
        player:startEvent(818); -- Start CS
    elseif (ecoWarActiveNation ~= 238 and ecoWarActiveNation > 1) then
        player:startEvent(823);
    elseif (ecoWarWindurst ~= QUEST_AVAILABLE and ecoWarActiveNation == 238  and player:getVar("ECO-WAR_ConquestWeek") ~= getConquestTally()) then
        player:startEvent(820); -- reminder
    else
        player:startEvent(821); -- Default chit-chat
    end
end;

function onEventUpdate(player,csid,option)
end;

function onEventFinish(player,csid,option)
    if (csid == 818 and option == 1) then
        if (player:getQuestStatus(WINDURST,dsp.quest.id.windurst.ECO_WARRIOR_WIN) == QUEST_AVAILABLE) then
            player:addQuest(WINDURST,dsp.quest.id.windurst.ECO_WARRIOR_WIN);
        end
        player:setVar("ECO_WARRIOR_ACTIVE",player:getZoneID());
        player:setVar("ECO-WAR_ConquestWeek",0);
    elseif (csid == 822) then
        if (player:getFreeSlotsCount() >= 1) then
            player:completeQuest(WINDURST,dsp.quest.id.windurst.ECO_WARRIOR_WIN);
            player:delKeyItem(dsp.ki.INDIGESTED_MEAT);
            player:addGil(GIL_RATE * 5000);
            player:messageSpecial(ID.text.GIL_OBTAINED,GIL_RATE * 5000);
            player:addItem(4198);
            player:messageSpecial(ID.text.ITEM_OBTAINED,4198);
            player:addTitle(dsp.title.EMERALD_EXTERMINATOR);
            player:addFame(WINDURST, 80);
            player:setVar("ECO-WAR_ConquestWeek",getConquestTally())
            player:setVar("ECO_WARRIOR_ACTIVE",0);
        else
            player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED,4198);
        end
    end
end;
