-- Git branch function
local function git_branch()
    local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    if branch ~= "" then
        return branch
    else
        return ""
    end
end

_G.git_branch = git_branch

vim.api.nvim_create_autocmd({"FileType", "BufEnter", "FocusGained"}, {
    group = vim.api.nvim_create_augroup("GitBranch", { clear = true }),
    callback = function()
        vim.b.branch_name = git_branch()
    end
})

-- Individual statusline component functions
local function file_path()
    return "%f"
end

local function flags()
    return "%h%w%m%r"
end

local function git_branch_name()
    return "%{% exists('b:branch_name') && !empty(b:branch_name) ? '[' .. b:branch_name .. ']' : '' %}"
end

local function filetype()
    return "%y"
end

local function showcmdloc()
    return "%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}"
end

local function keymap()
    return "%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}"
end

local function ruler()
    return "%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}"
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
