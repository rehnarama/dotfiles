local M = {}
local nvm_path = os.getenv("HOME") .. "/.local/share/nvm/"
local nvmrc = ".nvmrc"

local function get_nvmrc_version()
	local file = io.open(nvmrc, "rb") -- r read mode
	if not file then
		return nil
	end

	local version = file:read("*a"):gsub("%s+", "")

	return version
end

local function get_node_path(version)
	return nvm_path .. version .. "/bin/"
end

local current_version

local function deactivate(version)
	vim.env.PATH = string.gsub(vim.env.PATH, get_node_path(version) .. ":", "")
	current_version = nil
end

local function activate_node(version)
	if current_version == version then
		return
	end
	if version == nil then
		return
	end

	if current_version ~= nil then
		deactivate(current_version)
	end

	vim.notify("Using Node.js " .. version)
	vim.env.PATH = get_node_path(version) .. ":" .. vim.env.PATH
	current_version = version
end


function M.setup(opts)
	local function activate()
		local version = get_nvmrc_version()
		if version then
			activate_node(version)
		else
			activate_node(opts.default_node_version)
		end
	end


	vim.api.nvim_create_autocmd("DirChanged", {
		callback = activate,
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = activate,
	})
end

return M
