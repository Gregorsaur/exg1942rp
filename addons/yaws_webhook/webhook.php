<?php 
//
// Yet Another Warning System
//       Discord Relay
//

// This is for the people that can't/won't install chttp for whatever reasons
// you have. 
// Chuck this on a PHP Webserver, set the URL in the server config along with the
// same password, and you're away.

// For those who are just opening all the files before installing the addon: You
// don't actually NEED to use this. If you want you can use the one already
// provided curtesy of the chad himself, Livaco :) 
// This is here for the security freaks that don't trust me, or for the ones
// that want to customise it with blackjack and hookers.


// Set the password down here. Make sure this is the same on the server or else
// it'll fail! Ensure to escape any chars needed.
$password = "taDyq2HEt@RvtEk#^Nmz\$B3o#Gaif##R4bk\$V4oz&LXh%xmMNm2N@Ptu7RdPGDX3v!4YCL6%t7jock2@ENYWwzjykPxMa9Fydn9PevSkKghHC*TKv6xCqGSB65rD&AhF";

// And that's it. :)











// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// WARNING :: THE FOLLOWING CONTAINS TRACES OF NERD ASS CODE NOT FOR THE NORMAL HUMANS EYES :: WARNING
// (i mean it's really simple code tho)


require_once __DIR__ . '/vendor/autoload.php';
// the satisfaction of using your own library to speed things up is weirdly nice
use Livaco\EasyDiscordWebhook\DiscordWebhook;

header('Content-Type: application/json; charset=utf-8');

// The authorization/password stuff
if(!isset($_SERVER['HTTP_AUTHORIZATION'])) {
    http_response_code(401);
    // yes im using hard-coded json responses - suck my d
    die('{"code":401,"message":"Unauthorized."}');
}
$token = $_SERVER['HTTP_AUTHORIZATION'];
if($token != $password) {
    http_response_code(403);
    die('{"code":403,"message":"Forbidden."}');
}

// Passed auth - now check they have everything they need in the body 
// This way of doing it probably sucks but I would prefer this over if $_POST['title'] 500 times
$missing = [];
$required = [
    'webhookURL',
    'title', 
    'description',
    'color',
    'emojiTime',
    'targetName',
    'targetSteamID',
    'adminName',
    'adminSteamID',
    'points',
    'reason',
    'server'
];
foreach($required as $r) {
    if(!isset($_POST[$r])) {
        $missing[] = $r;
    }
}
if(count($missing) > 0) {
    http_response_code(400);
    die('{"code":400,"message":"Request is missing required fields: ' . implode(', ', $missing) . '"}');
}

// Now we have everything we can construct our webhook.
// If your curious on how to use this if your wanting to customse it, take a
// peep at https://github.com/LivacoNew/EasyDiscordWebhook 
// or if you've got a super duper fancy ass smart ide, ctrl click on the
// functions to view their source/phpdoc n shit 
$webhook = new DiscordWebhook($_POST['webhookURL']);
$webhook->setTitle($_POST['title']);
$webhook->setDescription($_POST['description']);
$webhook->addField(($_POST['emojiTime'] ? "🧑 " : "") . "Player", $_POST['targetName'] . "(" . $_POST['targetSteamID'] . ")", true);
$webhook->addField(($_POST['emojiTime'] ? "👮 " : "") . "Admin", $_POST['adminName'] . "(" . $_POST['adminSteamID'] . ")", true);
$webhook->addField(($_POST['emojiTime'] ? "❌ " : "") . "Points", $_POST['points'], true);
$webhook->addField(($_POST['emojiTime'] ? "📝 " : "") . "Reason", $_POST['reason'], false);
$webhook->setTimestamp(date("c")); // "it'll be fine" - livaco 2021
$webhook->setColor(dechex($_POST['color'])); // damn me
$webhook->setFooter($_POST['server']);

$webhook->sendWebhook();
http_response_code(200);
die('{"code":200,"message":"Successful."}');