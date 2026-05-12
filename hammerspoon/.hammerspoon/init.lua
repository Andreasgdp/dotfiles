-- Akiflow notification handling: never let those popups steal focus or
-- pull us to another AeroSpace workspace.

local AKIFLOW_BUNDLE = "com.akiflow.akiflow"
local NOTIF_TITLES = {
  ["Akiflow - Notifications"] = true,
  ["Akiflow - Cli"]           = true,
  ["Akiflow - Tray"]          = true,
}
local AEROSPACE = "/opt/homebrew/bin/aerospace"

local lastUserWorkspace = nil
local lastUserWindow    = nil

local function sh(cmd)
  local h = io.popen(cmd)
  if not h then return nil end
  local out = h:read("*a") or ""
  h:close()
  return (out:gsub("%s+$", ""))
end

local function currentWorkspace()
  return sh(AEROSPACE .. " list-workspaces --focused")
end

local function isAkiflowNotif(win)
  if not win then return false end
  local app = win:application()
  if not app or app:bundleID() ~= AKIFLOW_BUNDLE then return false end
  return NOTIF_TITLES[win:title() or ""] == true
end

-- Remember where the user actually was whenever a non-Akiflow window gains focus.
local userFilter = hs.window.filter.new(nil)
userFilter:subscribe(hs.window.filter.windowFocused, function(win)
  if isAkiflowNotif(win) then return end
  local app = win:application()
  if app and app:bundleID() == AKIFLOW_BUNDLE then return end
  lastUserWorkspace = currentWorkspace()
  lastUserWindow    = win:id()
end)

-- React to Akiflow notification windows appearing or being raised.
local akiflowFilter = hs.window.filter.new("Akiflow")
local function handle(win)
  if not isAkiflowNotif(win) then return end
  local wid = win:id()
  local ws  = lastUserWorkspace or currentWorkspace()
  if not wid or not ws then return end
  -- Small delay lets macOS finish raising before we move things around.
  hs.timer.doAfter(0.05, function()
    hs.execute(string.format(
      "%s move-node-to-workspace --window-id %d %s",
      AEROSPACE, wid, ws))
    hs.execute(string.format("%s workspace %s", AEROSPACE, ws))
    if lastUserWindow then
      local prev = hs.window.get(lastUserWindow)
      if prev then prev:focus() end
    end
  end)
end
akiflowFilter:subscribe({
  hs.window.filter.windowCreated,
  hs.window.filter.windowFocused,
  hs.window.filter.windowVisible,
  hs.window.filter.windowUnminimized,
}, handle)

-- Seed state at load time.
lastUserWorkspace = currentWorkspace()
local fw = hs.window.focusedWindow()
if fw and not isAkiflowNotif(fw) then lastUserWindow = fw:id() end
