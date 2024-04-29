BarAnimType = {
	["slideFromTop"] = "slideFromTop",
	["slideFromBottom"] = "slideFromBottom",
	["slideFromLeft"] = "slideFromLeft",
	["slideFromRight"] = "slideFromRight",
	["none"] = "none",
}

f.defaults = {
	actionBars = {
		Action = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromBottom,
		},
		MultiBarBottomLeft = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
		MultiBarBottomRight = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromBottom,
		},
		MultiBarRight = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
		MultiBarLeft = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromBottom,
		},
		MultiBar5 = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
		MultiBar6 = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
		MultiBar7 = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
		Stance = {
			scale = 1.14,
			hideBorder = true,
			animateDir = BarAnimType.slideFromTop,
		},
	},
}

function f:LoadSavedVars()
	-- NeatActionBarsDB is set by WoW if the file exists (see toc file).
	NeatActionBarsDB = NeatActionBarsDB or {}
	-- Set defaults for missing values (first load or new options added).
	-- TODO recursive
	for k, v in pairs(f.defaults) do
		if NeatActionBarsDB[k] == nil then
			NeatActionBarsDB[k] = v
		end
	end
end
