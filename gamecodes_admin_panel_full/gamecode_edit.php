<?php
require_once __DIR__ . '/includes/functions.php';
require_admin();
ensure_gamecodes_file();
ensure_categories_file();
$data = read_json_file(GAMECODES_FILE);
$gamecodes = $data['gamecodes'] ?? [];
$cats = read_json_file(CATEGORIES_FILE)['categories'] ?? [];
$action = $_SERVER['REQUEST_METHOD'];
if (isset($_GET['delete'])) {
    $delId = (int)$_GET['delete'];
    foreach($gamecodes as $k=>$c) {
        if ((int)$c['id'] === $delId) {
            array_splice($gamecodes,$k,1);
            write_json_file_atomic(GAMECODES_FILE, ['gamecodes'=>$gamecodes]);
            header('Location: /gamecodes_admin_panel_full/gamecodes.php');
            exit;
        }
    }
}
$editing = null;
if (isset($_GET['id'])) {
    $eid = (int)$_GET['id'];
    foreach($gamecodes as $c) if ((int)$c['id'] === $eid) $editing = $c;
}
if ($action === 'POST') {
    $id = isset($_POST['id']) ? (int)$_POST['id'] : 0;
    $title = trim($_POST['title'] ?? '');
    $type = trim($_POST['type'] ?? 'text');
    $content = trim($_POST['content'] ?? '');
    $categories_sel = $_POST['categories'] ?? [];
    if ($id > 0) {
        foreach($gamecodes as $k=>$c) {
            if ((int)$c['id'] === $id) {
                $gamecodes[$k] = array_merge($gamecodes[$k], ['title'=>$title,'type'=>$type,'content'=>$content,'categories'=>$categories_sel]);
                break;
            }
        }
    } else {
        $nid = next_id($gamecodes,'id');
        $new = ['id'=>$nid,'title'=>$title,'type'=>$type,'content'=>$content,'categories'=>$categories_sel,'featured'=>isset($_POST['featured'])];
        $gamecodes[] = $new;
    }
    write_json_file_atomic(GAMECODES_FILE, ['gamecodes'=>$gamecodes]);
    header('Location: /gamecodes_admin_panel_full/gamecodes.php');
    exit;
}
?>
<!doctype html><html><head><meta charset="utf-8"><title><?= $editing ? 'Edit' : 'Add' ?> Game Code</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css"></head><body>
<nav class="navbar navbar-dark bg-dark"><div class="container-fluid"><a class="navbar-brand" href="/gamecodes_admin_panel_full/">GameCodes Admin</a></div></nav>
<div class="container mt-4">
  <h3><?= $editing ? 'Edit' : 'Add' ?> Game Code</h3>
  <form method="post">
    <input type="hidden" name="id" value="<?=htmlspecialchars($editing['id'] ?? '')?>">
    <div class="mb-2"><input name="title" class="form-control" placeholder="Title" required value="<?=htmlspecialchars($editing['title'] ?? '')?>"></div>
    <div class="mb-2">
      <label>Categories (select multiple with CTRL)</label>
      <select name="categories[]" multiple class="form-control">
        <?php foreach($cats as $c): ?>
          <option value="<?=htmlspecialchars($c['name'])?>" <?= (is_array($editing['categories'] ?? []) && in_array($c['name'], $editing['categories'] ?? [])) ? 'selected' : ''?>><?=htmlspecialchars($c['name'])?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="mb-2"><select name="type" class="form-control"><option value="text">Text</option><option value="link">Link</option><option value="download">Download</option></select></div>
    <div class="mb-2"><textarea name="content" class="form-control" rows="6" placeholder="Code or link"><?=htmlspecialchars($editing['content'] ?? '')?></textarea></div>
    <div class="mb-2 form-check"><input type="checkbox" name="featured" class="form-check-input" id="f2" <?=!empty($editing['featured']) ? 'checked' : ''?>><label for="f2" class="form-check-label">Featured</label></div>
    <button class="btn btn-primary">Save</button>
  </form>
</div></body></html>
