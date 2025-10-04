<?php
require_once __DIR__ . '/../includes/functions.php';
header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json; charset=utf-8');
ensure_categories_file();
$data = read_json_file(CATEGORIES_FILE);
echo json_encode($data);
