
<div align="center">
<img src="https://github.com/user-attachments/assets/ada6c9b1-d30f-464b-9886-eab7e70188f7" width="300" />
</div>




# 🛠️ دیجیتال وی پی اس ToolBox

این اسکریپت توسط تیم [DigitalVPS.ir](https://client.digitalvps.ir) با هدف ساده‌سازی فرآیند تنظیم مقدار **MTU** در سیستم‌عامل‌های لینوکسی توسعه داده شده است.  
توسعه‌دهنده: [ParsaKSH](https://github.com/ParsaKSH)

---

## 📌 MTU چیست؟

> **MTU (Maximum Transmission Unit)** به بیشترین اندازه‌ی ممکن برای ارسال یک بسته‌ی شبکه بدون نیاز به تکه‌تکه شدن (fragmentation) گفته می‌شود.

در صورتی که مقدار MTU به‌درستی تنظیم نشده باشد، مشکلاتی مانند موارد زیر ممکن است رخ دهد:
- کاهش سرعت انتقال داده‌ها 🐢
- عدم پاسخ به برخی درخواست‌های پینگ ❌
- بروز خطا در ارتباطات VPN و برخی نرم‌افزارهای حساس به شبکه 🔐

---

## 🎯 قابلیت‌های اسکریپت

- 🔍 شناسایی خودکار بهترین مقدار MTU با استفاده از دستور `ping -M do`
- ✏️ امکان وارد کردن مقدار دلخواه MTU به صورت دستی
- ⚙️ اعمال مقدار MTU به صورت موقت (session-based)
- 📝 ذخیره تنظیمات به‌صورت دائمی در فایل‌های `netplan` یا `/etc/network/interfaces`


---

<details>
<summary>💼 سیستم‌های پشتیبانی‌شده</summary>

- Ubuntu 18.04 و نسخه‌های جدیدتر  
- Debian و سایر توزیع‌های مبتنی بر آن  
- سایر سیستم‌هایی که از ابزارهای `ip`, `ping`, `grep` پشتیبانی می‌کنند
</details>

---

## 🧪 دستور اجرای اسکریپت(کاربر روت):

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Digitalvps-Ir/Digitalvps-Toolbox/main/script.sh)
```
---
## <img src="https://client.digitalvps.ir/templates/lagom2/assets/img/logo/logo_big.1066038415.png" width="34" /> خرید سرور ایران و خارج با کیفیت بالا و پورت 10Gb/s

اگر برای راه‌اندازی تونل‌ها و زیرساخت‌های اینترنتی به یک سرور قدرتمند، پایدار و به‌صرفه نیاز دارید، **DigitalVPS** انتخابی شایسته است.

🔹 ارائه سرورهای مجازی ایران از شرکت‌های معتبر(لینک اختصاصی و با کیفیت):
- **رسپینا** <img src="https://client.digitalvps.ir/templates/lagom2/assets/img/page-manager/Respina-Logo.png" width="34" /> (پیشنهاد توسعه‌دهنده)
-  شاتل <img src="https://client.digitalvps.ir/templates/lagom2/assets/img/page-manager/shatel1.png" width="24" />
-  مبین‌نت <img src="https://client.digitalvps.ir/Logo/MobinNetLog.png" width="24" />

🔹 سرور های مجازی خارج از دیتاسنتر های ***Leaseweb*** ، ***Skylink*** و ***OVH***

- سرور مجازی هلند <img src="https://client.digitalvps.ir/templates/lagom2/assets/img/nilogo.png" width="24" />
- سرور مجازی آلمان <img src="https://client.digitalvps.ir/templates/lagom2/assets/img/page-manager/GB.svg" width="24" />

✨ ویژگی‌ها:
- **پینگ پایین به ترکیه و اروپا**
- **IPv6 استیبل**
- کیفیت بسیار بالا و قیمت پایین 💰
- آپتایم 99.9%

🎯 با خیال آسوده پروژه‌ی خود را روی زیرساختی مطمئن بنا کنید.

📎 می‌توانید از طریق لینک زیر اقدام به ثبت نام و خرید کنید:  
👉 [https://client.digitalvps.ir](https://client.digitalvps.ir)

---





با آرزوی پیروزی و شادکامی برای شما

تیم [DigitalVPS.ir](https://client.digitalvps.ir) ❤️



[DigitalVPS Telegram Group](t.me/digitalvps_group)

[OP-IRAN Telegram Group](t.me/OPIranClub)


