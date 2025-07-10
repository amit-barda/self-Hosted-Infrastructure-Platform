# פלטפורמת תשתית עצמית עם Docker ו-Traefik

פלטפורמה מלאה מבוססת Linux להפעלת שירותים עצמיים בצורה מאובטחת באמצעות Docker ו-Traefik reverse proxy עם HTTPS אוטומטי דרך Let's Encrypt.

## 🎯 תכונות

- **Portainer** - ממשק ניהול קונטיינרים
- **Gitea** - שרת Git עצמי
- **Vaultwarden** - מנהל סיסמאות עצמי (תואם Bitwarden)
- **Whoami** - שירות בדיקה לדיבוג
- **Traefik** - Reverse proxy עם HTTPS אוטומטי
- **Let's Encrypt** - תעודות SSL חינמיות

## 🏗️ ארכיטקטורה

```
אינטרנט → Traefik (Reverse Proxy) → שירותים
                ↓
        [Portainer, Gitea, Vaultwarden, Whoami]
```

## 📁 מבנה הפרויקט

```
self-hosted-infra/
├── docker-compose.yml          # קונפיגורציה ראשית של השירותים
├── .env                        # משתני סביבה
├── traefik/
│   ├── traefik.yml            # קונפיגורציה סטטית של Traefik
│   ├── dynamic_conf.yml       # קונפיגורציה דינמית של Traefik
│   └── acme.json              # אחסון תעודות SSL
├── portainer/
│   └── data/                  # נתוני Portainer
├── gitea/
│   └── data/                  # נתוני Gitea
├── vaultwarden/
│   └── data/                  # נתוני Vaultwarden
└── README.md                  # קובץ זה
```

## 🚀 התחלה מהירה

### דרישות מקדימות

- Docker ו-Docker Compose מותקנים
- שם דומיין המצביע לשרת שלך
- פורטים 80 ו-443 פתוחים בפיירוול

### 1. שכפול והגדרה

```bash
git clone <your-repo-url>
cd self-hosted-infra
```

### 2. הגדרת סביבה

ערוך קובץ `.env` עם הדומיין שלך:

```bash
cp .env.example .env
# ערוך .env עם שם הדומיין שלך
```

### 3. יצירת תיקיות נדרשות

```bash
mkdir -p traefik portainer/data gitea/data vaultwarden/data
chmod 600 traefik/acme.json
```

### 4. הפעלת שירותים

```bash
docker-compose up -d
```

### 5. גישה לשירותים

- **Portainer**: https://portainer.yourdomain.com
- **Gitea**: https://git.yourdomain.com
- **Vaultwarden**: https://vault.yourdomain.com
- **Whoami**: https://whoami.yourdomain.com

## 🔧 הגדרה

### קונפיגורציית Traefik

קונפיגורציית Traefik מחולקת ל:
- `traefik/traefik.yml` - קונפיגורציה סטטית
- `traefik/dynamic_conf.yml` - קונפיגורציה דינמית
- `docker-compose.yml` - תוויות שירות לגילוי אוטומטי

### תעודות SSL

תעודות SSL מנוהלות אוטומטית על ידי Let's Encrypt ונשמרות ב-`traefik/acme.json`.

### הגדרת שירותים

כל שירות ניתן להגדרה דרך משתני סביבה בקובץ `.env`.

## 🛡️ תכונות אבטחה

- HTTPS אוטומטי עם Let's Encrypt
- כותרות אבטחה דרך Traefik middleware
- בידוד קונטיינרים
- הגדרת משתני סביבה
- הרשאות קבצים נכונות

## 📊 ניטור

- Portainer מספק ניטור וניהול קונטיינרים
- לוח מחוונים של Traefik זמין ב-https://traefik.yourdomain.com
- בדיקות בריאות שירות מוגדרות

## 🔄 עדכונים

לעדכון שירותים:

```bash
docker-compose pull
docker-compose up -d
```

## 🗂️ שמירת נתונים

כל נתוני השירות נשמרים ב-Docker volumes:
- נתוני Portainer: `./portainer/data`
- נתוני Gitea: `./gitea/data`
- נתוני Vaultwarden: `./vaultwarden/data`
- תעודות Traefik: `./traefik/acme.json`

## 🐛 פתרון בעיות

### בדיקת לוגים של שירותים

```bash
docker-compose logs [service-name]
```

### הפעלה מחדש של שירותים

```bash
docker-compose restart [service-name]
```

### בדיקת קונפיגורציית Traefik

```bash
docker-compose logs traefik
```

## 📝 רישיון

MIT License - חופשי לשימוש בפרויקט זה לצרכי התשתית שלך.

## 🤝 תרומה

1. Fork את המאגר
2. צור ענף תכונה
3. בצע את השינויים שלך
4. שלח pull request

## 📞 תמיכה

לבעיות ושאלות, אנא פתח issue ב-GitHub. 