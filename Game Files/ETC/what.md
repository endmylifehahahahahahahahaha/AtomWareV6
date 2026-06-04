# Game Files — What To Dump

Folders are already created under `Game Files/`. Drop dumps into the matching folder.

---

## BedWars (`Game Files/BedWars/`)
Game IDs: 6872274481 (main), 8444591321, 8560631822

The game file hooks a ton of controllers via Knit + Flamework. These are the scripts worth having:

- `ProjectileController` — `lplr.PlayerScripts.TS.controllers.*` or via Flamework. Already partially dumped in `Projectile/`. Needed for SilentAim bow hook (`enableBeam`, upvalue 8 = BowConstantsTable).
- `ProjectileSourceController` — already dumped in `Projectile/`. The source-controller that owns `projectileHandler`.
- `KitController` — `Knit.Controllers.KitController`. Needed for kit ability hooks.
- `BlockBreakController` — `Knit.Controllers.BlockBreakController`. Has `blockBreaker` for block ESP.
- `DamageIndicatorController` — `Knit.Controllers.DamageIndicatorController.spawnDamageIndicator`. Used for damage rendering.
- `MatchHistoryController` — `lplr.PlayerScripts.TS.controllers.global.match-history.match-history-controller`.
- `client-sync-events` — `lplr.PlayerScripts.TS.client-sync-events`. Used for event hooking.
- `combat-constant` — `replicatedStorage.TS.combat.combat-constant`. Balance/damage values.
- `knockback-util` — `replicatedStorage.TS.damage.knockback-util`. Used for knockback direction spoofing.
- `knit-controller` — `lplr.PlayerScripts.TS.lib.knit.knit-controller`. The base controller class.

**How to dump:** In BedWars, use `getscriptclosure` or `require()` on the paths above while in-game, then `writefile`.

---

## Skywars (`Game Files/Skywars/`)
Game IDs: 8768229691 (main), 8542275097, 8592115909, 8951451142, 13246639586

Uses Flamework + rbxts. Controllers are resolved via `ControllerTable` after `Flamework.ignite`.

- `ProjectileController` — `ControllerTable.ProjectileController`. Has `chargeBow` (upvalues: ORIGIN_OFFSET idx 11, WORLD_ACCELERATION idx 13). Needed for bow trajectory.
- `MeleeController` — `ControllerTable.MeleeController`. Has `strikeDesktop` (upvalue 6 = Remotes table). Needed for killaura remote.
- `HotbarController` — `ControllerTable.HotbarController`. Has `getSword` (upvalue 1 = ItemMeta). Needed for weapon detection.
- `HumanoidController` — `ControllerTable.HumanoidController`. Has `addSpeedModifier` and `speedModifiers`. Needed for velocity/speed hacks.
- `SprintingController` — `ControllerTable.SprintingController`. Has `disableSprinting`, `setCanSprint`, `enableSprinting`.
- `ScreenController` — `ControllerTable.ScreenController`. Has `enableFocus` (used for NoClosingMenus).
- `camera-util` — `lplr.PlayerScripts.TS.util.camera-util`. Used for CameraUtil in bow aimbot.
- `global-store` — `lplr.PlayerScripts.TS.ui.rodux.global-store`. Has `GlobalStore` for inventory state.

**How to dump:** In Skywars after Flamework ignites, `debug.getupvalue` on the resolved controllers or `getscriptclosure` on `lplr.PlayerScripts.TS.*`.

---

## Bridge Duel (`Game Files/BridgeDuel/`)
Game IDs: 11630038968 (main), 12011959048, 14191889582, 14662411059

Uses Knit (older pattern via `replicatedStorage.Modules.Knit.Client`).

- `MovementController` — `Knit.GetController('MovementController')`. Has `AddSpeedOverride`, `RemoveSpeedOverride`, `KnitStart` (proto 5 = slowdown check). Needed for NoSlowdown.
- `BowClient` — `replicatedStorage.Client.Components.All.Tools.BowClient`. Has `Start` (upvalue 11 = aim function). Needed for bow aimbot hook.
- `MatchController` — `Knit.GetController('MatchController')`. Has `EnterQueue`. Needed for AutoQueue.
- `ViewmodelController` — `Knit.GetController('ViewmodelController')`. Has `PlayAnimation`. Needed for animation spoofing.
- `EffectsController` — `Knit.GetController('EffectsController')`. Has `PlaySound`.
- `Communication` — `replicatedStorage.Client.Communication`. Remote wrapper.
- `Blink` — `replicatedStorage.Blink.Client`. Has `game_state.team_won` event. Needed for AutoQueue trigger.
- `Constants/Melee` — `replicatedStorage.Constants.Melee`. Melee hitbox/timing constants.
- `Constants/Blocks` — `replicatedStorage.Constants.Blocks`. Block break times.

**How to dump:** In Bridge Duel after Knit starts, grab controllers via `Knit.GetController(name)` and dump the script source.

---

## Frontlines (`Game Files/Frontlines/`)
Game IDs: 5938036553 (main), 123804558118054, 131465939650733

Uses a custom module with `exe_func_t` event table pattern. The main script is found via `getconnections` on `game.LogService.MessageOut` and scanning module constants.

- `Main` (the root module) — Contains `append_exe_set`, `exe_func_t`, `globals`. Found by scanning constants `'spawn_bullet'`, `'on_melee_hit'`, `'spawn_throwable'`.
- `spawn_bullet` function — Upvalue 5 or 6 = `ShootRay` (RaycastParams). Needed for SilentAim bullet direction hook.
- `on_melee_hit` function — The knife kill function. Needed for melee hooks.
- `spawn_throwable` function — Upvalue 1 = Throwables table. Needed for grenade ESP.
- `Events` table — `debug.getupvalue(Main.append_exe_set, 1)`. Has all event handlers including `UPDATE_CHAT_GUI` and `INIT_FPV_SOL_AMMO_PICKUP`.
- `PickupBit` — Upvalue 5 of the INIT_FPV_SOL_AMMO_PICKUP handler.

**How to dump:** In Frontlines, use the `searchForScripts` pattern (scan `replicatedStorage` module constants for the identifiers above), then `getscriptclosure` and `writefile`.

---

## Jailbreak (`Game Files/Jailbreak/`)
Game ID: 606849621

Uses `replicatedStorage.Game.*` module pattern.

- `GunController` — `replicatedStorage.Game.Item.Gun`. Has `TransformLocalMousePosition` (SilentAim hook), `BulletEmitterOnLocalHitPlayer` (Wallbang hook). **Most important.**
- `ItemSystemController` — `replicatedStorage.Game.ItemSystem.ItemSystem`. Has `GetLocalEquipped`. Needed to check current weapon.
- `BulletEmitter` — `replicatedStorage.Game.ItemSystem.BulletEmitter`. Has `LifeSpan`, `LastUpdate`, `IgnoreList`.
- `VehicleController` — `replicatedStorage.Vehicle.VehicleUtils`. Has `toggleLocalLocked` (upvalue 2 = remote table), `NitroShopVisible` (upvalue 1 = nitro table), `updateSpdBarRatio`. Needed for Nitro/vehicle hacks.
- `FallingController` — `replicatedStorage.Game.Falling`. Has `Init` (upvalue 19, constant 9 = ragdoll check). Needed for NoFall.
- `CircleAction` — `replicatedStorage.Module.UI` → `.CircleAction`. Has `Press` (constant 3 = 'Timed'). Needed for InstantAction.
- `TeamChooseController` — `replicatedStorage.TeamSelect.TeamChooseUI`. Has `Init` (upvalue 2 = cash table).
- `PlayerUtils` — `replicatedStorage.Game.PlayerUtils`. Has `hasKey`. Needed for KeyBypass.

**How to dump:** In Jailbreak, `require()` each path directly — they're plain ModuleScripts on `replicatedStorage`.

---

## Aimblox (`Game Files/Aimblox/`)
Game ID: 79695841807485

Uses a dynamic script-scanning system (`searchForScripts` via module constant matching).

- `BulletHandler` — scan constants for `'BulletUpdate'`, `'HitEffects'`. Has the bullet fire/hit logic for SilentAim.
- `CharacterController` — scan constants for `'BloodVignette'`, `'HealthBar'`. Has health attribute signals.
- `CharacterReplicatorManager` — scan constants for `'CharacterReplicatorAngleUpdate'`. Needed for angle replication spoofing.
- `Network` — scan constants for `'CreateRemoteEvent'`, `'OnInvoke'`, `'ExceptPlayer'`. Remote wrapper.
- `Memory` — scan constants for `'LocalPlayerMemory'`, `'GlobalPlayerMemory'`. Has `GetLocalMemory()`.

**How to dump:** In Aimblox, use the `searchForScripts` pattern already in the game file — iterate `replicatedStorage:GetDescendants()`, collect `debug.getconstants(getscriptclosure(v))`, match, then dump the source.

---

## Notes
- The `Projectile/` folder already has BedWars `ProjectileController` and `ProjectileSourceController` dumps — move them to `BedWars/` when convenient.
- `ETC/` is for misc files that don't belong to one game.
- Dump format: raw decompiled Lua, filename should match the script name in-game.
