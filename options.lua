BarAnimType = {
	["slideFromTop"] = "slideFromTop",
	["slideFromBottom"] = "slideFromBottom",
	["slideFromLeft"] = "slideFromLeft",
	["slideFromRight"] = "slideFromRight",
	["none"] = "none",
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
		},
		MultiBarBottomLeft = {
			name = "MultiBarBottomLeft",
			buttonPrefix = "MultiBarBottomLeft",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = true,
		},
		MultiBarBottomRight = {
			name = "MultiBarBottomRight",
			buttonPrefix = "MultiBarBottomRight",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = true,
			onTarget = true,
		},
		MultiBarRight = {
			name = "MultiBarRight",
			buttonPrefix = "MultiBarRight",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = true,
		},
		MultiBarLeft = {
			name = "MultiBarLeft",
			buttonPrefix = "MultiBarLeft",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = true,
			onTarget = true,
		},
		MultiBar5 = {
			name = "MultiBar5",
			buttonPrefix = "MultiBar5",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
		},
		MultiBar6 = {
			name = "MultiBar6",
			buttonPrefix = "MultiBar6",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
		},
		MultiBar7 = {
			name = "MultiBar7",
			buttonPrefix = "MultiBar7",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
		},
		Stance = {
			name = "StanceBar",
			buttonPrefix = "Stance",
			scale = 1.22,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
			onTarget = false,
		},
	},
}

function f:LoadSavedVars()
	EnhancedEditModeDB = f.defaults
end

-- TODO settings panel
-- function f:LoadSavedVars()
-- 	-- EnhancedEditModeDB is set by WoW if the file exists (see toc file).
-- 	EnhancedEditModeDB = EnhancedEditModeDB or {}
-- 	-- Set defaults for missing values (first load or new options added).
-- 	-- TODO recursive
-- 	for k, v in pairs(f.defaults) do
-- 		if EnhancedEditModeDB[k] == nil then
-- 			EnhancedEditModeDB[k] = v
-- 		end
-- 	end
-- end
