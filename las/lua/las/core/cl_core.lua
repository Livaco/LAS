function Las.Core.Message(args)
    chat.AddText(unpack(args))
end

net.Receive("las.core.message", function()
    local args = net.ReadTable()
    Las.Core.Message(args)
end)

net.Receive("las.core.updateclonlinetable", function()
    Las.OnlineUsers = net.ReadTable()
end)