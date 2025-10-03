<?php
require_once __DIR__ . '/includes/functions.php';
require_admin();
ensure_categories_file();
$data = read_json_file(CATEGORIES_FILE);
$cats = $data['categories'] ?? [];
$action = $_SERVER['REQUEST_METHOD'];
$msg = '';
if (isset($_GET['delete'])) {
    $delId = (int)$_GET['delete'];
    foreach($cats as $k=>$c) {
        if ((int)$c['id'] === $delId) {
            make_backup(CATEGORIES_FILE);
            array_splice($cats,$k,1);
            write_json_file_atomic(CATEGORIES_FILE, ['categories'=>$cats]);
            header('Location: /gamecodes_admin_panel_full/categories.php');
            exit;
        }
    }
}
$editing = null;
if (isset($_GET['id'])) {
    $eid = (int)$_GET['id'];
    foreach($cats as $c) if ((int)$c['id'] === $eid) $editing = $c;
}
if ($action === 'POST') {
    $id = isset($_POST['id']) ? (int)$_POST['id'] : 0;
    $name = trim($_POST['name'] ?? '');
    $imageUrl = trim($_POST['imageUrl'] ?? '');
    $featured = isset($_POST['featured']) ? true : false;
    if (!empty($_FILES['image']['name'])) {
        $up = $_FILES['image'];
        $ext = pathinfo($up['name'], PATHINFO_EXTENSION);
        $fn = 'cat_' . time() . '.' . $ext;
        $target = UPLOADS_DIR . '/' . $fn;
        if (move_uploaded_file($up['tmp_name'], $target)) {
            $imageUrl = '/gamecodes_admin_panel_full/uploads/' . $fn;
        }
    }
    if ($name === '') {
        $msg = 'Name required';
    } else {
        if ($id > 0) {
            foreach($cats as $k=>$c) {
                if ((int)$c['id'] === $id) {
                    $cats[$k]['name'] = $name;
                    $cats[$k]['imageUrl'] = $imageUrl;
                    $cats[$k]['featured'] = $featured;
                    if (!empty($_POST['subcategories_json'])) {
                        $subs = json_decode($_POST['subcategories_json'], true);
                        if (is_array($subs)) $cats[$k]['subcategories'] = $subs;
                    }
                    break;
                }
            }
        } else {
            $nid = next_id($cats,'id');
            $new = [
                'id' => $nid,
                'name' => $name,
                'imageUrl' => $imageUrl,
                'subcategories' => [],
                'featured' => $featured ? true : false
            ];
            if (!empty($_POST['subcategories_json'])) {
                $subs = json_decode($_POST['subcategories_json'], true);
                if (is_array($subs)) $new['subcategories'] = $subs;
            }
            $cats[] = $new;
        }
        write_json_file_atomic(CATEGORIES_FILE, ['categories'=>$cats]);
        header('Location: /gamecodes_admin_panel_full/categories.php');
        exit;
    }
}
?>
<!doctype html><html><head><meta charset="utf-8"><title><?= $editing ? 'Edit' : 'Add' ?> Category</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css"></head><body>
<nav class="navbar navbar-dark bg-dark"><div class="container-fluid"><a class="navbar-brand" href="/gamecodes_admin_panel_full/">GameCodes Admin</a></div></nav>
<div class="container mt-4">
  <h3><?= $editing ? 'Edit' : 'Add' ?> Category</h3>
  <?php if($msg): ?><div class="alert alert-danger"><?=htmlspecialchars($msg)?></div><?php endif; ?>
  <form method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<?=htmlspecialchars($editing['id'] ?? '')?>">
    <div class="mb-2"><input name="name" class="form-control" placeholder="Category name" required value="<?=htmlspecialchars($editing['name'] ?? '')?>"></div>
    <div class="mb-2"><input name="imageUrl" class="form-control" placeholder="Image URL" value="<?=htmlspecialchars($editing['imageUrl'] ?? '')?>"></div>
    <div class="mb-2"><input name="image" type="file" class="form-control" accept="image/*"></div>
    <div class="mb-2">
      <label>Subcategories (JSON)</label>
      <textarea name="subcategories_json" class="form-control" rows="6"><?=htmlspecialchars(json_encode($editing['subcategories'] ?? [], JSON_PRETTY_PRINT))?></textarea>
    </div>
    <div class="mb-2 form-check"><input type="checkbox" name="featured" class="form-check-input" id="f1" <?=!empty($editing['featured']) ? 'checked' : ''?>><label for="f1" class="form-check-label">Featured</label></div>
    <button class="btn btn-primary">Save</button>
  </form>
</div></body></html>
