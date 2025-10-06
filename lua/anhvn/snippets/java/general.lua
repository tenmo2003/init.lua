---@diagnostic disable: undefined-global

local helpers = require "anhvn.snippets.java.helpers"

---@param type string
local function fill(type)
    return fmt(
        [[
{}

/**
 * @author anhvn
 * @since {}
 */
public {} {} {{

    {}
}}
]],
        {
            t(helpers.get_package()),
            t(os.date "%Y-%m-%d"),
            t(type),
            t(helpers.get_class_name()),
            i(1, "// implementation"),
        }
    )
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
        callbacks = helpers.ensure_imports_setting { "lombok.Getter", "lombok.Setter" },
    }),
    s("gs", {
        t { "@Getter", "@Setter" },
    }, {
        callbacks = helpers.ensure_imports_setting { "lombok.Getter", "lombok.Setter" },
    }),
    s("mclass", fill "class"),
    s("minterface", fill "interface"),
    s("menum", fill "enum"),
    s(
        "mexception",
        fmt(
            [[
{}

/**
 * @author anhvn
 * @since {}
 */
public class {} extends RuntimeException {{

    public {}(String message) {{
        super(message);
    }}
}}
]],
            {
                t(helpers.get_package()),
                t(os.date "%Y-%m-%d"),
                t(helpers.get_class_name()),
                t(helpers.get_class_name()),
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
                t(helpers.get_class_name()),
                i(0),
                t(helpers.get_class_name()),
                t(helpers.get_class_name()),
                t(helpers.get_class_name()),
            }
        )
    ),
}
