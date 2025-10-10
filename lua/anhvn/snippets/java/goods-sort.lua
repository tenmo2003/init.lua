---@diagnostic disable: undefined-global

local helpers = require "anhvn.snippets.java.helpers"

return {
    s("code1945", {
        t {
            "if (!session.hasKey(AccountConst.CODE))",
            "\treturn;",
            "int code = (Integer) session.get(AccountConst.CODE)",
        },
    }, {
        callbacks = helpers.ensure_imports_setting { "com.os.falcon.core_account.consts.AccountConst" },
    }),
    s(
        "messagegs",
        fmt(
            [[
{}

import com.os.falcon.core.network.api.message.FMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @author anhvn
 * @since {}
 */
@Getter
@Setter
public class {} extends FMessage {{
    {}

    @Override
    public String getEvent() {{
        return "{}";
    }}
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
                i(2, "// fields here"),
                i(1, "event_name"),
            }
        )
    ),
    s(
        "eventgs",
        fmt(
            [[
{}

import com.os.falcon.core.network.api.message.FSMessageEvent;
import com.os.falcon.core.network.server.Ack;
import com.os.falcon.core.network.server.api.FSession;

/**
 * @author anhvn
 * @since {}
 */
public class {} extends FSMessageEvent<{}> {{
    @Override
    public void onMessage(FSession session, {} message, Ack callback) {{
        {}
    }}
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
                i(1, "CSMessageType"),
                f(function(args)
                    return args[1][1]
                end, { 1 }),
                i(0, "// implementation here"),
            }
        )
    ),
}
