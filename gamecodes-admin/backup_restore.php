<?php
require_once __DIR__ . '/config.php';
require_auth();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_FILES['import']['tmp_name'])) {
    $json = file_get_contents($_FILES['import']['tmp_name']);
    $arr = json_decode($json, true);
    if ($arr === null) $error = 'Invalid JSON';
    else {
        // expect array of objects with id etc. Ask which file to restore via 'target'
        $target = $_POST['target'] ?? 'gamecodes';
        if ($target === 'gamecodes') {
            @copy(GAMECODES_FILE, BACKUP_DIR . '/gamecodes.import.' . time() . '.bak');
            file_put_contents(GAMECODES_FILE, json_encode($arr, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
        } else {
            @copy(CATEGORIES_FILE, BACKUP_DIR . '/categories.import.' . time() . '.bak');
            file_put_contents(CATEGORIES_FILE, json_encode($arr, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
        }
        header('Location: dashboard.php'); exit;
    }
}
?>
<!doctype html><html><head><meta charset="utf-8"><title>Backup & Restore</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></head><body class="bg-light">
<div class="container py-4">
  <a href="dashboard.php" class="btn btn-link">&larr; Back</a>
  <h4>Backup & Restore</h4>
  <p><a class="btn btn-secondary" href="data/gamecodes.json" download>Download gamecodes.json</a>
     <a class="btn btn-secondary" href="data/categories.json" download>Download categories.json</a></p>
  <hr>
  <form method="post" enctype="multipart/form-data">
    <div class="mb-2">
      <label>Import JSON</label>
      <input type="file" class="form-control" name="import" required>
    </div>
    <div class="mb-2">
      <select name="target" class="form-select">
        <option value="gamecodes">Gamecodes</option>
        <option value="categories">Categories</option>
      </select>
    </div>
    <button class="btn btn-primary">Import</button>
  </form>
</div></body></html>
