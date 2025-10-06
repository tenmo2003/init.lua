---@diagnostic disable: undefined-global

local helpers = require "anhvn.snippets.java.helpers"

return {
    s("code1945", {
        t {
            "if (!client.has(SessionConstants.CODE)) {",
            "\treturn;",
            "}",
            "int code = client.get(SessionConstants.CODE);",
        },
    }, {
        callbacks = helpers.ensure_imports_setting "com.onesoft.falcon.api.SessionConstants",
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
                t(helpers.get_package()),
                t(os.date "%Y-%m-%d"),
                t(helpers.get_class_name()),
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
                t(helpers.get_package()),
                t(os.date "%Y-%m-%d"),
                t(helpers.get_class_name()),
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
                t(helpers.get_package()),
                t(os.date "%Y-%m-%d"),
                i(1, "event_name"),
                t(helpers.get_class_name()),
                i(2, "CSMessageType"),
                f(function(args)
                    return args[1][1]
                end, { 2 }),
                i(0, "// implementation here"),
            }
        )
    ),
}
