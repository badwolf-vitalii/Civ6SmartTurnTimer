-- Read-only diagnostic probe. This mod must never finish turns or modify timers.
local PREFIX = "[Civ6SmartTurnTimer]"

local function log(message)
  print(PREFIX .. " " .. tostring(message))
end

local function describeMethod(target, methodName)
  if target == nil then
    return methodName .. "=unavailable (no object)"
  end

  local ok, method = pcall(function()
    return target[methodName]
  end)

  if not ok then
    return methodName .. "=unavailable (lookup failed)"
  end

  return methodName .. "=" .. type(method)
end

local function snapshot()
  if Game == nil or Game.GetLocalPlayer == nil or Players == nil then
    log("Required local player APIs are unavailable")
    return
  end

  local ok, playerID = pcall(Game.GetLocalPlayer)
  if not ok or type(playerID) ~= "number" or playerID < 0 then
    log("No active local player")
    return
  end

  local player = Players[playerID]
  if player == nil then
    log("Local player object is missing: " .. tostring(playerID))
    return
  end

  log("Local player: " .. tostring(playerID))
  log(describeMethod(player, "GetTechs"))
  log(describeMethod(player, "GetCulture"))
  log(describeMethod(player, "GetReligion"))

  local probes = {
    { getter = "GetTechs", methods = { "GetResearchingTech", "CanResearch", "GetResearchCost" } },
    { getter = "GetCulture", methods = { "GetProgressingCivic", "CanProgress", "GetCivicCost" } },
    { getter = "GetReligion", methods = { "GetReligionTypeCreated", "GetPantheon" } }
  }

  for _, probe in ipairs(probes) do
    local getter = player[probe.getter]
    if type(getter) == "function" then
      local success, instance = pcall(getter, player)
      if success and instance ~= nil then
        for _, methodName in ipairs(probe.methods) do
          log(probe.getter .. "." .. describeMethod(instance, methodName))
        end
      else
        log(probe.getter .. ": could not get object")
      end
    end
  end
end

log("Read-only diagnostics loaded; no timer or end-turn hooks installed")
snapshot()

if Events ~= nil and Events.LocalPlayerTurnBegin ~= nil then
  Events.LocalPlayerTurnBegin.Add(snapshot)
  log("LocalPlayerTurnBegin handler registered")
else
  log("LocalPlayerTurnBegin event unavailable")
end
