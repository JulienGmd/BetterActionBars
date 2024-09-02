ADDON_NAME = "BetterActionBars"
DB_NAME = "BetterActionBarsDB"
BAB = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")


--#region -- Initialization ----------------------------------------------------

function BAB:OnInitialize()
	-- 3rd argument: use global profile
	self.db = LibStub("AceDB-3.0"):New(DB_NAME, self.defaults, true)
	for _, bar in pairs(self.db.global) do
		OnScaleChanged(bar)
		OnHideBorderChanged(bar)
		InitVisibility(bar)
		OnShowOnHoverChanged(bar)
		OnShowOnTargetChanged(bar)
		OnReverseGrowDirChanged(bar)
		InitAnimations(bar)
		OnAnimTypeChanged(bar)
	end
end

-- #endregion


--#region -- Scale -------------------------------------------------------------

function OnScaleChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button:SetScale(bar.scale)
	end
end

-- #endregion


--#region -- Hide border -------------------------------------------------------

function OnHideBorderChanged(bar)
	function ScaleAndCenter(button, scale)
		button:SetScale(scale)
		button:ClearAllPoints()
		button:SetPoint("CENTER", 0, 0)
	end

	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		-- Hide the button border
		local value = bar.hideBorder and 0 or 1
		button.NormalTexture:SetAlpha(value)
		button.PushedTexture:SetAlpha(value)
		-- Reduce the size of the icon mask to hide the icon border
		value = bar.hideBorder and .95 or 1
		button.IconMask:SetScale(value);
		-- Scale some overlay elements to fill the icon mask
		value = bar.hideBorder and 1.1 or 1
		ScaleAndCenter(button.Border, value)
		ScaleAndCenter(button.CheckedTexture, value)
		ScaleAndCenter(button.Flash, value)
		ScaleAndCenter(button.HighlightTexture, value)
		ScaleAndCenter(button.NewActionTexture, value)
		ScaleAndCenter(button.PushedTexture, value)
	end
end

-- #endregion


--#region -- Show on hover / target --------------------------------------------

function InitVisibility(bar)
	bar.hovered = false
	OnVisibilityChanged(bar)

	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		-- Note: It's seems that the OnLeave event is always triggered after
		-- OnEnter, even if buttons overlap, so it's safe to set bar.hovered.
		button:HookScript("OnEnter", function(self)
			for _, bar in pairs(BAB.db.global) do
				bar.hovered = true
				OnVisibilityChanged(bar)
			end
		end)
		button:HookScript("OnLeave", function(self)
			for _, bar in pairs(BAB.db.global) do
				bar.hovered = false
				OnVisibilityChanged(bar)
			end
		end)
	end
end

local hasTarget = false
function BAB:PLAYER_TARGET_CHANGED()
	if hasTarget == UnitExists("target") then return end
	hasTarget = UnitExists("target")
	for _, bar in pairs(self.db.global) do
		OnVisibilityChanged(bar)
	end
end
BAB:RegisterEvent("PLAYER_TARGET_CHANGED")

function OnShowOnHoverChanged(bar)
	OnVisibilityChanged(bar)
end

function OnShowOnTargetChanged(bar)
	OnVisibilityChanged(bar)
end

function OnVisibilityChanged(bar)
	local showLevel = GetShowLevel(bar)
	if showLevel > 0 then
		FadeIn(bar)
	else
		FadeOutAfterDelay(bar, 1)
	end
end

function GetShowLevel(bar)
	if not bar.showOnHover and not bar.showOnTarget then return 1 end
	local showLevel = 0
	showLevel = showLevel + (bar.showOnHover and bar.hovered and 1 or 0)
	showLevel = showLevel + (bar.showOnTarget and UnitExists("target") and 1 or 0)
	return showLevel
end

function FadeIn(bar)
	if bar.fadeOutTimer then
		BAB:CancelTimer(bar.fadeOutTimer)
		bar.fadeOutTimer = nil
	end
	local barFrame = _G[bar.name]
	if not barFrame and not barFrame:IsShown() then return end
	UIFrameFadeIn(barFrame, .2, barFrame:GetAlpha(), 1)
end

function FadeOutAfterDelay(bar, delay)
	if bar.fadeOutTimer then
		BAB:CancelTimer(bar.fadeOutTimer)
		bar.fadeOutTimer = nil
	end
	local barFrame = _G[bar.name]
	if not barFrame and not barFrame:IsShown() then return end
	bar.fadeOutTimer = BAB:ScheduleTimer(function()
		UIFrameFadeOut(barFrame, .2, barFrame:GetAlpha(), 0)
		bar.fadeOutTimer = nil
	end, delay)
end

-- #endregion


--#region -- Reverse grow direction --------------------------------------------

-- Reverse the buttons order by changing their parent container
-- TODO works only for 2 rows of 6 buttons
function OnReverseGrowDirChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		local toContainerIndex
		if i <= 6 then
			toContainerIndex = bar.reverseGrowDir and i + 6 or i
		else
			toContainerIndex = bar.reverseGrowDir and i - 6 or i
		end
		local toContainer = _G[bar.name .. "ButtonContainer" .. toContainerIndex]
		button:ClearAllPoints()
		button:SetPoint("CENTER", toContainer, "CENTER", 0, 0)
	end
end
-- #endregion


--#region -- Animation ---------------------------------------------------------

function InitAnimations(bar)

	function GetCooldown(button)
		if not button.action then return 0 end
		local start, duration, _, _ = GetActionCooldown(button.action)
		if start <= 0 or duration <= 0 then return 0 end
		return start + duration - GetTime()
	end

	-- Hide button components (keep the background visible)
	function SetShowButton(button, show)
		button.icon:SetAlpha(show and 1 or 0)
		button.cooldown:SetAlpha(show and 1 or 0)
		if button.chargeCooldown then
			button.chargeCooldown:SetAlpha(show and 1 or 0)
		end
		if button.SpellActivationAlert then
			button.SpellActivationAlert:SetAlpha(show and 1 or 0)
		end
		if button.Count then
			button.Count:SetAlpha(show and 1 or 0)
		end
		if button.Name then
			button.Name:SetAlpha(show and 1 or 0)
		end
	end

	-- Move button elements (disallowed to move button in combat)
	function SetButtonPosition(button, x, y)
		button.icon:SetPoint("TOPLEFT", x, y)
		button.icon:SetPoint("BOTTOMRIGHT", x, y)
		button.cooldown:SetPoint("CENTER", x, y)
		if button.chargeCooldown then
			button.chargeCooldown:SetPoint("TOPLEFT", 2 + x, -2 + y)
			button.chargeCooldown:SetPoint("BOTTOMRIGHT", -2 + x, 2 + y)
		end
		if button.SpellActivationAlert then
			button.SpellActivationAlert:SetPoint("CENTER", x, y)
		end
		if button.Count then
			button.Count:SetPoint("BOTTOMRIGHT", -5 + x, 5 + y)
		end
		if button.Name then
			button.Name:SetPoint("BOTTOM", 0 + x, 2 + y)
		end
	end

	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button.animate = false
		-- Note: Not using OnShow because it is triggered by the gcd, hiding the cd.
		button.cooldown:HookScript("OnUpdate", function(self, elapsed)
			if bar.animType == BarAnimType.none then return end
			local cd = GetCooldown(button)
			if cd > 5 then
				button.animate = true
			end
			if button.animate then
				if cd > 5 then
					SetShowButton(button, false)
				else
					local x = 0
					local y = 0
					if bar.animType == BarAnimType.slideFromBottom then
						x = 0
						y = -cd * 20
					elseif bar.animType == BarAnimType.slideFromTop then
						x = 0
						y = cd * 20
					elseif bar.animType == BarAnimType.slideFromLeft then
						x = -cd * 20
						y = 0
					elseif bar.animType == BarAnimType.slideFromRight then
						x = cd * 20
						y = 0
					end
					SetButtonPosition(button, x, y)
					SetShowButton(button, true)
				end
			end
		end)

		button.cooldown:HookScript("OnHide", function(self)
			button.animate = false
			SetButtonPosition(button, 0, 0)
			SetShowButton(button, true)
		end)

	end
end

function OnAnimTypeChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button.animate = false
		SetButtonPosition(button, 0, 0)
		SetShowButton(button, true)
	end
end

--#endregion
