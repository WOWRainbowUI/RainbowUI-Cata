local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local B = Cell.bFuncs
local I = Cell.iFuncs
local U = Cell.uFuncs
local P = Cell.pixelPerfectFuncs
local A = Cell.animations

local HealComm

CELL_FADE_OUT_HEALTH_PERCENT = nil

local UnitGUID = UnitGUID
local UnitClassBase = UnitClassBase
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
-- local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitIsUnit = UnitIsUnit
local UnitIsConnected = UnitIsConnected
local UnitIsAFK = UnitIsAFK
local UnitIsFeignDeath = UnitIsFeignDeath
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGhost = UnitIsGhost
local UnitPowerType = UnitPowerType
local UnitPowerMax = UnitPowerMax
-- local UnitInRange = UnitInRange
-- local UnitIsVisible = UnitIsVisible
local SetRaidTargetIconTexture = SetRaidTargetIconTexture
local GetTime = GetTime
local GetRaidTargetIndex = GetRaidTargetIndex
local GetReadyCheckStatus = GetReadyCheckStatus
local UnitHasVehicleUI = UnitHasVehicleUI
-- local UnitInVehicle = UnitInVehicle
-- local UnitUsingVehicle = UnitUsingVehicle
local UnitIsCharmed = UnitIsCharmed
local UnitIsPlayer = UnitIsPlayer
local UnitThreatSituation = UnitThreatSituation
local GetThreatStatusColor = GetThreatStatusColor
local UnitExists = UnitExists
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local InCombatLockdown = InCombatLockdown
local UnitInPhase = UnitInPhase
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff
local IsInRaid = IsInRaid
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local barAnimationType, highlightEnabled, predictionEnabled

-------------------------------------------------
-- unit button func declarations
-------------------------------------------------
local UnitButton_UpdateAll
local UnitButton_UpdateAuras, UnitButton_UpdateAssignment, UnitButton_UpdateLeader, UnitButton_UpdateStatusText
local UnitButton_UpdateHealthColor, UnitButton_UpdateNameColor
local UnitButton_UpdatePowerMax, UnitButton_UpdatePower, UnitButton_UpdatePowerType

-------------------------------------------------
-- unit button init indicators
-------------------------------------------------
local enabledIndicators, indicatorNums, indicatorCustoms = {}, {}, {}

local function UpdateIndicatorParentVisibility(b, indicatorName, enabled)
    if not (indicatorName == "debuffs" or
            indicatorName == "privateAuras" or
            indicatorName == "defensiveCooldowns" or
            indicatorName == "externalCooldowns" or
            indicatorName == "allCooldowns" or
            indicatorName == "dispels" or
            indicatorName == "missingBuffs") then
        return
    end

    if enabled then
        b.indicators[indicatorName]:Show()
    else
        b.indicators[indicatorName]:Hide()
    end
end

local indicatorsInitialized
local previousLayout = {}

local function ResetIndicators()
    wipe(enabledIndicators)
    wipe(indicatorNums)

    for _, t in pairs(Cell.vars.currentLayoutTable["indicators"]) do
        -- update enabled
        if t["enabled"] then
            enabledIndicators[t["indicatorName"]] = true
        end
        -- update num
        if t["num"] then
            indicatorNums[t["indicatorName"]] = t["num"]
        end
        -- update statusIcon
        if t["indicatorName"] == "statusIcon" then
            I:EnableStatusIcon(t["enabled"])
        end
        -- update aoehealing
        if t["indicatorName"] == "aoeHealing" then
            I:EnableAoEHealing(t["enabled"])
        end
        -- update targetCounter
        if t["indicatorName"] == "targetCounter" then
            I:UpdateTargetCounterFilters(t["filters"], true)
            I:EnableTargetCounter(t["enabled"])
        end
        -- update targetedSpells
        if t["indicatorName"] == "targetedSpells" then
            I:EnableTargetedSpells(t["enabled"])
            I:ShowAllTargetedSpells(t["showAllSpells"])
        end
        -- update consumables
        if t["indicatorName"] == "consumables" then
            I:EnableConsumables(t["enabled"])
        end
        -- update healthThresholds
        if t["indicatorName"] == "healthThresholds" then
            I:UpdateHealthThresholds()
        end
        -- update missingBuffs
        if t["indicatorName"] == "missingBuffs" then
            I:UpdateMissingBuffsNum(t["num"], true)
            I:UpdateMissingBuffsFilters(t["filters"], true)
            I:EnableMissingBuffs(t["enabled"])
        end
        -- update custom
        if t["dispellableByMe"] ~= nil then
            indicatorCustoms[t["indicatorName"]] = t["dispellableByMe"]
        end
        if t["hideIfEmptyOrFull"] ~= nil then
            indicatorCustoms[t["indicatorName"]] = t["hideIfEmptyOrFull"]
        end
        if t["onlyShowTopGlow"] ~= nil then
            indicatorCustoms[t["indicatorName"]] = t["onlyShowTopGlow"]
        end
        if t["hideInCombat"] ~= nil then
            indicatorCustoms[t["indicatorName"]] = t["hideInCombat"]
        end
    end
end

local function HandleIndicators(b)
    b._indicatorReady = nil

    -- NOTE: Remove old
    I:RemoveAllCustomIndicators(b)

    for _, t in pairs(Cell.vars.currentLayoutTable["indicators"]) do
        local indicator = b.indicators[t["indicatorName"]] or I:CreateIndicator(b, t)
        -- update position
        if t["position"] then
            P:ClearPoints(indicator)
            P:Point(indicator, t["position"][1], b, t["position"][2], t["position"][3], t["position"][4])
        end
        -- update anchor
        if t["anchor"] then
            indicator:SetAnchor(t["anchor"])
        end
        -- update frameLevel
        if t["frameLevel"] then
            indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+t["frameLevel"])
        end
        -- update size
        if t["size"] then
            -- NOTE: debuffs: ["size"] = {{normalSize}, {bigSize}}
            if t["indicatorName"] == "debuffs" then
                indicator:SetSize(t["size"][1], t["size"][2])
            else
                P:Size(indicator, t["size"][1], t["size"][2])
            end
        end
        -- update thickness
        if t["thickness"] then
            indicator:SetThickness(t["thickness"])
        end
        -- update border
        if t["border"] then
            indicator:SetBorder(t["border"])
        end
        -- update height
        if t["height"] then
            P:Height(indicator, t["height"])
        end
        -- update height
        if t["textWidth"] then
            indicator:UpdateTextWidth(t["textWidth"])
        end
        -- update alpha
        if t["alpha"] then
            indicator:SetAlpha(t["alpha"])
        end
        -- update numPerLine
        if t["numPerLine"] then
            indicator:SetNumPerLine(t["numPerLine"])
        end
        -- update orientation
        if t["orientation"] then
            indicator:SetOrientation(t["orientation"])
        end
        -- update font
        if t["font"] then
            indicator:SetFont(unpack(t["font"]))
        end
        -- update format
        if t["format"] then
            indicator:SetFormat(t["format"])
            B:UpdateHealthText(b)
        end
        -- update color
        if t["color"] and t["indicatorName"] ~= "nameText" then
            indicator:SetColor(unpack(t["color"]))
        end
        -- update colors
        if t["colors"] then
            indicator:SetColors(t["colors"])
        end
        -- update texture
        if t["texture"] then
            indicator:SetTexture(t["texture"])
        end
        -- update dispel highlight
        if t["highlightType"] then
            indicator:UpdateHighlight(t["highlightType"])
        end
        -- update dispel icons
        if type(t["showDispelTypeIcons"]) == "boolean" then
            indicator:ShowIcons(t["showDispelTypeIcons"])
        end
        -- update duration
        if type(t["showDuration"]) == "boolean" or type(t["showDuration"]) == "number" then
            indicator:ShowDuration(t["showDuration"])
        end
        -- update animation
        if type(t["showAnimation"]) == "boolean" then
            indicator:ShowAnimation(t["showAnimation"])
        end
        -- update stack
        if type(t["showStack"]) == "boolean" then
            indicator:ShowStack(t["showStack"])
        end
        -- update duration
        if t["duration"] then
            indicator:SetDuration(t["duration"])
        end
        -- update circled nums
        if type(t["circledStackNums"]) == "boolean" then
            indicator:SetCircledStackNums(t["circledStackNums"])
        end
        -- update groupNumber
        if type(t["showGroupNumber"]) == "boolean" then
            indicator:ShowGroupNumber(t["showGroupNumber"])
        end
        -- update vehicleNamePosition
        if t["vehicleNamePosition"] then
            indicator:UpdateVehicleNamePosition(t["vehicleNamePosition"])
        end
        -- update timer
        if type(t["showTimer"]) == "boolean" then
            indicator:SetShowTimer(t["showTimer"])
        end
        -- update background
        if type(t["showBackground"]) == "boolean" then
            indicator:ShowBackground(t["showBackground"])
        end
        -- tooltip
        if type(t["showTooltip"]) == "boolean" then
            indicator:ShowTooltip(t["showTooltip"])
        end
        -- blacklist shortcut
        if type(t["enableBlacklistShortcut"]) == "boolean" then
            indicator:EnableBlacklistShortcut(t["enableBlacklistShortcut"])
        end
        -- speed
        if t["speed"] then
            indicator:SetSpeed(t["speed"])
        end
        -- update fadeOut
        if type(t["fadeOut"]) == "boolean" then
            indicator:SetFadeOut(t["fadeOut"])
        end
        -- update shape
        if t["shape"] then
            indicator:SetShape(t["shape"])
        end
        -- update glow
        if t["glowOptions"] then
            indicator:UpdateGlowOptions(t["glowOptions"])
        end

        -- init
        -- update name visibility
        if t["indicatorName"] == "nameText" then
            if t["enabled"] then
                indicator:Show()
            else
                indicator:Hide()
            end
        elseif t["indicatorName"] == "playerRaidIcon" then
            B:UpdatePlayerRaidIcon(b, t["enabled"])
        elseif t["indicatorName"] == "targetRaidIcon" then
            B:UpdateTargetRaidIcon(b, t["enabled"])
        else
            UpdateIndicatorParentVisibility(b, t["indicatorName"], t["enabled"])
        end
    
        -- update pixel perfect for built-in widgets
        -- if t["type"] == "built-in" then
        --     if indicator.UpdatePixelPerfect then
        --         indicator:UpdatePixelPerfect()
        --     end
        -- end
    end
    
    --! update pixel perfect for widgets
    B:UpdatePixelPerfect(b, true)

    b._indicatorReady = 1
end

local function UpdateIndicators(layout, indicatorName, setting, value, value2)
    F:Debug("|cffff7777UpdateIndicators:|r ", layout, indicatorName, setting, value, value2)

    local INDEX = Cell.vars.groupType == "solo" and "solo" or Cell.vars.layoutGroupType

    if layout then
        -- Cell:Fire("UpdateIndicators", layout): indicators copy/import
        -- Cell:Fire("UpdateIndicators", xxx, ...): indicator updated
        for k, v in pairs(previousLayout) do
            if v == layout then
                previousLayout[k] = nil -- update required
                F:Debug("UPDATE REQUIRED:", k)
            end
        end

        --! indicator changed, but not current layout
        if layout ~= Cell.vars.currentLayout then
            F:Debug("NO UPDATE: not active layout")
            return
        end

    elseif not indicatorName then -- Cell:Fire("UpdateIndicators")
        --! layout/groupType switched, check if update is required
        if previousLayout[INDEX] == Cell.vars.currentLayout then
            F:Debug("NO UPDATE: only reset custom indicator tables")
            I:ResetCustomIndicatorTables()
            ResetIndicators()
            --! update shared buttons: npcs, spotlights
            F:IterateSharedUnitButtons(HandleIndicators)
            return
        end
    end
    previousLayout[INDEX] = Cell.vars.currentLayout

    if not indicatorName then -- init
        ResetIndicators()

        -- update indicators
        F:IterateAllUnitButtons(HandleIndicators, indicatorsInitialized) -- -- NOTE: indicatorsInitialized = false, update ALL GROUP TYPE; indicatorsInitialized = true, just update CURRENT GROUP TYPE
        indicatorsInitialized = true

        -- update all when indicators update finished
        F:IterateAllUnitButtons(UnitButton_UpdateAll, true)
    else
        -- changed in IndicatorsTab
        if setting == "enabled" then
            enabledIndicators[indicatorName] = value

            if indicatorName == "aoeHealing" then
                I:EnableAoEHealing(value)
            elseif indicatorName == "targetCounter" then
                I:EnableTargetCounter(value)
            elseif indicatorName == "targetedSpells" then
                I:EnableTargetedSpells(value)
            elseif indicatorName == "consumables" then
                I:EnableConsumables(value)
            elseif indicatorName == "partyAssignmentIcon" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateAssignment(b)
                end, true)
            elseif indicatorName == "leaderIcon" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateLeader(b)
                end, true)
            elseif indicatorName == "playerRaidIcon" then
                F:IterateAllUnitButtons(function(b)
                    B:UpdatePlayerRaidIcon(b, value)
                end, true)
            elseif indicatorName == "targetRaidIcon" then
                F:IterateAllUnitButtons(function(b)
                    B:UpdateTargetRaidIcon(b, value)
                end, true)
            elseif indicatorName == "nameText" then
                F:IterateAllUnitButtons(function(b)
                    if value then
                        b.indicators[indicatorName]:Show()
                    else
                        b.indicators[indicatorName]:Hide()
                    end
                end, true)
            elseif indicatorName == "statusText" then
                F:IterateAllUnitButtons(function(b)
                    B:UpdateStatusText(b)
                end, true)
            elseif indicatorName == "healthText" then
                F:IterateAllUnitButtons(function(b)
                    B:UpdateHealthText(b)
                end, true)
            elseif indicatorName == "healthThresholds" then
                if value then
                    I:UpdateHealthThresholds()
                end
                F:IterateAllUnitButtons(function(b)
                    B.UpdateHealth(b)
                end, true)
            elseif indicatorName == "missingBuffs" then
                I:EnableMissingBuffs(value)
                F:IterateAllUnitButtons(function(b)
                    UpdateIndicatorParentVisibility(b, indicatorName, value)
                end, true)
            else
                -- refresh
                F:IterateAllUnitButtons(function(b)
                    UpdateIndicatorParentVisibility(b, indicatorName, value)
                    if not value then
                        b.indicators[indicatorName]:Hide() -- hide indicators which is shown right now
                    end
                    UnitButton_UpdateAuras(b)
                end, true)
            end
        elseif setting == "position" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:ClearPoints(indicator)
                P:Point(indicator, value[1], b, value[2], value[3], value[4])
                -- update arrangement
                if indicator.indicatorType == "icons" then
                    indicator:SetOrientation(indicator.orientation)
                end
            end, true)
        elseif setting == "anchor" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetAnchor(value)
            end, true)
        elseif setting == "frameLevel" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+value)
            end, true)
        elseif setting == "size" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                if indicatorName == "debuffs" then
                    indicator:SetSize(value[1], value[2])
                    -- update debuffs' normal/big icon sizes
                    UnitButton_UpdateAuras(b)
                else
                    P:Size(indicator, value[1], value[2])
                end
            end, true)
        elseif setting == "size-border" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:Size(indicator, value[1], value[2])
                indicator:SetBorder(value[3])
            end, true)
        elseif setting == "thickness" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetThickness(value)
            end, true)
        elseif setting == "height" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                P:Height(indicator, value)
            end, true)
        elseif setting == "textWidth" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:UpdateTextWidth(value)
            end, true)
        elseif setting == "alpha" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetAlpha(value)
            end, true)
        elseif setting == "orientation" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetOrientation(value)
            end, true)
        elseif setting == "font" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFont(unpack(value))
            end, true)
        elseif setting == "format" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetFormat(value)
                B:UpdateHealthText(b)
            end, true)
        elseif setting == "color" then
            if indicatorName == "nameText" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateNameColor(b)
                end, true)
            else
                F:IterateAllUnitButtons(function(b)
                    local indicator = b.indicators[indicatorName]
                    indicator:SetColor(unpack(value))
                end, true)
            end
        elseif setting == "customColors" then --! 其他的colors不调用widget.func，不发出通知，因为这些指示器都使用OnUpdate更新颜色。
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetColors(value)
            end, true)
        elseif setting == "vehicleNamePosition" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:UpdateVehicleNamePosition(value)
            end, true)
        elseif setting == "statusColors" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateStatusText(b)
            end, true)
        elseif setting == "num" then
            indicatorNums[indicatorName] = value
            if indicatorName == "missingBuffs" then
                I:UpdateMissingBuffsNum(value)
            else
                -- refresh
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateAuras(b)
                end, true)
            end
        elseif setting == "numPerLine" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetNumPerLine(value)
            end, true)
        elseif setting == "texture" then
            F:IterateAllUnitButtons(function(b)
                local indicator = b.indicators[indicatorName]
                indicator:SetTexture(value)
            end, true)
        elseif setting == "duration" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "highlightType" then
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:UpdateHighlight(value)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "thresholds" then
            I:UpdateHealthThresholds()
            F:IterateAllUnitButtons(function(b)
                B.UpdateHealth(b)
            end, true)
        elseif setting == "showDuration" then
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:ShowDuration(value)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "missingBuffsFilters" then
            I:UpdateMissingBuffsFilters()
        elseif setting == "targetCounterFilters" then
            I:UpdateTargetCounterFilters()
        elseif setting == "glowOptions" then
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:UpdateGlowOptions(value)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "checkbutton" then
            if value == "showGroupNumber" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowGroupNumber(value2)
                end, true)
            elseif value == "showTimer" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:SetShowTimer(value2)
                    UnitButton_UpdateStatusText(b)
                end, true)
            elseif value == "showBackground" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowBackground(value2)
                end, true)
            elseif value == "hideIfEmptyOrFull" then
                --! 血量文字指示器需要立即被刷新
                indicatorCustoms[indicatorName] = value2
                F:IterateAllUnitButtons(function(b)
                    B:UpdateHealthText(b)
                end, true)
            elseif value == "hideInCombat" then
                indicatorCustoms[indicatorName] = value2
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateLeader(b)
                end, true)
            elseif value == "showDispelTypeIcons" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowIcons(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showStack" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowStack(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showAnimation" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowAnimation(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "trackByName" then
                F:IterateAllUnitButtons(function(b)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showTooltip" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:ShowTooltip(value2)
                end, true)
            elseif value == "enableBlacklistShortcut" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:EnableBlacklistShortcut(value2)
                end, true)
            elseif value == "circledStackNums" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:SetCircledStackNums(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "fadeOut" then
                F:IterateAllUnitButtons(function(b)
                    b.indicators[indicatorName]:SetFadeOut(value2)
                    UnitButton_UpdateAuras(b)
                end, true)
            elseif value == "showAllSpells" then
                I:ShowAllTargetedSpells(value2)
            else
                indicatorCustoms[indicatorName] = value2
            end
        elseif setting == "create" then
            F:IterateAllUnitButtons(function(b)
                local indicator = I:CreateIndicator(b, value)
                -- update position
                if value["position"] then
                    P:ClearPoints(indicator)
                    P:Point(indicator, value["position"][1], b, value["position"][2], value["position"][3], value["position"][4])
                end
                -- update anchor
                if value["anchor"] then
                    indicator:SetAnchor(value["anchor"])
                end
                -- update size
                if value["size"] then
                    P:Size(indicator, value["size"][1], value["size"][2])
                end
                -- update size
                if value["frameLevel"] then
                    indicator:SetFrameLevel(indicator:GetParent():GetFrameLevel()+value["frameLevel"])
                end
                -- update orientation
                if value["orientation"] then
                    indicator:SetOrientation(value["orientation"])
                end
                -- update font
                if value["font"] then
                    indicator:SetFont(unpack(value["font"]))
                end
                -- update color
                if value["color"] then
                    indicator:SetColor(unpack(value["color"]))
                end
                -- update colors
                if value["colors"] then
                    indicator:SetColors(value["colors"])
                end
                -- update texture
                if value["texture"] then
                    indicator:SetTexture(value["texture"])
                end
                -- update showDuration
                if type(value["showDuration"]) ~= "nil" then
                    indicator:ShowDuration(value["showDuration"])
                end
                -- update showAnimation
                if type(value["showAnimation"]) == "boolean" then
                    indicator:ShowAnimation(value["showAnimation"])
                end
                -- update showStack
                if value["showStack"] then
                    indicator:ShowStack(value["showStack"])
                end
                -- update duration
                if value["duration"] then
                    indicator:SetDuration(value["duration"])
                end
                 -- update circled nums
                 if type(value["circledStackNums"]) == "boolean" then
                    indicator:SetCircledStackNums(value["circledStackNums"])
                end
                -- update fadeOut
                if type(value["fadeOut"]) == "boolean" then
                    indicator:SetFadeOut(value["fadeOut"])
                end
                -- update glow
                if value["glowOptions"] then
                    indicator:UpdateGlowOptions(value["glowOptions"])
                end
                -- FirstRun: Healers
                if value["auras"] and #value["auras"] ~= 0 then
                    UnitButton_UpdateAuras(b)
                end
            end, true)
        elseif setting == "remove" then
            F:IterateAllUnitButtons(function(b)
                I:RemoveIndicator(b, indicatorName, value)
            end, true)
        elseif setting == "auras" then
            -- indicator auras changed, hide them all, then recheck whether to show
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:Hide()
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "debuffBlacklist" or setting == "dispelBlacklist" or setting == "defensives" or setting == "externals" or setting == "bigDebuffs" or setting == "debuffTypeColor" then
            F:IterateAllUnitButtons(function(b)
                UnitButton_UpdateAuras(b)
            end, true)
        elseif setting == "speed" then
            -- only Consumables indicator has this option for now
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:SetSpeed(value)
            end, true)
        elseif setting == "shape" then
            F:IterateAllUnitButtons(function(b)
                b.indicators[indicatorName]:SetShape(value)
            end, true)
        end
    end
end
Cell:RegisterCallback("UpdateIndicators", "UnitButton_UpdateIndicators", UpdateIndicators)

-------------------------------------------------
-- debuffs
-------------------------------------------------
local function UnitButton_UpdateDebuffs(self)
    local unit = self.state.displayedUnit
    
    -- self.state.BGOrb = nil

    -- user created indicators
    I:ResetCustomIndicators(self, "debuff")

    local startIndex, raidDebuffsFound, wsFound = 1
    local glowType, glowOptions
    local refreshing = false

    for i = 1, 40 do
        -- name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, ...
        local name, icon, count, debuffType, duration, expirationTime, source, _, _, spellId = UnitDebuff(unit, i)
        if not name then
            break
        end
        
        local auraInstanceID = (source or "") .. spellId
        
        -- check Bleed
        debuffType = I:CheckDebuffType(debuffType, spellId)

        if duration then
            if Cell.vars.iconAnimation == "duration" then
                local timeIncreased = self._debuffs_cache[auraInstanceID] and (expirationTime - self._debuffs_cache[auraInstanceID] >= 0.5) or false
                local countIncreased = self._debuffs_count_cache[auraInstanceID] and (count > self._debuffs_count_cache[auraInstanceID]) or false
                refreshing = timeIncreased or countIncreased
            elseif Cell.vars.iconAnimation == "stack" then
                refreshing = self._debuffs_count_cache[auraInstanceID] and (count > self._debuffs_count_cache[auraInstanceID]) or false
            else
                refreshing = false
            end

            if enabledIndicators["debuffs"] and duration <= 600 and not Cell.vars.debuffBlacklist[spellId] then
                if not indicatorCustoms["debuffs"] then -- all debuffs
                    if Cell.vars.bigDebuffs[spellId] then  -- isBigDebuff
                        self._debuffs_big[i] = refreshing
                        startIndex = startIndex + 1
                    elseif startIndex <= indicatorNums["debuffs"]+indicatorNums["raidDebuffs"] then -- normal debuffs, may contain topDebuff
                        self._debuffs_normal[i] = refreshing
                        startIndex = startIndex + 1
                    end

                elseif I:CanDispel(debuffType) then -- only dispellableByMe
                    if Cell.vars.bigDebuffs[spellId] then  -- isBigDebuff
                        self._debuffs_big[i] = refreshing
                        startIndex = startIndex + 1
                    elseif startIndex <= indicatorNums["debuffs"]+indicatorNums["raidDebuffs"] then -- normal debuffs, may contain topDebuff
                        if I:CanDispel(debuffType) then
                            self._debuffs_normal[i] = refreshing
                            startIndex = startIndex + 1
                        end
                    end
                end
            end
            
            -- user created indicators
            I:UpdateCustomIndicators(self, "debuff", spellId, name, expirationTime - duration, duration, debuffType or "", icon, count, refreshing)

            -- prepare raidDebuffs
            if enabledIndicators["raidDebuffs"] and I:GetDebuffOrder(name, spellId, count) then
                raidDebuffsFound = true
                tinsert(self._debuffs_raid, i)
                self._debuffs_raid_refreshing[i] = refreshing -- store all raidDebuffs
                self._debuffs_raid_orders[i] = I:GetDebuffOrder(name, spellId, count)

                if not indicatorCustoms["raidDebuffs"] then -- glow all matching debuffs
                    glowType, glowOptions = I:GetDebuffGlow(name, spellId, count)
                    if glowType and glowType ~= "None" then
                        self._debuffs_glow_current[glowType] = glowOptions
                        self._debuffs_glow_cache[glowType] = true
                    end
                end
            end

            self._debuffs_cache[auraInstanceID] = expirationTime
            self._debuffs_count_cache[auraInstanceID] = count
            self._debuffs_current[auraInstanceID] = i

            if enabledIndicators["dispels"] and debuffType and debuffType ~= "" then
                -- all dispels / only dispellableByMe
                if not indicatorCustoms["dispels"] or I:CanDispel(debuffType) then
                    if Cell.vars.dispelBlacklist[spellId] then
                        -- no highlight
                        self._debuffs_dispel[debuffType] = false
                    else
                        self._debuffs_dispel[debuffType] = true
                    end
                end
            end

            -- BG orbs
            -- if spellId == 121164 then
            --     self.state.BGOrb = "blue"
            -- end
            -- if spellId == 121175 then
            --     self.state.BGOrb = "purple"
            -- end
            -- if spellId == 121176 then
            --     self.state.BGOrb = "green"
            -- end
            -- if spellId == 121177 then
            --     self.state.BGOrb = "orange"
            -- end
        end
    end

    -- update raid debuffs
    if raidDebuffsFound then
        startIndex = 1
        self.indicators.raidDebuffs:Show()

        -- sort indices
        -- NOTE: self._debuffs_raid_orders = { [index] = debuffOrder } used for sorting
        table.sort(self._debuffs_raid, function(a, b)
            return self._debuffs_raid_orders[a] < self._debuffs_raid_orders[b]
        end)
        
        -- show
        local topGlowType, topGlowOptions
        for i = 1, indicatorNums["raidDebuffs"] do
            if self._debuffs_raid[i] then -- self._debuffs_raid[i] -> index
                local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitDebuff(unit, self._debuffs_raid[i])
                if name then
                    self.indicators.raidDebuffs[i]:SetCooldown(expirationTime - duration, duration, debuffType or "", icon, count, self._debuffs_raid_refreshing[self._debuffs_raid[i]])
                    self.indicators.raidDebuffs[i].index = self._debuffs_raid[i] -- NOTE: for tooltip
                    startIndex = startIndex + 1
                    -- store debuffs indices shown by raidDebuffs indicator
                    self._debuffs_raid_shown[self._debuffs_raid[i]] = true

                    if i == 1 then -- top
                        topGlowType, topGlowOptions = I:GetDebuffGlow(name, spellId, count)
                    end
                end
            end
        end

        -- update raidDebuffs
        self.indicators.raidDebuffs:UpdateSize(startIndex - 1)
        for i = startIndex, 3 do
            self.indicators.raidDebuffs[i].index = nil
        end

        -- update glow
        if not indicatorCustoms["raidDebuffs"] then
            if topGlowType and topGlowType ~= "None" then
                -- to make sure top glow has highest priority
                self._debuffs_glow_current[topGlowType] = topGlowOptions
            end
            for t, o in pairs(self._debuffs_glow_current) do
                self.indicators.raidDebuffs:ShowGlow(t, o, true)
            end
            for t, _ in pairs(self._debuffs_glow_cache) do
                if not self._debuffs_glow_current[t] then
                    self.indicators.raidDebuffs:HideGlow(t)
                    self._debuffs_glow_cache[t] = nil
                end
            end
            wipe(self._debuffs_glow_current)
        else
            self.indicators.raidDebuffs:ShowGlow(topGlowType, topGlowOptions)
        end
    else
        self.indicators.raidDebuffs:Hide()
    end

    -- update debuffs
    startIndex = 1
    if enabledIndicators["debuffs"] then
        -- bigDebuffs first
        for debuffIndex, refreshing in pairs(self._debuffs_big) do
            local name, icon, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, debuffIndex)
            if name and not self._debuffs_raid_shown[debuffIndex] and startIndex <= indicatorNums["debuffs"] then
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.debuffs[startIndex]:SetCooldown(expirationTime - duration, duration, debuffType or "", icon, count, refreshing, true)
                self.indicators.debuffs[startIndex].index = debuffIndex -- NOTE: for tooltip
                self.indicators.debuffs[startIndex].spellId = spellId -- NOTE: for blacklist
                startIndex = startIndex + 1
            end
        end
        -- then normal debuffs
        for debuffIndex, refreshing in pairs(self._debuffs_normal) do
            local name, icon, count, debuffType, duration, expirationTime, _, _, _, spellId = UnitDebuff(unit, debuffIndex)
            if name and not self._debuffs_raid_shown[debuffIndex] and startIndex <= indicatorNums["debuffs"] then
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.debuffs[startIndex]:SetCooldown(expirationTime - duration, duration, debuffType or "", icon, count, refreshing)
                self.indicators.debuffs[startIndex].index = debuffIndex -- NOTE: for tooltip
                self.indicators.debuffs[startIndex].spellId = spellId -- NOTE: for blacklist
                startIndex = startIndex + 1
            end
        end
    end

    -- update debuffs
    self.indicators.debuffs:UpdateSize(startIndex - 1)
    for i = startIndex, 10 do
        self.indicators.debuffs[i].index = nil
        self.indicators.debuffs[i].spellId = nil
    end

    -- update dispels
    self.indicators.dispels:SetDispels(self._debuffs_dispel)
    
    -- user created indicators
    I:ShowCustomIndicators(self, "debuff")

    -- update debuffs_cache
    for auraInstanceID, expirationTime in pairs(self._debuffs_cache) do
        -- lost or expired
        if not self._debuffs_current[auraInstanceID] or (expirationTime ~= 0 and GetTime() >= expirationTime) then -- expirationTime == 0: no duration 
            self._debuffs_cache[auraInstanceID] = nil
            self._debuffs_count_cache[auraInstanceID] = nil
        end
    end

    wipe(self._debuffs_current)
    wipe(self._debuffs_normal)
    wipe(self._debuffs_big)
    wipe(self._debuffs_dispel)
    wipe(self._debuffs_raid)
    wipe(self._debuffs_raid_refreshing)
    wipe(self._debuffs_raid_orders)
    wipe(self._debuffs_raid_shown)
end

-------------------------------------------------
-- buffs
-------------------------------------------------
local function UnitButton_UpdateBuffs(self)
    local unit = self.state.displayedUnit
    
    self.state.BGFlag = nil

    -- user created indicators
    I:ResetCustomIndicators(self, "buff")

    local refreshing = false
    local defensiveFound, externalFound, allFound, drinkingFound, pwsFound = 1, 1, 1, false, false
    
    for i = 1, 40 do
        -- name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, ...
        local name, icon, count, debuffType, duration, expirationTime, source, _, _, spellId, _, _, _, _, _, arg16 = UnitBuff(unit, i)
        if not name then
            break
        end

        local auraInstanceID = (source or "") .. spellId
        
        if duration then
            if Cell.vars.iconAnimation == "duration" then
                local timeIncreased = self._buffs_cache[auraInstanceID] and (expirationTime - self._buffs_cache[auraInstanceID] >= 0.5) or false
                local countIncreased = self._buffs_count_cache[auraInstanceID] and (count > self._buffs_count_cache[auraInstanceID]) or false
                refreshing = timeIncreased or countIncreased
            elseif Cell.vars.iconAnimation == "stack" then
                refreshing = self._buffs_count_cache[auraInstanceID] and (count > self._buffs_count_cache[auraInstanceID]) or false
            else
                refreshing = false
            end

            -- defensiveCooldowns
            if enabledIndicators["defensiveCooldowns"] and I:IsDefensiveCooldown(name, spellId) and defensiveFound <= indicatorNums["defensiveCooldowns"] then
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.defensiveCooldowns[defensiveFound]:SetCooldown(expirationTime - duration, duration, nil, icon, count, refreshing)
                defensiveFound = defensiveFound + 1
            end

            -- externalCooldowns
            if enabledIndicators["externalCooldowns"] and I:IsExternalCooldown(name, spellId, source, unit) and externalFound <= indicatorNums["externalCooldowns"] then
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.externalCooldowns[externalFound]:SetCooldown(expirationTime - duration, duration, nil, icon, count, refreshing)
                externalFound = externalFound + 1
            end

            -- allCooldowns
            if enabledIndicators["allCooldowns"] and (I:IsExternalCooldown(name, spellId, source, unit) or I:IsDefensiveCooldown(name, spellId)) and allFound <= indicatorNums["allCooldowns"] then
                -- start, duration, debuffType, texture, count, refreshing
                self.indicators.allCooldowns[allFound]:SetCooldown(expirationTime - duration, duration, nil, icon, count, refreshing)
                allFound = allFound + 1
            end

            -- drinking
            if enabledIndicators["statusText"] and I:IsDrinking(name) then
                if not self.indicators.statusText:GetStatus() then
                    self.indicators.statusText:SetStatus("DRINKING")
                    self.indicators.statusText:Show()
                end
                drinkingFound = true
            end

            -- user created indicators
            I:UpdateCustomIndicators(self, "buff", spellId, name, expirationTime - duration, duration, nil, icon, count, refreshing, source == "player" or source == "pet", arg16)

            -- check BG flags for statusIcon
            if spellId == 301091 then
                self.state.BGFlag = "alliance"
            end
            if spellId == 301089 then
                self.state.BGFlag = "horde"
            end

            self._buffs_current[auraInstanceID] = i
            self._buffs_cache[auraInstanceID] = expirationTime
            self._buffs_count_cache[auraInstanceID] = count
        end
    end

    -- update defensiveCooldowns
    self.indicators.defensiveCooldowns:UpdateSize(defensiveFound - 1)
    
    -- update externalCooldowns
    self.indicators.externalCooldowns:UpdateSize(externalFound - 1)
    
    -- update allCooldowns
    self.indicators.allCooldowns:UpdateSize(allFound - 1)
    
    -- hide drinking
    if not drinkingFound and self.indicators.statusText:GetStatus() == "DRINKING" then
        -- self.indicators.statusText:Hide()
        self.indicators.statusText:SetStatus()
    end

    -- update buffs_cache
    for auraInstanceID, expirationTime in pairs(self._buffs_cache) do
        -- lost or expired
        if not self._buffs_current[auraInstanceID] or (expirationTime ~= 0 and GetTime() >= expirationTime) then
            self._buffs_cache[auraInstanceID] = nil
            self._buffs_count_cache[auraInstanceID] = nil
        end
    end
    wipe(self._buffs_current)

    I:ShowCustomIndicators(self, "buff")
end

-------------------------------------------------
-- aura tables
-------------------------------------------------
local function InitAuraTables(self)
    -- for icon animation only
    self._buffs_current = {}
    self._buffs_cache = {}
    self._buffs_count_cache = {}
    self._debuffs_current = {}
    self._debuffs_cache = {}
    self._debuffs_count_cache = {}

    -- debuffs
    self._debuffs_normal = {} -- [auraInstanceID] = refreshing
    self._debuffs_big = {} -- [auraInstanceID] = refreshing
    self._debuffs_dispel = {} -- [debuffType] = true/false
    self._debuffs_raid = {} -- {index1, index2, ...}
    self._debuffs_raid_refreshing = {} -- [auraInstanceID] = refreshing
    self._debuffs_raid_orders = {} -- [auraInstanceID] = order
    self._debuffs_raid_shown = {} -- [auraInstanceID] = true, currently shown by raidDebuffs indicator
    self._debuffs_glow_current = {}
    self._debuffs_glow_cache = {}
end

local function ResetAuraTables(self)
    wipe(self._buffs_current)
    wipe(self._buffs_cache)
    wipe(self._buffs_count_cache)
    wipe(self._debuffs_current)
    wipe(self._debuffs_cache)
    wipe(self._debuffs_count_cache)

    -- debuffs
    wipe(self._debuffs_normal)
    wipe(self._debuffs_big)
    wipe(self._debuffs_dispel)
    wipe(self._debuffs_raid)
    wipe(self._debuffs_raid_refreshing)
    wipe(self._debuffs_raid_orders)
    wipe(self._debuffs_raid_shown)

    -- raid debuffs glow
    wipe(self._debuffs_glow_current)
    wipe(self._debuffs_glow_cache)
    if self.indicators.raidDebuffs then
        self.indicators.raidDebuffs:HideGlow()
    end
end

-------------------------------------------------
-- functions
-------------------------------------------------
local function UpdateUnitHealthState(self, diff)
    local unit = self.state.displayedUnit
    local guid = self.state.guid

    local health = UnitHealth(unit) + (diff or 0)
    local healthMax = UnitHealthMax(unit)
    health = min(health, healthMax) --! diff

    self.state.health = health
    self.state.healthMax = healthMax
    self.state.totalAbsorbs = 0

    if healthMax == 0 then
        self.state.healthPercent = 0
    else
        self.state.healthPercent = health / healthMax
    end

    self.state.wasDead = self.state.isDead
    self.state.isDead = health == 0
    if self.state.wasDead ~= self.state.isDead then
        UnitButton_UpdateStatusText(self)
        I.UpdateStatusIcon_Resurrection(self)
        if not self.state.isDead then
            self.state.hasSoulstone = nil
            I.UpdateStatusIcon(self)
        end
    end
    
    self.state.wasDeadOrGhost = self.state.isDeadOrGhost
    self.state.isDeadOrGhost = UnitIsDeadOrGhost(unit)
    if self.state.wasDeadOrGhost ~= self.state.isDeadOrGhost then
        I.UpdateStatusIcon_Resurrection(self)
        UnitButton_UpdateHealthColor(self)
    end

    if enabledIndicators["healthText"] and healthMax ~= 0 then
        if health == healthMax or self.state.isDeadOrGhost then
            if not indicatorCustoms["healthText"] then
                self.indicators.healthText:SetHealth(health, healthMax, self.state.totalAbsorbs)
                self.indicators.healthText:Show()
            else
                self.indicators.healthText:Hide()
            end
        else
            self.indicators.healthText:SetHealth(health, healthMax, self.state.totalAbsorbs)
            self.indicators.healthText:Show()
        end
    else
        self.indicators.healthText:Hide()
    end
end

-------------------------------------------------
-- power filter funcs
-------------------------------------------------
local function ShouldShowPowerBar(b)
    if not (b:IsVisible() or b.isPreview) then return end
    if not b.powerSize or b.powerSize == 0 then return end
    
    if not b.state.guid  then
        return true
    end

    local class
    if b.state.inVehicle then
        class = "VEHICLE"
    elseif string.find(b.state.guid, "^Player") then
        class = b.state.class
    elseif string.find(b.state.guid, "^Pet") then
        class = "PET"
    elseif string.find(b.state.guid, "^Creature") then
        class = "NPC"
    elseif string.find(b.state.guid, "^Vehicle") then
        class = "VEHICLE"
    end
    
    if class then
        return Cell.vars.currentLayoutTable["powerFilters"][class]
    end

    return true
end

local function ShowPowerBar(b)
    if b:IsVisible() and not b.isPreview then
        b:RegisterEvent("UNIT_POWER_FREQUENT")
        b:RegisterEvent("UNIT_MAXPOWER")
        b:RegisterEvent("UNIT_DISPLAYPOWER")
    end
    b.widget.powerBar:Show()
    b.widget.powerBarLoss:Show()
    b.widget.gapTexture:Show()

    P:ClearPoints(b.widget.healthBar)
    P:ClearPoints(b.widget.powerBar)
    if b.orientation == "horizontal" or b.orientation == "vertical_health" then
        P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", CELL_BORDER_SIZE, -CELL_BORDER_SIZE)
        P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -CELL_BORDER_SIZE, b.powerSize + CELL_BORDER_SIZE * 2)
        P:Point(b.widget.powerBar, "TOPLEFT", b.widget.healthBar, "BOTTOMLEFT", 0, -CELL_BORDER_SIZE)
        P:Point(b.widget.powerBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -CELL_BORDER_SIZE, CELL_BORDER_SIZE)
    else
        P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", CELL_BORDER_SIZE, -CELL_BORDER_SIZE)
        P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -(b.powerSize + CELL_BORDER_SIZE * 2), CELL_BORDER_SIZE)
        P:Point(b.widget.powerBar, "TOPLEFT", b.widget.healthBar, "TOPRIGHT", CELL_BORDER_SIZE, 0)
        P:Point(b.widget.powerBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -CELL_BORDER_SIZE, CELL_BORDER_SIZE)
    end

    if b:IsVisible() then
        -- update now
        UnitButton_UpdatePowerMax(b)
        UnitButton_UpdatePower(b)
        UnitButton_UpdatePowerType(b)
    end
end

local function HidePowerBar(b)
    b:UnregisterEvent("UNIT_POWER_FREQUENT")
    b:UnregisterEvent("UNIT_MAXPOWER")
    b:UnregisterEvent("UNIT_DISPLAYPOWER")
    b.widget.powerBar:Hide()
    b.widget.powerBarLoss:Hide()
    b.widget.gapTexture:Hide()

    P:ClearPoints(b.widget.healthBar)
    P:Point(b.widget.healthBar, "TOPLEFT", b, "TOPLEFT", CELL_BORDER_SIZE, -CELL_BORDER_SIZE)
    P:Point(b.widget.healthBar, "BOTTOMRIGHT", b, "BOTTOMRIGHT", -CELL_BORDER_SIZE, CELL_BORDER_SIZE)
end

-------------------------------------------------
-- unit button functions
-------------------------------------------------
local function UnitButton_UpdateTarget(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    if UnitIsUnit(unit, "target") then
        if highlightEnabled then self.widget.targetHighlight:Show() end
    else
        self.widget.targetHighlight:Hide()
    end
end

local function CheckVehicleRoot(self, petUnit)
    if not petUnit then return end

    local playerUnit = F:GetPlayerUnit(petUnit)

    local isRoot
    for i = 1, UnitVehicleSeatCount(playerUnit) do
        local controlType, occupantName, serverName, ejectable, canSwitchSeats = UnitVehicleSeatInfo(playerUnit, i)
        if UnitName(playerUnit) == occupantName then
            isRoot = controlType == "Root"
            break
        end
    end

    self.indicators.roleIcon:SetRole(isRoot and "VEHICLE" or "NONE")
end

UnitButton_UpdateAssignment = function(self)
    local unit = self.state.unit
    if not unit then return end

    local partyAssignmentIcon = self.indicators.partyAssignmentIcon
    if enabledIndicators["partyAssignmentIcon"] then
        partyAssignmentIcon:UpdateAssignment(unit)

        --! check vehicle root
        if self.state.guid and strfind(self.state.guid, "^Vehicle") then
            CheckVehicleRoot(self, unit)
        end
    else
        partyAssignmentIcon:Hide()
    end
end

UnitButton_UpdateLeader = function(self, event)
    local unit = self.state.unit
    if not unit then return end
    
    local leaderIcon = self.indicators.leaderIcon

    if enabledIndicators["leaderIcon"] then
        if indicatorCustoms["leaderIcon"] and (InCombatLockdown() or event == "PLAYER_REGEN_DISABLED") then
            leaderIcon:Hide()
            return
        end

        local isLeader = UnitIsGroupLeader(unit)
        self.state.isLeader = isLeader
        local isAssistant = UnitIsGroupAssistant(unit) and IsInRaid()
        self.state.isAssistant = isAssistant
        
        leaderIcon:SetIcon(isLeader, isAssistant)
    else
        leaderIcon:Hide()
    end
end

local function UnitButton_UpdatePlayerRaidIcon(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local playerRaidIcon = self.indicators.playerRaidIcon

    local index = GetRaidTargetIndex(unit)

    if enabledIndicators["playerRaidIcon"] then
        if index then
            SetRaidTargetIconTexture(playerRaidIcon.tex, index)
            playerRaidIcon:Show()
        else
            playerRaidIcon:Hide()
        end
    else
        playerRaidIcon:Hide()
    end
end

local function UnitButton_UpdateTargetRaidIcon(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local targetRaidIcon = self.indicators.targetRaidIcon

    local index = GetRaidTargetIndex(unit.."target")

    if enabledIndicators["targetRaidIcon"] then
        if index then
            SetRaidTargetIconTexture(targetRaidIcon.tex, index)
            targetRaidIcon:Show()
        else
            targetRaidIcon:Hide()
        end
    else
        targetRaidIcon:Hide()
    end
end

local function UnitButton_UpdateReadyCheck(self)
    local unit = self.state.unit
    if not unit then return end
    
    local status = GetReadyCheckStatus(unit)
    self.state.readyCheckStatus = status

    if status then
        -- self.widget.readyCheckHighlight:SetVertexColor(unpack(READYCHECK_STATUS[status].c))
        -- self.widget.readyCheckHighlight:Show()
        self.indicators.readyCheckIcon:SetStatus(status)
    else
        -- self.widget.readyCheckHighlight:Hide()
        self.indicators.readyCheckIcon:Hide()
    end
end

local function UnitButton_FinishReadyCheck(self)
    if self.state.readyCheckStatus == "waiting" then
        -- self.widget.readyCheckHighlight:SetVertexColor(unpack(READYCHECK_STATUS.notready.c))
        self.indicators.readyCheckIcon:SetStatus("notready")
    end
    C_Timer.After(6, function()
        -- self.widget.readyCheckHighlight:Hide()
        self.indicators.readyCheckIcon:Hide()
    end)
end

UnitButton_UpdatePowerMax = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local value = UnitPowerMax(unit)
    if value < 0 then value = 0 end
    
    if barAnimationType == "Smooth" then
        self.widget.powerBar:SetMinMaxSmoothedValue(0, value)
    else
        self.widget.powerBar:SetMinMaxValues(0, value)
    end
end

UnitButton_UpdatePower = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    if barAnimationType == "Smooth" then
        self.widget.powerBar:SetSmoothedValue(UnitPower(unit))
    else
        self.widget.powerBar:SetValue(UnitPower(unit))
    end
end

UnitButton_UpdatePowerType = function(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local r, g, b, lossR, lossG, lossB
    local a = Cell.loaded and CellDB["appearance"]["lossAlpha"] or 1

    if not UnitIsConnected(unit) then
        r, g, b = 0.5, 0.5, 0.5
        lossR, lossG, lossB = r*0.2, g*0.2, b*0.2
    else
        r, g, b, lossR, lossG, lossB, self.state.powerType = F:GetPowerColor(unit, self.state.class)
    end

    self.widget.powerBar:SetStatusBarColor(r, g, b)
    self.widget.powerBarLoss:SetVertexColor(lossR, lossG, lossB)
end

local function UnitButton_UpdateHealthMax(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    UpdateUnitHealthState(self)

    if barAnimationType == "Smooth" then
        self.widget.healthBar:SetMinMaxSmoothedValue(0, self.state.healthMax)
    else
        self.widget.healthBar:SetMinMaxValues(0, self.state.healthMax)
    end

    if Cell.vars.useGradientColor then
        UnitButton_UpdateHealthColor(self)
    end
end

local function UnitButton_UpdateHealth(self, diff)
    local unit = self.state.displayedUnit
    if not unit then return end

    UpdateUnitHealthState(self, diff)
    local healthPercent = self.state.healthPercent
    
    if barAnimationType == "Flash" then
        self.widget.healthBar:SetValue(self.state.health)
        local diff = healthPercent - (self.state.healthPercentOld or healthPercent)
        if diff >= 0 then
            self.func.HideFlash()
        elseif diff <= -0.05 and diff >= -1 then --! player (just joined) UnitHealthMax(unit) may be 1 ====> diff == -maxHealth
            self.func.ShowFlash(abs(diff))
        end
    elseif barAnimationType == "Smooth" then
        self.widget.healthBar:SetSmoothedValue(self.state.health)
    else
        self.widget.healthBar:SetValue(self.state.health)
    end

    if Cell.vars.useGradientColor then
        UnitButton_UpdateHealthColor(self)
    end

    self.state.healthPercentOld = healthPercent

    if enabledIndicators["healthThresholds"] then
        self.indicators.healthThresholds:CheckThreshold(healthPercent)
    else
        self.indicators.healthThresholds:Hide()
    end

    if CELL_FADE_OUT_HEALTH_PERCENT then
        if self.state.inRange and healthPercent < CELL_FADE_OUT_HEALTH_PERCENT then
            A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
        else
            A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
        end
    end
end

local useLibHealComm = false
local function UnitButton_UpdateHealPrediction(self)
    if not predictionEnabled then
        self.widget.incomingHeal:Hide()
        return
    end

    local unit = self.state.displayedUnit
    if not unit then return end

    local value = 0

    if useLibHealComm and HealComm then
        --! NOTE: use LibHealComm
        if self.__displayedGuid then
            local modifier = HealComm:GetHealModifier(self.__displayedGuid) or 1
            value = (HealComm:GetHealAmount(self.__displayedGuid, HealComm.CASTED_HEALS) or 0) * modifier
            -- local hot = select(3, HealComm:GetNextHealAmount(self.__displayedGuid, HealComm.HOT_HEALS)) or 0
            -- NOTE: hots within 3 seconds
            local hot = (HealComm:GetHealAmount(self.__displayedGuid, HealComm.OVERTIME_AND_BOMB_HEALS, GetTime()+3) or 0) * modifier
            value = value + hot
        end
    else
        value = UnitGetIncomingHeals(unit) or 0
    end

    if value == 0 then 
        self.widget.incomingHeal:Hide()
        return
    end

    UpdateUnitHealthState(self)

    self.widget.incomingHeal:SetValue(value / self.state.healthMax)
end

UnitButton_UpdateAuras = function(self)
    if not indicatorsInitialized then return end

    local unit = self.state.displayedUnit
    if not unit then return end

    UnitButton_UpdateDebuffs(self)
    UnitButton_UpdateBuffs(self)
    I.UpdateStatusIcon(self)
end

local function UnitButton_UpdateThreat(self)
    local unit = self.state.displayedUnit
    if not unit or not UnitExists(unit) then return end

    local status = UnitThreatSituation(unit)
    if status and status >= 2 then
        if enabledIndicators["aggroBlink"] then
            self.indicators.aggroBlink:ShowAggro(GetThreatStatusColor(status))
        end
        if enabledIndicators["aggroBorder"] then
            self.indicators.aggroBorder:ShowAggro(GetThreatStatusColor(status))
        end
    else
        self.indicators.aggroBlink:Hide()
        self.indicators.aggroBorder:Hide()
    end
end

local function UnitButton_UpdateThreatBar(self)
    if not enabledIndicators["aggroBar"] then 
        self.indicators.aggroBar:Hide()
        return
    end

    local unit = self.state.displayedUnit
    if not unit or not UnitExists(unit) then return end

    -- isTanking, status, scaledPercentage, rawPercentage, threatValue = UnitDetailedThreatSituation(unit, mobUnit)
    local _, status, scaledPercentage, rawPercentage = UnitDetailedThreatSituation(unit, "target")
    if status then
        self.indicators.aggroBar:Show()
        self.indicators.aggroBar:SetSmoothedValue(scaledPercentage)
        self.indicators.aggroBar:SetStatusBarColor(GetThreatStatusColor(status))
    else
        self.indicators.aggroBar:Hide()
    end
end

local function UnitButton_UpdateInRange(self)
    local unit = self.state.displayedUnit
    if not unit then return end

    local inRange = F:IsInRange(unit)

    self.state.inRange = inRange
    if Cell.loaded then
        if self.state.inRange ~= self.state.wasInRange then
            if inRange then
                if CELL_FADE_OUT_HEALTH_PERCENT then
                    if not self.state.healthPercent or self.state.healthPercent < CELL_FADE_OUT_HEALTH_PERCENT then
                        A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
                    else
                        A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
                    end
                else
                    A:FrameFadeIn(self, 0.25, self:GetAlpha(), 1)
                end
            else
                A:FrameFadeOut(self, 0.25, self:GetAlpha(), CellDB["appearance"]["outOfRangeAlpha"])
            end
        end
        self.state.wasInRange = inRange
        -- self:SetAlpha(inRange and 1 or CellDB["appearance"]["outOfRangeAlpha"])
    end
end

local function UnitButton_UpdateVehicleStatus(self)
    local unit = self.state.unit
    if not unit then return end

    if UnitHasVehicleUI(unit) then -- or UnitInVehicle(unit) or UnitUsingVehicle(unit) then
        self.state.inVehicle = true
        if unit == "player" then
            self.state.displayedUnit = "vehicle"
        else
            -- local prefix, id, suffix = strmatch(unit, "([^%d]+)([%d]*)(.*)")
            local prefix, id = strmatch(unit, "([^%d]+)([%d]+)")
            self.state.displayedUnit = prefix.."pet"..id
        end
        self.indicators.nameText:UpdateVehicleName()
    else
        self.state.inVehicle = nil
        self.state.displayedUnit = self.state.unit
        self.indicators.nameText.vehicle:SetText("")
    end
    
    if Cell.loaded then
        if ShouldShowPowerBar(self) then
            ShowPowerBar(self)
        else
            HidePowerBar(self)
        end
    end
end

UnitButton_UpdateStatusText = function(self)
    local statusText = self.indicators.statusText
    if not enabledIndicators["statusText"] then
        -- statusText:Hide()
        statusText:SetStatus()
        return
    end

    local unit = self.state.unit
    if not unit then return end

    self.state.guid = UnitGUID(unit) -- update!
    if not self.state.guid then return end

    if not UnitIsConnected(unit) and UnitIsPlayer(unit) then
        statusText:Show()
        statusText:SetStatus("OFFLINE")
        statusText:ShowTimer()
    elseif UnitIsAFK(unit) then
        statusText:Show()
        statusText:SetStatus("AFK")
        statusText:ShowTimer()
    elseif UnitIsFeignDeath(unit) then
        statusText:Show()
        statusText:SetStatus("FEIGN")
        statusText:HideTimer(true)
    elseif UnitIsDeadOrGhost(unit) then
        statusText:Show()
        statusText:HideTimer(true)
        if UnitIsGhost(unit) then
            statusText:SetStatus("GHOST")
        else
            statusText:SetStatus("DEAD")
        end
    elseif statusText:GetStatus() == "DRINKING" then
        -- update colors
        statusText:Show()
        statusText:SetStatus("DRINKING")
    else
        -- statusText:Hide()
        statusText:HideTimer(true)
        statusText:SetStatus()
    end
end

local function UnitButton_UpdateName(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.name = UnitName(unit)
    self.state.fullName = F:UnitFullName(unit)
    self.state.class = UnitClassBase(unit)
    self.state.guid = UnitGUID(unit)
    self.state.isPlayer = UnitIsPlayer(unit)

    self.indicators.nameText:UpdateName()
end

UnitButton_UpdateNameColor = function(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.class = UnitClassBase(unit) --! update class or it may be nil

    local nameText = self.indicators.nameText

    if not Cell.loaded then
        nameText:SetColor(1, 1, 1)
        return 
    end
    
    if UnitIsPlayer(unit) then -- player
        if not UnitIsConnected(unit) then
            nameText:SetColor(F:GetClassColor(self.state.class))
        elseif UnitIsCharmed(unit) then
            nameText:SetColor(F:GetClassColor(self.state.class))
        else
            if Cell.vars.currentLayoutTable["indicators"][1]["color"][1] == "class_color" then
                nameText:SetColor(F:GetClassColor(self.state.class))
            else
                nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["color"][2]))
            end
        end
    elseif string.find(unit, "pet") then -- pet
        if Cell.vars.currentLayoutTable["indicators"][1]["color"][1] == "class_color" then
            nameText:SetColor(0.5, 0.5, 1)
        else
            nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["color"][2]))
        end
    else -- npc
        if Cell.vars.currentLayoutTable["indicators"][1]["color"][1] == "class_color" then
            nameText:SetColor(0, 1, 0.2)
        else
            nameText:SetColor(unpack(Cell.vars.currentLayoutTable["indicators"][1]["color"][2]))
        end
    end
end

UnitButton_UpdateHealthColor = function(self)
    local unit = self.state.unit
    if not unit then return end

    self.state.class = UnitClassBase(unit) --! update class or it may be nil

    local barR, barG, barB
    local lossR, lossG, lossB
    local barA, lossA = 1, 1
    
    if Cell.loaded then
        barA =  CellDB["appearance"]["barAlpha"]
        lossA =  CellDB["appearance"]["lossAlpha"]
    end

    if UnitIsPlayer(unit) then -- player
        if not UnitIsConnected(unit) then
            barR, barG, barB = 0.4, 0.4, 0.4
            lossR, lossG, lossB = 0.4, 0.4, 0.4
        elseif UnitIsCharmed(unit) then
            barR, barG, barB = 0.5, 0, 1
            lossR, lossG, lossB = barR*0.2, barG*0.2, barB*0.2
        elseif self.state.inVehicle then
            barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0, 1, 0.2)
        else
            barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, F:GetClassColor(self.state.class))
        end
    elseif string.find(unit, "pet") then -- pet
        barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0.5, 0.5, 1)
    else -- npc
        barR, barG, barB, lossR, lossG, lossB = F:GetHealthColor(self.state.healthPercent, self.state.isDeadOrGhost, 0, 1, 0.2)
    end

    -- local r, g, b = RAID_CLASS_COLORS["DEATHKNIGHT"]:GetRGB()
    self.widget.healthBar:SetStatusBarColor(barR, barG, barB, barA)
    self.widget.healthBarLoss:SetVertexColor(lossR, lossG, lossB, lossA)

    if Cell.loaded and CellDB["appearance"]["healPrediction"][2] then
        self.widget.incomingHeal:SetVertexColor(CellDB["appearance"]["healPrediction"][3][1], CellDB["appearance"]["healPrediction"][3][2], CellDB["appearance"]["healPrediction"][3][3], CellDB["appearance"]["healPrediction"][3][4])
    else
        self.widget.incomingHeal:SetVertexColor(barR, barG, barB, 0.4)
    end
end

-------------------------------------------------
-- LibHealComm
-------------------------------------------------
Cell.HealComm = {}
local function HealComm_UpdateHealPrediction(_, event, casterGUID, spellID, healType, endTime, ...)
    -- print(event, casterGUID, spellID, healType, endTime, ...)
    -- update incomingHeal
    for i = 1, select("#", ...) do
        F:HandleUnitButton("guid", select(i, ...), UnitButton_UpdateHealPrediction)
    end
end
Cell.HealComm.HealComm_UpdateHealPrediction = HealComm_UpdateHealPrediction

function F:EnableLibHealComm(enabled)
    HealComm = LibStub("LibHealComm-4.0", true)
    if not HealComm then return end

    useLibHealComm = enabled
    if enabled then
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_HealStarted", "HealComm_UpdateHealPrediction")
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_HealUpdated", "HealComm_UpdateHealPrediction")
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_HealStopped", "HealComm_UpdateHealPrediction")
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_HealDelayed", "HealComm_UpdateHealPrediction")
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_ModifierChanged", "HealComm_UpdateHealPrediction")
        HealComm.RegisterCallback(Cell.HealComm, "HealComm_GUIDDisappeared", "HealComm_UpdateHealPrediction")
    else
        HealComm.UnregisterAllCallbacks(Cell.HealComm)
    end
end

-------------------------------------------------
-- cleu health updater
-------------------------------------------------
local cleuHealthUpdater = CreateFrame("Frame", "CellCleuHealthUpdater")
cleuHealthUpdater:SetScript("OnEvent", function()
    local _, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22 = CombatLogGetCurrentEventInfo()
    
    if not F:IsFriend(destFlags) then return end

    local diff
    if subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
        -- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
        diff = arg15
    elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then
        -- spellId, spellName, spellSchool, amount, overhealing, absorbed, critical
        diff = -arg15
    elseif subEvent == "SWING_DAMAGE" then
        -- amount
        diff = -arg12
    elseif subEvent == "RANGE_DAMAGE" then
        -- spellId, spellName, spellSchool, amount
        diff = -arg15
    elseif subEvent == "ENVIRONMENTAL_DAMAGE" then
        -- environmentalType, amount
        diff = -arg13
    end

    if diff and diff ~= 0 then
        F:HandleUnitButton("guid", destGUID, UnitButton_UpdateHealth, diff)
    end
end)

local function UpdateCLEU()
    if CellDB["general"]["useCleuHealthUpdater"] then
        cleuHealthUpdater:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        cleuHealthUpdater:UnregisterAllEvents()
    end
end
Cell:RegisterCallback("UpdateCLEU", "UnitButton_UpdateCLEU", UpdateCLEU)

-------------------------------------------------
-- translit names
-------------------------------------------------
Cell:RegisterCallback("TranslitNames", "UnitButton_TranslitNames", function()
    F:IterateAllUnitButtons(function(b)
        UnitButton_UpdateName(b)
    end, true)
end)

-------------------------------------------------
-- update all
-------------------------------------------------
UnitButton_UpdateAll = function(self)
    if not self:IsVisible() then return end

    UnitButton_UpdateVehicleStatus(self)
    UnitButton_UpdateName(self)
    UnitButton_UpdateNameColor(self)
    UnitButton_UpdateHealthMax(self)
    UnitButton_UpdateHealth(self)
    UnitButton_UpdateHealPrediction(self)
    UnitButton_UpdateStatusText(self)
    UnitButton_UpdateHealthColor(self)
    UnitButton_UpdateTarget(self)
    UnitButton_UpdatePlayerRaidIcon(self)
    UnitButton_UpdateTargetRaidIcon(self)
    UnitButton_UpdateInRange(self)
    UnitButton_UpdateAssignment(self)
    UnitButton_UpdateLeader(self)
    UnitButton_UpdateReadyCheck(self)
    UnitButton_UpdateThreat(self)
    UnitButton_UpdateThreatBar(self)
    I.UpdateStatusIcon_Resurrection(self)
    
    if Cell.loaded and self._powerBarUpdateRequired then
        self._powerBarUpdateRequired = nil
        if ShouldShowPowerBar(self) then
            ShowPowerBar(self)
        else
            HidePowerBar(self)
        end
    else
        UnitButton_UpdatePowerType(self)
        UnitButton_UpdatePowerMax(self)
        UnitButton_UpdatePower(self)
    end

    UnitButton_UpdateAuras(self)
end

-------------------------------------------------
-- unit button events
-------------------------------------------------
local function UnitButton_RegisterEvents(self)
    -- self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    
    self:RegisterEvent("UNIT_HEALTH")
    self:RegisterEvent("UNIT_HEALTH_FREQUENT")
    self:RegisterEvent("UNIT_MAXHEALTH")
    
    self:RegisterEvent("UNIT_POWER_FREQUENT")
    self:RegisterEvent("UNIT_MAXPOWER")
    self:RegisterEvent("UNIT_DISPLAYPOWER")
    
    self:RegisterEvent("UNIT_AURA")
    
    self:RegisterEvent("UNIT_HEAL_PREDICTION")
    
    self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    self:RegisterEvent("UNIT_ENTERED_VEHICLE")
    self:RegisterEvent("UNIT_EXITED_VEHICLE")
    
    self:RegisterEvent("UNIT_FLAGS") -- afk
    self:RegisterEvent("UNIT_FACTION") -- mind control
    
    self:RegisterEvent("UNIT_CONNECTION") -- offline
    self:RegisterEvent("PLAYER_FLAGS_CHANGED") -- afk
    self:RegisterEvent("UNIT_NAME_UPDATE") -- unknown target
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA") --? update status text

    -- self:RegisterEvent("PARTY_LEADER_CHANGED") -- GROUP_ROSTER_UPDATE
    -- self:RegisterEvent("PLAYER_ROLES_ASSIGNED") -- GROUP_ROSTER_UPDATE
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")

    self:RegisterEvent("PLAYER_TARGET_CHANGED")

    if Cell.loaded then
        if enabledIndicators["playerRaidIcon"] then
            self:RegisterEvent("RAID_TARGET_UPDATE")
        end
    else
        self:RegisterEvent("RAID_TARGET_UPDATE")
    end
    if Cell.loaded then
        if enabledIndicators["targetRaidIcon"] then
            self:RegisterEvent("UNIT_TARGET")
        end
    else
        self:RegisterEvent("UNIT_TARGET")
    end
    
    self:RegisterEvent("READY_CHECK")
    self:RegisterEvent("READY_CHECK_FINISHED")
    self:RegisterEvent("READY_CHECK_CONFIRM")
    
    -- self:RegisterEvent("UNIT_PHASE") -- warmode, traditional sources of phasing such as progress through quest chains
    -- self:RegisterEvent("PARTY_MEMBER_DISABLE")
    -- self:RegisterEvent("PARTY_MEMBER_ENABLE")
    -- self:RegisterEvent("INCOMING_RESURRECT_CHANGED")
    
    -- self:RegisterEvent("VOICE_CHAT_CHANNEL_ACTIVATED")
    -- self:RegisterEvent("VOICE_CHAT_CHANNEL_DEACTIVATED")
    
    -- self:RegisterEvent("UNIT_PET")
    self:RegisterEvent("UNIT_PORTRAIT_UPDATE") -- pet summoned far away
    
    pcall(UnitButton_UpdateAll, self)
end

local function UnitButton_UnregisterEvents(self)
    self:UnregisterAllEvents()
end

local function UnitButton_OnEvent(self, event, unit)
    -- print(event, self:GetName(), unit, self.state.displayedUnit, self.state.unit)
    -- if UnitExists(unit) and (UnitIsUnit(unit, self.state.displayedUnit) or UnitIsUnit(unit, self.state.unit)) then
    if unit and (self.state.displayedUnit == unit or self.state.unit == unit) then
        if  event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" then
            self._updateRequired = 1
            self._powerBarUpdateRequired = 1
        
        elseif event == "UNIT_NAME_UPDATE" then
            UnitButton_UpdateName(self)
            UnitButton_UpdateNameColor(self)
            UnitButton_UpdateHealthColor(self)
        
        elseif event == "UNIT_MAXHEALTH" then
            UnitButton_UpdateHealthMax(self)
            UnitButton_UpdateHealth(self)
            UnitButton_UpdateHealPrediction(self)
            
        elseif event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" then
            UnitButton_UpdateHealth(self)
            UnitButton_UpdateHealPrediction(self)
            -- UnitButton_UpdateStatusText(self)
    
        elseif event == "UNIT_HEAL_PREDICTION" then
            if not useLibHealComm then
                UnitButton_UpdateHealPrediction(self)
            end
    
        elseif event == "UNIT_MAXPOWER" then
            UnitButton_UpdatePowerMax(self)
            UnitButton_UpdatePower(self)
    
        elseif event == "UNIT_POWER_FREQUENT" then
            UnitButton_UpdatePower(self)
    
        elseif event == "UNIT_DISPLAYPOWER" then
            UnitButton_UpdatePowerMax(self)
            UnitButton_UpdatePower(self)
            UnitButton_UpdatePowerType(self)
    
        elseif event == "UNIT_AURA" then
            UnitButton_UpdateAuras(self)
    
        elseif event == "UNIT_TARGET" then
            UnitButton_UpdateTargetRaidIcon(self)
            
        elseif event == "PLAYER_FLAGS_CHANGED" or event == "UNIT_FLAGS" then
            UnitButton_UpdateStatusText(self)
            
        elseif event == "UNIT_FACTION" then -- mind control
            UnitButton_UpdateNameColor(self)
            UnitButton_UpdateHealthColor(self) 
            
        elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
            UnitButton_UpdateThreat(self)

        -- elseif event == "INCOMING_RESURRECT_CHANGED" or event == "UNIT_PHASE" or event == "PARTY_MEMBER_DISABLE" or event == "PARTY_MEMBER_ENABLE" then
        --     UnitButton_UpdateStatusIcon(self)
    
        elseif event == "READY_CHECK_CONFIRM" then
            UnitButton_UpdateReadyCheck(self)

        elseif event == "UNIT_PORTRAIT_UPDATE" then -- pet summoned far away
            if self.state.healthMax == 0 then
                self._updateRequired = 1
                self._powerBarUpdateRequired = 1
            end
        end

    else
        if event == "GROUP_ROSTER_UPDATE" then
            self._updateRequired = 1
            self._powerBarUpdateRequired = 1

        elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" then
            UnitButton_UpdateLeader(self, event)
    
        elseif event == "PLAYER_TARGET_CHANGED" then
            UnitButton_UpdateTarget(self)
            UnitButton_UpdateThreatBar(self)
        
        elseif event == "UNIT_THREAT_LIST_UPDATE" then
            UnitButton_UpdateThreatBar(self)
    
        elseif event == "RAID_TARGET_UPDATE" then
            UnitButton_UpdatePlayerRaidIcon(self)
            UnitButton_UpdateTargetRaidIcon(self)
    
        elseif event == "READY_CHECK" then
            UnitButton_UpdateReadyCheck(self)
    
        elseif event == "READY_CHECK_FINISHED" then
            UnitButton_FinishReadyCheck(self)
        
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            UnitButton_UpdateStatusText(self)

        -- elseif event == "VOICE_CHAT_CHANNEL_ACTIVATED" or event == "VOICE_CHAT_CHANNEL_DEACTIVATED" then
        -- 	VOICE_CHAT_CHANNEL_MEMBER_SPEAKING_STATE_CHANGED
        end
    end
end

local timer
local function EnterLeaveInstance()
    if timer then timer:Cancel() timer=nil end
    timer = C_Timer.NewTimer(1, function()
        F:Debug("|cffff1111*** EnterLeaveInstance:|r UnitButton_UpdateAll")
        F:IterateAllUnitButtons(UnitButton_UpdateAll, true)
        timer = nil
    end)
end
Cell:RegisterCallback("EnterInstance", "UnitButton_EnterInstance", EnterLeaveInstance)
Cell:RegisterCallback("LeaveInstance", "UnitButton_LeaveInstance", EnterLeaveInstance)

local function UnitButton_OnAttributeChanged(self, name, value)
    if name == "unit" and not self:GetAttribute("oldUnit") then
        if not value or value ~= self.state.unit then
            -- NOTE: when unitId for this button changes
            if self.__unitGuid then -- self.__unitGuid is deleted when hide
                -- print("deleteUnitGuid:", self:GetName(), self.state.unit, self.__unitGuid)
                Cell.vars.guids[self.__unitGuid] = nil
                self.__unitGuid = nil
            end
            if self.__unitName then
                Cell.vars.names[self.__unitName] = nil
                self.__unitName = nil
            end
            wipe(self.state)
        end

        if type(value) == "string" then
            self.state.unit = value
            self.state.displayedUnit = value
            if string.find(value, "raid") then Cell.unitButtons.raid.units[value] = self end
            -- for omnicd
            if string.match(value, "raid%d") then
                local i = string.match(value, "%d")
                _G["CellRaidFrameMember"..i] = self
                self.unit = value
            end

            ResetAuraTables(self)
        end
    end
end

-------------------------------------------------
-- unit button show/hide/enter/leave
-------------------------------------------------
Cell.vars.guids = {} -- guid to unitid
Cell.vars.names = {} -- name to unitid

local function UnitButton_OnShow(self)
    self._updateRequired = nil -- prevent UnitButton_UpdateAll twice. when convert party <-> raid, GROUP_ROSTER_UPDATE fired.
    self._powerBarUpdateRequired = 1
    UnitButton_RegisterEvents(self)

    --[[
    if self.state.unit then
        -- NOTE: update Cell.vars.guids
        local guid = UnitGUID(self.state.unit)
        if guid then
            Cell.vars.guids[guid] = self.state.unit
        end
        --! NOTE: can't get valid name immediately after an unseen player joining into group
        self.__timer = C_Timer.NewTicker(0.5, function()
            local name = GetUnitName(self.state.unit, true)
            if name and name ~= _G.UNKNOWN then
                Cell.vars.names[name] = self.state.unit
                self.__timer:Cancel()
                self.__timer = nil
            end
        end)
        -- print("show", self.state.unit, guid, name)
    end
    ]]
end

local function UnitButton_OnHide(self)
    UnitButton_UnregisterEvents(self)

    ResetAuraTables(self)
    
    -- NOTE: update Cell.vars.guids
    -- print("hide", self.state.unit, self.__unitGuid, self.__unitName)
    if self.__unitGuid then
        Cell.vars.guids[self.__unitGuid] = nil
        self.__unitGuid = nil
    end
    if self.__unitName then
        Cell.vars.names[self.__unitName] = nil
        self.__unitName = nil
    end
    self.__displayedGuid = nil
    F:RemoveElementsExceptKeys(self.state, "unit", "displayedUnit")
end

local function UnitButton_OnEnter(self)
    if not IsEncounterInProgress() then UnitButton_UpdateStatusText(self) end
    
    if highlightEnabled then self.widget.mouseoverHighlight:Show() end
    
    local unit = self.state.displayedUnit
    if not unit then return end
    
    F:ShowTooltips(self, "unit", unit)
end

local function UnitButton_OnLeave(self)
    self.widget.mouseoverHighlight:Hide()
    GameTooltip:Hide()
end

local UNKNOWN = _G.UNKNOWN
local UNKNOWNOBJECT = _G.UNKNOWNOBJECT
local function UnitButton_OnTick(self)
    local e = (self.__tickCount or 0) + 1
    if e >= 2 then -- every 0.5 second
        e = 0
        
        if self.state.unit and self.state.displayedUnit then
            local displayedGuid = UnitGUID(self.state.displayedUnit)
            if displayedGuid ~= self.__displayedGuid then
                -- NOTE: displayed unit entity changed
                F:RemoveElementsExceptKeys(self.state, "unit", "displayedUnit")
                self.__displayedGuid = displayedGuid
                self._updateRequired = 1
                self._powerBarUpdateRequired = 1
            end

            local guid = UnitGUID(self.state.unit)
            if guid and guid ~= self.__unitGuid then
                -- print("guidChanged:", self:GetName(), self.state.unit, guid)
                -- NOTE: unit entity changed
                -- update Cell.vars.guids
                self.__unitGuid = guid
                Cell.vars.guids[guid] = self.state.unit

                -- NOTE: only save players' names
                if UnitIsPlayer(self.state.unit) then
                    -- update Cell.vars.names
                    local name = GetUnitName(self.state.unit, true)
                    if (name and self.__nameRetries and self.__nameRetries >= 4) or (name and name ~= UNKNOWN and name ~= UNKNOWNOBJECT) then
                        self.__unitName = name
                        Cell.vars.names[name] = self.state.unit
                        self.__nameRetries = nil
                    else
                        -- NOTE: update on next tick
                        -- 国服可以起名为“未知目标”，干！就只多重试4次好了
                        self.__nameRetries = (self.__nameRetries or 0) + 1
                        self.__unitGuid = nil 
                    end
                end
            end
        end
    end

    self.__tickCount = e

    UnitButton_UpdateInRange(self)
    
    if self._updateRequired and self._indicatorReady then
        self._updateRequired = nil
        UnitButton_UpdateAll(self)
    end

    --! for Xtarget
    if self:GetAttribute("refreshOnUpdate") then
        UnitButton_UpdateAll(self)
    end
end

local function UnitButton_OnUpdate(self, elapsed)
    local e = (self.__updateElapsed or 0) + elapsed
    if e > 0.25 then
        UnitButton_OnTick(self)
        e = 0
    end
    self.__updateElapsed = e
end

-------------------------------------------------
-- button functions
-------------------------------------------------
function B:SetPowerSize(button, size)
    button.powerSize = size
    
    if size == 0 then
        HidePowerBar(button)
    else
        if ShouldShowPowerBar(button) then
            ShowPowerBar(button)
        else
            HidePowerBar(button)
        end
    end
end

function B:UpdateShields(button)
    predictionEnabled = CellDB["appearance"]["healPrediction"][1]
    UnitButton_UpdateHealPrediction(button)
end

function B:SetTexture(button, tex)
    button.widget.healthBar:SetStatusBarTexture(tex)
    button.widget.healthBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    button.widget.healthBarLoss:SetTexture(tex)
    button.widget.powerBar:SetStatusBarTexture(tex)
    button.widget.powerBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    button.widget.powerBarLoss:SetTexture(tex)
    button.widget.incomingHeal:SetTexture(tex)
    button.widget.damageFlashTex:SetTexture(tex)
end

function B:UpdateColor(button)
    UnitButton_UpdateHealthColor(button)
    UnitButton_UpdatePowerType(button)
    button:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
end

function B:SetOrientation(button, orientation, rotateTexture)
    local healthBar = button.widget.healthBar
    local healthBarLoss = button.widget.healthBarLoss
    local powerBar = button.widget.powerBar
    local powerBarLoss = button.widget.powerBarLoss
    local incomingHeal = button.widget.incomingHeal
    local damageFlashTex = button.widget.damageFlashTex
    local gapTexture = button.widget.gapTexture

    gapTexture:SetColorTexture(unpack(CELL_BORDER_COLOR))

    button.orientation = orientation
    if orientation == "vertical_health" then
        healthBar:SetOrientation("vertical")
        powerBar:SetOrientation("horizontal")
    else
        healthBar:SetOrientation(orientation)
        powerBar:SetOrientation(orientation)
    end
    healthBar:SetRotatesTexture(rotateTexture)
    powerBar:SetRotatesTexture(rotateTexture)
    
    button.indicators.healthThresholds:SetOrientation(orientation)

    if rotateTexture then
        F:RotateTexture(healthBarLoss, 90)
        F:RotateTexture(powerBarLoss, 90)
        F:RotateTexture(incomingHeal, 90)
        F:RotateTexture(damageFlashTex, 90)
    else
        F:RotateTexture(healthBarLoss, 0)
        F:RotateTexture(powerBarLoss, 0)
        F:RotateTexture(incomingHeal, 0)
        F:RotateTexture(damageFlashTex, 0)
    end
    
    if orientation == "horizontal" then
        -- update healthBarLoss
        P:ClearPoints(healthBarLoss)
        P:Point(healthBarLoss, "TOPRIGHT", healthBar)
        P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        
        -- update powerBarLoss
        P:ClearPoints(powerBarLoss)
        P:Point(powerBarLoss, "TOPRIGHT", powerBar)
        P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        
        -- update gapTexture
        P:ClearPoints(gapTexture)
        P:Point(gapTexture, "BOTTOMLEFT", powerBar, "TOPLEFT")
        P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "TOPRIGHT")
        P:Height(gapTexture, CELL_BORDER_SIZE)
        
        -- update incomingHeal
        P:ClearPoints(incomingHeal)
        P:Point(incomingHeal, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
        P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        function incomingHeal:SetValue(incomingPercent)
            local barWidth = healthBar:GetWidth()
            local incomingHealWidth = incomingPercent * barWidth
            local lostHealthWidth = barWidth * (1 - button.state.healthPercent)
        
            -- print(incomingPercent, barWidth, incomingHealWidth, lostHealthWidth)
            -- FIXME: if incomingPercent is a very tiny number, like 0.005
            -- P:Scale(incomingHealWidth) ==> 0
            --! if width is set to 0, then the ACTUAL width may be 256!!!

            if lostHealthWidth == 0 then
                incomingHeal:Hide()
            else
                if lostHealthWidth > incomingHealWidth then
                    incomingHeal:SetWidth(incomingHealWidth)
                else
                    incomingHeal:SetWidth(lostHealthWidth)
                end
                incomingHeal:Show()
            end
        end
        
        -- update damageFlashTex
        P:ClearPoints(damageFlashTex)
        P:Point(damageFlashTex, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
        P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
        function damageFlashTex:SetValue(lostPercent)
            local barWidth = healthBar:GetWidth()
            damageFlashTex:SetWidth(barWidth * lostPercent)
        end
    else -- vertical
        P:ClearPoints(healthBarLoss)
        P:Point(healthBarLoss, "TOPRIGHT", healthBar)
        P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
        
        if orientation == "vertical" then
            -- update powerBarLoss
            P:ClearPoints(powerBarLoss)
            P:Point(powerBarLoss, "TOPRIGHT", powerBar)
            P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "TOPLEFT")
            
            -- update gapTexture
            P:ClearPoints(gapTexture)
            P:Point(gapTexture, "TOPRIGHT", powerBar, "TOPLEFT")
            P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "BOTTOMLEFT")
            P:Width(gapTexture, CELL_BORDER_SIZE)
        else -- vertical_health
            -- update powerBarLoss
            P:ClearPoints(powerBarLoss)
            P:Point(powerBarLoss, "TOPRIGHT", powerBar)
            P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "BOTTOMRIGHT")
            
            -- update gapTexture
            P:ClearPoints(gapTexture)
            P:Point(gapTexture, "BOTTOMLEFT", powerBar, "TOPLEFT")
            P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "TOPRIGHT")
            P:Height(gapTexture, CELL_BORDER_SIZE)
        end
        
        -- update incomingHeal
        P:ClearPoints(incomingHeal)
        P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
        P:Point(incomingHeal, "BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
        function incomingHeal:SetValue(incomingPercent)
            local barHeight = healthBar:GetHeight()
            local incomingHealHeight = incomingPercent * barHeight
            local lostHealthHeight = barHeight * (1 - button.state.healthPercent)
        
            if lostHealthHeight == 0 then
                incomingHeal:Hide()
            else
                if lostHealthHeight > incomingHealHeight then
                    incomingHeal:SetHeight(incomingHealHeight)
                else
                    incomingHeal:SetHeight(lostHealthHeight)
                end
                incomingHeal:Show()
            end
        end
        
        -- update damageFlashTex
        P:ClearPoints(damageFlashTex)
        P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "TOPLEFT")
        P:Point(damageFlashTex, "BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
        function damageFlashTex:SetValue(lostPercent)
            local barHeight = healthBar:GetHeight()
            damageFlashTex:SetHeight(barHeight * lostPercent)
        end
    end

    -- update consumables
    I:UpdateConsumablesOrientation(button, orientation)
end

function B:UpdateHighlightColor(button)
    button.widget.targetHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["targetColor"]))
    button.widget.mouseoverHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["mouseoverColor"]))
end

function B:UpdateHighlightSize(button)
    local targetHighlight = button.widget.targetHighlight
    local mouseoverHighlight = button.widget.mouseoverHighlight
    
    local size = CellDB["appearance"]["highlightSize"]
    
    if size ~= 0 then
        highlightEnabled = true
        
        P:ClearPoints(targetHighlight)
        P:ClearPoints(mouseoverHighlight)

        -- update point
        if size < 0 then
            size = abs(size)
            P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT")
            P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT")
            P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT")
            P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT")
        else
            P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT", -size, size)
            P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", size, -size)
            P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT", -size, size)
            P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", size, -size)
        end

        -- update thickness
        targetHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(size)})
        mouseoverHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(size)})

        -- update color
        targetHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["targetColor"]))
        mouseoverHighlight:SetBackdropBorderColor(unpack(CellDB["appearance"]["mouseoverColor"]))

        UnitButton_UpdateTarget(button) -- 0->!0 show highlight again
    else
        highlightEnabled = false
        targetHighlight:Hide()
        mouseoverHighlight:Hide()
    end
end

-- raidIcons
function B:UpdatePlayerRaidIcon(button, enabled)
    if not button:IsShown() then return end
    UnitButton_UpdatePlayerRaidIcon(button)
    if enabled then
        button:RegisterEvent("RAID_TARGET_UPDATE")
    else
        button:UnregisterEvent("RAID_TARGET_UPDATE")
    end
end

function B:UpdateTargetRaidIcon(button, enabled)
    if not button:IsShown() then return end
    UnitButton_UpdateTargetRaidIcon(button)
    if enabled then
        button:RegisterEvent("UNIT_TARGET")
    else
        button:UnregisterEvent("UNIT_TARGET")
    end
end

-- healthText
function B:UpdateHealthText(button)
    if button.state.displayedUnit then
        UpdateUnitHealthState(button)
    end
end

-- statusText
function B:UpdateStatusText(button)
    UnitButton_UpdateStatusText(button)
end

-- pixel perfect
function B:UpdatePixelPerfect(button, updateIndicators)
    button:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(CELL_BORDER_SIZE)})
    button:SetBackdropColor(0, 0, 0, CellDB["appearance"]["bgAlpha"])
    button:SetBackdropBorderColor(unpack(CELL_BORDER_COLOR))
    P:Resize(button)

    P:Repoint(button.widget.healthBar)
    P:Repoint(button.widget.healthBarLoss)
    P:Repoint(button.widget.powerBar)
    P:Repoint(button.widget.powerBarLoss)
    P:Repoint(button.widget.gapTexture)
    P:Resize(button.widget.gapTexture)

    P:Repoint(button.widget.incomingHeal)
    P:Repoint(button.widget.damageFlashTex)
    
    B:UpdateHighlightSize(button)

    if updateIndicators then
        -- indicators
        for _, i in pairs(button.indicators) do
            if i.UpdatePixelPerfect then
                i:UpdatePixelPerfect() 
            end
        end
    else
        button.indicators.nameText:UpdatePixelPerfect()
        button.indicators.statusText:UpdatePixelPerfect()
    end

    button.widget.srIcon:UpdatePixelPerfect()
end

B.UpdateAll = UnitButton_UpdateAll
B.UpdateHealth = UnitButton_UpdateHealth
B.UpdateHealthMax = UnitButton_UpdateHealthMax
B.UpdateAuras = UnitButton_UpdateAuras
B.UpdateName = UnitButton_UpdateName

-------------------------------------------------
-- unit button init
-------------------------------------------------
-- local startTimeCache, statusCache = {}, {}
local startTimeCache = {}

-- NOTE: prevent a nil method error
local DumbFunc = function() end

function CellUnitButton_OnLoad(button)
    local name = button:GetName()

    button.widget = {}
    button.state = {}
    button.func = {}
    button.indicators = {}

    InitAuraTables(button)

    -- background
    -- local background = button:CreateTexture(name.."Background", "BORDER")
    -- button.widget.background = background
    -- background:SetAllPoints(button)
    -- background:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
    -- background:SetVertexColor(0, 0, 0, 1)

    -- backdrop
    button:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(CELL_BORDER_SIZE)})
    button:SetBackdropColor(0, 0, 0, 1)
    button:SetBackdropBorderColor(unpack(CELL_BORDER_COLOR))
    
    -- healthbar
    local healthBar = CreateFrame("StatusBar", name.."HealthBar", button)
    button.widget.healthBar = healthBar
    -- P:Point(healthBar, "TOPLEFT", button, "TOPLEFT", 1, -1)
    -- P:Point(healthBar, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 4)
    healthBar:SetStatusBarTexture(Cell.vars.texture)
    healthBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    healthBar:SetFrameLevel(button:GetFrameLevel()+5)

    -- FIXME: fix blizzard shits!
    healthBar:SetScript("OnValueChanged", function(self, value)
        if value == 0 then
            healthBar:SetValue(0.1)
        end
    end)
    
    -- hp loss
    local healthBarLoss = button:CreateTexture(name.."HealthBarLoss", "ARTWORK", nil , -7)
    button.widget.healthBarLoss = healthBarLoss
    -- P:Point(healthBarLoss, "TOPRIGHT", healthBar)
    -- P:Point(healthBarLoss, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    healthBarLoss:SetTexture(Cell.vars.texture)

    -- powerbar
    local powerBar = CreateFrame("StatusBar", name.."PowerBar", button)
    button.widget.powerBar = powerBar
    -- P:Point(powerBar, "TOPLEFT", healthBar, "BOTTOMLEFT", 0, -1)
    -- P:Point(powerBar, "BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    powerBar:SetStatusBarTexture(Cell.vars.texture)
    powerBar:GetStatusBarTexture():SetDrawLayer("ARTWORK", -6)
    powerBar:SetFrameLevel(button:GetFrameLevel()+6)

    local gapTexture = button:CreateTexture(nil, "BORDER")
    button.widget.gapTexture = gapTexture
    -- P:Point(gapTexture, "BOTTOMLEFT", powerBar, "TOPLEFT")
    -- P:Point(gapTexture, "BOTTOMRIGHT", powerBar, "TOPRIGHT")
    -- P:Height(gapTexture, 1)
    gapTexture:SetColorTexture(unpack(CELL_BORDER_COLOR))

    -- power loss
    local powerBarLoss = button:CreateTexture(name.."PowerBarLoss", "ARTWORK", nil , -7)
    button.widget.powerBarLoss = powerBarLoss
    -- P:Point(powerBarLoss, "TOPRIGHT", powerBar)
    -- P:Point(powerBarLoss, "BOTTOMLEFT", powerBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    powerBarLoss:SetTexture(Cell.vars.texture)

    -- incoming heal
    local incomingHeal = healthBar:CreateTexture(name.."IncomingHealBar", "ARTWORK", nil, -6)
    button.widget.incomingHeal = incomingHeal
    -- P:Point(incomingHeal, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
    -- P:Point(incomingHeal, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    incomingHeal:SetTexture(Cell.vars.texture)
    -- incomingHeal:SetAlpha(0.4)
    incomingHeal:Hide()
    incomingHeal.SetValue = DumbFunc

    -- shield bar
    local shieldBar = healthBar:CreateTexture(name.."ShieldBar", "ARTWORK", nil, -7)
    button.widget.shieldBar = shieldBar
    shieldBar:SetTexture("Interface\\AddOns\\Cell\\Media\\shield.tga", "REPEAT", "REPEAT")
    shieldBar:SetHorizTile(true)
    shieldBar:SetVertTile(true)
    shieldBar:SetVertexColor(1, 1, 1, 0.4)
    shieldBar:Hide()
    shieldBar.SetValue = DumbFunc

    -- over-shield glow
    local overShieldGlow = healthBar:CreateTexture(name.."OverShieldGlow", "OVERLAY")
    button.widget.overShieldGlow = overShieldGlow
    overShieldGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
    overShieldGlow:SetBlendMode("ADD")
    overShieldGlow:Hide()

    -- bar animation
    -- flash
    local damageFlashTex = healthBar:CreateTexture(name.."DamageFlash", "ARTWORK", nil, -6)
    button.widget.damageFlashTex = damageFlashTex
    damageFlashTex:SetTexture("Interface\\BUTTONS\\WHITE8X8")
    damageFlashTex:SetVertexColor(1, 1, 1, 0.7)
    -- P:Point(damageFlashTex, "TOPLEFT", healthBar:GetStatusBarTexture(), "TOPRIGHT")
    -- P:Point(damageFlashTex, "BOTTOMLEFT", healthBar:GetStatusBarTexture(), "BOTTOMRIGHT")
    damageFlashTex:Hide()
    damageFlashTex.SetValue = DumbFunc

    -- damage flash animation group
    local damageFlashAG = damageFlashTex:CreateAnimationGroup()
    local alpha = damageFlashAG:CreateAnimation("Alpha")
    alpha:SetFromAlpha(0.7)
    alpha:SetToAlpha(0)
    alpha:SetDuration(0.2)
    damageFlashAG:SetScript("OnPlay", function(self)
        damageFlashTex:Show()
    end)
    damageFlashAG:SetScript("OnFinished", function(self)
        damageFlashTex:Hide()
    end)

    button.func.ShowFlash = function(lostPercent)
        damageFlashTex:SetValue(lostPercent)
        -- damageFlashTex:Show()
        damageFlashAG:Play()
    end

    button.func.HideFlash = function()
        damageFlashAG:Finish()
    end

    -- smooth
    Mixin(healthBar, SmoothStatusBarMixin)
    Mixin(powerBar, SmoothStatusBarMixin)

    button.func.UpdateAnimation = function()
        barAnimationType = CellDB["appearance"]["barAnimation"]
        if aType ~= "Flash" then
            damageFlashAG:Finish()
        end
    end

    -- target highlight
    local targetHighlight = CreateFrame("Frame", name.."TargetHighlight", button, "BackdropTemplate")
    button.widget.targetHighlight = targetHighlight
    targetHighlight:EnableMouse(false)
    targetHighlight:SetFrameLevel(button:GetFrameLevel()+6)
    -- targetHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    -- P:Point(targetHighlight, "TOPLEFT", button, "TOPLEFT", -1, 1)
    -- P:Point(targetHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    targetHighlight:Hide()
    
    -- mouseover highlight
    local mouseoverHighlight = CreateFrame("Frame", name.."MouseoverHighlight", button, "BackdropTemplate")
    button.widget.mouseoverHighlight = mouseoverHighlight
    mouseoverHighlight:EnableMouse(false)
    mouseoverHighlight:SetFrameLevel(button:GetFrameLevel()+7)
    -- mouseoverHighlight:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
    -- P:Point(mouseoverHighlight, "TOPLEFT", button, "TOPLEFT", -1, 1)
    -- P:Point(mouseoverHighlight, "BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    mouseoverHighlight:Hide()

    -- readyCheck highlight
    -- local readyCheckHighlight = button:CreateTexture(name.."ReadyCheckHighlight", "BACKGROUND")
    -- button.widget.readyCheckHighlight = readyCheckHighlight
    -- readyCheckHighlight:SetPoint("TOPLEFT", -1, 1)
    -- readyCheckHighlight:SetPoint("BOTTOMRIGHT", 1, -1)
    -- readyCheckHighlight:SetTexture("Interface\\Buttons\\WHITE8x8")
    -- readyCheckHighlight:Hide()

    --* tsGlowFrame (Targeted Spells)
    local tsGlowFrame = CreateFrame("Frame", name.."TSGlowFrame", button)
    button.widget.tsGlowFrame = tsGlowFrame
    tsGlowFrame:SetAllPoints(button)

    --* srGlowFrame (Spell Request)
    local srGlowFrame = CreateFrame("Frame", name.."SRGlowFrame", button)
    button.widget.srGlowFrame = srGlowFrame
    srGlowFrame:SetFrameLevel(button:GetFrameLevel()+120)
    srGlowFrame:SetAllPoints(button)
    
    --* drGlowFrame (Dispel Request)
    local drGlowFrame = CreateFrame("Frame", name.."DRGlowFrame", button)
    button.widget.drGlowFrame = drGlowFrame
    drGlowFrame:SetFrameLevel(button:GetFrameLevel()+120)
    drGlowFrame:SetAllPoints(button)

    --* overlayFrame
    local overlayFrame = CreateFrame("Frame", name.."OverlayFrame", button)
    button.widget.overlayFrame = overlayFrame
    overlayFrame:SetFrameLevel(button:GetFrameLevel()+8) -- button:GetFrameLevel() == 4
    overlayFrame:SetAllPoints(button)

    -- aggro bar
    local aggroBar = Cell:CreateStatusBar(name.."AggroBar", overlayFrame, 20, 4, 100, true)
    button.indicators.aggroBar = aggroBar
    -- aggroBar:SetPoint("BOTTOMLEFT", overlayFrame, "TOPLEFT", 1, 0)
    aggroBar:Hide()

    -- indicators
    I:CreateNameText(button)
    I:CreateStatusText(button)
    I:CreateHealthText(button)
    I:CreateStatusIcon(button)
    I:CreatePartyAssignmentIcon(button)
    I:CreateLeaderIcon(button)
    I:CreateReadyCheckIcon(button)
    I:CreateAggroBlink(button)
    I:CreateAggroBorder(button)
    I:CreatePlayerRaidIcon(button)
    I:CreateTargetRaidIcon(button)
    I:CreateAoEHealing(button)
    I:CreateDefensiveCooldowns(button)
    I:CreateExternalCooldowns(button)
    I:CreateAllCooldowns(button)
    I:CreateDispels(button)
    I:CreateDebuffs(button)
    I:CreateRaidDebuffs(button)
    I:CreateTargetCounter(button)
    I:CreateTargetedSpells(button)
    I:CreateConsumables(button)
    I:CreateHealthThresholds(button)
    I:CreateMissingBuffs(button)
    U:CreateSpellRequestIcon(button)
    U:CreateDispelRequestText(button)

    -- events
    button:SetScript("OnAttributeChanged", UnitButton_OnAttributeChanged) -- init
    button:HookScript("OnShow", UnitButton_OnShow)
    button:HookScript("OnHide", UnitButton_OnHide) -- use _onhide for click-castings
    button:HookScript("OnEnter", UnitButton_OnEnter) -- SecureHandlerEnterLeaveTemplate
    button:HookScript("OnLeave", UnitButton_OnLeave) -- SecureHandlerEnterLeaveTemplate
    button:SetScript("OnUpdate", UnitButton_OnUpdate)
    button:SetScript("OnEvent", UnitButton_OnEvent)
    button:RegisterForClicks("AnyDown")
end