local AddonName, SAO = ...
local Module = "aura"

--[[
    Lists of auras that must be tracked
    These lists should be setup at start, based on the player class

    The name should be unique
    For stackable buffs, the stack count should be appended e.g., maelstrom_weapon_4

    Spell IDs may not be unique, especially for stackable buffs
    Because of that, RegisteredAurasBySpellID is a multimap instead of a map
]]
SAO.RegisteredAurasByName = {}
SAO.RegisteredAurasBySpellID = {}

--[[
    List of markers for each aura activated excplicitly by an aura event, usually from CLEU.
    Key = spellID, Value = number of stacks, or nil if marker is reset

    This list looks redundant with SAO.ActiveOverlays, but there are significant differences:
    - ActiveOverlays tracks absolutely every overlay, while AuraMarkers is focused on "aura from CLEU"
    - ActiveOverlays is limited to effects that have an overlay, while AuraMarkers tracks effects with or without overlays
]]
SAO.AuraMarkers = {}

-- Register a new aura
-- If texture is nil, no Spell Activation Overlay (SAO) is triggered; subsequent params are ignored until glowIDs
-- If texture is a function, it will be evaluated at runtime when the SAO is triggered
-- If glowIDs is nil or empty, no Glowing Action Button (GAB) is triggered
-- All SAO arguments (between spellID and b, included) mimic Retail's SPELL_ACTIVATION_OVERLAY_SHOW event arguments
function SAO.RegisterAura(self, name, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, glowIDs, combatOnly)
    if (type(texture) == 'string') then
        texture = self.TexName[texture];
    end
    local aura = { name, stacks, spellID, texture, positions, scale, r, g, b, autoPulse, glowIDs, nil, combatOnly }

    -- Cannot track spell ID on Classic Era, but can track spell name
    local registeredSpellID = spellID;
    if self.IsEra() and not self:IsFakeSpell(spellID) then
        registeredSpellID = GetSpellInfo(spellID);
        SAO:Debug(Module, "Skipping aura registration of "..tostring(name).." because os unknown spell "..tostring(spellID));
        if not registeredSpellID then return end
    end

    if (type(texture) == 'string') then
        self:MarkTexture(texture);
    end

    -- Register aura in the spell list, sorted by spell ID and by stack count
    self.RegisteredAurasByName[name] = aura;
    if self.RegisteredAurasBySpellID[registeredSpellID] then
        if self.RegisteredAurasBySpellID[registeredSpellID][stacks] then
            table.insert(self.RegisteredAurasBySpellID[registeredSpellID][stacks], aura)
        else
            self.RegisteredAurasBySpellID[registeredSpellID][stacks] = { aura };
        end
    else
        self.RegisteredAurasBySpellID[registeredSpellID] = { [stacks] = { aura } }
    end

    -- Register the glow IDs
    -- The same glow ID may be registered by different auras, but it's okay
    self:RegisterGlowIDs(glowIDs);

    -- Apply aura immediately, if found
    local exists, _, count = self:FindPlayerAuraByID(spellID);
    if (exists and (stacks == 0 or stacks == count)) then
        self:MarkAura(spellID, count);
        self:ActivateOverlay(count, select(3,unpack(aura)));
        self:AddGlow(spellID, select(11,unpack(aura)));
    end
end

function SAO:MarkAura(spellID, count)
    if type(count) ~= 'number' then
        self:Debug(Module, "Marking aura of "..tostring(spellID).." with invalid count "..tostring(count));
    end
    if type(self.AuraMarkers[spellID]) == 'number' then
        self:Debug(Module, "Marking aura of "..tostring(spellID).." with count "..tostring(count).." but it already has a count of "..self.AuraMarkers[spellID]);
    end
    self.AuraMarkers[spellID] = count;
end

function SAO:UnmarkAura(spellID)
    self.AuraMarkers[spellID] = nil;
end

function SAO:GetAuraMarker(spellID)
    return self.AuraMarkers[spellID];
end
