---@diagnostic disable: undefined-global

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function get_package()
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

local function get_class_name()
    local filename = vim.fn.expand "%:t:r"
    if filename and filename ~= "" then
        return filename
    end
    return "ClassName"
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

    if last_import_line <= 0 then
        table.insert(classes_to_import, "") -- Add empty line after import when only package declaration is found
    end

    vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, classes_to_import)
end

local function ensure_imports_setting(imports)
    if type(imports) == "string" then
        imports = { imports }
    end
    return {
        [-1] = {
            [events.pre_expand] = function(snippet, event_args)
                ensure_imports(imports, snippet, event_args)
            end,
        },
    }
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
        callbacks = ensure_imports_setting { "lombok.Getter", "lombok.Setter" },
    }),
    s("gs", {
        t { "@Getter", "@Setter" },
    }, {
        callbacks = ensure_imports_setting { "lombok.Getter", "lombok.Setter" },
    }),
    s("code1945", {
        t {
            "if (!client.has(SessionConstants.CODE)) {",
            "\treturn;",
            "}",
            "int code = client.get(SessionConstants.CODE);",
        },
    }, {
        callbacks = ensure_imports_setting "com.onesoft.falcon.api.SessionConstants",
    }),
    s(
        "cs1945",
        fmt(
            [[
{}

import com.onesoft.falcon.sdk.message.common.Message;
import lombok.Getter;
import lombok.Setter;

/**
 * @author anhvn
 * @since {}
 */
@Getter
@Setter
public class {} extends Message {{
    {}

    @Override
    public String getEvent() {{
        return "{}";
    }}
}}
]],
            {
                f(function()
                    return get_package()
                end),
                f(function()
                    return os.date "%Y-%m-%d"
                end),
                f(function()
                    return get_class_name()
                end),
                i(2, "// fields here"),
                i(1, "event_name"),
            }
        )
    ),
    s(
        "sc1945",
        fmt(
            [[
{}

import com.onesoft.falcon.sdk.message.common.SCMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @author anhvn
 * @since {}
 */
@Getter
@Setter
public class {} extends SCMessage {{
    {}

    @Override
    public String getEvent() {{
        return "{}";
    }}
}}
]],
            {
                f(function()
                    return get_package()
                end),
                f(function()
                    return os.date "%Y-%m-%d"
                end),
                f(function()
                    return get_class_name()
                end),
                i(2, "// fields here"),
                i(1, "event_name"),
            }
        )
    ),
    s(
        "event1945",
        fmt(
            [[
{}

import com.corundumstudio.socketio.AckRequest;
import com.corundumstudio.socketio.SocketIOClient;
import com.corundumstudio.socketio.listener.DataListener;
import com.onesoft.server.socketio.annotation.Event;

/**
 * @author anhvn
 * @since {}
 */
@Event(name = "{}")
public class {} implements DataListener<{}> {{
    @Override
    public void onData(SocketIOClient client, {} data, AckRequest ackSender)
        throws Exception {{
        {}
    }}
}}
]],
            {
                f(function()
                    return get_package()
                end),
                f(function()
                    return os.date "%Y-%m-%d"
                end),
                i(1, "event_name"),
                f(function()
                    return get_class_name()
                end),
                i(2, "CSMessageType"),
                f(function(args)
                    return args[1][1]
                end, { 2 }),
                i(0, "// implementation here"),
            }
        )
    ),
    s(
        "bpsingleton",
        fmt(
            [[
    private {}() {{
        {}
    }}

    public static {} getInstance() {{
        return SingletonHolder.INSTANCE;
    }}

    private static class SingletonHolder {{
        private static final {} INSTANCE = new {}();
    }}
]],
            {
                f(function()
                    return get_class_name()
                end),
                i(0),
                f(function()
                    return get_class_name()
                end),
                f(function()
                    return get_class_name()
                end),
                f(function()
                    return get_class_name()
                end),
            }
        )
    ),
}
