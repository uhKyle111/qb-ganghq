Config = {}

-- HQs that can be bought
Config.HQs = {
    { id = 1, name = "Vagos HQ", price = 50000, coords = vector3(-215.0, -1341.0, 30.0), signHeading = 270.0 },
    { id = 2, name = "Ballas HQ", price = 75000, coords = vector3(100.0, -1931.0, 20.0), signHeading = 180.0 }
}

-- HQ Dashboard Access Point (Tablet Prop Location)
Config.Dashboard = {
    coords = vector3(-54.14, -1227.73, 29.24),  -- Tablet Location
    prop = "hei_prop_dlc_tablet"  -- Tablet Model
}

-- Active Missions
Config.ActiveMissions = {}

-- Gang Business Reputation System
Config.Businesses = {
    ["vagos"] = { rep = 0, issues = {} },
    ["ballas"] = { rep = 0, issues = {} }
}
