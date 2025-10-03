local M = {}

local events = require "luasnip.util.events"

function M.get_package()
    local filepath = vim.fn.expand "%:p"
    local package_path = filepath:match "src/main/java/(.+)/[^/]+%.java$"
    if package_path then
        return "package " .. package_path:gsub("/", ".") .. ";"
    end
    package_path = filepath:match "src/java/(.+)/[^/]+%.java$"
    if package_path then
        return "package " .. package_path:gsub("/", ".") .. ";"
    end
    return ""
end

function M.get_class_name()
    local filename = vim.fn.expand "%:t:r"
    if filename and filename ~= "" then
        return filename
    end
    return "ClassName"
end

function M.trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function M.ensure_imports(classes, node, event_args)
    if type(classes) == "string" then
        classes = { classes }
    end

    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, event_args.expand_pos[1] + 1, false)

    local existing_imports = {}
    local package_line = -1
    local last_import_line = -1

    for i, line in ipairs(lines) do
        if line:match "^package " then
            package_line = i
            break
        end
    end

    for index = package_line + 1, #lines do
        local line = lines[index]
        if line:match "^import " then
            last_import_line = index
            -- Extract the import statement (remove 'import ' and ';')
            local import_statement = line:match "^import%s+(.+);$"
            if import_statement then
                existing_imports[import_statement] = true
            end
        elseif line:match "^[^/]" and trim(line) ~= "" and not line:match "^package " and not line:match "^import " then
            break
        end
    end

    local classes_to_import = {}
    for _, class in ipairs(classes) do
        if not existing_imports[class] then
            table.insert(classes_to_import, "import " .. class .. ";")
        end
    end

    if #classes_to_import == 0 then
        return
    end

    local insert_line
    if last_import_line > 0 then
        insert_line = last_import_line
    elseif package_line > 0 then
        insert_line = package_line + 1
        if lines[package_line + 1] and M.trim(lines[package_line + 1]) ~= "" then
            table.insert(classes_to_import, 1, "")
        end
    else
        insert_line = 0
    end

    if last_import_line <= 0 then
        table.insert(classes_to_import, "") -- Add empty line after import when only package declaration is found
    end

    vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, classes_to_import)
end

function M.ensure_imports_setting(imports)
    if type(imports) == "string" then
        imports = { imports }
    end
    return {
        [-1] = {
            [events.pre_expand] = function(snippet, event_args)
                M.ensure_imports(imports, snippet, event_args)
            end,
        },
    }
end

return M
