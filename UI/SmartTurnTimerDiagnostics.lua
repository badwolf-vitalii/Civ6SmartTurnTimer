-- Read-only diagnostic probe. Never change the game timer or submit turn actions.
local PREFIX = "[Civ6SmartTurnTimer]"
local lastSnapshot = nil

local function log(message)
  print(PREFIX .. " " .. tostring(message))
end

local function invoke(target, name, ...)
  if target == nil then
    return nil, "missing object"
  end

  local okMethod, method = pcall(function() return target[name] end)
  if not okMethod or type(method) ~= "function" then
    return nil, "missing method"
  end

  local ok, value = pcall(method, target, ...)
  if not ok then
    return nil, "method failed: " .. tostring(value)
  end

  return value, nil
end

local function countAvailable(target, methodName, infoCollection, idField)
  -- Enumerating GameInfo tables can differ by build; isolate probing failures.
  if target == nil or infoCollection == nil then
    return "unknown", "missing object or game data"
  end

  local count = 0
  local checked = 0
  local first = nil
  local iteratorOK, iterator = pcall(function() return infoCollection() end)
  if not iteratorOK then
    return "unknown", "cannot enumerate game data: " .. tostring(iterator)
  end
  for row in iterator do
    local id = row[idField]
    if type(id) == "number" then
      local allowed, errorMessage = invoke(target, methodName, id)
      if errorMessage ~= nil or type(allowed) ~= "boolean" then
        return "unknown", errorMessage or "unexpected return type"
      end
      checked = checked + 1
      if allowed then
        count = count + 1
        first = first or tostring(row.Type or id)
      end
    end
  end

  return tostring(count), "checked=" .. tostring(checked) .. ", first=" .. tostring(first)
end

local function describeResearch(target, methodName, collection, idField, availabilityMethod)
  local current, currentError = invoke(target, methodName)
  if currentError ~= nil then
    return "current=unknown (" .. currentError .. ")"
  end

  local count, details = countAvailable(target, availabilityMethod, collection, idField)
  return "current=" .. tostring(current) .. ", available=" .. count .. " (" .. details .. ")"
end

local function snapshot(reason)
  if Game == nil or type(Game.GetLocalPlayer) ~= "function" or Players == nil then
    log("Snapshot unavailable: missing player APIs")
    return
  end

  local ok, playerID = pcall(Game.GetLocalPlayer)
  if not ok or type(playerID) ~= "number" or playerID < 0 then
    log("Snapshot unavailable: no active local player")
    return
  end

  local player = Players[playerID]
  if player == nil then
    log("Snapshot unavailable: local player object missing")
    return
  end

  local techs, techError = invoke(player, "GetTechs")
  local culture, cultureError = invoke(player, "GetCulture")
  local religion, religionError = invoke(player, "GetReligion")

  local techRows = GameInfo and GameInfo.Technologies or nil
  local civicRows = GameInfo and GameInfo.Civics or nil

  local technology = techError and ("unavailable: " .. techError)
    or describeResearch(techs, "GetResearchingTech", techRows, "Index", "CanResearch")
  local civic = cultureError and ("unavailable: " .. cultureError)
    or describeResearch(culture, "GetProgressingCivic", civicRows, "Index", "CanProgress")

  local pantheon, pantheonError = invoke(religion, "GetPantheon")
  local founded, foundedError = invoke(religion, "GetReligionTypeCreated")
  local religionDetails = religionError and ("unavailable: " .. religionError)
    or ("pantheon=" .. tostring(pantheonError or pantheon)
      .. ", foundedReligion=" .. tostring(foundedError or founded))

  local summary = "player=" .. playerID .. " | tech " .. technology
    .. " | civic " .. civic .. " | religion " .. religionDetails
  if summary ~= lastSnapshot then
    log("Snapshot (" .. tostring(reason or "event") .. "): " .. summary)
    lastSnapshot = summary
  else
    log("Snapshot unchanged (" .. tostring(reason or "event") .. ")")
  end

  -- A numeric current research value alone does not prove that the choice is
  -- pending; likewise nil / -1 does not prove a required choice is available.
  -- Religion IDs alone cannot identify a pending belief selection popup.
end

local function registerEvent(name)
  if Events == nil then return end
  local event = Events[name]
  if event == nil or type(event.Add) ~= "function" then
    log("Event unavailable: " .. name)
    return
  end

  local success, errorMessage = pcall(function()
    event.Add(function() snapshot(name) end)
  end)
  if success then
    log("Event registered: " .. name)
  else
    log("Event registration failed: " .. name .. ": " .. tostring(errorMessage))
  end
end

log("Research state probe loaded (read-only); timer untouched")
snapshot("load")
registerEvent("LocalPlayerTurnBegin")
registerEvent("ResearchChanged")
registerEvent("CivicChanged")
