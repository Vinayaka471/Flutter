<?php
// config.php
session_start();

define('DATA_DIR', __DIR__ . '/data');
define('GAMECODES_FILE', DATA_DIR . '/gamecodes.json');
define('CATEGORIES_FILE', DATA_DIR . '/categories.json');
define('BACKUP_DIR', DATA_DIR . '/backup');
define('UPLOADS_DIR', __DIR__ . '/uploads/images');
define('CACHE_TTL', 60); // seconds

if (!defined('ADMIN_USER')) define('ADMIN_USER', 'admin');
if (!defined('ADMIN_PASS')) define('ADMIN_PASS', 'admin123');

if (!defined('API_TOKEN')) define('API_TOKEN', 'CHANGE_THIS_TOKEN');

date_default_timezone_set('Asia/Kolkata');

require_once __DIR__ . '/functions.php';
