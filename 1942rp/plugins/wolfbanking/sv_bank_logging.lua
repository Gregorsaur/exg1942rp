banklist = banklist or {}
banklist.list = banklist.list or {}
--ENUMS
DEPOSIT = 1
WITHDRAW = 2
CHECKDEPO = 3
REPAYLOAN = 4

function banklist:Init()
    --Creating db table
    local query = [[CREATE TABLE IF NOT EXISTS `nut_bank_logs` (
      `id`	INTEGER NOT NULL AUTO_INCREMENT,
      `action`	INTEGER NOT NULL,
      `steamid`	TEXT NOT NULL,
      `info`	TEXT,
      PRIMARY KEY (`id`)
    );]]
    nut.db.query(query)

    nut.db.query("SELECT * FROM nut_bank_logs", function(data)
        if not data then return end
        MsgC(Color(0, 255, 0), "Gathering all banking logs (" .. #data .. " entries)\n")
        local logs = {}
        local logMax = 30
        --Reorganizing data
        local idata = {}

        for k, v in pairs(data) do
            idata[v.steamid] = idata[v.steamid] or {}
            idata[v.steamid][#idata[v.steamid] + 1] = v
        end

        banklist.list = idata
    end)
end

netstream.Hook("GetBankLogs", function(ply)
    netstream.Start(ply, "ReceiveBankLogs", banklist.list)
end)

--Funcs
function banklist.Add(ply, action, info)
    print("Added log")
    banklist.list[ply:SteamID64()] = banklist.list[ply:SteamID64()] or {}

    banklist.list[ply:SteamID64()][#banklist.list[ply:SteamID64()] + 1] = {
        action = action,
        info = info
    }
end

function banklist.Get()
    return banklist.list
end