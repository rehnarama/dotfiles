local M = {}
local pyenv_path = os.getenv("HOME") .. "/.pyenv/versions/"
local python_version_file = ".python-version"

local function get_python_version()
	local file = io.open(python_version_file, "rb") -- r read mode
	if not file then
		return nil
	end

	local version = file:read("*a"):gsub("%s+", "")

	return version
end

local function get_python_path(version)
	local matches = vim.fn.glob(pyenv_path .. version .. "*", nil, true)
	-- Return first match
	return matches[1] .. "/bin"
end

local current_version

local function deactivate(version)
	vim.env.PATH = string.gsub(vim.env.PATH, get_python_path(version) .. ":", "")
	current_version = nil
end

local function activate_pyenv(version)
	if current_version == version then
		return
	end
	if version == nil then
		return
	end

	if current_version ~= nil then
		deactivate(current_version)
	end

	vim.notify("Using Python Version " .. version)
	vim.env.PATH = get_python_path(version) .. ":" .. vim.env.PATH
	current_version = version
end

function M.setup(opts)
	local function activate()
		local version = get_python_version()
		if version then
			activate_pyenv(version)
		elseif opts.default_version ~= nil then
			activate_pyenv(opts.default_version)
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
