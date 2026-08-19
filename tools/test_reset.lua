package.path = "/g/?.lua;/g/?/?.lua;" .. package.path

UP, DOWN, LEFT, RIGHT = 0, 2, 3, 1
BTN_Z, BTN_E, BTN_Q, BTN_F, BTN_G = 4, 15, 14, 12, 13

local keys = {}
local ui = {}
function ui.btn(id, pad) return keys[id] == true end
_G.ui = ui

local input = require "input"

-- bug: confirm MAIN MENU with a held button must NOT re-fire inside the new scene
keys[BTN_Z] = true
assert(input.p1Confirm() == true, "first press should fire")
input.reset() -- transition menu -> play / play -> menu
assert(input.p1Confirm() == false, "held button must NOT re-fire after reset (bug MAIN MENU)")
keys[BTN_Z] = false
assert(input.p1Confirm() == false, "released -> false")
keys[BTN_Z] = true
assert(input.p1Confirm() == true, "new press fires again")
print("RESET-KEEPS-PREV OK")

-- claims are cleared by reset (pads can be reassigned), but pad priority still works
input.reset()
keys[UP] = true -- keyboard (pad 0)
assert(input.p1Up() == true, "P1 up via keyboard fallback")
input.reset()
print("CLAIMS-CLEAR OK")