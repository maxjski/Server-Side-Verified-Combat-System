--[[
========================================================================
= Title : Water Example
= Description: Make Things float within a Volume depending on their material
= NOTE: only works with blocks!!!
= Scripter : TGazza
========================================================================
]]

local Self = script.Parent
local FloatMats = {"Plastic","Wood","Grass","Ice","WoodPlanks"}

local WorkSpaceObjects = {}
local WSONum = 1
local tick = 0
local resetTick = 40

-- the following data is to update the ObjectTable
local ValidClassNames = {"Part","WedgePart","TrussPart","Model","Seat","VehicleSeat"}
function isValidClass(part)
	local CN = part.className 
	for i=1,#ValidClassNames do
		if(CN == ValidClassNames[i]) then
			return true
		end
	end
	return false
end
function isValidPart(part)	-- returns className if its a part or model otherwise returns nil
	if isValidClass(part) == true then
		return part
	end
   return nil -- not a part or an model
end

function retriveParts(model) -- main function for retriving all the parts of a model and loading them into a table
	if(isValidPart(model) and model.className ~= "Model") then
			WorkSpaceObjects[WSONum] = model;
			WSONum = WSONum + 1;
	else
		local raw_model = model:GetChildren()
		for i=1,#raw_model do
			local part = isValidPart(raw_model[i])
			if(part ~= nil) then
				if(part.className == "Model") then
					retriveParts(part);
				else
					if(part.Anchored == false) then
						--if(part:findFirstChild("TAG") == nil) then
						--	Tag = Instance.new("ObjectValue")
						--	Tag.Parent = part
						--	Tag.Name = "TAG"
							WorkSpaceObjects[WSONum] = part;
							WSONum = WSONum + 1;
						--end
					end
				end
			end
		end
	end
end
function RemoveBits(model) -- Function for removing bits from our global table as they dont exist in the workspace anymore
	if(isValidPart(model) and model.className ~= "Model") then
		for i=1,#WorkSpaceObjects	do
			if(model == WorkSpaceObjects[i]) then
				table.remove(WorkSpaceObjects,i)
				WSONum = WSONum -1
			end
		end
	else
		local raw_model = model:GetChildren()
		for i=1,#raw_model do
			local part = raw_model[i]
			if(part.className == "Model") then
				RemoveBits(part);
			else
				for i=1,#WorkSpaceObjects	do
					if(part == WorkSpaceObjects[i]) then
						table.remove(WorkSpaceObjects,i)
						WSONum = WSONum -1
					end
				end
			end
		end
	end
end

retriveParts(game.Workspace); -- call our retreiver
game.Workspace.ChildAdded:connect(retriveParts)-- just encase any new objects get added to the game
game.Workspace.ChildRemoved:connect(RemoveBits)
-- end of object table data
function GetBaseSize()
	local Size = Vector3.new(0,0,0)
	local mySize = Self.Size
	local Mesh = Self:findFirstChild("Mesh")
	if(Mesh ~= nil) then
		Size = Vector3.new((mySize.X*Mesh.Scale.X),
								 (mySize.Y*Mesh.Scale.Y),
								 (mySize.Z*Mesh.Scale.Z))
	else
		Size = mySize
	end
	return Size
end

function GetBasePosition()
	local Pos = Vector3.new(0,0,0)
	local myPos = Self.Position
	local Mesh = Self:findFirstChild("Mesh")
	if(Mesh ~= nil) then
		Pos = Vector3.new((myPos.X+Mesh.Offset.X),
								(myPos.Y+Mesh.Offset.Y),
								(myPos.Z+Mesh.Offset.Z))
	else
		Pos = myPos
	end
	return Pos
end
local AreaOfEffect = GetBaseSize()
local MyBasePos = GetBasePosition()
function CheckMats(part)
	local isBoyant = false
	for i=1,#FloatMats do
		if(part.Material == Enum.Material[FloatMats[i]]) then
			isBoyant = true
		end
	end
	return isBoyant
end
function isinArea(part) --main function to check if parts are within an area
	isIT = false
	if(part~= nil) then
		local Area = AreaOfEffect
		local PartSize = part.Size
		local MyPos = MyBasePos
		local PartPos = part.Position
		if((PartPos.Y+(PartSize.Y/2) > MyPos.Y-(Area.Y/2))
		and(PartPos.Y-(PartSize.Y/2) < MyPos.Y+(Area.Y/2))) then
			if((PartPos.X+(PartSize.X/2) > MyPos.X-(Area.X/2))
			and(PartPos.X-(PartSize.X/2) < MyPos.X+(Area.X/2))) then 
				if((PartPos.Z+(PartSize.Z/2) > MyPos.Z-(Area.Z/2))
				and(PartPos.Z-(PartSize.Z/2) < MyPos.Z+(Area.Z/2))) then -- should be in the volume
					isIT = true
				end
			end
		end
	end
	return isIT
end
while true do
	for i =1,#WorkSpaceObjects do
		if(WorkSpaceObjects[i] ~= nil)then
			if(WorkSpaceObjects[i].Parent ~= nil) then
				if(CheckMats(WorkSpaceObjects[i]) == true) then
					if(WorkSpaceObjects[i]:findFirstChild("BoyancyTimes")~= nil) then
						Mass = WorkSpaceObjects[i]:GetMass()*(230*WorkSpaceObjects[i].BoyancyTimes.Value)
					else
						Mass = WorkSpaceObjects[i]:GetMass()*230
					end
				else
					Mass = WorkSpaceObjects[i]:GetMass()*150
				end
				inArea = isinArea(WorkSpaceObjects[i])
				BoyantPos_Y = MyBasePos.Y + ((AreaOfEffect.Y/2))
				if(inArea == true) then
					if(WorkSpaceObjects[i]:findFirstChild("WaterForce") == nil) then
						BP = Instance.new("BodyPosition")
						BP.Parent = WorkSpaceObjects[i]
						BP.Name = "WaterForce"
						if(WorkSpaceObjects[i].Parent:findFirstChild("Humanoid") ~= nil) then
							BP.D = 1.25e+004
							BP.P = 1e+005
							BP.position=Vector3.new(0,BoyantPos_Y+25,0)
							BP.maxForce = Vector3.new(0,Mass*1.5,0)
						else
							BP.D = 1.25e+003
							BP.P = 1e+004
							BP.position=Vector3.new(0,BoyantPos_Y,0)
							BP.maxForce = Vector3.new(0,Mass,0)
						end
					end
					if(WorkSpaceObjects[i]:findFirstChild("WaterForce") ~= nil) then
						if(WorkSpaceObjects[i].Parent:findFirstChild("Humanoid") ~= nil) then
							BP = WorkSpaceObjects[i].WaterForce
							if(WorkSpaceObjects[i].Parent.Humanoid.Jump == true) then
								BP.position=Vector3.new(0,BoyantPos_Y+50,0)
								BP.maxForce = Vector3.new(0,Mass*4,0)
								tick = tick +1
								if(tick >= resetTick) then
									tick = 0
									WorkSpaceObjects[i].Parent.Humanoid.Jump = false 
								end
							else
								BP.position=Vector3.new(0,BoyantPos_Y+1,0)
								BP.maxForce = Vector3.new(0,Mass*2,0)
							end
						end
					end
				else
					if(WorkSpaceObjects[i] ~= nil)then
						if(WorkSpaceObjects[i]:findFirstChild("WaterForce") ~= nil) then
							WorkSpaceObjects[i].WaterForce:remove()
						end
					end
				end
			end
		end
	end
	--print(#WorkSpaceObjects)
	wait()
end
