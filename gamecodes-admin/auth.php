<?php
require_once __DIR__ . '/config.php';

function check_session_or_token() {
    if (isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in'] === true) return true;
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    $token = null;
    if (!empty($headers['Authorization'])) {
        if (preg_match('/Bearer\s+(.+)/', $headers['Authorization'], $m)) $token = $m[1];
    } elseif (!empty($_GET['api_token'])) {
        $token = $_GET['api_token'];
    } elseif (!empty($_POST['api_token'])) {
        $token = $_POST['api_token'];
    }
    if ($token && hash_equals(API_TOKEN, $token)) return true;
    return false;
}
