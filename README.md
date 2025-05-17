
<div align="center">
<img src="https://github.com/user-attachments/assets/ecb36fe4-7328-4acc-9e83-8325fa479fed" width="300" />
</div>




# 🛠️ ابزار تنظیم MTU برای سرورهای لینوکس

این اسکریپت توسط تیم [DigitalVPS.ir](https://github.com/Digitalvps-Ir) با هدف ساده‌سازی فرآیند تنظیم مقدار **MTU** در سیستم‌عامل‌های لینوکسی توسعه داده شده است.  
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
- 📋 ارائه منوی گرافیکی ترمینالی کاربرپسند

---

<details>
<summary>💼 سیستم‌های پشتیبانی‌شده</summary>

- Ubuntu 18.04 و نسخه‌های جدیدتر  
- Debian و سایر توزیع‌های مبتنی بر آن  
- سایر سیستم‌هایی که از ابزارهای `ip`, `ping`, `grep` پشتیبانی می‌کنند
</details>

---

## 🧪 نحوه اجرا

```bash
bash <(curl -Ls https://raw.githubusercontent.com/Digitalvps-Ir/main-interface-mtu-setter/main/script.sh)
```

🤝 همکاری در توسعه
چنانچه پیشنهاد، گزارش اشکال یا درخواستی برای توسعه این ابزار دارید، از طریق صفحه گیت‌هاب پروژه با ما در ارتباط باشید.

با احترام،
تیم DigitalVPS.ir ❤️

t.me/digitalvps_group
t.me/OPIranClub

