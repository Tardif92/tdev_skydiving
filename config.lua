Config = {}

Config.Debug = false
Config.Framework = 'auto' -- 'auto', 'esx', 'qb', 'qbox'
Config.Target = 'auto' -- 'auto', 'ox_target', 'qb-target', 'none'
Config.Menu = 'nui' -- 'auto', 'nui', 'ox_lib', 'qb-menu', 'esx'
Config.Inventory = 'auto' -- 'auto', 'ox_inventory', 'framework'
Config.Locale = 'en'
Config.Webhook = ''

Config.UI = {
  title = 'TDev Skydiving'
}

Config.Command = {
  stop = 'stopskydiving'
}

Config.ActivityReturnCoords = vector4(-1037.6606, -2737.7354, 20.1693, 328.1419)

Config.Tandem = {
  enabled = true,
  requirePassengerItem = false, -- Instructor supplies the shared canopy.
  controlCommand = '+tdev_tandem_control',
  controlKey = 'H', -- Instructor: hand over / take back. Tourist: return controls.
  inputIntervalMs = 80,
  inputTimeoutMs = 650,
  attachTimeoutMs = 6000,
  offset = vector3(0.0, 0.42, -0.12), -- Tourist in front of instructor; tune for custom peds.
  rotation = vector3(0.0, 0.0, 0.0),
  freefallAnimation = { dict = 'skydive@freefall', clip = 'free_idle' },
  canopyAnimation = { dict = 'skydive@parachute@', clip = 'chute_idle' }
}

Config.RequiredItem = {
  name = 'parachute',
  label = 'Parachute',
  amount = 1,
  consumeOnStart = false
}

Config.Payment = {
  enabled = false,
  price = 500,
  account = 'bank',
  allowStartWhenDebitUnavailable = false
}

Config.Security = {
  maxLobbySize = 8,
  lobbyTimeoutSeconds = 300,
  readyTimeoutSeconds = 120,
  antiSpamCooldownMs = 1000,

  minPedDistanceToOpen = 5.0,
  minPedDistanceToStart = 10.0,

  validatePedServerSide = true,
  validateDestinationServerSide = true,
  preventMultipleActiveActivities = true,
  preventDoubleCharge = true,
  refundOnInternalFailure = true,
  kickFromLobbyOnDisconnect = true
}

Config.ActivityPeds = {
  {
    id = 'lsia_skydiving',
    label = 'Skydiving Instructor',
    model = 's_m_m_pilot_02',
    coords = vector4(-1037.6606, -2737.7354, 20.1693, 328.1419),
    scenario = 'WORLD_HUMAN_CLIPBOARD',

    blip = {
      enabled = true,
      sprite = 94,
      color = 3,
      scale = 0.8,
      label = 'Skydiving'
    },

    enabledActivities = {
      skydiving = true
    }
  }
}

Config.Skydiving = {
  planeModel = 'luxor',
  pilotModel = 's_m_m_pilot_02',
  maxPlayersPerPlane = 8,
  sessionTimeoutSeconds = 900,

  parachuteWeapon = 'GADGET_PARACHUTE',
  autoGiveParachute = true,
  removeGivenParachuteOnCleanup = true,

  forceFirstPerson = false,
  useScreenFade = true,

  -- All distances are metres; speeds are metres per second.
  briefingSeconds = 5,
  boardingTimeoutSeconds = 35,
  cruiseSpeed = 65.0,
  jumpRunRadius = 500.0,
  minimumJumpHeight = 200.0,
  countdownSeconds = 3,
  exitOffset = vector3(-4.5, -2.0, -2.0), -- Side exit; Z also clears the aircraft's lower model bounds.
  cinematic = { enabled = true, durationMs = 6500, fov = 52.0 },
  hud = { enabled = true, updateMs = 150, units = 'metric' }, -- or 'imperial'
  safety = { autoDeploy = true, deployHeight = 180.0, warningHeight = 280.0 },
  landing = {
    settleMs = 1200,
    maxVerticalSpeed = 1.5,
    resultSeconds = 12,
    excellentRadius = 3.0,
    goodRadius = 8.0,
    serverMaxDistance = 2500.0,
    serverHeightTolerance = 35.0
  },

  jumpKeyCommand = '+tdev_skydiving_jump',
  jumpKeyDefault = 'SPACE',

  deployKeyCommand = '+tdev_skydiving_deploy',
  deployKeyDefault = 'F',

  marker = {
    type = 1,
    scale = vector3(24.0, 24.0, 0.35),
    airBeacon = false, -- Enable the tall guide column for beginner servers.
    airBeaconScale = vector3(32.0, 32.0, 180.0),
    color = {
      r = 88,
      g = 181,
      b = 255,
      a = 120
    },
    drawDistance = 5000.0,
    radiusToFinish = 12.0
  },

  destinations = {
    {
      id = 'vespucci_beach',
      menu = { terrain = 'COASTLINE', description = 'Ocean views, golden sand and a wide-open landing zone on the west coast.' },
      label = 'Vespucci Beach Landing',
      startPedId = 'lsia_skydiving',
      landingCoords = vector3(-1335.0, -1575.0, 4.0),
      planeSpawn = vector4(-1600.0, -2500.0, 900.0, 30.0),
      jumpCoords = vector3(-1350.0, -1600.0, 850.0)
    },
    {
      id = 'vinewood_hills',
      menu = { terrain = 'HILLSIDE', description = 'Leave the city below and line up your canopy over the Vinewood hills.' },
      label = 'Vinewood Hills Landing',
      startPedId = 'lsia_skydiving',
      landingCoords = vector3(684.0, 566.0, 130.0),
      planeSpawn = vector4(200.0, -2000.0, 950.0, 15.0),
      jumpCoords = vector3(684.0, 566.0, 850.0)
    },
    {
      id = 'sandy_shores',
      menu = { terrain = 'DESERT', description = 'Big skies and desert horizons. Bring it home at Sandy Shores airfield.' },
      label = 'Sandy Shores Airfield Landing',
      startPedId = 'lsia_skydiving',
      landingCoords = vector3(1740.0, 3266.0, 41.0),
      planeSpawn = vector4(850.0, 2100.0, 1000.0, 28.0),
      jumpCoords = vector3(1740.0, 3266.0, 850.0)
    }
  }
}
