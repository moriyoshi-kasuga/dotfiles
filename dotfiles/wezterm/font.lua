local wezterm = require("wezterm")
local M = {
	fonts = {},
	default = nil,
	cache = os.getenv("HOME") .. "/.cache/wezterm-font",
}

function M.get_default()
	local f = io.open(M.cache, "r")
	if f == nil then
		return M.default
	end
	local v = f:read("a")
	f:close()
	if v == nil or v == "" or M.fonts[v] == nil then
		return nil
	end
	return v
end

function M.load_default(config)
	local name = M.get_default()
	if name == nil then
		return
	end
	M.select(config, name)
end

function M.save_default(name)
	local f = io.open(M.cache, "w")
	if f == nil then
		wezterm.log_info("not able to write to " .. M.cache)
		return
	end
	f:write(name)
	f:close()
end

function M.register_fonts(opts)
	for _, v in ipairs(opts or {}) do
		local name = v.name or v.mod
		if M.default == nil and v.default == true then
			M.default = name
		end
		M.fonts[name] = v
	end
end

function M.select(config, name)
	local font = M.fonts[name]
	require("fonts." .. font.mod)(config, font.opts)
end

function M.selector_action()
	return wezterm.action_callback(function(window, pane)
		local choices = {}
		for k, _ in pairs(M.fonts) do
			table.insert(choices, { label = k })
		end
		table.sort(choices, function(a, b)
			return a.label < b.label
		end)

		window:perform_action(
			wezterm.action.InputSelector({
				action = wezterm.action_callback(function(_, _, _, label)
					local overrides = window:get_config_overrides() or {}
					M.select(overrides, label)
					window:set_config_overrides(overrides)
					M.save_default(label)
					-- wezterm.log_info("Set font to " .. label)
				end),
				title = "Font Selector",
				choices = choices,
				fuzzy = true,
			}),
			pane
		)
	end)
end

return M
