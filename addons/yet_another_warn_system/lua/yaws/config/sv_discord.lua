---------------------------------------------------------------------------------------------------
-- This file is for the Discord Webhook. In case you want an explanation, the Discord Webhook will post to your Discord server
-- whenever a player is warned. It can be used to publically show off your warns, or to keep a private log inside a staff
-- only channel. Either way, this is how you do it.
---------------------------------------------------------------------------------------------------


-- This enables Discord Webhooks.
-- Default: false
YAWS.ManualConfig.Discord.Enabled = true


-- A while ago, some dubmass got all requests from the Garry's Mod HTTP library blocked by Discord, so we have to use a workaround.
-- There's two options, either work, just the method to get them is different:
--    > Use CHTTP. This is a module that is a drop in replacement for the default HTTP library, and isn't blocked by discord.
--    > Use a PHP relay. The addon sends a request to a website that posts the webhook for us. I can host this file for you, 
--      or you can host it yourself. 
--
-- Both will have the same functionality. The only difference is how you install them. CHTTP requires installing a module. 
-- If your host doesn't allow that, or you don't like installing random DLLs off the internet (like me), you can opt for the
-- relay option. Relay is free to use from me, but you can also self-host if you want to (that's the yaws_webhook folder you 
-- got when you downloaded the addon!)

-- Choose which one your using down here.
-- Put in either "CHTTP" or "RELAY".
-- Default: RELAY
YAWS.ManualConfig.Discord.Method = "RELAY"

-- IF YOU OPTED FOR CHTTP:
--    > You will need to install the CHTTP module from here: https://github.com/timschumi/gmod-chttp
--    > If you need help, follow the installation guide in the README.
--    > If your host doesn't allow installation of DLLs, contact them and request them to add it. If they refuse, go for the 
--      relay instead.
--
-- IF YOU OPTED FOR THE RELAY:
--    > Type in below where the request will be going. If you want to host it yourself, upload it and type it in here (get 
--      someone who knows what they're doing to do it!)
--    > This only should be edited if you are self-hosting. If you're using my free relay, leave this alone.
YAWS.ManualConfig.Discord.RelayURL = "https://api.livaco.dev/yaws/webhook.php"
--    > Now, you need a "password". This is so the relay knows the request came from the server and not some random knob living 
--      in his mums basement.
--    > This MUST be the same as the password set in your webhook.php file, otherwise the webhook will reject every request.
--    > This must be as secure as possible to prevent bruteforcing.
--    > This only should be edited if you are self-hosting. If you're using my free relay, leave this alone.
YAWS.ManualConfig.Discord.Password = "taDyq2HEt@RvtEk#^Nmz$B3o#Gaif##R4bk$V4oz&LXh%xmMNm2N@Ptu7RdPGDX3v!4YCL6%t7jock2@ENYWwzjykPxMa9Fydn9PevSkKghHC*TKv6xCqGSB65rD&AhF"



-- Cool, assuming you've typed everything in correctly your webhook workaround should now be working properly.
-- Now we just need to set up the webhook itself. This isn't as bad as above luckly.



-- The webhook URL that was generated. If you don't know what this should be, follow the knowledgebase guide.
-- https://www.gmodstore.com/help/addon/713165594686816257/installation-setup-2/topics/discord-relay
YAWS.ManualConfig.Discord.WebhookURL = "https://discord.com/api/webhooks/1034740549929926686/Pg8kKo7YGfsazNjLiUj9LNiy1zIhFfYc2JCv5qMlNyIjAADC-gkNehiaAUuXboPfMt4E"

-- The color the side bar thingy should be.
-- Default: Color(83, 182, 155)
YAWS.ManualConfig.Discord.EmbedColor = Color(83, 182, 155)

-- The title/description of the embed.
-- Default: Player Warned 
YAWS.ManualConfig.Discord.EmbedTitle = "Player Warned"
-- Default: A player has been warned.
YAWS.ManualConfig.Discord.EmbedDescription = "A player has been warned."

-- If the embed should use emojis 
-- Default: true
YAWS.ManualConfig.Discord.UseEmojis = true

-- Print debug info. Enable this if no webhook errors are appearing in your server console but you still aren't 
-- getting anything in your webhook, as it will tell you what's wrong.
-- Default: false
YAWS.ManualConfig.Discord.Debug = false