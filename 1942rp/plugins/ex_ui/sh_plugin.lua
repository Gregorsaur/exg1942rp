local PLUGIN    = PLUGIN
PLUGIN.name     = 'External Gaming UI'
PLUGIN.author   = 'Bilwin'
PLUGIN.websiteURL = 'https://externalgaming.noclip.me/'
PLUGIN.discordURL = 'https://discord.gg/externalgaming'
PLUGIN.backgrounds = {
    nut.util.getMaterial('external_g/bg1.png'),
    nut.util.getMaterial('external_g/bg2.png'),
    nut.util.getMaterial('external_g/bg3.png'),
    nut.util.getMaterial('external_g/bg4.png')
}

nut.util.includeDir(PLUGIN.path .. '/derma/steps', true)
nut.util.includeDir(PLUGIN.path .. '/new_derma', true)

function LerpColor(frac, from, to)
	local col = Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
    )

	return col
end

nut.config.add(
	'music',
	'music/hl2_song2.mp3',
	'The default music played in the character menu.',
	nil,
	{category = PLUGIN.name}
)

nut.config.add(
	'musicvolume',
	'0.25',
	'The Volume for the music played in the character menu.',
	nil,
	{
		form = 'Float',
		data = {min = 0, max = 1},
		category = PLUGIN.name
	}
)

if CLIENT then
    local function _SScale(size)
        return size * (ScrH() / 900) + 10
    end

    function PLUGIN:LoadFonts(font)
        surface.CreateFont('nutCharTitleFont', {
            font = font,
            weight = 200,
            size = _SScale(70),
            additive = true
        })

        surface.CreateFont('nutCharDescFont', {
            font = font,
            weight = 200,
            size = _SScale(24),
            additive = true
        })

        surface.CreateFont('nutCharSubTitleFont', {
            font = font,
            weight = 200,
            size = _SScale(12),
            additive = true
        })

        surface.CreateFont('nutCharButtonFont', {
            font = font,
            weight = 200,
            size = _SScale(24),
            additive = true
        })

        surface.CreateFont('nutCharSmallButtonFont', {
            font = font,
            weight = 200,
            size = _SScale(22),
            additive = true
        })

        surface.CreateFont('nutEgMainMenu', {
            font        = 'Open Sans',
            extended    = true,
            size        = SScale(12),
            weight      = 500,
            antialias   = true
        })
    end

    function PLUGIN:NutScriptLoaded()
        vgui.Create('nsNewCharacterMenu')
    end

    function PLUGIN:KickedFromCharacter(id, isCurrentChar)
        if isCurrentChar then
            vgui.Create('nsNewCharacterMenu')
        end
    end

    function PLUGIN:CreateMenuButtons(tabs)
        tabs['characters'] = function(panel)
            if IsValid(nut.gui.menu) then
                nut.gui.menu:Remove()
            end

            vgui.Create('nsNewCharacterMenu')
        end
    end
end

if SERVER then
    resource.AddWorkshop('2884226192')
end