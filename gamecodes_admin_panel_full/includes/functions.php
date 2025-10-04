<?php
// includes/functions.php
require_once __DIR__ . '/config.php';

function read_json_file($path) {
    if (!file_exists($path)) return null;
    $txt = file_get_contents($path);
    return json_decode($txt, true);
}

function write_json_file_atomic($path, $data) {
    make_backup($path);
    $tmp = $path . '.tmp';
    $json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    if ($json === false) return false;
    file_put_contents($tmp, $json);
    rename($tmp, $path);
    return true;
}

function make_backup($path) {
    if (!file_exists($path)) return;
    $basename = basename($path);
    $ts = date('Ymd_His');
    copy($path, BACKUP_DIR . "/" . $basename . ".bak.$ts.json");
}

function ensure_categories_file() {
    if (!file_exists(CATEGORIES_FILE)) {
        $starter = ['categories' => []];
        file_put_contents(CATEGORIES_FILE, json_encode($starter, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));
    }
}

function ensure_gamecodes_file() {
    if (!file_exists(GAMECODES_FILE)) {
        $starter = ['gamecodes' => []];
        file_put_contents(GAMECODES_FILE, json_encode($starter, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));
    }
}

function next_id(array $items, $field='id') {
    $max = 0;
    foreach($items as $it) {
        if (!empty($it[$field]) && (int)$it[$field] > $max) $max = (int)$it[$field];
    }
    return $max + 1;
}
