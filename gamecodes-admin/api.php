<?php
require_once __DIR__ . '/config.php';
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET,POST,OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

function require_token() {
    $token = null;
    $h = function_exists('getallheaders') ? getallheaders() : [];
    if (!empty($h['Authorization'])) {
        if (preg_match('/Bearer\s+(.+)/', $h['Authorization'], $m)) $token = $m[1];
    } elseif (!empty($_GET['api_token'])) $token = $_GET['api_token'];
    elseif (!empty($_POST['api_token'])) $token = $_POST['api_token'];
    if (!$token || !hash_equals(API_TOKEN, $token)) json_response(['error'=>'Invalid token'],401);
    return true;
}

if (isset($_GET['gamecodes'])) {
    $gamecodes = load_json(GAMECODES_FILE);
    json_response(['success'=>true,'data'=>$gamecodes]);
}

if (isset($_GET['categories'])) {
    $categories = load_json(CATEGORIES_FILE);
    json_response(['success'=>true,'data'=>$categories]);
}

if (isset($_GET['featured'])) {
    $gamecodes = load_json(GAMECODES_FILE);
    $categories = load_json(CATEGORIES_FILE);
    $featCodes = array_values(array_filter($gamecodes, fn($g)=>!empty($g['is_featured'])));
    $featCats = array_values(array_filter($categories, fn($c)=>!empty($c['is_featured'])));
    json_response(['success'=>true,'gamecodes'=>$featCodes,'categories'=>$featCats]);
}

$body = json_decode(file_get_contents('php://input'), true) ?? $_POST;

if (isset($_GET['add'])) {
    require_token();
    $gamecodes = load_json(GAMECODES_FILE);
    $new = $body;
    if (empty($new['title'])) json_response(['error'=>'Title required'],400);
    $new['id'] = generate_id();
    $new['created_at'] = date(DATE_ATOM);
    $new['updated_at'] = date(DATE_ATOM);
    $new['views'] = 0; $new['clicks']=0; $new['downloads']=0;
    $gamecodes[] = $new;
    if (!save_json(GAMECODES_FILE, $gamecodes)) json_response(['error'=>'Save failed'],500);
    json_response(['success'=>true,'id'=>$new['id']]);
}

if (isset($_GET['edit'])) {
    require_token();
    if (empty($body['id'])) json_response(['error'=>'id required'],400);
    $gamecodes = load_json(GAMECODES_FILE);
    [$idx,$old] = find_by_id($gamecodes, $body['id']);
    if ($old === null) json_response(['error'=>'Not found'],404);
    $allowed = ['title','description','type','content','categories','tags','image','is_new','is_featured','views','clicks','downloads'];
    foreach ($allowed as $k) if (isset($body[$k])) $old[$k] = $body[$k];
    $old['updated_at'] = date(DATE_ATOM);
    $gamecodes[$idx] = $old;
    if (!save_json(GAMECODES_FILE, $gamecodes)) json_response(['error'=>'Save failed'],500);
    json_response(['success'=>true]);
}

if (isset($_GET['delete'])) {
    require_token();
    if (empty($body['id'])) json_response(['error'=>'id required'],400);
    $gamecodes = load_json(GAMECODES_FILE);
    [$idx,$old] = find_by_id($gamecodes, $body['id']);
    if ($old === null) json_response(['error'=>'Not found'],404);
    array_splice($gamecodes, $idx, 1);
    save_json(GAMECODES_FILE, $gamecodes);
    json_response(['success'=>true]);
}

json_response(['error'=>'Invalid endpoint'], 400);
