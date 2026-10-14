# tdev_skydiving

## Version 2.2.1 — fluid aircraft exit

The countdown stays inside the plane. Once it ends, the exit clears the vehicle task and starts native freefall in the same frame, restores gravity, and carries the aircraft's forward momentum with a small downward release. The position clears the aircraft's lower model bounds, and collision with that aircraft alone is suppressed for 750 ms using frame-only calls. This avoids waiting for a lingering bailout animation or remaining caught against the fuselage. The tandem tourist is explicitly unfrozen when attaching. `exitTimeoutMs` is no longer used; `exitOffset` still sets the side/rear position, with Z adjusted for hull clearance.

The original approach used [TaskLeaveVehicle's animated bailout flag](https://github.com/citizenfx/natives/blob/master/TASK/TaskLeaveVehicle.md). The replacement uses its immediate-exit flag, clears the remaining task, and uses [frame-only aircraft collision suppression](https://github.com/citizenfx/natives/blob/master/ENTITY/SetEntityNoCollisionEntity.md). This is a code-level fix verified in the Lua simulation; confirm the actual transition with a solo and tandem jump on your FiveM server.

## Version 2.2 — blue flight desk and tandem jumps

The custom NUI, parachute illustration, flight instruments and landing marker now use a navy / sky-blue theme. Choose a destination, then **Duo / Tandem Jump**. One player creates a duo as instructor; the other opens the same destination at the same guide and joins that named instructor. Refresh the list if the host just created their flight. Both players must toggle ready, then the instructor starts. Solo and ordinary group flights remain available.

The pair boards the same aircraft in separate seats. The instructor presses **Space** in the jump window and **F** to deploy (or lets the configured automatic deployment act). After the exit, the tourist attaches in front of the instructor; one native parachute carries both. Once the canopy is open, the instructor presses **H** to hand steering to the tourist or reclaim it. The tourist steers with standard parachute controls and can press **H** to return control. The HUD identifies the controller. H is rebindable under FiveM key bindings.

Only the instructor needs the inventory item by default. `Config.Tandem.requirePassengerItem = true` requires it for both. Configured fares remain per person. The normal `consumeOnStart` setting applies only to players required to supply equipment. The physical parachute always belongs to the instructor; tourist inputs are relayed through the server with session, controller and revision checks. A lost input stream returns control to the instructor. The tourist cannot take control without a handover or deploy/cut a second canopy while attached.

Landing finishes the pair together. Disconnects, death, cancellation and failed attachment end the pair, restore controls and detach the tourist; an airborne tourist receives emergency parachute activation with bounded opening retries. A resource stop runs immediate separation, but cannot keep retrying after the resource unloads. No health or revive changes are made. Custom ped proportions may need `Config.Tandem.offset`, `rotation` and animation settings adjusted.

Install the **whole resource**, including both new `tandem.lua` files and `fxmanifest.lua`. Replace the server copy and run `restart tdev_skydiving` with no active jumps. This requires OneSync, as before. Automated Lua simulation and browser checks passed; two-client GTA physics, attachment appearance, actual steering override and latency still require in-game verification on your server. See `VALIDATION.md` for the tandem test sequence.

## Version 2.1 — usable parachutes and a new flight desk

The redesigned dependency-free NUI includes an original vector parachute illustration, destination cards, route descriptions, approximate drop heights, prices and an eight-player-ready manifest. Keyboard focus, Escape, disabled actions and failed callbacks are handled. The lobby opens after creating/joining a group and remains open while ready states update. Set `Config.Menu = 'nui'` to use this interface; other menu providers retain their own appearance. Each destination's optional `menu.terrain` and `menu.description` customize its presentation.

### Parachute fix

The inventory item and GTA's usable parachute gadget are separate. The previous version forced the gadget into the selected-weapon slot, which conflicts with ox_inventory's weapon-mismatch/disarm behavior, and did not call `SetPedGadget`. This version holsters through ox_inventory when present, grants the gadget without selecting it as a firearm, activates it, and checks it at boarding, exit, freefall and deployment. An exit is blocked when gear cannot be equipped. Opening requests retry for up to 1.8 seconds to cover the exit animation and stop when the real canopy state confirms opening. A used/cut canopy is not replenished. No inventory resource or global weapon-protection setting is modified.

`Config.RequiredItem.consumeOnStart = false` intentionally keeps the reusable item in the inventory. Set it to `true` if each activity should consume one item on the server; do not also trigger inventory item use, which would double-consume it. `Config.Skydiving.autoGiveParachute` should stay `true` for this automatic equipment flow. If set to `false`, an already usable GTA gadget is required.

Replace the deployed server resource with the complete updated folder and run `restart tdev_skydiving` while no jumps are active. Changing a separate Desktop copy does not update a running server resource automatically. Regression tests cover removed gadgets and the menu callbacks, but confirm F/automatic deployment in a real session with your installed inventory.

## Version 2.0 — cinematic jumps

The instructor, destination menu, inventory checks, payments and existing framework integrations remain available. The flight now has a safety briefing, group boarding barrier, optional exterior camera flyby, green-light jump window, audible exit countdown, native aircraft bail-out and a freefall/canopy/landing flow.

The flight HUD shows altitude above ground, speed, horizontal distance to the target and freefall time. A low-altitude warning and optional automatic canopy deployment help beginners. A confirmed touchdown produces a score and jump report; off-target landings finish too. The HUD never takes keyboard or mouse focus.

### Controls

- **Space**, by default: begin the jump countdown when the green light appears.
- **F**, by default: request canopy deployment. GTA's normal parachute controls remain available.
- **Back / Esc**: skip the exterior flyby.
- **/stopskydiving**: leave your current activity and return to the instructor. This command only works while participating and does not heal or resurrect characters.
- Bindings can be changed in GTA Settings → Key Bindings → FiveM.

### Configuration added in 2.0

All options below are under `Config.Skydiving` in `config.lua`.

| Option | Default | Purpose |
| --- | --- | --- |
| `briefingSeconds` | 5 | Time to read the safety briefing |
| `boardingTimeoutSeconds` | 35 | Maximum boarding wait before failure recovery |
| `cruiseSpeed` | 65 | Aircraft cruise speed, metres per second |
| `jumpRunRadius` | 500 | Distance around the jump point where exits may begin |
| `minimumJumpHeight` | 200 | Minimum exit altitude above terrain |
| `countdownSeconds` | 3 | Exit countdown |
| `exitOffset` | (-4.5, -2, -2) | Exit position in aircraft-local coordinates; Z is also adjusted below the model bounds |
| `forceFirstPerson` | false | Optional first-person view during the passenger flight |
| `cinematic.enabled` | true | Exterior flyby camera |
| `cinematic.durationMs` / `fov` | 6500 / 52 | Flyby duration and field of view |
| `hud.enabled` / `updateMs` | true / 150 | Instruments and update frequency; stage prompts remain visible |
| `hud.units` | metric | Set `imperial` for feet and mph |
| `safety.autoDeploy` | true | Request emergency deployment at the configured altitude |
| `safety.deployHeight` / `warningHeight` | 180 / 280 | Deployment and warning heights above terrain |
| `landing.settleMs` | 1200 | Stable touchdown time before server validation |
| `landing.resultSeconds` | 12 | Jump report duration |
| `landing.excellentRadius` / `goodRadius` | 3 / 8 | Precision/excellent grade thresholds |
| `marker.radiusToFinish` | 12 | Landing-zone radius and zero-score distance |
| `landing.serverMaxDistance` | 2500 | Maximum horizontal miss accepted as a completed jump |
| `landing.serverHeightTolerance` | 35 | Vertical tolerance around the configured destination elevation |
| `marker.airBeacon` | false | Optional tall training guide; ground zone and routed blip remain visible |

Distances are metres internally, even with imperial display. Keep the warning height above the automatic deployment height. Automatic deployment is an assist using GTA's normal parachute logic, not a guarantee against injury. A severed or unavailable canopy may not open again.

For custom aircraft, match both lobby-size settings to the actual passenger capacity and test the exit offset. Seats are assigned by the server and checked against the loaded model. The aircraft remains frozen while the group boards, then launches when the server confirms everyone is aboard. Disconnecting during boarding cancels that group. In flight, the network owner maintains the pilot task so ownership can migrate.

### Landing and cleanup

Landing detection waits until the player is alive, on the ground, outside a vehicle and no longer falling or ragdolling. Movement is briefly held during touchdown confirmation. The server checks session membership, the recorded jump, elapsed time, position, vertical stability and vehicle state before calculating distance and score. Freefall, top speed and canopy-use information are client telemetry: there are **no cash, XP or inventory rewards** attached to the report. This is plausibility validation, not a replacement for an anticheat.

A water landing ends the attempt. Landings beyond the configured server bounds are rejected and the client exits after a confirmation timeout. Set destination elevations carefully, particularly for mountainous routes. Cancellation before jumping returns the player to their original position; cancellation in the air preserves the parachute. Camera modes, overlays, markers and blips are cleaned up. Consumed items are returned to connected players when boarding is cancelled with refunds enabled; offline refunds depend on the existing framework integration.

### Upgrade and verification

Replace the entire resource folder, including the new `client/experience.lua` and `html/flight.js`. Merge personal settings into the new config rather than replacing it with the old config, which lacks the new option tables. Restart the resource while no jumps are active.

See `VALIDATION.md` for completed automated checks and the in-game acceptance checklist. Lua/JS and mocked logic tests passed; aircraft physics, animation blending, network ownership migration and the real framework/inventory integrations still require an actual FiveM session.

Native references: [aircraft exit flags](https://github.com/citizenfx/natives/blob/master/TASK/TaskLeaveVehicle.md), [skydiving task](https://github.com/citizenfx/natives/blob/master/TASK/TaskSkyDive.md), [parachute states](https://github.com/citizenfx/natives/blob/master/PED/GetPedParachuteState.md), [aircraft mission](https://github.com/citizenfx/natives/blob/master/TASK/TaskPlaneMission.md).

TDev skydiving activity for ESX, QBCore, Qbox, and ox_inventory. A supported framework/inventory is required for the existing item validation.

## Install

1. Put `tdev_skydiving` in your server resources folder.
2. Add the parachute item to your inventory:
   - ESX: run `install/esx_items.sql`.
   - QBCore/Qbox shared items: copy `install/qbcore_items.lua` into your shared items table.
   - ox_inventory: copy `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`.
3. Add `ensure tdev_skydiving` after your framework and inventory resources.
4. Configure `config.lua` if your item name, framework, target, menu, or airport ped coords differ.

## Flow

- Airport instructor ped opens the skydiving menu.
- Player chooses a landing destination.
- Player can create/join a group lobby or start alone.
- Every lobby member must have the configured parachute item before readying and again at activity start.
- Server validates ped distance, destination, lobby state, item possession, payment, and plane entity network IDs.

## Key Config

- `Config.RequiredItem.name`: inventory item required in the player's pocket.
- `Config.RequiredItem.consumeOnStart`: leave `false` to require the item without consuming it.
- `Config.Payment.enabled`: disabled by default.
- `Config.Framework`: `auto`, `esx`, `qb`, or `qbox`.
- `Config.Inventory`: `auto`, `ox_inventory`, or `framework`.
- `Config.Target`: `auto`, `ox_target`, `qb-target`, or `none`.
- `Config.Menu`: `nui`, `auto`, `ox_lib`, `qb-menu`, or `esx`.

The NUI menu is dependency-free. ox_lib menu support is only used when `lib` is available.
