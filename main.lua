ADDON_NAME = "EnhancedEditMode"


----- Initialization -----------------------------------------------------------

f = CreateFrame("Frame")

function f:OnEvent(event, ...)
	self[event](self, event, ...)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

function f:ADDON_LOADED(event, addon)
	if addon == ADDON_NAME then
		f:UnregisterEvent("ADDON_LOADED")
		f:LoadSavedVars()
		Init()
	end
end

----- Utils --------------------------------------------------------------------

function Init()
	for _, bar in pairs(EnhancedEditModeDB.actionBars) do
		InitHover(bar)
		InitAnimations(bar)
		OnScaleChanged(bar)
		OnHideBorderChanged(bar)
	end
end

function InitHover(bar)
	local showBars = false
	local fadeOutTimer = nil

	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end
		local oldOnEnter = button:GetScript("OnEnter")
		button:SetScript("OnEnter", function(self)
			if oldOnEnter then oldOnEnter(self) end -- Call the original OnEnter
			SetShowBars(true)
		end)
		local oldOnLeave = button:GetScript("OnLeave")
		button:SetScript("OnLeave", function(self)
			if oldOnLeave then oldOnLeave(self) end -- Call the original OnLeave
			SetShowBars(false)
		end)
	end

	function SetShowBars(show)
		if showBars == show then return end
		showBars = show

		if showBars then
			CancelTimer(fadeOutTimer)
			FadeInBars()
		else
			CancelTimer(fadeOutTimer)
			fadeOutTimer = C_Timer.NewTimer(1, function()
				if not showBars then
					FadeOutBars()
				end
			end)
		end
	end

	function FadeInBars()
		for _, bar in pairs(EnhancedEditModeDB.actionBars) do
			local barFrame = _G[bar.name]
			if barFrame and barFrame:IsShown() then
				UIFrameFadeIn(barFrame, .2, barFrame:GetAlpha(), 1)
			end
		end
	end

	function FadeOutBars()
		for _, bar in pairs(EnhancedEditModeDB.actionBars) do
			local barFrame = _G[bar.name]
			if barFrame and barFrame:IsShown() and bar.onHover then
				UIFrameFadeOut(barFrame, .2, barFrame:GetAlpha(), 0)
			end
		end
	end

end

function InitAnimations(bar)
	for i = 1, 12 do
		local button = _G[bar.buttonPrefix .. "Button" .. i]
		if not button then return end

		-- Note: Not using OnShow because it is triggered by the gcd, hiding the cd.
		local oldOnUpdate = button:GetScript("OnUpdate")
		button.cooldown:SetScript("OnUpdate", function(self, elapsed)
			if oldOnUpdate then oldOnUpdate(self, elapsed) end -- Call the original OnUpdate
			local cd = button:GetCooldown()
			if cd > 5 then
				button.animate = true
			end
			if button.animate then
				if cd > 5 then
					button:SetAlpha(0)
				else
					button:SetAlpha(1)
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
					button:SetPoint("CENTER", x, y)
				end
			end
		end)

		local oldOnHide = button.cooldown:GetScript("OnHide")
		button.cooldown:SetScript("OnHide", function(self)
			if oldOnHide then oldOnHide(self) end -- Call the original OnHide
			button.animate = false
			button:SetAlpha(1)
			button:SetPoint("CENTER", 0, 0)
		end)

		function button:GetCooldown()
			if not self.action then return 0 end
			local start, duration, _, _ = GetActionCooldown(self.action)
			if start <= 0 or duration <= 0 then return 0 end
			return start + duration - GetTime()
		end
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
