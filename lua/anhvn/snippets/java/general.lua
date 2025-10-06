---@diagnostic disable: undefined-global

local helpers = require "anhvn.snippets.java.helpers"

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
    s(
        "fill",
        fmt(
            [[
{}

/**
 * @author anhvn
 * @since {}
 */
public class {} {{

    {}
}}
]],
            {
                f(function()
                    return helpers.get_package()
                end),
                f(function()
                    return os.date "%Y-%m-%d"
                end),
                f(function()
                    return helpers.get_class_name()
                end),
                i(1, "// implementation"),
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
                    return helpers.get_class_name()
                end),
                i(0),
                f(function()
                    return helpers.get_class_name()
                end),
                f(function()
                    return helpers.get_class_name()
                end),
                f(function()
                    return helpers.get_class_name()
                end),
            }
        )
    ),
}
