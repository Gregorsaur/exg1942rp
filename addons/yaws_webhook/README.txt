This folder contains the relay the Discord Webhook system uses. These exact files are hosted already for free on my website, and is the default config of YAWS.
You only need this folder if you are self-hosting your relay. If you're using my relay, using CHTTP, or not even enabling Discord Webhook's, you don't need this.

To install this: 
> Drag 'n drop the files here into a PHP webserver. No need for composer install, it's already done as the dependencies are lightweight.
    - PHP Version should be as latest as possible, preferably >= 7.0
> Open webhook.php, and change $password to be something secure.
    - Take the default value as an example of how secure we're talking here. Something as hard to brute-force as possible.
> Go into sv_discord.lua on the addon itself, and ensure your method is set to the RELAY option.
> Scroll down in that file, and set the Relay URL to your website's webhook.php file, e.g https://www.judyishot.com/yaws/webhook.php
> Ensure the password is set to the same as the webhook.

Done!
If you still require help, make a ticket or join my discord server and I'll talk you through it myself :)