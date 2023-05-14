BGF = BGF or {}
BGF.nextCalc = nil
BGF.cache = BGF.cache or {}
BGF.data = BGF.data or {}
BANKNAME = "Bank General Funds"
--Banking Folder
local path = "nutscript/" .. "starwarsrp" --SCHEMA.folder
local varFile = path .. "/bankvars.txt"

if SERVER then
    --Read BGF data
    BGF.data = util.JSONToTable(file.Read(varFile) or "{}") or {}

    function BGF:Sync(ply)
        if not ply then
            ply = player.GetAll()
        end

        netstream.Start(ply, "BankingSyncBGF", BGF.data.funds)
    end

    function BGF:Save()
        local json = util.TableToJSON(self.data, true)
        file.Write(varFile, json)
        --Syncing
        self:Sync()
    end

    function BGF:SetFunds(f)
        self.data.funds = f
        self:Save()
    end

    function BGF:AddFunds(f)
        if not self.data.funds then
            self.data.funds = 0
        end

        self.data.funds = self.data.funds + f
        self:Save()
    end

    function BGF:RemoveFunds(f)
        self.data.funds = self.data.funds - f
        self:Save()
    end

    hook.Add("PlayerInitialSpawn", "SyncingBGF", function(ply)
        BGF:Sync(ply)
    end)
else
    netstream.Hook("BankingSyncBGF", function(funds)
        if not BGF.data then
            BGF.data = {}
        end

        BGF.data.funds = funds
    end)
end

function BGF:GetFunds()
    local funds = tonumber(self.data.funds) or 0

    return funds
end

if SERVER then
    function BGF:CalcStats(callback)
        if table.Count(self.cache) > 0 and self.nextCalc and CurTime() <= self.nextCalc then
            callback(self.cache)

            return
        end

        self.nextCalc = CurTime() + 5
        local query = [[
      SELECT _data FROM nut_characters;
    ]]

        --Querying
        nut.db.query(query, function(data)
            local payload = {}
            payload.totalAccounts = 0
            payload.totalPremium = 0

            for _, v in pairs(data) do
                for _, json in pairs(v) do
                    local dataTbl = util.JSONToTable(json)

                    if dataTbl["hasBankAcc"] then
                        payload.totalAccounts = payload.totalAccounts + 1
                    end

                    if dataTbl["bankAccType"] and dataTbl["bankAccType"] == 2 then
                        payload.totalPremium = payload.totalPremium + 1
                    end
                end
            end

            callback(payload)
        end)
    end

    netstream.Hook("BankingCalcStats", function(ply)
        BGF:CalcStats(function(data)
            BGF.cache = data
            netstream.Start(ply, "BankingCalcStats.Return", data)
        end)
    end)
end

function BGF:CalculateStats(callback)
    if CLIENT then
        netstream.Start("BankingCalcStats")

        netstream.Hook("BankingCalcStats.Return", function(data)
            self.nextCalc = CurTime() + 3600 --Next available query in an hour
            self.cache = data
            callback(data)
        end)
    end
end

--Bank General Funds commands (BGF)
nut.command.add("getbgf", {
    adminOnly = true,
    onRun = function(ply, args)
        ply:PrintMessage(HUD_PRINTTALK, BGF:GetFunds() .. nut.currency.symbol)
    end
})

nut.command.add("setbgf", {
    superadminOnly = true,
    syntax = "<number amount>",
    onRun = function(ply, args)
        if args[1] then
            BGF:SetFunds(args[1])
        end
    end
})