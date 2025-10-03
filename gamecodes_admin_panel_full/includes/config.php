<?php
// includes/config.php
session_start();

// Admin credentials (change before production)
define('ADMIN_USER', 'admin');
define('ADMIN_PASS', 'admin123'); // change this

// Files and paths (writable)
define('DATA_DIR', __DIR__ . '/../data');
define('CATEGORIES_FILE', DATA_DIR . '/categories.json');
define('GAMECODES_FILE', DATA_DIR . '/gamecodes.json');
define('BACKUP_DIR', DATA_DIR . '/backups');
define('UPLOADS_DIR', __DIR__ . '/../uploads');

// API token for token-based authentication (use long random string)
define('API_TOKEN', 'REPLACE_WITH_A_LONG_RANDOM_TOKEN_please_change');

// Ensure directories exist
@mkdir(DATA_DIR, 0755, true);
@mkdir(BACKUP_DIR, 0755, true);
@mkdir(UPLOADS_DIR, 0755, true);

function require_admin() {
    if (empty($_SESSION['is_admin']) || $_SESSION['is_admin'] !== true) {
        header('Location: /gamecodes_admin_panel_full/auth/login.php');
        exit;
    }
}
