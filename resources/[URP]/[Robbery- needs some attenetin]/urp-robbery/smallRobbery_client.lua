URPCore = nil


Citizen.CreateThread(function ()
  while URPCore == nil do
   TriggerEvent('urp:getSharedObject', function(obj) URPCore = obj end)
   Citizen.Wait(1)
  end
 
  while URPCore.GetPlayerData() == nil do
   Citizen.Wait(10)
  end
 
  PlayerData = URPCore.GetPlayerData()
 end)
 
RegisterNetEvent('urp:playerLoaded')
AddEventHandler('urp:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)


RegisterNetEvent('urp:setJob')
AddEventHandler('urp:setJob', function(job)
	PlayerData.job = job
end)


local shouldBeOpen = false
local shouldSquareOpen = false
local JobCount = {}


RegisterNetEvent('urp-numbers:setjobs')
AddEventHandler('urp-numbers:setjobs', function(jobslist)
  JobCount = jobslist
    if JobCount['cops'] ~= nil then
      CopsOnline = JobCount['cops']
    else
      CopsOnline = 0
    end
    
end)

RegisterNetEvent("robbery:openDoor")
AddEventHandler("robbery:openDoor", function(Doortype)
  if Doortype == "vault" then
    shouldBeOpen = true
    local VaultDoor = GetClosestObjectOfType(255.2283, 223.976, 102.3932, 25.0, `v_ilev_bk_vaultdoor`, 0, 0, 0)
    local CurrentHeading = GetEntityHeading(VaultDoor)
    SetEntityHeading(VaultDoor, 0.0)
    FreezeEntityPosition(VaultDoor,true)
    CurrentHeading = GetEntityHeading(VaultDoor)
  elseif Doortype == "square" then
    shouldSquareOpen = true
    local VaultDoor = GetClosestObjectOfType(147.26,-1045.25,29.37, 25.0,2121050683, 0, 0, 0)
    local CurrentHeading = GetEntityHeading(VaultDoor)
    SetEntityHeading(VaultDoor, 180.0)
    FreezeEntityPosition(VaultDoor,true)
    CurrentHeading = GetEntityHeading(VaultDoor)
  end

end)

RegisterNetEvent("robbery:closeDoor")
AddEventHandler("robbery:closeDoor", function(Doortype)
  if Doortype == "vault" then
    shouldBeOpen = false
    local VaultDoor = GetClosestObjectOfType(255.2283, 223.976, 102.3932, 25.0, `v_ilev_bk_vaultdoor`, 0, 0, 0)
    local CurrentHeading = GetEntityHeading(VaultDoor)
    SetEntityHeading(VaultDoor, 160.0)
    FreezeEntityPosition(VaultDoor,true)
    CurrentHeading = GetEntityHeading(VaultDoor)
  elseif Doortype == "square" then
    shouldSquareOpen = false
    local VaultDoor = GetClosestObjectOfType(147.26,-1045.25,29.37, 25.0,2121050683, 0, 0, 0)
    local CurrentHeading = GetEntityHeading(VaultDoor)
    SetEntityHeading(VaultDoor, 160.0)
    FreezeEntityPosition(VaultDoor,true)
    CurrentHeading = GetEntityHeading(VaultDoor)
  end
end)

local doorsRotated = {}


RegisterNetEvent("robbery:SmallBankDoor")
AddEventHandler("robbery:SmallBankDoor", function(hex)
  --print('SMALL BANK DOOR ',hex)
  local VaultDoor = ""
    local PosPly = GetEntityCoords(PlayerPedId())
      VaultDoor = GetClosestObjectOfType(PosPly["x"],PosPly["y"],PosPly["z"], 15.0,hex, 0, 0, 0)

   --print("VAULT DOOR", VaultDoor)
    if VaultDoor == 0 then
    --   print("pepega door")
      return
    end
    local factor = 50

    FreezeEntityPosition(VaultDoor,false)
    local CurrentHeading = GetEntityHeading(VaultDoor)

    if doorsRotated[VaultDoor] == nil then

      if hex == -131754413 then
        factor = 90
        TriggerEvent("DrawBankMarkers",VaultDoor,true)
      else
        TriggerEvent("DrawBankMarkers",VaultDoor,false)
      end

      doorsRotated[VaultDoor] = true
      for i = 1, factor do
        SetEntityHeading(VaultDoor, CurrentHeading - i)
        Wait(5)
      end

    elseif doorsRotated[VaultDoor] ~= nil then

      if hex == -131754413 and not Drawing then
        TriggerEvent("DrawBankMarkers",VaultDoor,true)
      else
        if hex ~= -131754413 and not DrawingV then
          TriggerEvent("DrawBankMarkers",VaultDoor,false)
        end
      end

    end
    
    FreezeEntityPosition(VaultDoor,true)

end)

local Drawing = false
local DrawingV = false

local banks = {
  ["Bank1"] = { ["x"]=152.04, ["y"]=-1040.77, ["z"]= 29.37, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  ["Bank2"] = { ["x"]=-1212.980, ["y"]=-330.841, ["z"]= 37.787, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  ["Bank3"] = { ["x"]=-2962.582, ["y"]=482.627, ["z"]= 15.703, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  ["Bank4"] = { ["x"]=314.187, ["y"]=-278.621, ["z"]= 54.170, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  ["Bank5"] = { ["x"]=-351.534, ["y"]=-49.529, ["z"]= 49.042, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  ["Bank6"] = { ["x"]=1176.04, ["y"]=2706.339, ["z"]= 37.15, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
}


local nearbank = 0



local RobberyTimers = {}

RegisterNetEvent("robbery:timers")
AddEventHandler("robbery:timers", function(timers)
  RobberyTimers = timers
  local CardIds = ""
  for i = 1, 5 do
    if i ~= 1 then
      CardIds = CardIds .. " | Time Slot " .. i .. " uses Card ID: #" .. RobberyTimers[i]
   else
      CardIds = "Time Slot " .. i .. " uses Card ID: #" .. RobberyTimers[i] 
    end
  end
	TriggerEvent('phone:addnotification', 'EMAIL', "The bank time slots are set to these hours, 8-10, 10-12, 12-14, 14-16, 16-18. || " .. CardIds)
end)
curhrs = "0"

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(hrs,mins)
  curhrs = tonumber(hrs)
  Citizen.Wait(5000)
end)


RegisterCommand('securebank', function()
  if URPCore.PlayerData.job.name == 'police' then
    TriggerEvent('robbery:secure', true)
  else
    TriggerEvent("notification", "This is a police restricted command")
  end
end)


function PassCard(cardType)
  local answer = false
  if RobberyTimers[1] ~= nil then
    local timeframe = 0
    if curhrs >= 8 and curhrs < 10 then
      timeframe = 1
    end

    if curhrs >= 10 and curhrs < 12 then
      timeframe = 2
    end

    if curhrs >= 12 and curhrs < 14 then
      timeframe = 3
    end

    if curhrs >= 14 and curhrs < 16 then
      timeframe = 4
    end

    if curhrs >= 16 and curhrs < 18 then
      timeframe = 5
    end
    
    if cardType == "securityblue" and RobberyTimers[timeframe] == 1 then
      answer = true
    end

    if cardType == "securityblack" and RobberyTimers[timeframe] == 2 then
      answer = true
    end

    if cardType == "securitygreen" and RobberyTimers[timeframe] == 3 then
      answer = true
    end

    if cardType == "securitygold" and RobberyTimers[timeframe] == 4 then
      answer = true
    end

    if cardType == "securityred" and RobberyTimers[timeframe] == 5 then
      answer = true
    end

  end
  return answer
end
local lockpicking = false
RegisterNetEvent('animation:fuckyou')
AddEventHandler('animation:fuckyou', function()
    local lPed = PlayerPedId()
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    while lockpicking do

        if not IsEntityPlayingAnim(lPed, "mini@repair", "fixing_a_player", 3) then
            ClearPedSecondaryTask(lPed)
            TaskPlayAnim(lPed, "mini@repair", "fixing_a_player", 8.0, -8, -1, 16, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
    end
    ClearPedTasks(lPed)
end)


local bankenabled = true
RegisterNetEvent("restart:soon")
AddEventHandler("restart:soon", function()
  bankenabled = false
end)  

RegisterNetEvent("robbery:scanLock")
AddEventHandler("robbery:scanLock", function(lockpick,cardType)
    if nearbank == 0 then
      return
    end

    if not bankenabled then
      TriggerEvent("notification","Too late to rob this bank, Pepega.")
      return
    end

    if banks["Bank"..nearbank] == nil then return end
    if not banks["Bank"..nearbank]["started"] then
      TriggerEvent("notification","This is not ready to rob, Pepega.")
      return
    end

    local PosPly = GetEntityCoords(PlayerPedId())
    if lockpick then
      lockpicking = false
      return
      
    else
      -- if CopsOnline >= 2 then
      if CopsOnline >= 0 then
        local passCard = PassCard(cardType)
        local plyPos = GetEntityCoords(PlayerPedId())
        TriggerEvent("animation:PlayAnimation","id")
        local VaultDoor = GetClosestObjectOfType(PosPly["x"],PosPly["y"],PosPly["z"], 3.0,2121050683, 0, 0, 0)
        if VaultDoor ~= 0 then

          local finished = exports["urp-taskbar"]:taskBar(25000,"Requesting Access")
          if finished ~= 100 or not passCard then 
              TriggerEvent("notification","Incorrect card or you cancelled..", 2)
              return
          end
          TriggerEvent('inventory:removeItem',cardType, 1)

          TriggerServerEvent("rob:doorOpen",nearbank,"robbingvault")
          TriggerEvent("alert:noPedCheck", "BankRobbery")
    
        end

          local VaultDoor = GetClosestObjectOfType(PosPly["x"],PosPly["y"],PosPly["z"], 3.0,-63539571, 0, 0, 0)
          if VaultDoor ~= 0 then

          local finished = exports["urp-taskbar"]:taskBar(25000,"Requesting Access")
          if finished ~= 100 or not passCard then
              TriggerEvent("notification","Incorrect card or you cancelled..",2)
              return
          end
          TriggerEvent('inventory:removeItem',cardType, 1)
          if #(PosPly - GetEntityCoords(PlayerPedId())) > 3.0 then
            TriggerEvent("notification","Moved too far..",2)
            return
          end
          TriggerServerEvent("rob:doorOpen",nearbank,"robbingvault")
          TriggerEvent("client:newStress",true,550)
        end
      end
    end
end)

Citizen.CreateThread(function()
  Citizen.Wait(1)
  while true do
  local x, y, z = 1275.5922851563,-1710.2532958984,54.771492004395
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  local texttodraw = "[~r~E~s~] - Decrypt"
  local distance = GetDistanceBetweenCoords(pos.x,pos.y,pos.z,x, y, z,false)
    if distance <= 1.5 then
      DrawText3D(x, y, z, texttodraw)
    if IsControlJustReleased(0, 86) then
      FreezeEntityPosition(PlayerPedId(),true)
      if exports["urp-inventory"]:hasEnoughOfItem("pix2",1,false) then			
        TriggerEvent("Animation:typeforrob")
        local finished = exports["urp-taskbar"]:taskBar(15000,"Decrypting Data")
        if finished == 100 then					
          FreezeEntityPosition(PlayerPedId(),false)						
          TriggerServerEvent('request:BankUpdate')
          TriggerEvent("inventory:removeItem", "pix2", 1)
          TriggerEvent("notification", "You have received a email!")
        end
      else
        FreezeEntityPosition(PlayerPedId(),false)	
        TriggerEvent("notification", "You need a Red Key")
      end

          end
    
      end
      Citizen.Wait(5)
  end
end)



RegisterNetEvent("updateBanksNow")
AddEventHandler("updateBanksNow", function(newBanks)
    if newBanks then
      banks = newBanks

    end
end)

RegisterNetEvent("robbery:scanbank")
AddEventHandler("robbery:scanbank", function(bankID,newBanks)
    if newBanks then
      banks = newBanks

    end

    nearbank = bankID
    local bank = "Bank"..bankID
    if banks[bank] == nil then
      return
    end

    if #(GetEntityCoords(PlayerPedId()) - vector3(banks[bank]["x"],banks[bank]["y"],banks[bank]["z"])) < 10.0 then
      if banks[bank]["robbing"] then
        OpenNearestBank(false)
      end
      if banks[bank]["robbingvault"] then
        OpenNearestBank(true)
      end
    end

end)

function OpenNearestBank(vault)
    if vault then
     TriggerEvent("robbery:SmallBankDoor",2121050683)

    else
      TriggerEvent("robbery:SmallBankDoor",-131754413)
    end
end


RegisterNetEvent("robbery:disablescans")
AddEventHandler("robbery:disablescans", function()
  nearbank = 0
  Drawing = false
  DrawingV = false
end)

RegisterNetEvent("robbery:disablescansServer")
AddEventHandler("robbery:disablescansServer", function(resetID)
  if resetID == nearbank then

    Drawing = false
    DrawingV = false
  end

end)



RegisterNetEvent("robbery:secure")
AddEventHandler("robbery:secure", function()
  if nearbank == 0 then
    return
  end

  local finished = exports["urp-taskbar"]:taskBar(25000,"Securing Bank")
  if finished == 100 then
    TriggerServerEvent("robbery:shutdown",nearbank)
  end
  
end)

RegisterNetEvent("robbery:giveleitem")
AddEventHandler("robbery:giveleitem", function(confirmed,slotid)

  
    if confirmed then
      if slotid < 5 then
        TriggerServerEvent( 'mission:completed', math.random(1500))
        if math.random(100) == 100 then
          local myluck = math.random(5)
          if myluck == 1 then
            TriggerEvent("player:receiveItem","securityblue", 1)
          elseif myluck == 2 then
            TriggerEvent("player:receiveItem","securityblack", 1)
          elseif myluck == 3 then
            TriggerEvent("player:receiveItem","securitygreen", 1)
          elseif myluck == 4 then
            TriggerEvent("player:receiveItem","securityred", 1)
          end
        end
      else

        GiveRareItem()
      end
   
    else

    end
end)


gunListRob = {
  [1] = 453432689,
  [2] = 453432689,
  [3] = 584646201,
  [4] = 453432689,  
  [5] = 453432689,
  [6] = -2009644972,
  [7] = 453432689,
  [8] = 584646201,
  [9] = 584646201,
  [10] = -2009644972,
}

function GiveRareItem()
  
  if math.random(100) > 90 then

    TriggerEvent("player:receiveItem","Gruppe6Card3", 1)

  end

  if math.random(100) > 65 then

    local roll = math.random(7)
    if roll == 1 then
      TriggerEvent("player:receiveItem","pix1",math.random(1,5))
    elseif roll == 2 then
      TriggerEvent("player:receiveItem","rolexwatch",math.random(5,20))
    elseif roll == 3 then
      TriggerEvent("player:receiveItem","goldbar",math.random(5,15))
    elseif roll == 4 then
      TriggerEvent("player:receiveItem","goldbar",math.random(5,15))
    else
      TriggerServerEvent( 'mission:completed', math.random(2500,4500))
    end

  else
    TriggerServerEvent( 'mission:completed', math.random(750,2500))
  end

end

RegisterNetEvent("DrawBankMarkers")
AddEventHandler("DrawBankMarkers", function(Door,Wood)
  local crd = GetEntityCoords(Door)

  local x1,y1,z1 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, -1.0, 1 + 0.0, 0.0))
  local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, -1.0, 2.5 + 0.0, 0.0))
  local x3,y3,z3 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, -1.0, 4.0 + 0.0, 0.0))
  local x4,y4,z4 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, -1.0, 5.5 + 0.0, 0.0))     


  local x5,y5,z5 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 0.19, 1.2 + 0.0, 0.0))
  local x6,y6,z6 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 0.19, 2.55 + 0.0, 0.0))
  local x7,y7,z7 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 1.1, 3.5 + 0.0, 0.0))
  local x8,y8,z8 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 3.6, 4.1 + 0.0, 0.0))
  local x9,y9,z9 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 4.9, 4.1 + 0.0, 0.0))
  local x10,y10,z10 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 3.6, 0.5 + 0.0, 0.0))
  local x11,y11,z11 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 4.9, 0.5 + 0.0, 0.0))
  local x12,y12,z12 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 5.8, 1.2 + 0.0, 0.0))
  local x13,y13,z13 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 5.8, 2.4 + 0.0, 0.0))
  local x14,y14,z14 = table.unpack(GetOffsetFromEntityInWorldCoords(Door, 5.8, 3.6 + 0.0, 0.0))


  if Wood and not Drawing then
    Drawing = true
   
    while Drawing do 
      Wait(1)
        DrawTextAndScan(x1,y1,z1, 1)
        DrawTextAndScan(x2,y2,z2, 2)
        DrawTextAndScan(x3,y3,z3, 3)
        DrawTextAndScan(x4,y4,z4, 4)    
    end

  elseif not DrawingV and not Wood then
    DrawingV = true
    while DrawingV do 
      Wait(1)
        DrawTextAndScan(x5,y5,z5, 5)
        DrawTextAndScan(x6,y6,z6, 6)
        DrawTextAndScan(x7,y7,z7, 7)
        DrawTextAndScan(x8,y8,z8, 8)
        DrawTextAndScan(x9,y9,z9, 9)
        DrawTextAndScan(x10,y10,z10, 10)
        DrawTextAndScan(x11,y11,z11, 11)
        DrawTextAndScan(x12,y12,z12, 12)
        DrawTextAndScan(x13,y13,z13, 13)
        DrawTextAndScan(x14,y14,z14, 14)    
    end

  end
  
end)



function DrawTextAndScan(x,y,z, inputType)

    local dst = #(vector3(x,y,z) - GetEntityCoords(PlayerPedId()))
    if dst > 3.0 then
      return
    end
    local text = "Search"
    local bank = "Bank"..nearbank

    local robbed = false

    if banks[bank]["rob"] then
      if banks[bank]["rob"][inputType] then
        text = "Empty"
        robbed = true
      end
    end

    if robbed then
      return
    end

    if dst < 1.0 then
      if IsControlJustPressed(0,38) then
        lockpicking = true
        TriggerEvent("animation:fuckyou")
        local timer = 5000
        if inputType < 5 then
          timer = 5000 
        end
        local finished = exports["urp-taskbar"]:taskBar(timer,"Opening")
        if finished == 100 then
          TriggerServerEvent("robbery:checkSearch",nearbank, inputType)
        end
        lockpicking = false
        Wait(1000)
      end
    end
    
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)  
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


