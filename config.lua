-- config.lua
Config = {}

-- Gang HQ Settings (for purchasing an HQ)
Config.HQPrice = 50000                -- Cost to purchase a Gang HQ
Config.RequiredRepForPurchase = 100   -- Minimum reputation required to purchase a Gang HQ
Config.HQLocation = vector3(100.0, -200.0, 20.0)  -- Example HQ purchase location
Config.HQRadius = 2.0                 -- Marker interaction radius

-- Gang Panel (Dashboard) Settings (this is the hub for all gang management)
Config.GangPanelLocation = vector3(-54.06, -1227.65, 29.21)  -- Location for the gang dashboard prop
Config.GangPanelZOffset = 0.5         -- Vertical offset for the prop
Config.GangPanelHeading = 0.0         -- Default heading for the prop

-- Gang Reputation and Mission Settings
Config.RepRewards = {
    missionComplete = 10,   -- Reputation reward per mission completed
    businessProfit = 5      -- Reputation reward for business profit milestones
}

-- Example Missions (expand as needed)
Config.Missions = {
    { name = "Smash a rival business", reward = 2500, rep = 15 },
    { name = "Steal supplies", reward = 1500, rep = 10 }
}
