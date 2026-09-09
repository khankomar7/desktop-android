<div align="center">

# 🖥️ Claude Remote Desktop

A full Ubuntu XFCE desktop, streamed to your browser (works on desktop and mobile), with **Claude Desktop** and **Claude Code** preinstalled — ready to deploy on [Railway](https://railway.com) or any Docker host.

یک دسکتاپ کامل اوبونتو (XFCE) که از طریق مرورگر قابل استفاده‌ست (روی موبایل هم کار می‌کنه)، به‌همراه نصب از پیش انجام‌شده‌ی **Claude Desktop** و **Claude Code** — آماده برای دیپلوی روی [Railway](https://railway.com) یا هر هاست داکری دیگه.

[Deploy on Railway](#-deploy-on-railway--دیپلوی-روی-railway) · [Local Setup](#-run-locally--اجرای-لوکال) · [Performance Tuning](#️-performance-tuning--بهینه‌سازی-روانی)

![License](https://img.shields.io/badge/license-MIT-blue) ![Base](https://img.shields.io/badge/base-linuxserver%2Fwebtop-informational) ![Platform](https://img.shields.io/badge/platform-Railway%20%7C%20Docker-8A2BE2) ![Claude](https://img.shields.io/badge/includes-Claude%20Desktop%20%26%20Code-orange)

</div>

---

## 📑 Contents / فهرست

- [Features](#-features--امکانات)
- [Deploy on Railway](#-deploy-on-railway--دیپلوی-روی-railway)
- [Run locally](#-run-locally--اجرای-لوکال)
- [First-time setup](#️-first-time-setup-inside-the-desktop--راه‌اندازی-اولیه-داخل-دسکتاپ)
- [Performance tuning](#️-performance-tuning--بهینه‌سازی-روانی)
- [Project structure](#-project-structure--ساختار-پروژه)

---

## ✨ Features / امکانات

- Full Linux desktop accessible from any browser (built on [linuxserver/webtop](https://github.com/linuxserver/docker-webtop))
  دسکتاپ کامل لینوکس، قابل دسترسی از هر مرورگری
- Claude Desktop preinstalled via Anthropic's official apt repository
  Claude Desktop از قبل نصب‌شده، از طریق ریپازیتوری رسمی Anthropic
- Claude Code (CLI) preinstalled via npm
  Claude Code (خط فرمان) از قبل نصب‌شده
- Works well on mobile browsers (Chrome/Firefox on Android/iOS)
  روی مرورگر موبایل هم به‌خوبی کار می‌کنه

---

## 🚀 Deploy on Railway / دیپلوی روی Railway

1. Push this repo to your GitHub account.
   این ریپو رو به گیت‌هاب خودت پوش کن.
2. In Railway: **New Project → Deploy from GitHub repo** → select this repo.
   توی Railway: **New Project → Deploy from GitHub repo** رو بزن و این ریپو رو انتخاب کن.
3. Railway detects the `Dockerfile` automatically and builds it.
   Railway خودش Dockerfile رو تشخیص می‌ده و بیلد می‌کنه.
4. Go to **Settings → Networking → Generate Domain**, and set the port to **3000**.
   برو به **Settings → Networking → Generate Domain**، و پورت رو **3000** بذار.
5. Open the generated `*.up.railway.app` URL — you'll land on the desktop.
   دامنه‌ی تولیدشده رو باز کن — دسکتاپ رو می‌بینی.

### ⚠️ Cost note / نکته‌ی هزینه

This is a resource-heavy service (continuous video streaming), not a lightweight web app. Running it 24/7 on Railway's usage-based billing can cost noticeably more than the $5 Hobby plan minimum.

این یه سرویس سنگینه (استریم مداوم ویدیو)، نه یه اپ وب سبک. اجرای ۲۴/۷ اون روی صورت‌حساب مصرف‌محور Railway می‌تونه به‌مراتب بیشتر از حداقل ۵ دلار پلن Hobby هزینه داشته باشه.

**Recommendations / پیشنهادها:**
- Set a **Hard Limit** under `Settings → Usage Limits` to avoid surprise bills.
  توی `Settings → Usage Limits` یه **سقف هزینه** بذار.
- If you don't need it always-on, enable **Serverless** (sleeps after 10 min idle, wakes on demand).
  اگه نیازی به روشن بودن دائمی نداری، **Serverless** رو فعال کن (بعد از ۱۰ دقیقه بی‌فعالیتی می‌خوابه).

---

## 💻 Run locally / اجرای لوکال

```bash
git clone https://github.com/<your-username>/claude-remote-desktop.git
cd claude-remote-desktop
docker compose up -d --build
```

Then open **http://localhost:3000** in your browser.
بعد **http://localhost:3000** رو توی مرورگر باز کن.

---

## 🖥️ First-time setup inside the desktop / راه‌اندازی اولیه داخل دسکتاپ

1. Open the app launcher (sidebar → **Apps → Manage Apps**) and click **Claude Desktop**.
   لانچر برنامه‌ها رو باز کن (پنل کناری → **Apps → Manage Apps**) و روی **Claude Desktop** بزن.
2. Sign in with your Anthropic / Claude.ai account.
   با حساب Anthropic / Claude.ai وارد شو.
3. To use Claude Code instead, open a terminal and run:
   برای استفاده از Claude Code، یه ترمینال باز کن و بزن:
   ```bash
   claude
   ```

---

## ⚙️ Performance tuning / بهینه‌سازی روانی

**These optimizations are already baked into the Dockerfile as defaults** — no manual panel tweaking needed:
**این بهینه‌سازی‌ها از قبل به‌صورت مقادیر پیش‌فرض توی Dockerfile تنظیم شدن** — نیازی به تنظیم دستی از پنل نیست:

| Variable | Default | Why |
|---|---|---|
| `MAX_RES` | `1920x1080` | Clamps the virtual display — the base image defaults to a wasteful 16K canvas |
| `SELKIES_ENCODER` | `x264enc-striped` | Low-latency video encoder, smoother than the default JPEG fallback |
| `SELKIES_FRAMERATE` | `30` | Caps FPS — lower uses less bandwidth/CPU, feels smoother on weak connections |
| `SELKIES_H264_CRF` | `28` | Quality/size tradeoff — higher = smaller & faster, lower = sharper |

Override any of them anytime, either in `docker-compose.yml` or as Railway service variables (**Variables** tab). If streaming still feels laggy:
هر کدوم رو هر وقت خواستی می‌تونی override کنی، چه توی `docker-compose.yml` چه به‌عنوان متغیر محیطی توی Railway (تب **Variables**). اگه بازم استریم کند بود:

- Turn off audio capture if you don't need it (`SELKIES_AUDIO_ENABLED=false`).
  اگه لازم نداری، ضبط صدا رو خاموش کن.
- Increase allocated CPU/RAM on Railway (Hobby plan supports up to 8 vCPU / 8 GB RAM per service).
  منابع CPU/RAM اختصاص‌یافته روی Railway رو بیشتر کن.

---

## 📁 Project structure / ساختار پروژه

```
.
├── Dockerfile          # Image definition (webtop + Claude Desktop + Claude Code)
├── docker-compose.yml  # Local testing
├── .gitignore
└── README.md
```

---

## 📜 License

MIT — use freely, no warranty.
