local netcalls = {"car_dealer_ss", "car_dealer_wehrkreis", "carvendorretrieveaction", "carvendoropenaction", "CarDealerUsed", "MoneyTake", "car_dealer"}

for k, v in pairs(netcalls) do
    util.AddNetworkString(v)
end
------------------------------------------------------------------------------------------