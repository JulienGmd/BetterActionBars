----- Initialization -----------------------------------------------------------

ADDON_NAME = "EnhancedEditMode"
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
	local bars = {
		"Action",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBar5",
		"MultiBar6",
		"MultiBar7",
		"Stance",
	}
	for _, bar in ipairs(bars) do
		InitAnimations(bar)
		OnScaleChanged(bar)
		OnHideBorderChanged(bar)
	end
end

function InitAnimations(bar)
	for i = 1, 12 do
		local bs = EnhancedEditModeDB.actionBars[bar]
		local button = _G[bar.."Button"..i]
		if not button then return end

		-- Note: Not using OnShow because it is triggered by the gcd, hiding the cd.
		button.cooldown:SetScript("OnUpdate", function(self, elapsed)
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
					if bs.animateDir == BarAnimType.slideFromBottom then
						x = 0
						y = -cd * 20
					elseif bs.animateDir == BarAnimType.slideFromTop then
						x = 0
						y = cd * 20
					elseif bs.animateDir == BarAnimType.slideFromLeft then
						x = -cd * 20
						y = 0
					elseif bs.animateDir == BarAnimType.slideFromRight then
						x = cd * 20
						y = 0
					end
					button:SetPoint("CENTER", x, y)
				end
			end
		end)

		button.cooldown:SetScript("OnHide", function(self)
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
	local bs = EnhancedEditModeDB.actionBars[bar]
	for i = 1, 12 do
		local button = _G[bar.."Button"..i]
		if not button then return end
		button:SetScale(bs.scale)
	end
end

function OnHideBorderChanged(bar)
	local bs = EnhancedEditModeDB.actionBars[bar]
	for i = 1, 12 do
		local button = _G[bar.."Button"..i]
		if not button then return end
		-- Hide the button border
		button.NormalTexture:SetAlpha(bs.hideBorder and 0 or 1)
		button.PushedTexture:SetAlpha(bs.hideBorder and 0 or 1)
		-- Reduce the size of the icon mask to hide the icon border
		button.IconMask:SetScale(bs.hideBorder and .95 or 1);
		-- Scale some overlay elements to fill the icon mask
		ScaleAndCenter(button.Border, bs.hideBorder and 1.1 or 1)
		ScaleAndCenter(button.CheckedTexture, bs.hideBorder and 1.1 or 1)
		ScaleAndCenter(button.Flash, bs.hideBorder and 1.1 or 1)
		ScaleAndCenter(button.HighlightTexture, bs.hideBorder and 1.1 or 1)
		ScaleAndCenter(button.NewActionTexture, bs.hideBorder and 1.1 or 1)
		ScaleAndCenter(button.PushedTexture, bs.hideBorder and 1.1 or 1)
	end
end

function ScaleAndCenter(button, scale)
	button:SetScale(scale)
	button:ClearAllPoints()
	button:SetPoint("CENTER", 0, 0)
end
