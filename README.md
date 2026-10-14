# GotChores - Family Task Management System

GotChores is a family-based task system designed to make managing household chores fun and rewarding. Think less "task manager", more "gameboard for real life".

## Features

- **Role-based Access**: Parents and Children with different capabilities
- **Invitation-only Households**: Secure household creation and member invitation
- **Visual Chore Completion**: Tap-to-complete interface with optional photo proof
- **Rewards System**: Points-based rewards to motivate completion
- **Mobile-first Design**: Beautiful, modern UI optimized for mobile devices

## Requirements

- PHP 8.2 or higher
- MariaDB/MySQL 10.3 or higher
- Web server (Apache/Nginx) with mod_rewrite enabled
- GD or Imagick extension for image processing

## Installation

1. **Clone or download this project** to your web server directory

2. **Create the database:**
   Create the database manually (e.g., `apple4923`) via phpMyAdmin or MySQL admin tools.

3. **Configure the database connection:**
   Edit `config/config.php` and update:
   ```php
   define('DB_HOST', 'localhost');
   define('DB_NAME', 'your_database');
   define('DB_USER', 'your_username');
   define('DB_PASS', 'your_password');
   ```

4. **Build the database (tables + migrations):**
   Open in your browser:
   ```
   http://localhost/build.php
   ```

5. **Set up file uploads directory:**
   ```bash
   mkdir -p uploads/profiles uploads/proof
   chmod 755 uploads/profiles uploads/proof
   ```

5. **Configure web server:**
   - Point document root to the project directory
   - Ensure PHP is enabled
   - Set up URL rewriting if needed (optional)

6. **Access the application:**
   Navigate to `http://localhost/` (or your configured URL)

## Getting Started

1. **Create a Parent Account:**
   - Go to `/register.php`
   - Choose "Parent" role
   - Complete registration

2. **Create a Household:**
   - After login, click "Create a Household"
   - Give it a name (e.g., "The Smith Family")

3. **Invite Family Members:**
   - Go to Invitations section
   - Create invitation links for parents or children
   - Share the links with family members

4. **Create Chores:**
   - Use "Create Chore" to add tasks
   - Assign to specific members
   - Set rewards and schedules

5. **Start Managing:**
   - Children can view and complete chores
   - Parents can track progress and manage everything

## Project Structure

```
GotChores/
├── api/              # API endpoints (AJAX handlers)
├── assets/           # CSS, JS, images
│   ├── css/
│   └── js/
├── config/           # Configuration files
├── database/         # Database schema
├── includes/         # PHP classes and functions
├── uploads/          # User-uploaded files (created on setup)
│   ├── profiles/     # Profile pictures
│   └── proof/        # Chore proof photos
├── views/            # Dashboard view templates
└── *.php            # Main application files
```

## Key Files

- `config/config.php` - Main configuration
- `includes/bootstrap.php` - Auto-loads all classes
- `includes/Database.php` - Database connection handler
- `includes/Auth.php` - Authentication system
- `includes/Household.php` - Household management
- `includes/Chore.php` - Chore management
- `includes/Reward.php` - Rewards system
- `includes/Invitation.php` - Invitation system

## Security Features

- Password hashing with PHP's `password_hash()`
- Prepared statements to prevent SQL injection
- File upload validation
- Single-use invitation tokens with expiry
- Role-based access control
- Session management

## Development Notes

- Built with vanilla PHP (no frameworks)
- Mobile-first responsive CSS
- Clean, maintainable code structure
- Ready for PWA enhancements (future)

## Android App (offline-first, no account for kids)

There is a native Android app (`android/`) that pairs with the website. The child **never logs in** —

a parent shows an on-screen QR (or a 6-character code), the kid scans it with the app, and the device
is permanently linked. The app works fully offline (local Room database); chore completions queue up
and sync when a connection returns. Parent actions (new chore, approval, coins) reach the child's
device through background sync, with local reminders for due-soon chores.

### Backend you must enable first (one time)

1. Open `build.php` on your server — it now runs the `device_bindings` migration
   (`database/migrations/add-device-bindings.sql`).
2. That's it. The API lives at `/api/v2/` (pair, sync, complete, claim-chore, claim-reward, notify).
3. Parents find the pairing screen at `/qr/pair.php?user_id=<childId>&household=<householdId>`
   (linked from the existing child QR page).

### Building the app

```bash
cd android
./gradlew assembleDebug   # needs JDK 17+ and the Android SDK (local.properties)
# APK: android/app/build/outputs/apk/debug/app-debug.apk
```

The app points at `https://gotchores.net` by default; override with `-PapiBaseUrl=...`.

### Audio & icons (generated once)

- `scripts/generate-audio-assets.php` — generates the ElevenLabs voice lines + SFX and converts them
  to OGG with ffmpeg into `android/app/src/main/res/raw/` and `sounds/`.
  Needs `ELEVENLABS_API_KEY` in the environment (never committed; see `.env.example`).
- `scripts/generate-icons.php` — creates the website logo variants and Android launcher icons
  (uses ffmpeg, no GD/Python required).

## License

This project is open source and available for personal use.
