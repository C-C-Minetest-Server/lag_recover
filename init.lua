-- lag_recover/init.lua
-- Recover from irrecoverable lag
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: LGPL-3.0-or-later

local minetest, settings_loader, beerchat = minetest, settings_loader, nil
if minetest.global_exists("beerchat") then
    beerchat = _G.beerchat
end


local S = minetest.get_translator("lag_recover")
local lag_counter = 0
local settings = settings_loader.load_settings("lag_recover.", {
    globalstep_count = {
        stype = "integer",
        default = 40,
    },
    lag_threshold = {
        stype = "float",
        default = 0.6, -- normal: 0.1 second
    },
    globalstep_before_warning = {
        stype = "integer",
        default = 25,
    }
}, true)

minetest.register_globalstep(function(dtime)
    if dtime > settings.lag_threshold then
        lag_counter = lag_counter + 1
        if lag_counter > settings.globalstep_count then
            minetest.request_shutdown("Recovering from server lag", true, 0)
        elseif lag_counter > settings.globalstep_before_warning then
            minetest.chat_send_all(minetest.colorize("yellow",
                S("This server may restart to recover from the lag. Type \"@1\" if you believe this is a mistake. " ..
                    "(Step count @2/@3)",
                    "hang on", lag_counter, settings.globalstep_count)))
        end
    else
        if lag_counter > settings.globalstep_before_warning then
            minetest.chat_send_all(minetest.colorize("yellow",
                S("Restart stopped.")))
        end
        lag_counter = 0
    end
end)

local register_on_chat_message = beerchat and beerchat.register_on_chat_message or minetest.register_on_chat_message
register_on_chat_message(function(_, message)
    if lag_counter == 0 then return end
    message = string.gsub(message, "%s+", "")
    message = string.lower(message)
    if string.match(message, "hangon") then
        lag_counter = 0
        minetest.chat_send_all(minetest.colorize("yellow",
            S("Successfully cancled lag restart.")))
    end
end)
