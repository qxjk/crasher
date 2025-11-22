function errmsg(msg)
    managers.chat:_receive_message(1, "error", msg, Color.red, false)
end

function crasher(peer)
    if not peer:unit() then
        errmsg(peer:name() .. " has no unit")
        return
    end
    peer:send("set_pose", peer:unit(), 1)
end

function peer_selection(clbk)
    local params_array = {}
    local peer

    for i = 1, 4 do
        peer = managers.network:session():peer(i)
        if peer and (peer ~= managers.network:session():local_peer()) then
            params_array[#params_array + 1] = { text = peer:name(), data = peer, callback = clbk }
        end
    end

    if #params_array == 0 then
        errmsg("no players")
        return
    end

    params_array[#params_array + 1] = {}
    params_array[#params_array + 1] = { text = "cancel" }

    local menu = QuickMenu:new("player selection", "select a player to crash", params_array)
    menu:Show()
end

peer_selection(crasher)
