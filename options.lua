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
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = false,
		},
		MultiBarBottomLeft = {
			name = "MultiBarBottomLeft",
			buttonPrefix = "MultiBarBottomLeft",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = false,
		},
		MultiBarBottomRight = {
			name = "MultiBarBottomRight",
			buttonPrefix = "MultiBarBottomRight",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = false,
		},
		MultiBarRight = {
			name = "MultiBarRight",
			buttonPrefix = "MultiBarRight",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = false,
		},
		MultiBarLeft = {
			name = "MultiBarLeft",
			buttonPrefix = "MultiBarLeft",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromBottom,
			onHover = false,
		},
		MultiBar5 = {
			name = "MultiBar5",
			buttonPrefix = "MultiBar5",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
		},
		MultiBar6 = {
			name = "MultiBar6",
			buttonPrefix = "MultiBar6",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
		},
		MultiBar7 = {
			name = "MultiBar7",
			buttonPrefix = "MultiBar7",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
		},
		Stance = {
			name = "StanceBar",
			buttonPrefix = "Stance",
			scale = 1.14,
			hideBorder = true,
			animType = BarAnimType.slideFromTop,
			onHover = true,
		},
	},
}

function f:LoadSavedVars()
	-- EnhancedEditModeDB is set by WoW if the file exists (see toc file).
	EnhancedEditModeDB = EnhancedEditModeDB or {}
	-- Set defaults for missing values (first load or new options added).
	-- TODO recursive
	for k, v in pairs(f.defaults) do
		if EnhancedEditModeDB[k] == nil then
			EnhancedEditModeDB[k] = v
		end
	end
end
