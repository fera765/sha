## Shadow socks with V2Ray

### Heroku autodeploy + tg notification with connection details

---

1. Create a bot using [@BotFather](https://telegram.me/BotFather), get it's token
2. Start conversation with bot
3. Go to [@getmyid_bot](https://telegram.me/getmyid_bot) and obtain your account id or run following curl command

```
curl https://api.telegram.org/bot<TO:KEN>/getUpdates | grep -Po '"from":{"id":.+?,'
```

4. Open url below, replace ACC_NAME and REPO_NAME with your own

```
https://heroku.com/deploy?template=https://github.com/ACC_NAME/REPO_NAME/tree/main
```

For this repo it will be

###### please don't use this repo

```
https://heroku.com/deploy?template=https://github.com/SanariSan/sharoku/tree/main
```

5. Fill in all required fields, for example

```
AppName - super-secret-name
ENCRYPT - chacha20-ietf-poly1305
PASSWORD - dontpwnme
TG_BOT_TOKEN - token_from:step_1
TG_CHAT_ID - id_from_step_3
```

6. Click `Deploy app`

7. Wait for connection information to come to you from bot in telegram

8. Open your shadowsocks app with V2Ray plugin installed and scan `qr`/paste `ss` string

9. Stop and block bot, otherwise it will send you same info on each vps dyno startup

---

#### Looking for some examples on curl bot interaction?

#### Check out [this gist](https://gist.github.com/SanariSan/4c7cca1aef10dfe0e27e55cfd97e9a53)
