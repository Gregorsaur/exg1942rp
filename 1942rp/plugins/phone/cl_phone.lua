net.Receive("Public_Phone_Menu", function()

local frame = vgui.Create("DFrame")
frame:SetSize(300,275)
frame:Center()
frame:SetTitle("Public Telephone")
frame:MakePopup()

local target = vgui.Create("DTextEntry", frame)
target:SetTall(25)
target:Dock(TOP)
target:SetText("Name")

local message = vgui.Create("DTextEntry", frame)
message:SetTall(150)
message:Dock(TOP)
message:SetMultiline(true)
message:SetText("Message")

local submit = vgui.Create("DButton", frame)
submit:SetTall(55)
submit:Dock(BOTTOM)
submit:SetText("Send ($2)")
submit.DoClick = function()
LocalPlayer():ConCommand("say /publicphone " .. target:GetValue() .. " " .. message:GetValue())
end



end)

net.Receive("Private_Phone_Menu", function()

local frame = vgui.Create("DFrame")
frame:SetSize(300,275)
frame:Center()
frame:SetTitle("Telephone")
frame:MakePopup()

local target = vgui.Create("DTextEntry", frame)
target:SetTall(25)
target:Dock(TOP)
target:SetText("Name")

local message = vgui.Create("DTextEntry", frame)
message:SetTall(150)
message:Dock(TOP)
message:SetMultiline(true)
message:SetText("Message")

local submit = vgui.Create("DButton", frame)
submit:SetTall(55)
submit:Dock(BOTTOM)
submit:SetText("Send")
submit.DoClick = function()
LocalPlayer():ConCommand("say /pm " .. target:GetValue() .. " " .. message:GetValue())
end



end)