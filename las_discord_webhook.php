<?php
    // The reason you need to use a proxy website, is due to discord blocking all requests from Garry's Mod due to spam.
    $LASWebHook = Array();



    // Configuration.

    // The title for all the messages.
    $LASWebHook['title'] = "Livaco's Admin System Logging";

    // The URL for your webhook
    $LASWebHook['webhookurl'] = "https://discordapp.com/api/webhooks/1234567891011121314/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-aaaaaaaaaaaaaaaaaaaaaaaaaa";

    // The password. This needs to be the same specified in the sv_discord.lua file.
    $LASWebHook['password'] = "super_secret_password";

    // The HEX code to be used at the side. DO NOT ADD THE #. Note that if this is set to false, it will use the modules color.
    $LASWebHook['color'] = false;

    // Don't touch ANY of the rest of this file.


    if(!isset($_POST['message']) || !isset($_POST['module']) || !isset($_POST['password'])) {
        die("No Message/Module/Module Description/Password set.");
    } else {
        $module = $_POST['module'];
        $message = $_POST['message'];
        $password = $_POST['password'];
        if($LASWebHook['password'] != $password) {
            die("Invalid Password.");
        }

        $color = $_POST['override_color'];
        if($LASWebHook['color'] != false) {
            if(!isset($_POST['override_color'])) {
                $color = $LASWebHook['color']; // Since there is no other choice set.
            } else {
                $color = $LASWebHook['color'];
            }
        }

        $hookObject = json_encode([
            "embeds" => [
                [
                    "title" => $LASWebHook['title'],
                    "type" => "rich",
                    "description" => $message,
                    "color" => hexdec($color),
                    "timestamp" => date("c"),
                    "footer" => [
                        "text" => $module
                    ]
                ]
            ]
        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE );
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $LASWebHook['webhookurl'],
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $hookObject,
            CURLOPT_HTTPHEADER => [
                "Length" => strlen($hookObject),
                "Content-Type" => "application/json"
            ]
        ]);
        $response = curl_exec($ch);
        curl_close($ch);
    }
?>