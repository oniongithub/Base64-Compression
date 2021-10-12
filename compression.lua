local function compress(str)
    local newString = ""
    local currentChar = ""
    local currentAmount = 1

    for i = 1, #str do
        local curChar = str:sub(i, i)

        if (curChar ~= currentChar) then
            if (currentAmount <= 4) then
                newString = newString .. currentChar
            else
                newString = newString .. currentChar .. "^" .. currentAmount .. " "
            end
               
            currentChar = curChar
            currentAmount = 1
        else
            if (currentAmount == 1) then
                local stillTrue = true
                for f = 0, 3 do
                    if (#str >= i + f) then
                        local newChar = str:sub(i + f, i + f)
                        if (newChar ~= currentChar) then stillTrue = false end
                    else
                        stillTrue = false
                    end
                end

                if (stillTrue) then currentAmount = currentAmount + 1 else
                    newString = newString .. currentChar
                end
            else
                currentAmount = currentAmount + 1
            end
        end
    end

    if (currentAmount <= 4) then
        newString = newString .. currentChar
    else
        newString = newString .. currentChar .. "^" .. currentAmount .. " "
    end

    return newString
end

local function decompress(str)
    local newString = ""
    local currentChar = ""
    local skipNext = 0

    for i = 1, #str do
        if (skipNext == 0) then
            local curChar = str:sub(i, i)
            local nextChar = str:sub(i + 1, i + 1)

            if (curChar == "^") then
                local charNumber = ""

                for f = 1, 1000 do
                        local curChar = str:sub(i + f,i + f)

                        if (curChar ~= " ") then
                            charNumber = charNumber .. curChar
                        else
                            goto breakLoop
                        end
                end

                ::breakLoop::

                skipNext = #charNumber + 1
                for f = 1, tonumber(charNumber) do
                    newString = newString .. currentChar
                end
            else
                if (nextChar ~= "^") then
                    newString = newString .. curChar
                end

                currentChar = curChar
            end
        else
            skipNext = skipNext - 1
        end
    end

    return newString
end
