-- Color Cache stuff
-- If you wanna edit the colors here ya go.
YAWS.UI.ColorCache = {}

-- Light Theme
YAWS.UI.ColorCache.Light = {
    theme = Color(134, 168, 148),
    
    bar_background = Color(255, 255, 255),
    frame_background = Color(235, 235, 235),
    panel_background = Color(255, 255, 255),

    text_header = Color(50, 50, 50),
    text_main = Color(75, 75, 75),
    text_placeholder = Color(146, 146, 146),

    sidebutton_dull = Color(125, 125, 125),
    sidebutton_highlight = Color(75, 131, 100),
    sidebutton_highlightbg = Color(132, 158, 143, 45),
    sidebutton_highlightbg2 = Color(122, 138, 112, 0),

    divider = Color(78, 78, 78, 90),
    divider_faded = Color(50, 50, 50, 35),

    scroll_bg = Color(200, 200, 200, 0),
    scroll_grip = Color(100, 100, 100),

    switch_bg = Color(120, 120, 120),

    input_bg = Color(255, 255, 255),
    input_bg_dim = Color(225, 225, 225),
    
    text_entry_border_inactive = Color(175, 175, 175),
    text_entry_border_active = Color(134, 168, 148),

    player_card_border = Color(175, 175, 175),
    player_card_bg = Color(255, 255, 255),

    button_base = Color(101, 138, 116),
    button_hover = Color(121, 158, 136),
    button_text = Color(255, 255, 255),
    button_faded = Color(0, 0, 0, 100),

    icon_button_base = Color(7, 7, 7),
    icon_button_hover = Color(108, 196, 144),

    button_warn_base = Color(151, 67, 67),
    button_warn_hover = Color(206, 85, 85),

    active_warning = Color(255, 50, 50),
    expired_warning = Color(97, 78, 78),

    yaws = Color(101, 138, 116),
}

-- Dark Theme
YAWS.UI.ColorCache.Dark = {
    theme = Color(134, 168, 148),
   
    bar_background = Color(35, 35, 35),
    frame_background = Color(25, 25, 25),
    panel_background = Color(35, 35, 35),
    
    text_header = Color(255, 255, 255),
    text_main = Color(220, 220, 220),
    text_placeholder = Color(160, 160, 160),

    sidebutton_dull = Color(200, 200, 200),
    sidebutton_highlight = Color(255, 255, 255),
    sidebutton_highlightbg = Color(111, 150, 127, 45),
    sidebutton_highlightbg2 = Color(44, 66, 61, 0),
    
    divider = Color(59, 59, 59),
    divider_faded = Color(59, 59, 59, 60),

    scroll_bg = Color(200, 200, 200, 0),
    scroll_grip = Color(100, 100, 100),

    switch_bg = Color(120, 120, 120),
    
    input_bg = Color(39, 39, 39),
    input_bg_dim = Color(28, 28, 28),

    text_entry_border_inactive = Color(56, 56, 56),
    text_entry_border_active = Color(134, 168, 148),
    
    player_card_border = Color(68, 68, 68),
    player_card_bg = Color(35, 35, 35),

    button_base = Color(68, 95, 80),
    button_hover = Color(95, 119, 105),
    button_text = Color(255, 255, 255),
    button_faded = Color(0, 0, 0, 100),
    
    icon_button_base = Color(220, 220, 220),
    icon_button_hover = Color(127, 192, 154),

    button_warn_base = Color(148, 63, 63),
    button_warn_hover = Color(206, 85, 85),

    active_warning = Color(255, 50, 50),
    expired_warning = Color(235, 215, 215),

    yaws = Color(130, 185, 152),
}



-- don't touch down here tho
function YAWS.UI.UseDarkTheme() 
    return YAWS.UserSettings.GetValue("dark_mode")
end 
function YAWS.UI.ColorScheme() 
    return YAWS.UserSettings.GetValue("dark_mode") && YAWS.UI.ColorCache.Dark || YAWS.UI.ColorCache.Light
end 