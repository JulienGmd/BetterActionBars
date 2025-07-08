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
		animDuration = 10,
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
		animDuration = {
			type = "range",
			name = "Animation duration",
			desc = "Set the duration of the buttons animation in seconds",
			min = 5,
			max = 30,
			step = 1,
			order = 0.1,
			get = function(info) return BAB.db.global.animDuration end,
			set = function(info, val)
				BAB.db.global.animDuration = val;
			end,
		},
		-- Bars options are filled in below
	},
}

for i, v in pairs(barNames) do
	local displayName = BAB.defaults.global.bars[v].displayName or v

	options.args[v .. "_padding"] = {
		type = "description",
		name = "\n\n\n\n",
		order = i + 1,
	}

	options.args[v .. "_header"] = {
		type = "header",
		name = displayName,
		order = i + 1.1,
	}

	options.args[v .. "_padding2"] = {
		type = "description",
		name = "\n",
		order = i + 1.2,
	}

	options.args[v .. "_hideBorder"] = {
		type = "toggle",
		name = "Hide Border",
		desc = "Hide the border of the buttons",
		order = i + 1.3,
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
		order = i + 1.4,
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
		order = i + 1.5,
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
		order = i + 1.6,
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
		order = i + 1.7,
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
		order = i + 1.8,
		get = function(info) return BAB.db.global.bars[v].animType end,
		set = function(info, val)
			BAB.db.global.bars[v].animType = val;
			OnAnimTypeChanged(BAB.db.global.bars[v])
		end,
	}
end

LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)

--#endregion
