-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/7624

POLAROID_CONFIG.Host = "https://uguu.se/upload.php" -- hosting for photos (known free hosts: https://uguu.se/upload.php) want to selfhost it? https://github.com/pomf/pomf
POLAROID_CONFIG.Language = "en" --[[ default langs:
	en (english)
	ru (russian - русский)
	fr (french - français)
	tr (turkish - türk)
	es (spanish - español)
	uk (ukrainian - український)

	if you enter an unknown language, then the default (english) will be selected
	wanna make translation? create pr on https://github.com/Be1zebub/Gmodstore-Polaroid-Configuration-files or dm me on gmodstore https://www.gmodstore.com/users/beelzebub
]]--

POLAROID_CONFIG.EnableEditor = true -- true/false

POLAROID_CONFIG.CartrigeSize = 3 -- Count of "polaroid ammo". also when using the `polaroid_cartridge` entity "polaroid ammo" will be filled up to this number (cartridge changed).
POLAROID_CONFIG.InfinityPhotos = false -- true or false (ignores "polaroid ammo" count, take as many photos as you wish)
POLAROID_CONFIG.PhotoQuality = 70 -- number 0-100

POLAROID_CONFIG.AutoRemovePhotos = true -- enable automatic photo removing (does not affects on framed photos)
POLAROID_CONFIG.AutoRemovePhotosTime = 60 * 5 -- seconds

-- stickers for image editor (a menu designed for photo editing that opens immediately after taking a photo)
POLAROID_CONFIG:AddStickers("Neko", { -- Sticker-pack name
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_gasm.png", -- sticker image url (you can upload your custom stickers on imgur.com)
		name = "Neko GASM" -- sticker name
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_hehe.png",
		name = "Neko HeHe"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_lul.png",
		name = "Neko LUL"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_ok.png",
		name = "Neko OK"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_pog.png",
		name = "Neko POG"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/neko/neko_smart.png",
		name = "Neko Smart"
	}
}, function(ply) -- customcheck (to allow stickers using only for admins, donators, specific jobs, etc...)
	if ply.IsVIP then
		return ply:IsVIP()
	end

	return true
end)

POLAROID_CONFIG:AddStickers("Pepe", {
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/pepe/pepe_batya.png",
		name = "Pepe Batya"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/pepe/pepe_ok.png",
		name = "Pepe OK"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/pepe/pepe_retard.png",
		name = "Pepe Retard"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/pepe/pepe_roflan.png",
		name = "Pepe KEKW"
	}
})

POLAROID_CONFIG:AddStickers("Roflan", {
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/bless_rng.png",
		name = "Bless RNG"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_buldiga.png",
		name = "Roflan Buldiga"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_chelik.png",
		name = "Roflan Chelik"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_dodik.png",
		name = "Roflan Dodik"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_dovolen.png",
		name = "Roflan Dovolen"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_dulka.png",
		name = "Roflan Dulka"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_ebalo.png",
		name = "Roflan Ebalo"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_hmm.png",
		name = "Roflan Hmm"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_koronniy.png",
		name = "Roflan Koronniy"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_old.png",
		name = "Roflan OLD"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_rabotyaga.png",
		name = "Roflan Rabotyaga"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_thinking.png",
		name = "Roflan Thinking"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_tsar.png",
		name = "Roflan Tsar"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_vglorius.png",
		name = "Roflan Vglorius"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_wtf_ebat.png",
		name = "Roflan WTF Ebat"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/roflan/roflan_zdarova.png",
		name = "Roflan Zdarova"
	}
})

POLAROID_CONFIG:AddStickers("Twitch", {
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/cool_story_bob.png",
		name = "Coolstorybob"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/facepalm.png",
		name = "Facepalm"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/gachi_surprised.png",
		name = "Gachi Surprised"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/kappa.png",
		name = "Kappa"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/pogchamp.png",
		name = "Pogchamp"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/press_f.png",
		name = "Press F"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/prolapsus.png",
		name = "Prolapsus"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/roflan_hmm_papa.png",
		name = "Roflan Hhmm papa"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/roflan_yasno.png",
		name = "Roflan Yasno"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/roll_safe.png",
		name = "Rollsafe"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/twitch/seemsgood.png",
		name = "Seems Good"
	}
})

POLAROID_CONFIG:AddStickers("Vk", {
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_dogich.png",
		name = "Dogich"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_ebashu.png",
		name = "Ebashu"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_kleva.png",
		name = "Kleva"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_oru.png",
		name = "Oru"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_pukich.png",
		name = "Pukich"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_pukich_two.png",
		name = "Pukech"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_usach.png",
		name = "Mustache"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_wtf.png",
		name = "WTF"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/roflan_zloy.png",
		name = "Zloy"
	},
	{
		url = "https://incredible-gmod.ru/gmodstore/polaroid/stickers/vk/sad_microchelik.png",
		name = "Sad Microchelik"
	}
})

hook.Run("Polaroid/ConfigLoaded") -- do not touch this line!