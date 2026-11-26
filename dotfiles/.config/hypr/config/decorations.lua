hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = {
                    ECLIPSE_PINK,
                    ECLIPSE_PURPLE
                },
                angle = 45,
            },
            inactive_border = ECLIPSE_GRAY,
        },
    },
    group = {
        col = {
            border_active = ECLIPSE_PINK,
            border_inactive = ECLIPSE_GRAY,
            border_locked_active = ECLIPSE_WINE,
            border_locked_inactive = ECLIPSE_GRAY,
        },
        groupbar = {
            col = {
                active = ECLIPSE_PINK,
                inactive = ECLIPSE_GRAY,
                locked_active = ECLIPSE_WINE,
                locked_inactive = ECLIPSE_GRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 5,
        active_opacity = 0.96,
        inactive_opacity = 0.90,
        fullscreen_opacity = 1,
        blur = {
            size = 8,
            passes = 3,
            special = true,
        },
    },
})
