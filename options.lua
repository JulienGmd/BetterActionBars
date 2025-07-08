local barNames = {
	"MainMenuBar",
	"MultiBarBottomLeft",
	"MultiBarBottomRight",
	"MultiBarRight",
	"MultiBarLeft",
	"MultiBar5",
	"MultiBar6",
	"MultiBar7",
	"StanceBar",
}

BarAnimType = {
	["none"] = "none",
	["slideFromTop"] = "slideFromTop",
	["slideFromBottom"] = "slideFromBottom",
	["slideFromLeft"] = "slideFromLeft",
	["slideFromRight"] = "slideFromRight",
}


--#region -- Defaults db values ------------------------------------------------

BAB.defaults = {
	global = {
		bars = {} -- filled in below
	}
}

for _, v in pairs(barNames) do
	BAB.defaults.global.bars[v] = {
		name = v,
		buttonPrefix = "", -- set below
		displayName = "", -- set below
		scale = 1,
		hideBorder = false,
		hideShortcut = false,
		hideMacroName = false,
		reverseGrowDir = false,
		animType = BarAnimType.none,
		animDuration = 5, -- in seconds
		animDistance = 100, -- in pixels
	}
end

BAB.defaults.global.bars['MainMenuBar'].buttonPrefix = "Action"
BAB.defaults.global.bars['MultiBarBottomLeft'].buttonPrefix = "MultiBarBottomLeft"
BAB.defaults.global.bars['MultiBarBottomRight'].buttonPrefix = "MultiBarBottomRight"
BAB.defaults.global.bars['MultiBarRight'].buttonPrefix = "MultiBarRight"
BAB.defaults.global.bars['MultiBarLeft'].buttonPrefix = "MultiBarLeft"
BAB.defaults.global.bars['MultiBar5'].buttonPrefix = "MultiBar5"
BAB.defaults.global.bars['MultiBar6'].buttonPrefix = "MultiBar6"
BAB.defaults.global.bars['MultiBar7'].buttonPrefix = "MultiBar7"
BAB.defaults.global.bars['StanceBar'].buttonPrefix = "Stance"

BAB.defaults.global.bars["MainMenuBar"].displayName = "Action Bar 1"
BAB.defaults.global.bars["MultiBarBottomLeft"].displayName = "Action Bar 2"
BAB.defaults.global.bars["MultiBarBottomRight"].displayName = "Action Bar 3"
BAB.defaults.global.bars["MultiBarRight"].displayName = "Action Bar 4"
BAB.defaults.global.bars["MultiBarLeft"].displayName = "Action Bar 5"
BAB.defaults.global.bars["MultiBar5"].displayName = "Action Bar 6"
BAB.defaults.global.bars["MultiBar6"].displayName = "Action Bar 7"
BAB.defaults.global.bars["MultiBar7"].displayName = "Action Bar 8"
BAB.defaults.global.bars["StanceBar"].displayName = "Stance Bar"

--#endregion


--#region -- AceConfig options (shown in the Interface Options) ----------------

local options = {
	name = ADDON_NAME,
	handler = BAB,
	type = 'group',
	args = {
		general = {
			type = "header",
			name = "General Options",
			order = 0,
		},
		generalDescription = {
			type = "description",
			name = "\nUse these options to change all bars options at once\n\n",
			order = 0.01,
		},

		hideBorder = {
			type = "toggle",
			name = "Hide Border",
			desc = "Hide the border of the buttons",
			order = 0.02,
			get = function(info) return not AnyBarHasNotOption("hideBorder") end, -- Any disabled = disabled
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].hideBorder = val;
					OnHideBorderChanged(BAB.db.global.bars[v])
				end
			end,
		},
		hideShortcut = {
			type = "toggle",
			name = "Hide Shortcut",
			desc = "Hide the shortcut text on the buttons",
			order = 0.03,
			get = function(info) return not AnyBarHasNotOption("hideShortcut") end,
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].hideShortcut = val;
					OnHideShortcutChanged(BAB.db.global.bars[v])
				end
			end,
		},
		hideMacro = {
			type = "toggle",
			name = "Hide Macro Name",
			desc = "Hide the macro name on the buttons",
			order = 0.04,
			get = function(info) return not AnyBarHasNotOption("hideMacroName") end,
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].hideMacroName = val;
					OnHideMacroNameChanged(BAB.db.global.bars[v])
				end
			end,
		},
		reverseGrowDirection = {
			type = "toggle",
			name = "Reverse Grow Direction",
			desc = "Reverse the grow direction of the bar (only works for 2 rows of 6 buttons for now)",
			order = 0.05,
			get = function(info) return not AnyBarHasNotOption("reverseGrowDir") end,
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].reverseGrowDir = val;
					OnReverseGrowDirChanged(BAB.db.global.bars[v])
				end
			end,
		},
		scale = {
			type = "range",
			name = "Scale",
			desc = "Set the scale of the buttons",
			min = 0.5,
			max = 2,
			step = 0.01,
			order = 0.06,
			get = function(info) return BAB.db.global.bars["MainMenuBar"].scale end, -- TODO
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].scale = val;
					OnScaleChanged(BAB.db.global.bars[v])
				end
			end,
		},
		animation = {
			type = "select",
			name = "Animation",
			desc = "Set the animation for when the buttons are on cooldown",
			values = {
				["none"] = "None",
				["slideFromTop"] = "Slide from top",
				["slideFromBottom"] = "Slide from bottom",
				["slideFromLeft"] = "Slide from left",
				["slideFromRight"] = "Slide from right",
			},
			order = 0.07,
			get = function(info) return BAB.db.global.bars["MainMenuBar"].animType end, -- TODO
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].animType = val;
					OnAnimTypeChanged(BAB.db.global.bars[v])
				end
			end,
		},
		animDuration = {
			type = "range",
			name = "Animation duration",
			desc = "Set the duration of the buttons animation in seconds",
			min = 5,
			max = 120,
			step = 1,
			order = 0.08,
			get = function(info) return BAB.db.global.bars["MainMenuBar"].animDuration end, -- TODO
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].animDuration = val;
				end
			end,
		},
		animDistance = {
			type = "range",
			name = "Animation distance",
			desc = "Set the distance of the buttons animation in pixels",
			min = 0,
			max = 500,
			step = 1,
			order = 0.09,
			get = function(info) return BAB.db.global.bars["MainMenuBar"].animDistance end, -- TODO
			set = function(info, val)
				for _, v in pairs(barNames) do
					BAB.db.global.bars[v].animDistance = val;
				end
			end,
		},
		-- Bars options are filled in below
	},
}

for i, v in pairs(barNames) do
	options.args[v .. "_padding"] = {
		type = "description",
		name = "\n\n\n\n",
		order = i + 1,
	}

	options.args[v .. "_header"] = {
		type = "header",
		name = BAB.defaults.global.bars[v].displayName or v,
		order = i + 1.01,
	}

	options.args[v .. "_padding2"] = {
		type = "description",
		name = "\n",
		order = i + 1.02,
	}

	options.args[v .. "_hideBorder"] = {
		type = "toggle",
		name = "Hide Border",
		desc = "Hide the border of the buttons",
		order = i + 1.03,
		get = function(info) return BAB.db.global.bars[v].hideBorder end,
		set = function(info, val)
			BAB.db.global.bars[v].hideBorder = val;
			OnHideBorderChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_hideShortcut"] = {
		type = "toggle",
		name = "Hide Shortcut",
		desc = "Hide the shortcut text on the buttons",
		order = i + 1.04,
		get = function(info) return BAB.db.global.bars[v].hideShortcut end,
		set = function(info, val)
			BAB.db.global.bars[v].hideShortcut = val;
			OnHideShortcutChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_hideMacro"] = {
		type = "toggle",
		name = "Hide Macro Name",
		desc = "Hide the macro name on the buttons",
		order = i + 1.05,
		get = function(info) return BAB.db.global.bars[v].hideMacroName end,
		set = function(info, val)
			BAB.db.global.bars[v].hideMacroName = val;
			OnHideMacroNameChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_reverseGrowDirection"] = {
		type = "toggle",
		name = "Reverse Grow Direction",
		desc = "Reverse the grow direction of the bar (only works for 2 rows of 6 buttons for now)",
		order = i + 1.06,
		get = function(info) return BAB.db.global.bars[v].reverseGrowDir end,
		set = function(info, val)
			BAB.db.global.bars[v].reverseGrowDir = val;
			OnReverseGrowDirChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_scale"] = {
		type = "range",
		name = "Scale",
		desc = "Set the scale of the buttons",
		min = 0.5,
		max = 2,
		step = 0.01,
		order = i + 1.07,
		get = function(info) return BAB.db.global.bars[v].scale end,
		set = function(info, val)
			BAB.db.global.bars[v].scale = val;
			OnScaleChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_animation"] = {
		type = "select",
		name = "Animation",
		desc = "Set the animation for when the buttons are on cooldown",
		values = {
			["none"] = "None",
			["slideFromTop"] = "Slide from top",
			["slideFromBottom"] = "Slide from bottom",
			["slideFromLeft"] = "Slide from left",
			["slideFromRight"] = "Slide from right",
		},
		order = i + 1.08,
		get = function(info) return BAB.db.global.bars[v].animType end,
		set = function(info, val)
			BAB.db.global.bars[v].animType = val;
			OnAnimTypeChanged(BAB.db.global.bars[v])
		end,
	}
	options.args[v .. "_animDuration"] = {
		type = "range",
		name = "Animation duration",
		desc = "Set the duration of the buttons animation in seconds",
		min = 5,
		max = 120,
		step = 1,
		order = i + 1.09,
		hidden = function(info) return BAB.db.global.bars[v].animType == BarAnimType.none end,
		get = function(info) return BAB.db.global.bars[v].animDuration end,
		set = function(info, val)
			BAB.db.global.bars[v].animDuration = val;
		end,
	}
	options.args[v .. "_animDistance"] = {
		type = "range",
		name = "Animation distance",
		desc = "Set the distance of the buttons animation in pixels",
		min = 0,
		max = 500,
		step = 1,
		order = i + 1.10,
		hidden = function(info) return BAB.db.global.bars[v].animType == BarAnimType.none end,
		get = function(info) return BAB.db.global.bars[v].animDistance end,
		set = function(info, val)
			BAB.db.global.bars[v].animDistance = val;
		end,
	}
end

function AnyBarHasNotOption(optionName)
	for _, v in pairs(barNames) do
		if not BAB.db.global.bars[v][optionName] then
			return true
		end
	end
	return false
end

LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)

--#endregion
