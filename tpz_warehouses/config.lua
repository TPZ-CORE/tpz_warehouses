Config = {}

Config.PromptsKeys = {

    -- Prompts close to the NPC.
    ['OPEN_PERSONAL_WAREHOUSE']  = { label = "Open Personal Warehouse",   key = 0xC7B5340A },
    ['OPEN_OTHER_WAREHOUSE']     = { label = "Open Other Warehouse",      key = 0x156F7119 },

    -- Action prompts
    ['CREATE_WAREHOUSE_KEYS']    = { label = "Create Warehouse Keys",     key = 0xCEFD9220 },
    ['BUY_WAREHOUSE']            = { label = "Buy Warehouse With Cash",   key = 0x760A9C6F },
    ['BUY_GOLD_WAREHOUSE']       = { label = "Buy Warehouse With Gold",   key = 0x7F8D09B8 },
    ['SELL_WAREHOUSE']           = { label = "Sell Warehouse",            key = 0x4AF4D473 },
}


Config.WarehouseKeyItem         = "warehousekeys"
Config.SellWarehouseTAX         = 50 -- 50% TAX, if the cost is 150, the player will receive 75 dollars (higher percentage = lower tax).

-- The amount that will be given back to the player when selling a warehouse (in percentage).
-- for example, if warehouse cost is 300 and tax is 50%, 150 will be given back.
Config.SellWarehouseTax = 50 

Config.Locations = { 
  
    -- Valentine
    ['val_warehouse'] = {
        Title = "Warehouse",

        Coords = {x = -242.204, y = 754.3040, z = 116.69},

        -- The distance to show prompts and Open / Buy a Warehouse.
        ActionDistance  = 2.0,

        Blips = {
            Enabled = true,
            Sprite  = -426139257,
            Title   = "Warehouse",
        },

        -- If this is enabled, a circular marker will be displayed when close to the warehouse actions.
        Marker = {
            Enabled = true,
            RGBA    = {r = 240, g = 230, b = 140, a = 50},
            DisplayDistance = 10.0,
        },

        Weight      = 100000, -- 100KG
        WeightLabel = "100KG",

        Price       = 600,
        GoldPrice   = 50,

    },

    -- Rhodes
    ['rh_warehouse'] = {
        Title = "Warehouse",

        Coords = {x = 1403.313, y = -1372.75, z = 80.285},

        ActionDistance  = 2.0,

        Blips = {
            Enabled = true,
            Sprite  = -426139257,
            Title   = "Warehouse",
        },

        Marker = {
            Enabled = true,
            RGBA    = {r = 240, g = 230, b = 140, a = 50},
            DisplayDistance = 10.0,
        },

        Weight      = 75000, -- 75KG
        WeightLabel = "75KG",

        Price       = 450,
        GoldPrice   = 35,

    },

    -- ST Denis
    ['sd_warehouse'] = {
        Title = "Warehouse",

        Coords = {x = 2513.380, y = -1492.53, z = 44.972},

        ActionDistance  = 2.0,

        Blips = {
            Enabled = true,
            Sprite  = -426139257,
            Title   = "Warehouse",
        },

        Marker = {
            Enabled = true,
            RGBA    = {r = 240, g = 230, b = 140, a = 50},
            DisplayDistance = 10.0,
        },

        Weight      = 40000, -- 40KG
        WeightLabel = "40KG",

        Price       = 300,
        GoldPrice   = 25,

    },

    --Blackwater
    ['bw_warehouse'] = {
        Title = "Warehouse",

        Coords = {x = -944.152, y = -1333.53, z = 49.678},

        ActionDistance  = 2.0,

        Blips = {
            Enabled = true,
            Sprite  = -426139257,
            Title   = "Warehouse",
        },

        Marker = {
            Enabled = true,
            RGBA    = {r = 240, g = 230, b = 140, a = 50},
            DisplayDistance = 10.0,
        },

        Weight      = 40000, -- 40KG
        WeightLabel = "40KG",

        Price       = 300,
        GoldPrice   = 25,
    },


    --Guarma
    ['gu_warehouse'] = {
        Title = "Warehouse",

        Coords = { x = 1366.991, y = -6964.94, z = 59.092 },

        ActionDistance  = 2.0,

        Blips = {
            Enabled = true,
            Sprite  = -426139257,
            Title   = "Warehouse",
        },

        Marker = {
            Enabled = true,
            RGBA    = {r = 240, g = 230, b = 140, a = 50},
            DisplayDistance = 10.0,
        },

        Weight      = 75000, -- 75KG
        WeightLabel = "75KG",

        Price       = 450,
        GoldPrice   = 35,
    },



}