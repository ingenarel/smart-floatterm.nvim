local m = {}

function m.openNeovimTerm(command)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	---@type integer
	local bufID = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(bufID, true, {
		relative = "editor",
		width = floatingWinWidth,
		height = floatingWinHeight,
		col = math.floor((vim.o.columns - floatingWinWidth + m.neovimXoffset) / 2),
		row = math.floor((vim.o.lines - floatingWinHeight + m.neovimYoffset) / 2),
		border = "rounded",
		style = "minimal",
	})
	vim.cmd.term(command)
end

function m.openTmuxTerm(command)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	vim.system({
		"tmux",
		"display-popup",
		"-E",
		"-w",
		tostring(floatingWinWidth),
		"-h",
		tostring(floatingWinHeight),
		"-x",
		tostring(math.floor((vim.o.columns - floatingWinWidth + m.tmuxXoffset) / 2)),
		"-y",
		tostring(math.floor((vim.o.lines + floatingWinHeight + m.tmuxYoffset) / 2)),
		"-d",
		vim.fn.getcwd(),
		command,
	})
end

function m.openZellijTerm(command)
	---@type integer
	local floatingWinWidth = math.floor(vim.o.columns / 100 * m.widthPercentage)
	---@type integer
	local floatingWinHeight = math.floor(vim.o.lines / 100 * m.heightPercentage)
	local execute = {
		"zellij",
		"action",
		"new-pane",
		"--floating",
		"--width",
		tostring(floatingWinWidth),
		"--height",
		tostring(floatingWinHeight),
		"-x",
		tostring(math.floor((vim.o.columns - floatingWinWidth - 2) / 2)),
		"-y",
		tostring(math.floor((vim.o.lines - floatingWinHeight + 3) / 2)),
	}
	if command ~= nil then
		table.insert(execute, "--close-on-exit")
		table.insert(execute, "--")
		table.insert(execute, command)
	end
	vim.system(execute)
end

function m.open(command)
	if os.getenv("TMUX") then
		m.openTmuxTerm(command)
	elseif os.getenv("ZELLIJ") then
		m.openZellijTerm(command)
	else
		m.openNeovimTerm(command)
	end
end

function m.setup(opts)
	m.heightPercentage = opts.heightPercentage
	m.widthPercentage = opts.widthPercentage

	m.neovimXoffset = opts.neovimXoffset
	m.neovimYoffset = opts.neovimYoffset

	m.tmuxXoffset = opts.tmuxXoffset
	m.tmuxYoffset = opts.tmuxYoffset

	if m.heightPercentage == nil then
		m.heightPercentage = 70
	end
	if m.widthPercentage == nil then
		m.widthPercentage = 80
	end

	if m.neovimXoffset == nil then
		m.neovimXoffset = -2
	end
	if m.neovimYoffset == nil then
		m.neovimYoffset = -2
	end

	if m.tmuxXoffset == nil then
		m.tmuxXoffset = -2
	end
	if m.tmuxYoffset == nil then
		m.tmuxYoffset = -2
	end

end

return m
