ADDON_NAME = "BetterActionBars"


----- Initialization -----------------------------------------------------------

f = CreateFrame("Frame")

function f:OnEvent(event, ...)
	self[event](self, event, ...)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:HookScript("OnEvent", f.OnEvent)

function f:ADDON_LOADED(event, addon)
	if addon == ADDON_NAME then
		f:UnregisterEvent("ADDON_LOADED")
		f:LoadSavedVars()
		Init()
	end
end

local hasTarget = false
function f:PLAYER_TARGET_CHANGED(event)
	if hasTarget == UnitExists("target") then return end
	hasTarget = UnitExists("target")
	for _, bar in pairs(BetterActionBarsDB.actionBars) do
		if bar.onTarget then
			bar.showLevel = bar.showLevel + (hasTarget and 1 or -1)
			OnShowLevelChanged(bar)
		end
	end
end


----- Utils --------------------------------------------------------------------

function Init()
	for _, bar in pairs(BetterActionBarsDB.actionBars) do
		InitFade(bar)
		InitAnimations(bar)
		OnScaleChanged(bar)
		OnHideBorderChanged(bar)
		OnReverseGrowDirChanged(bar)
	end
end

function InitFade(bar)

	function OnShowLevelChanged(bar)
		if bar.showLevel > 0 then
			CancelTimer(bar.fadeOutTimer)
			FadeIn(bar)
		else
			CancelTimer(bar.fadeOutTimer)
			bar.fadeOutTimer = C_Timer.NewTimer(1, function()
				if bar.showLevel <= 0 then
					FadeOut(bar)
				end
			end)
		end
	end

	function FadeIn(bar)
		local barFrame = _G[bar.name]
		if barFrame and barFrame:IsShown() then
			UIFrameFadeIn(barFrame, .2, barFrame:GetAlpha(), 1)
		end
	end

	function FadeOut(bar)
		local barFrame = _G[bar.name]
		if barFrame and barFrame:IsShown() then
			UIFrameFadeOut(barFrame, .2, barFrame:GetAlpha(), 0)
		end
	end

	bar.fadeOutTimer = nil
	bar.showLevel = (bar.onHover or bar.onTarget) and 0 or 1
	OnShowLevelChanged(bar)

	-- onHover: Bind OnEnter/OnLeave events of the buttons
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button:HookScript("OnEnter", function(self)
			for _, bar in pairs(BetterActionBarsDB.actionBars) do
				if bar.onHover then
					bar.showLevel = bar.showLevel + 1
					OnShowLevelChanged(bar)
				end
			end
		end)
		button:HookScript("OnLeave", function(self)
			for _, bar in pairs(BetterActionBarsDB.actionBars) do
				if bar.onHover then
					bar.showLevel = bar.showLevel - 1
					OnShowLevelChanged(bar)
				end
			end
		end)
	end

end

function InitAnimations(bar)

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

		function button:GetCooldown()
			if not self.action then return 0 end
			local start, duration, _, _ = GetActionCooldown(self.action)
			if start <= 0 or duration <= 0 then return 0 end
			return start + duration - GetTime()
		end

		-- Note: Not using OnShow because it is triggered by the gcd, hiding the cd.
		button.cooldown:HookScript("OnUpdate", function(self, elapsed)
			if bar.animType == BarAnimType.none then return end
			local cd = button:GetCooldown()
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

function OnScaleChanged(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		button:SetScale(bar.scale)
	end
end

function OnHideBorderChanged(bar)
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

function ScaleAndCenter(button, scale)
	button:SetScale(scale)
	button:ClearAllPoints()
	button:SetPoint("CENTER", 0, 0)
end

function CancelTimer(timer)
	if timer then
		timer:Cancel()
		timer = nil
	end
end
