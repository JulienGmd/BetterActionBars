BarAnimType = {
	["none"] = "none",
	["slideFromTop"] = "slideFromTop",
	["slideFromBottom"] = "slideFromBottom",
	["slideFromLeft"] = "slideFromLeft",
	["slideFromRight"] = "slideFromRight",
}

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

local barNamesToEditModeName = {
	["MainMenuBar"] = "Action Bar 1",
	["MultiBarBottomLeft"] = "Action Bar 2",
	["MultiBarBottomRight"] = "Action Bar 3",
	["MultiBarRight"] = "Action Bar 4",
	["MultiBarLeft"] = "Action Bar 5",
	["MultiBar5"] = "Action Bar 6",
	["MultiBar6"] = "Action Bar 7",
	["MultiBar7"] = "Action Bar 8",
	["StanceBar"] = "Stance Bar",
}


--#region -- Defaults db values ------------------------------------------------

BAB.defaults = {
	global = {}, -- filled in below
}

for _, v in pairs(barNames) do
	BAB.defaults.global[v] = {
		name = v,
		buttonPrefix = "", -- set below
		scale = 1,
		hideBorder = false,
		hideShortcut = false,
		hideMacroName = false,
		reverseGrowDir = false,
		animType = BarAnimType.none,
	}
end

BAB.defaults.global['MainMenuBar'].buttonPrefix = "Action"
BAB.defaults.global['MultiBarBottomLeft'].buttonPrefix = "MultiBarBottomLeft"
BAB.defaults.global['MultiBarBottomRight'].buttonPrefix = "MultiBarBottomRight"
BAB.defaults.global['MultiBarRight'].buttonPrefix = "MultiBarRight"
BAB.defaults.global['MultiBarLeft'].buttonPrefix = "MultiBarLeft"
BAB.defaults.global['MultiBar5'].buttonPrefix = "MultiBar5"
BAB.defaults.global['MultiBar6'].buttonPrefix = "MultiBar6"
BAB.defaults.global['MultiBar7'].buttonPrefix = "MultiBar7"
BAB.defaults.global['StanceBar'].buttonPrefix = "Stance"

--#endregion


--#region -- AceConfig options (shown in the Interface Options) ----------------

local options = {
	name = ADDON_NAME,
	handler = BAB,
	type = 'group',
	args = {}, -- filled in below
}

for _, v in pairs(barNames) do
	options.args[v] = {
		name = barNamesToEditModeName[v] or v,
		type = "group",
		args = {
			scale = {
				type = "range",
				name = "Scale",
				desc = "Set the scale of the buttons",
				min = 0.5,
				max = 2,
				step = 0.01,
				get = function(info) return BAB.db.global[v].scale end,
				set = function(info, val)
					BAB.db.global[v].scale = val;
					OnScaleChanged(BAB.db.global[v])
				end,
			},
			hideBorder = {
				type = "toggle",
				name = "Hide Border",
				desc = "Hide the border of the buttons",
				get = function(info) return BAB.db.global[v].hideBorder end,
				set = function(info, val)
					BAB.db.global[v].hideBorder = val;
					OnHideBorderChanged(BAB.db.global[v])
				end,
			},
			hideShortcut = {
				type = "toggle",
				name = "Hide Shortcut",
				desc = "Hide the shortcut text on the buttons",
				get = function(info) return BAB.db.global[v].hideShortcut end,
				set = function(info, val)
					BAB.db.global[v].hideShortcut = val;
					OnHideShortcutChanged(BAB.db.global[v])
				end,
			},
			hideMacroName = {
				type = "toggle",
				name = "Hide Macro Name",
				desc = "Hide the macro name on the buttons",
				get = function(info) return BAB.db.global[v].hideMacroName end,
				set = function(info, val)
					BAB.db.global[v].hideMacroName = val;
					OnHideMacroNameChanged(BAB.db.global[v])
				end,
			},
			reverseGrowDir = {
				type = "toggle",
				name = "Reverse Grow Direction",
				desc = "Reverse the grow direction of the bar (only works for 2 rows of 6 buttons for now)",
				get = function(info) return BAB.db.global[v].reverseGrowDir end,
				set = function(info, val)
					BAB.db.global[v].reverseGrowDir = val;
					OnReverseGrowDirChanged(BAB.db.global[v])
				end,
			},
			animType = {
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
				get = function(info) return BAB.db.global[v].animType end,
				set = function(info, val)
					BAB.db.global[v].animType = val;
					OnAnimTypeChanged(BAB.db.global[v])
				end,
			},
		},
	}
end

LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME)

--#endregion
