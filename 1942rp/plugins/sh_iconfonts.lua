PLUGIN.name = "Font Icons"
PLUGIN.desc = "Easy way to get the right character for the right icon"
PLUGIN.author = "It's A Joke"
--resource
resource.AddFile("resource/fonts/wolficonfont.ttf")

--Creating tables and the library
ICON = {}
ICON.font = "wolficonfont"
ICON.characters = {
  trash = "-",
  male = "a",
  female = "b",
  bank = "d",
  tick = "e",
  phone = "CALL",
  hamburger = "g"
}

function ICON:GetIconChar(iconDesc)
  return self.characters[iconDesc] or "nil"
end

if CLIENT then
  surface.CreateFont("wolficon_normal", {
    font = ICON.font,
    size = 25,
    weight = 400,
    antialias = true
  })

  surface.CreateFont("wolficon_small", {
    font = ICON.font,
    size = 18,
    weight = 400,
    antialias = true
  })

  surface.CreateFont("wolficon_big", {
    font = ICON.font,
    size = 34,
    weight = 400,
    antialias = true
  })

  surface.CreateFont("wolficon_enormous", {
    font = ICON.font,
    size = 50,
    weight = 400,
    antialias = true
  })
end


