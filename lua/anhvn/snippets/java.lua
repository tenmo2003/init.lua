---@diagnostic disable: undefined-global

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function ensure_imports(classes, node, event_args)
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
        -- Add empty line after package statement
        if lines[package_line + 1] and trim(lines[package_line + 1]) ~= "" then
            table.insert(classes_to_import, 1, "")
        end
    else
        insert_line = 0
    end

    table.insert(classes_to_import, "") -- Add empty line after imports

    vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, classes_to_import)
end

return {
    s("psf", {
        t { "public static final " },
        i(1, "type"),
        t { " " },
        i(2, "name"),
        t { " = " },
        i(3, "value"),
        t { ";" },
    }),
    s("psfi", {
        t { "public static final int " },
        i(1, "name"),
        t { " = " },
        i(2, "value"),
        t { ";" },
    }),
    s("psfs", {
        t { "public static final String " },
        i(1, "name"),
        t { " = " },
        i(2, "value"),
        t { ";" },
    }),
    s("getset", {
        t { "@Getter", "@Setter" },
    }, {
        callbacks = {
            [-1] = {
                [events.pre_expand] = function(snippet, event_args)
                    ensure_imports({ "lombok.Getter", "lombok.Setter" }, snippet, event_args)
                end,
            },
        },
    }),
    s("code1945", {
        t {
            "if (!client.has(SessionConstants.CODE)) {",
            "\treturn;",
            "}",
            "int code = client.get(SessionConstants.CODE);",
        },
    }, {
        callbacks = {
            [-1] = {
                [events.pre_expand] = function(snippet, event_args)
                    ensure_imports({ "com.onesoft.falcon.api.SessionConstants" }, snippet, event_args)
                end,
            },
        },
    }),
}
