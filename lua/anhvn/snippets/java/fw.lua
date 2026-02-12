---@diagnostic disable: undefined-global

local helpers = require "anhvn.snippets.java.helpers"

return {
    s("codefw", {
        t {
            "if (!session.hasKey(AccountConst.CODE))",
            "\treturn;",
            "int code = (Integer) session.get(AccountConst.CODE);",
        },
    }, {
        callbacks = helpers.ensure_imports_setting { "com.os.falcon.core.account.consts.AccountConst" },
    }),
    s(
        "messagefw",
        fmt(
            [[
{}

import com.os.falcon.core.network.annotation.FAMessage;
import com.os.falcon.core.network.messages.FMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * @author anhvn
 * @since {}
 */
@Getter
@Setter
@FAMessage(name = "{}")
public class {} extends FMessage {{
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
                i(1, "event_name"),
                f(function()
                    return helpers.get_class_name()
                end),
                i(2, "// fields here"),
            }
        )
    ),
    s(
        "eventfw",
        fmt(
            [[
{}

import com.os.falcon.core.network.service.event.FSMessageEvent;
import com.os.falcon.core.network.service.future.Ack;
import com.os.falcon.core.network.service.components.FSession;


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
