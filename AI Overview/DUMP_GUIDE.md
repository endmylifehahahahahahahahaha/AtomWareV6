# BedWars — What to Dump for Better Development

This guide lists the exact scripts/modules to dump from the BedWars game
(`placeId: 6872274481`) that will unlock the most accurate and powerful module
development. Dumping means grabbing the bytecode via `getscriptbytecode` and
decompiling with a tool like unluac, lua-decompiler, or the built-in `vm.lua`.

---

## Priority 1 — Must-Have (Core remotes + combat logic)

### `ReplicatedStorage.TS.shared-sync-events`
> **Why:** Contains `SharedSyncEvents` — the definitive list of every ClientSyncEvent
> (projectile fire, sword hit, kit abilities, etc.). Without this you're guessing remote names.
>
> **What you get:** Correct `StartLaunchProjectile`, `ProjectileTargetingEnded`,
> `ProjectileMaxCharged`, `ItemCooldownModifierCheck` event names and their payload schemas.

---

### `ReplicatedStorage.TS.item.item-meta`
> **Why:** The `getItemMeta` function returns every item's `projectileSource`,
> `fireDelaySec`, `cooldownId`, `sword.chargedAttack`, `launchSound`, etc.
>
> **What you get:** Accurate fire delays per weapon, projectile type strings,
> ammo item types, walk speed multipliers while charging.

---

### `ReplicatedStorage.TS.projectile.projectile-meta`
> **Why:** `ProjectileMeta` maps every projectile type to its `launchVelocity`,
> `gravitationalAcceleration`, bullet size, and lifetime.
>
> **What you get:** The exact speed and gravity values for `prediction.SolveTrajectory`,
> instead of hard-coding 196.2.

---

### `ReplicatedStorage.rbxts_include.node_modules.@rbxts.net.out._NetManaged`
> **Why:** This is the remote container for all networked events. The names inside
> (e.g. `OwlAiming`, `OwlFireProjectile`, `SwordHit`) change with every game update.
>
> **What you get:** Up-to-date remote instance names. If OwlAura stops firing, it
> means a remote was renamed here.

---

### `lplr.PlayerScripts.*.SwordController` (or `bedwars.SwordController`)
> **Why:** Controls sword cooldowns (`lastSwing`, `lastAttack`), the `playSwordEffect`
> function, and the attack remote path. SilentAura hooks into this.
>
> **What you get:** Correct hook targets so SyncHits works, and the actual cooldown
> variable names so you don't overshoot the attack rate.

---

## Priority 2 — High Value (Kit-specific & projectile targeting)

### `ReplicatedStorage.TS.games.bedwars.kit.kits.*`  (all kit folders)
> **Why:** Each kit folder has a `*-controller.lua` that manages the kit ability.
> Dumping these reveals the ability remote names, cooldowns, state checks,
> and any special data sent with each ability.
>
> **Highest value kits to dump first:**
> - `glacial-skater` — Krystal kit (Autowin relies on `updateMomentum`)
> - `frosty-gun` — FrostyGun spray controller (remote + fire logic)
> - `owl-keeper` — Owl weapon controller (fixes `OwlAiming` / `OwlFireProjectile` args)
> - `ninja` — Chakram projectile source
> - `mage` — Spellbook fire logic

---

### `ReplicatedStorage.TS.projectile.projectile-controller`
> **Why:** `ProjectileController.enableTargeting` / `launchProjectile` are the
> client-side entry points for all projectile weapons. Dumping this shows the
> exact `projectileHandler` structure and how `aimPoint` / `velocityMultiplier` are set.
>
> **What you get:** Fixes for SilentAim (projectile visual spoof), and the correct
> field names to override when writing prediction-based modules.

---

### `ReplicatedStorage.TS.entity.entity-util`
> **Why:** `EntityUtil:getEntity`, `getLocalPlayerEntity`, and the entity state
> checks used server-side. Lets you mirror the server's own entity validity checks
> in your modules to avoid false hits.

---

### `ReplicatedStorage.Hotbar.HotbarItemSystem`
> **Why:** Maps hand slot → item instance. Critical for `store.hand` / `store.tools`
> lookups. If switchItem ever breaks, this is why.

---

## Priority 3 — Useful for Specific Modules

### `ReplicatedStorage.TS.status-effect.status-effect-util`
> **Why:** Shows how the game detects frozen, stunned, slowed states.
> Improves `isFrozen()` in SilentAura and `NoDebuff` module accuracy.

### `ReplicatedStorage.TS.grappling-hook.grappling-hook-util`
> **Why:** Exposes `GrapplingHookFunctions.HOOK_CHAMBERED` — needed for any
> grappling-hook-aware projectile module to check if the hook is ready.

### `ReplicatedStorage.TS.animation.animation-util`
> **Why:** `GameAnimationUtil:playAnimation` is used for idle animations on bows/staves.
> Dumping it helps sync animation spoofing with actual game animation IDs.

### `ReplicatedStorage.Game.Robbery.RobberyPassengerTrain` *(Jailbreak)*
> **Why:** Used in the `606849621.lua` cargo controller. Only relevant if you're
> developing Jailbreak-specific modules.

---

## How to Dump a Script

### Method 1 — decompile via getscriptbytecode
```lua
local vm = loadstring(readfile('newvape/libraries/vm.lua'))()
local target = require(game.ReplicatedStorage.TS["item"]["item-meta"])
-- OR for a LocalScript:
local script = lplr.PlayerScripts:FindFirstChild("YourTarget", true)
local bytecode = getscriptbytecode(script)
local ok, data = pcall(vm.luau_deserialize, bytecode)
-- data.protoList contains all functions with constants/upvalues
```

### Method 2 — Use require() directly and print upvalues
```lua
local mod = require(game.ReplicatedStorage.TS["projectile"]["projectile-meta"])
for k, v in pairs(mod.ProjectileMeta) do
    print(k, v.launchVelocity, v.gravitationalAcceleration)
end
```

### Method 3 — Hook FireServer to log remotes at runtime
```lua
local old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        print("[REMOTE]", self:GetFullName(), ...)
    end
    return old(self, ...)
end)
```
> Best approach for discovering new remote names after a game update.

---

## Quick Reference — Remote Names That Commonly Change

| Purpose | Current Name | Located In |
|---------|-------------|-----------|
| Shoot projectile | `FireProjectile` | `_NetManaged` or `remotes.FireProjectile` |
| Sword hit | `SwordHit` | `bedwars.Client:Get('SwordHit')` |
| Owl aim/fire | `OwlAiming`, `OwlFireProjectile` | `_NetManaged` |
| Buy item | `BuyItem` | Game shop remote |
| Place block | `PlaceBlock` | Block placement remote |
| Kit ability | varies per kit | Kit controller |

> **Tip:** Run the `fireHook` logger in `games/606849621.lua` as a template —
> it already demonstrates how to intercept and log every `FireServer` call with
> the remote's resolved name.

---

## Files Already Dumped in This Repo

| File | Source |
|------|--------|
| `Game Files/Projectile/Projectile-Source-Controller.lua` | Decompiled |
| `Game Files/Projectile/default-projectile-source-controller.lua` | Decompiled |
| `dumps/OwlAura.lua` | Custom implementation |
| `dumps/SilentAura.lua` | Custom implementation |
| `dumps/BackTrack.lua` | Custom implementation |
