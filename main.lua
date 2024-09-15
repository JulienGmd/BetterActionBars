ADDON_NAME = "BetterActionBars"
DB_NAME = "BetterActionBarsDB"
BAB = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")


--#region -- Initialization ----------------------------------------------------

function BAB:OnInitialize()
	-- Load the saved variables (global profile), filling with defaults if needed
	self.db = LibStub("AceDB-3.0"):New(DB_NAME, self.defaults, true)

	BAB:ScheduleTimer(function() -- Wait one frame to make this addon runs last
		-- Initialize
		for _, bar in pairs(self.db.global) do
			OnScaleChanged(bar)
			OnHideBorderChanged(bar)
			OnHideShortcutChanged(bar)
			OnHideMacroNameChanged(bar)
			OnReverseGrowDirChanged(bar)
			InitAnimations(bar)
			OnAnimTypeChanged(bar)
		end
	end, 0)
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


--#region -- Hide shortcut -----------------------------------------------------

function OnHideShortcutChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button.HotKey:SetAlpha(bar.hideShortcut and 0 or 1)
	end
end

--#endregion


--#region -- Hide macro name ---------------------------------------------------

function OnHideMacroNameChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button.Name:SetAlpha(bar.hideMacroName and 0 or 1)
	end
end

--#endregion


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
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		ResetAnimation(bar, button)
		button.cooldown:HookScript("OnUpdate", function(self, elapsed)
			AnimateButton(bar, button, elapsed)
		end)
		button.cooldown:HookScript("OnHide", function(self)
			ResetAnimation(bar, button)
		end)
	end
end

function OnAnimTypeChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		ResetAnimation(bar, button)
	end
end

function ResetAnimation(bar, button)
	button.cd = 0
	button.animate = false
	SetButtonPosition(button, 0, 0)
	SetShowButton(bar, button, true)
end

function AnimateButton(bar, button, elapsed)
	if bar.animType == BarAnimType.none then return end

	local cd = GetButtonCooldown(button)
	if (cd > 1.5) then
		button.cd = cd
	elseif (cd == 0) then
		button.cd = 0
	else
		-- If the cooldown is the gcd, manually decrease the cooldown to ignore it.
		button.cd = button.cd - elapsed
	end

	if button.cd <= 0 then
		button.cd = 0
		button.animate = false
		return
	end

	if button.cd > 5 then
		button.animate = true
	end

	if button.animate then
		if button.cd > 5 then
			SetShowButton(bar, button, false)
		else
			local x = 0
			local y = 0
			if bar.animType == BarAnimType.slideFromBottom then
				x = 0
				y = -button.cd * 20
			elseif bar.animType == BarAnimType.slideFromTop then
				x = 0
				y = button.cd * 20
			elseif bar.animType == BarAnimType.slideFromLeft then
				x = -button.cd * 20
				y = 0
			elseif bar.animType == BarAnimType.slideFromRight then
				x = button.cd * 20
				y = 0
			end
			SetButtonPosition(button, x, y)
			SetShowButton(bar, button, true)
		end
	end
end

function GetButtonCooldown(button)
	if not button.action then return 0 end
	local start, duration, _, _ = GetActionCooldown(button.action)
	if start <= 0 or duration <= 0 then return 0 end
	return start + duration - GetTime()
end

-- Hide button components (keep the background visible)
function SetShowButton(bar, button, show)
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
		button.Name:SetAlpha(show and not bar.hideMacroName and 1 or 0)
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

--#endregion
