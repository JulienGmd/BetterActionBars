print("main.lua loaded")

----- Initialization -----------------------------------------------------------

local ADDON_NAME = "NeatActionBars"
local f = CreateFrame("Frame")

function f:OnEvent(event, ...)
	self[event](self, event, ...)
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

function f:ADDON_LOADED(event, addon)
	if addon == ADDON_NAME then
		self:UnregisterEvent("ADDON_LOADED")
		self.ADDON_LOADED = nil
		Init()
	end
end

----- Utils --------------------------------------------------------------------

function Init()
	local buttonPrefixes = {
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
	for _, buttonPrefix in ipairs(buttonPrefixes) do
		for i = 1, 12 do
			InitButton(_G[buttonPrefix.."Button"..i])
		end
	end
end

function InitButton(button)
	if not button then return end

	button:SetScale(1.14)

	-- Hide the button border
	button.NormalTexture:SetAlpha(0)
	button.PushedTexture:SetAlpha(0)

	-- Reduce the size of the icon mask to hide the icon border
	button.IconMask:SetScale(.95);

	-- Scale some overlay elements to fill the icon mask
	ScaleAndCenter(button.Border, 1.1)
	ScaleAndCenter(button.CheckedTexture, 1.1)
	ScaleAndCenter(button.Flash, 1.1)
	ScaleAndCenter(button.HighlightTexture, 1.1)
	ScaleAndCenter(button.NewActionTexture, 1.1)
	ScaleAndCenter(button.PushedTexture, 1.1)

	-- Animations

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
				button:SetPoint("CENTER", 0, cd * 20)
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

function ScaleAndCenter(button, scale)
	button:SetScale(scale)
	button:ClearAllPoints()
	button:SetPoint("CENTER", 0, 0)
end
