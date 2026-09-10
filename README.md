# Claude Remote Desktop

یک دسکتاپ Ubuntu XFCE که از طریق مرورگر قابل استفاده است و Claude Desktop و Claude Code را در اختیار می‌گذارد. این پروژه بر پایه‌ی [`linuxserver/webtop`](https://github.com/linuxserver/docker-webtop) ساخته شده و برای اجرای Docker و Railway طراحی شده است.

> **وضعیت پروژه:** در حال توسعه. قبل از انتشار عمومی، احراز هویت و HTTPS را تنظیم کنید.

## قابلیت‌ها

- دسکتاپ XFCE در مرورگر دسکتاپ و موبایل
- تمرکز اصلی روی گوشی‌های Android با لمس، trackpad مجازی و keyboard روی صفحه
- Claude Desktop از مخزن رسمی Anthropic
- Claude Code از npm
- نگهداری تنظیمات و home در volume مسیر `/config`
- پروفایل کیفیت بالاتر برای دسکتاپ و پروفایل سبک‌تر برای موبایل

## پیش‌نیاز مهم معماری

Claude Desktop در حال حاضر بسته‌ی Linux برای `amd64` ارائه می‌کند. این پروژه عمداً برای `linux/amd64` تنظیم شده است. اجرای آن روی ARM فقط با emulation و با افت عملکرد احتمالی انجام می‌شود و پشتیبانی رسمی محسوب نمی‌شود.

## اجرای محلی امن

```bash
cp .env.example .env
# مقدار WEBTOP_PASSWORD را در .env به یک رمز طولانی و تصادفی تغییر دهید.
docker compose up -d --build
```

برای بازکردن محیط توسعه با پورت‌های فقط-localhost و تنظیمات سبک‌تر موبایل:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

- حالت عادی: `https://localhost:3001`
- حالت توسعه: `https://localhost:3001` و در صورت نیاز `http://localhost:3000`
- گواهی HTTPS پیش‌فرض self-signed است و ممکن است مرورگر هشدار نشان دهد.

فایل `.env` و مسیر `config/` نباید commit شوند.

## تنظیمات اصلی

| متغیر | مقدار پیش‌فرض | توضیح |
|---|---:|---|
| `WEBTOP_USER` | اجباری | نام کاربر webtop |
| `WEBTOP_PASSWORD` | اجباری | رمز ورود؛ در Git قرار نگیرد |
| `MAX_RES` | `1920x1080` | حداکثر رزولوشن دسکتاپ |
| `SELKIES_FRAMERATE` | `30` | تعداد فریم برای stream |
| `SELKIES_H264_CRF` | `28` | مقدار بیشتر یعنی حجم کمتر و کیفیت پایین‌تر |
| `SELKIES_AUDIO_ENABLED` | `false` | ضبط صدا؛ در صورت نیاز فعال شود |
| `CPU_LIMIT` | `2` | سقف CPU کانتینر |
| `MEMORY_LIMIT` | `4G` | سقف RAM کانتینر |

## تنظیمات Android

پروفایل اصلی پروژه از ابتدا برای Android تنظیم شده است. در webtop/Selkies این امکانات برای گوشی نگه داشته شده‌اند:

- **Trackpad mode** برای حرکت نرم‌تر و نسبی موس با یک انگشت
- **Direct touch mode** برای برنامه‌های لمسی
- **On-screen keyboard** برای تایپ بدون کیبورد فیزیکی
- **Fullscreen** برای بیشترین فضای قابل استفاده
- clipboard متنی برای کپی و paste بین گوشی و دسکتاپ

برای کاهش شلوغی، مصرف اینترنت و سطح حمله، این قابلیت‌ها به‌صورت پیش‌فرض غیرفعال‌اند:

- صدا و میکروفون
- gamepad و gaming mode
- file upload/download
- session sharing و collaboration
- binary clipboard
- نمایشگر دوم
- دکمه‌ها و بخش‌های غیرضروری sidebar

برای حرکت نرم‌تر موس، ابتدا در sidebar حالت **Trackpad** را انتخاب کنید. برای برنامه‌هایی که خودشان touch-friendly هستند، **Direct touch** مناسب‌تر است. در صورت تارشدن متن، از بخش Screen scaling حالت CSS را بررسی کنید؛ این پروژه برای کاهش مصرف دیتا آن را به‌صورت پیش‌فرض فعال کرده است.

برای موبایل یا شبکه‌ی ضعیف، این profile را امتحان کنید:

```env
MAX_RES=1280x720
SELKIES_FRAMERATE=24
SELKIES_H264_CRF=30
SELKIES_AUDIO_ENABLED=false
```

اگر کیفیت بیشتری لازم دارید، فقط این موارد را افزایش دهید:

```env
MAX_RES=1920x1080
SELKIES_FRAMERATE=30
SELKIES_H264_CRF=28
```

افزایش هم‌زمان رزولوشن و frame rate روی اینترنت موبایل، latency و مصرف دیتا را زیاد می‌کند. برای استفاده‌ی روزمره‌ی Android، `1280x720` و ۲۴ فریم نقطه‌ی شروع پیشنهادی هستند.

## Railway و انتشار عمومی

برای Railway، متغیرهای `WEBTOP_USER`، `WEBTOP_PASSWORD` و تنظیمات عملکرد را در بخش **Variables** وارد کنید؛ آن‌ها را داخل repository قرار ندهید.

پورت HTTPS داخلی سرویس `3001` است. اگر از دامنه‌ی عمومی استفاده می‌کنید:

1. احراز هویت را اجباری نگه دارید.
2. ترجیحاً سرویس را پشت Reverse Proxy با TLS معتبر قرار دهید.
3. پورت HTTP یعنی `3000` را مستقیماً عمومی نکنید.
4. WebSocket را فعال و proxy buffering را خاموش کنید.
5. قابلیت‌های غیرفعال‌شده‌ی Android مانند file transfer و sharing را فقط در صورت نیاز و با آگاهی از ریسک فعال کنید.
6. برای Railway سقف هزینه و resource limit تعیین کنید؛ این سرویس به‌دلیل encoding مداوم سبک نیست.

webtop یک محیط دسکتاپ کامل با terminal و `sudo` بدون رمز داخل کانتینر فراهم می‌کند. بنابراین انتشار بدون سخت‌سازی مناسب خطرناک است. جزئیات بیشتر در [SECURITY.md](SECURITY.md) آمده است.

## توسعه و CI

فایل `.github/workflows/ci.yml` در هر push و pull request، Compose را validate می‌کند، image amd64 را build می‌کند و repository را برای secretهای accidentally committed اسکن می‌کند.

برای مشاهده‌ی لاگ‌ها:

```bash
docker compose logs -f desktop
```

برای توقف سرویس:

```bash
docker compose down
```

## ساختار پروژه

```text
.
├── Dockerfile
├── docker-compose.yml
├── docker-compose.dev.yml
├── .env.example
├── .dockerignore
├── SECURITY.md
├── LICENSE
├── README.md
└── .github/workflows/ci.yml
```

## مجوز

این پروژه تحت مجوز MIT منتشر می‌شود. متن کامل در [LICENSE](LICENSE) قرار دارد.
