-- MIT License

-- Copyright (c) 2018-2021 three bow technologies and industries ltd gmbh

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.







-- This is a modified version of Theebow's Better Derma Grid that actually
-- fucking works and lays out properly 
-- if your ever bored, download the original and try to get it to work with
-- elements that layout in PerformLayout like they're meant to, instead of just
-- on creation. Fun little experiment to see how quickly you turn to alcohol and
-- eventually the noose
-- https://github.com/Threebow/better-derma-grid

local PANEL = {}

AccessorFunc(PANEL, "horizontalMargin", "HorizontalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "verticalMargin", "VerticalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "columns", "Columns", FORCE_NUMBER)

function PANEL:Init()
	self:SetHorizontalMargin(0)
	self:SetVerticalMargin(0)

	self.Rows = {}
	self.Cells = {}
end

function PANEL:AddCell(pnl)
	local cols = self:GetColumns()
	local idx = math.floor(#self.Cells/cols)+1
	self.Rows[idx] = self.Rows[idx] || self:CreateRow()

	local margin = self:GetHorizontalMargin()
	
	pnl:SetParent(self.Rows[idx])
    -- _____
	pnl:Dock(LEFT)
	pnl:DockMargin(0, 0, #self.Rows[idx].Items+1 < cols && self:GetHorizontalMargin() || 0, 0)
	pnl:SetWide((self:GetWide() - margin * (cols - 1)) / cols)

	table.insert(self.Rows[idx].Items, pnl)
	table.insert(self.Cells, pnl)
	self:CalculateRowHeight(self.Rows[idx])

    self:InvalidateLayout()
end

function PANEL:CreateRow()
	local row = self:Add("DPanel")
    -- _____
	-- row:Dock(TOP)
	-- row:DockMargin(0, 0, 0, self:GetVerticalMargin())
	row.Paint = nil
	row.Items = {}
	return row
end

function PANEL:CalculateRowHeight(row)
	local height = 0

	for k, v in pairs(row.Items) do
		height = math.max(height, v:GetTall())
	end

	row:SetTall(height)
end

function PANEL:Skip()
	local cell = vgui.Create("DPanel")
	cell.Paint = nil
	self:AddCell(cell)
    self:InvalidateLayout()
end

function PANEL:Clear()
	for _, row in pairs(self.Rows) do
		for _, cell in pairs(row.Items) do
			cell:Remove()
		end
		row:Remove()
	end

	self.Cells, self.Rows = {}, {}
    self:InvalidateLayout()
end

function PANEL:PerformLayout(w, h)
	self:PrePerformLayout(w, h)

    for _,row in pairs(self.Rows) do 
        row:Dock(TOP)
	    row:DockMargin(0, 0, 0, self:GetVerticalMargin())
		
		for _,cell in pairs(row.Items) do
            local cols = self:GetColumns()
	        -- local idx = math.floor(#self.Cells/cols)+1
            local margin = self:GetHorizontalMargin()
			
			cell:Dock(LEFT)
			-- never gona be able to use this for anything else aside from 3 col grids now lmfao
			if(_ % 3 == 1) then 
				cell:DockMargin(
					0,
					0,
					margin,
					0
				)
			elseif(_ % 3 == 2) then 
				cell:DockMargin(
					0,
					0,
					0,
					0
				)
			else 
				cell:DockMargin(
					margin,
					0,
					0,
					0
				)
			end 
            cell:SetWide((self:GetWide() - (margin * (cols - 1))) / cols)
        end
    end 

	self:PostPerformLayout(w, h)
end 
function PANEL:PrePerformLayout(w, h) end 
function PANEL:PostPerformLayout(w, h) end 

PANEL.OnRemove = PANEL.Clear

vgui.Register("yaws.grid", PANEL, "yaws.scroll")