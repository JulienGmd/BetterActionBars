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
		ScaleAllBarButtons()
	end
end

----- Utils --------------------------------------------------------------------

function ScaleAllBarButtons()
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
		ScaleBarButtons(buttonPrefix)
	end
end

function ScaleBarButtons(buttonPrefix)
	for i = 1, 12 do
		local button = _G[buttonPrefix.."Button"..i]
		if not button then
			break
		end

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

		button:SetScale(1.14)
	end
end

function ScaleAndCenter(button, scale)
	button:SetScale(scale)
	button:ClearAllPoints()
	button:SetPoint("CENTER", 0, 0)
end
