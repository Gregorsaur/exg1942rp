resource.AddFile("materials/documents/cover.png")
resource.AddFile("materials/documents/infos.png")

function PLUGIN:PlayerSpawn(client)
    if not client:getChar() then return end
    local characs = client:getChar():getData("charCharacteristics", {})

    local charCharacteristics = {
        ["Age"] = client:getChar():getData("age", "nil"),
        ["Date of Birth"] = client:getChar():getData("dob", "nil"),
        ["Place of Birth"] = client:getChar():getData("pob", "nil"),
        ["Height"] = client:getChar():getData("height", "nil"),
        ["Hair Color"] = client:getChar():getData("hair_color", "nil"),
        ["Eye Color"] = client:getChar():getData("eye_color", "nil"),
        ["Religion"] = client:getChar():getData("religion", "nil"),
        ["Blood Type"] = client:getChar():getData("blood_type", "nil"),
        ["Occupation"] = client:getChar():getData("occupation", "nil")
    }

    if client:getChar():getData("hair_color", "nil") == "nil" then
        for k, v in SortedPairs(charCharacteristics) do
            if client:Alive() then
                if k == "Occupation" then
                    client:getChar():setData("occupation", characs[k])
                end

                if k == "Age" then
                    client:getChar():setData("age", characs[k])
                end

                if k == "Date of Birth" then
                    client:getChar():setData("dob", characs[k])
                end

                if k == "Place of Birth" then
                    client:getChar():setData("pob", characs[k])
                end

                if k == "Weight" then
                    client:getChar():setData("weight", characs[k])
                end

                if k == "Religion" then
                    client:getChar():setData("religion", characs[k])
                end

                if k == "Eye Color" then
                    client:getChar():setData("eye_color", characs[k])
                end

                if k == "Blood Type" then
                    client:getChar():setData("blood_type", characs[k])
                end

                if k == "Height" then
                    client:getChar():setData("height", characs[k])
                end

                if k == "Hair Color" then
                    client:getChar():setData("hair_color", characs[k])
                end

                local age = client:getChar():getData("age", "nil")
                local eye = client:getChar():getData("eye_color", "nil")
                local height = client:getChar():getData("height", "nil")
                local POB = client:getChar():getData("pob", "nil")
                local hair = client:getChar():getData("hair_color", "nil")
                client:getChar():setDesc("A " .. POB .. " individual stands before you seems to be " .. height .. " feet tall with " .. eye .. " eyes and " .. hair .. " hair. They seem to be around " .. age .. " years old.")
            end
        end
    end
end