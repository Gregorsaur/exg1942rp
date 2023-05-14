function SCHEMA:LoadNutFonts(font, genericFont)
    surface.CreateFont("MAIN_Font32", {
        font = "Roboto Condensed",
        extended = false,
        size = 24,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })

    surface.CreateFont("MAIN_Font24", {
        font = "Roboto",
        extended = false,
        size = 24,
        weight = 0,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })
end