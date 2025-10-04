<?php
// functions.php
function ensure_dirs() {
    foreach ([DATA_DIR, BACKUP_DIR, UPLOADS_DIR] as $d) {
        if (!is_dir($d)) mkdir($d, 0755, true);
    }
}

ensure_dirs();

function load_json($file) {
    $cacheFile = __DIR__ . '/cache/' . basename($file) . '.cache';
    if (!is_dir(__DIR__ . '/cache')) mkdir(__DIR__ . '/cache', 0755, true);

    if (file_exists($cacheFile) && (time() - filemtime($cacheFile) < CACHE_TTL)) {
        $data = file_get_contents($cacheFile);
        return json_decode($data, true) ?: [];
    }

    if (!file_exists($file)) {
        file_put_contents($file, json_encode([] , JSON_PRETTY_PRINT));
    }
    $json = @file_get_contents($file);
    $arr = @json_decode($json, true);
    if ($arr === null) {
        if (file_exists($file)) copy($file, BACKUP_DIR . '/' . basename($file) . '.broken.' . time());
        $arr = [];
    }
    file_put_contents($cacheFile, json_encode($arr, JSON_PRETTY_PRINT));
    return $arr;
}

function save_json($file, $data) {
    $json = json_encode($data, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE);
    if ($json === false) return false;
    if (file_exists($file)) {
        @copy($file, BACKUP_DIR . '/' . basename($file) . '.' . date('Ymd_His') . '.bak');
    }
    file_put_contents($file, $json);
    $cacheFile = __DIR__ . '/cache/' . basename($file) . '.cache';
    if (file_exists($cacheFile)) @unlink($cacheFile);
    return true;
}

function generate_id($prefix='gc_') {
    return $prefix . bin2hex(random_bytes(4));
}

function find_by_id($arr, $id) {
    foreach ($arr as $i => $item) if (isset($item['id']) && $item['id'] === $id) return [$i, $item];
    return [null, null];
}

function require_auth() {
    if (!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] !== true) {
        header('Location: login.php');
        exit;
    }
}

function login_attempt($user, $pass) {
    if ($user === ADMIN_USER && $pass === ADMIN_PASS) {
        $_SESSION['admin_logged_in'] = true;
        $_SESSION['admin_user'] = $user;
        return true;
    }
    return false;
}

function logout() {
    session_unset();
    session_destroy();
}

function json_response($payload, $status=200) {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($payload, JSON_UNESCAPED_UNICODE);
    exit;
}
