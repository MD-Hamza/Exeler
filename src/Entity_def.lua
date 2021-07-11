ENTITY_DEFS = {
    ["player"] = {
        walkSpeed = 140,
        animations = {
            ["idle-up"] = {
                frames = {1},
                interval = 1,
                texture = "walk"
            },
            ["idle-left"] = {
                frames = {10},
                interval = 1,
                texture = "walk" 
            },
            ["idle-down"] = {
                frames = {19},
                interval = 1,
                texture = "walk"
            },
            ["idle-right"] = {
                frames = {28},
                interval = 1,
                texture = "walk"
            },
            ["up"] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.1,
                texture = "walk"
            },
            ["left"] = {
                frames = {10, 11, 12, 13, 14, 15, 16, 17, 18},
                interval = 0.1,
                texture = "walk" 
            },
            ["down"] = {
                frames = {19, 20, 21, 22, 23, 24, 25, 26, 27},
                interval = 0.1,
                texture = "walk"
            },
            ["right"] = {
                frames = {28, 29, 30, 31, 32, 33, 34, 35, 36},
                interval = 0.1,
                texture = "walk"
            },
            ["slash-up"] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.05,
                texture = "slash",
                looping = false
            },
            ["slash-left"] = {
                frames = {7, 8, 9, 10, 11, 12},
                interval = 0.05,
                texture = "slash",
                looping = false
            },
            ["slash-down"] = {
                frames = {13, 14, 15, 16, 17, 18},
                interval = 0.05,
                texture = "slash",
                looping = false
            },
            ["slash-right"] = {
                frames = {19, 20, 21, 22, 23, 24},
                interval = 0.05,
                texture = "slash",
                looping = false
            },
            ["bow-up"] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["bow-left"] = {
                frames = {14, 15, 16, 17, 18, 19, 20, 21, 22},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["bow-down"] = {
                frames = {27, 28, 29, 30, 31, 32, 33, 34, 35},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["bow-right"] = {
                frames = {40, 41, 42, 44, 44, 45, 46, 47, 48},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["arrow-up"] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["arrow-left"] = {
                frames = {14, 15, 16, 17, 18, 19, 20, 21, 22},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["arrow-down"] = {
                frames = {27, 28, 29, 30, 31, 32, 33, 34, 35},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["arrow-right"] = {
                frames = {40, 41, 42, 44, 44, 45, 46, 47, 48},
                interval = 0.06,
                texture = "bow",
                looping = false
            },
            ["fire-up"] = {
                frames = {10, 11, 12, 13},
                interval = 0.08,
                texture = "bow",
                looping = false
            },
            ["fire-left"] = {
                frames = {23, 24, 25, 26},
                interval = 0.08,
                texture = "bow",
                looping = false
            },
            ["fire-down"] = {
                frames = {36, 37, 38, 39},
                interval = 0.08,
                texture = "bow",
                looping = false
            },
            ["fire-right"] = {
                frames = {49, 50, 51, 52},
                interval = 0.08,
                texture = "bow",
                looping = false
            }
        }
    },
    ["skeleton"] = {
        walkSpeed = 160,
        animations = {
            ["idle-up"] = {
                frames = {1},
                interval = 1,
                texture = "skeleton"
            },
            ["idle-left"] = {
                frames = {10},
                interval = 1,
                texture = "skeleton" 
            },
            ["idle-down"] = {
                frames = {19},
                interval = 1,
                texture = "skeleton"
            },
            ["idle-right"] = {
                frames = {28},
                interval = 1,
                texture = "skeleton"
            },
            ["walk-up"] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.1,
                texture = "skeleton"
            },
            ["walk-left"] = {
                frames = {10, 11, 12, 13, 14, 15, 16, 17, 18},
                interval = 0.1,
                texture = "skeleton" 
            },
            ["walk-down"] = {
                frames = {19, 20, 21, 22, 23, 24, 25, 26, 27},
                interval = 0.1,
                texture = "skeleton"
            },
            ["walk-right"] = {
                frames = {28, 29, 30, 31, 32, 33, 34, 35, 36},
                interval = 0.1,
                texture = "skeleton"
            },
            ["hurt"] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.1,
                texture = "skeleton"
            }
        }
    }
}