--- Set custom indentation for one or more filetypes.
-- @param fileTypes string or table: a single filetype (string) or list of filetypes.
-- @param indent integer: number of spaces for tabstop and shiftwidth.
-- @param useExpandtab boolean|nil: whether to use spaces instead of tabs. Defaults to true.
local function setCustomIndentation(fileTypes, indent)
    if type(fileTypes) == "string" then
        fileTypes = { fileTypes }
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = fileTypes,
        callback = function()
            vim.bo.tabstop = indent
            vim.bo.shiftwidth = indent
            vim.bo.expandtab = true
        end
    })
end


setCustomIndentation({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, 2)
