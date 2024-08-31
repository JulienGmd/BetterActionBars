BarAnimType = {
	["none"] = "none",
	["slideFromTop"] = "slideFromTop",
	["slideFromBottom"] = "slideFromBottom",
	["slideFromLeft"] = "slideFromLeft",
	["slideFromRight"] = "slideFromRight",
}

f.defaults = {
	actionBars = {
		MainMenuBar = {
			name = "MainMenuBar",
			buttonPrefix = "Action",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = true,
			onTarget = true,
			reverseGrowDir = true,
		},
		MultiBarBottomLeft = {
			name = "MultiBarBottomLeft",
			buttonPrefix = "MultiBarBottomLeft",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = true,
			reverseGrowDir = false,
		},
		MultiBarBottomRight = {
			name = "MultiBarBottomRight",
			buttonPrefix = "MultiBarBottomRight",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = true,
			onTarget = true,
			reverseGrowDir = false,
		},
		MultiBarRight = {
			name = "MultiBarRight",
			buttonPrefix = "MultiBarRight",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = true,
			reverseGrowDir = false,
		},
		MultiBarLeft = {
			name = "MultiBarLeft",
			buttonPrefix = "MultiBarLeft",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = true,
			onTarget = true,
			reverseGrowDir = false,
		},
		MultiBar5 = {
			name = "MultiBar5",
			buttonPrefix = "MultiBar5",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
			reverseGrowDir = false,
		},
		MultiBar6 = {
			name = "MultiBar6",
			buttonPrefix = "MultiBar6",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
			reverseGrowDir = false,
		},
		MultiBar7 = {
			name = "MultiBar7",
			buttonPrefix = "MultiBar7",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
			reverseGrowDir = false,
		},
		Stance = {
			name = "StanceBar",
			buttonPrefix = "Stance",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
			reverseGrowDir = false,
		},
	},
}

function f:LoadSavedVars()
	BetterActionBarsDB = f.defaults
end

-- TODO settings panel
-- function f:LoadSavedVars()
-- 	-- BetterActionBarsDB is set by WoW if the file exists (see toc file).
-- 	BetterActionBarsDB = BetterActionBarsDB or {}
-- 	-- Set defaults for missing values (first load or new options added).
-- 	-- TODO recursive
-- 	for k, v in pairs(f.defaults) do
-- 		if BetterActionBarsDB[k] == nil then
-- 			BetterActionBarsDB[k] = v
-- 		end
-- 	end
-- end
