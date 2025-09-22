local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

function OpenFloatingWindow(opts)
    opts = opts or {}

    -- Get the current Neovim UI size
    local ui = vim.api.nvim_list_uis()[1]
    local screen_width = ui.width
    local screen_height = ui.height

    -- Default to 80% of the screen size
    local width = opts.width or math.floor(screen_width * 0.8)
    local height = opts.height or math.floor(screen_height * 0.8)

    -- Center the window
    local col = math.floor((screen_width - width) / 2)
    local row = math.floor((screen_height - height) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    -- Set window options
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded", -- optional: 'single', 'double', 'rounded', 'solid', 'shadow'
    }

    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    return { buf = buf, win = win }
end

function ToggleFloatingTerminal()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = OpenFloatingWindow { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
        vim.cmd "startinsert"
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.api.nvim_create_user_command("Floaterminal", ToggleFloatingTerminal, {})

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set({ "n", "t" }, "<C-Space>", ToggleFloatingTerminal, { desc = "Toggle floating terminal" })
