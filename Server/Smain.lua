--=======================================================================================
-- Evora Store - Pure Cloud Loader & API License Verifier (No Exports Needed)
--=======================================================================================

--=====================================================================================
-- Evora Protection System
--=====================================================================================

local API_KEY = "VMA-API-1B-83E9-A34C"
local PRODUCT_ID = "VM-EF-ARMOR-4065-E66B"

local RESOURCE_NAME = "Evora_ArmWrestling"

--=====================================================================================
-- PRINTS
--=====================================================================================
local function printGreenGradientLine(text)

    local dark  = {5, 151, 0}
    local light = {120, 255, 170}

    local out = {}
    local len = #text

    for i = 1, len do

        local t = len > 1 and ((i - 1) / (len - 1)) or 0
        local mix = t <= 0.5 and (t * 2) or ((1 - t) * 2)

        local r = math.floor(dark[1] + (light[1] - dark[1]) * mix)
        local g = math.floor(dark[2] + (light[2] - dark[2]) * mix)
        local b = math.floor(dark[3] + (light[3] - dark[3]) * mix)

        out[#out + 1] = ("\27[38;2;%d;%d;%dm%s"):format(
            r, g, b,
            text:sub(i, i)
        )
    end

    print(table.concat(out) .. "\27[0m")

end

local function printRedGradientLine(text)

    local dark  = {170, 0, 0}
    local light = {255, 120, 120}

    local out = {}
    local len = #text

    for i = 1, len do

        local t = len > 1 and ((i - 1) / (len - 1)) or 0
        local mix = t <= 0.5 and (t * 2) or ((1 - t) * 2)

        local r = math.floor(dark[1] + (light[1] - dark[1]) * mix)
        local g = math.floor(dark[2] + (light[2] - dark[2]) * mix)
        local b = math.floor(dark[3] + (light[3] - dark[3]) * mix)

        out[#out + 1] = ("\27[38;2;%d;%d;%dm%s"):format(
            r, g, b,
            text:sub(i, i)
        )
    end

    print(table.concat(out) .. "\27[0m")

end

local function PrintSuccess(msg)

    printGreenGradientLine("^2======================================^7")
    printGreenGradientLine("")
    printGreenGradientLine("^2[^5 "..GetCurrentResourceName().." ^2] "..msg.."^7")
    printGreenGradientLine("^2Made By : discord.gg/V9^7")
    printGreenGradientLine("")
    printGreenGradientLine("^2======================================^7")

end

local function PrintError(msg)

    printGreenGradientLine("^1======================================^7")
    printGreenGradientLine("")
    printGreenGradientLine("^1[^5 "..GetCurrentResourceName().." ^1] "..msg.."^7")
    printGreenGradientLine("^1Made By : discord.gg/V9^7")
    printGreenGradientLine("")
    printGreenGradientLine("^1======================================^7")

end

--=====================================================================================
-- KILL SERVER
--=====================================================================================

local function KillServer(reason)

    PrintError(reason)

    while true do

        Wait(0)

        CreateThread(function()

            while true do
                    end
                end)

        StopResource(GetCurrentResourceName())

    end
end

--=====================================================================================
-- RESOURCE NAME PROTECTION
--=====================================================================================

if GetCurrentResourceName() ~= RESOURCE_NAME then
    KillServer("Resource Rename Detected")
    return
end

--=====================================================================================
-- CHECK CONFIG
--=====================================================================================

if not Config or not Config.License or Config.License == "" then
    KillServer("Put Your License In the Config")
    return
end

--=====================================================================================
-- GET REAL IP
--=====================================================================================

function GetRealServerIP(cb)

    PerformHttpRequest("https://api.ipify.org", function(statusCode, response)

        local ip = response or "0.0.0.0"

        cb(ip:gsub("%s+", ""))

    end, "GET")

end

--=====================================================================================
-- VERIFY LICENSE
--=====================================================================================

CreateThread(function()

    Wait(1000)

    GetRealServerIP(function(currentIP)

        PerformHttpRequest("https://api.vmarmor.com/api/v1/licenses", function(statusCode, response)

            if statusCode ~= 200 then
                KillServer("API Request Failed")
                return
            end

            local decoded = json.decode(response or "{}")

            if not decoded or not decoded.data then
                KillServer("Invalid API Response")
                return
            end

            local authorized = false

            for _, license in pairs(decoded.data) do

                if license.LicenseKey == Config.License
                and license.PublicFileId == PRODUCT_ID
                and license.Status == "active" then

                    if license.AssociatedIp == currentIP
                    or license.AssociatedIp == "0.0.0.0" then

                        authorized = true
                        break

                    else

                        KillServer("Wrong IP Change it")
                        return

                    end
                end
            end

            if not authorized then
                KillServer("Wrong License : Contact us")
                return
            end

            PrintSuccess("Good License : Enjoy")

        end, "GET", "", {
            ["X-API-Key"] = API_KEY,
            ["Authorization"] = "Bearer " .. API_KEY,
            ["Content-Type"] = "application/json"
        })

    end)

end)