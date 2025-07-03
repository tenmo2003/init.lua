-- Git branch function
local function git_branch()
    local branch = vim.fn.system "git branch --show-current 2> /dev/null | tr -d '\n'"
    return branch ~= "" and branch or ""
end

_G.git_branch = git_branch

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "FocusGained" }, {
    group = vim.api.nvim_create_augroup("GitBranch", { clear = true }),
    callback = function()
        vim.b.branch_name = git_branch()
    end,
})

-- Statusline component functions with highlight groups
local function file_path()
    return "%#StatusLinePath#%f"
end

local function flags()
    return "%#StatusLinePath#%h%w%m%r"
end

local function git_branch_name()
    return "%#StatusLineGit#%{% exists('b:branch_name') && !empty(b:branch_name) ? 'on  ' .. b:branch_name : '' %}%*"
end

local function filetype()
    return "%#StatusLineFileType#%y"
end

local function showcmdloc()
    return "%#StatusLineInactive#%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}"
end

local function keymap()
    return "%#StatusLineInactive#%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}"
end

local function ruler()
    return "%#StatusLineRuler#%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l/%L,%c%V%) %P' : &rulerformat ) : '' %}"
end

-- Compose all components
local function build_statusline()
    local parts = {
        "%<",
        file_path(),
        flags(),
        " ",
        git_branch_name(),
        "%=",
        filetype(),
        "  ",
        showcmdloc(),
        keymap(),
        ruler(),
    }
    return table.concat(parts)
end

-- Set the statusline
vim.o.statusline = build_statusline()

vim.api.nvim_set_hl(0, "StatusLineGit", { fg = "#a6e3a1", bold = true }) -- green (for general Git info)
