local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

return h.make_builtin({
    method = DIAGNOSTICS,
    filetypes = { "lua" },
    generator_opts = {
        command = "selene",
        args = { "--display-style", "quiet", "-" },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
            return code <= 1
        end,
        on_output = h.diagnostics.from_pattern(
            [[(%d+):(%d+): (%w+)%[([%w_]+)%]: ([`]*([%w_]+)[`]*.*)]],
            { "row", "col", "severity", "code", "message", "_quote" },
            { adapters = { h.diagnostics.adapters.end_col.from_quote }, offsets = { end_col = 1 } }
        ),
    },
    factory = h.generator_factory,
})
