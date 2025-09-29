<?php
require_once __DIR__ . '/config.php';
require_auth();
$categories = load_json(CATEGORIES_FILE);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['action'])) {
    $action = $_POST['action'];
    if ($action === 'add') {
        $name = trim($_POST['name'] ?? '');
        if ($name==='') $error = 'Name required';
        else {
            $id = generate_id('cat_');
            $img = '';
            if (!empty($_FILES['image']['tmp_name'])) {
                $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
                $filename = $id . '.' . $ext;
                move_uploaded_file($_FILES['image']['tmp_name'], UPLOADS_DIR . '/' . $filename);
                $img = 'uploads/images/' . $filename;
            }
            $categories[] = ['id'=>$id,'name'=>$name,'description'=>$_POST['description'] ?? '','image'=>$img,'is_featured'=>!empty($_POST['is_featured'])];
            save_json(CATEGORIES_FILE, $categories);
            header('Location: categories.php'); exit;
        }
    }
    if ($action === 'delete' && !empty($_POST['id'])) {
        [$idx,$old] = find_by_id($categories, $_POST['id']);
        if ($old!==null) { array_splice($categories,$idx,1); save_json(CATEGORIES_FILE,$categories); }
        header('Location: categories.php'); exit;
    }
}

?>
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Categories</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
  <a href="dashboard.php" class="btn btn-link">&larr; Back</a>
  <div class="row">
    <div class="col-md-6">
      <h4>Existing Categories</h4>
      <ul class="list-group">
        <?php foreach($categories as $c): ?>
          <li class="list-group-item d-flex justify-content-between align-items-center">
            <div>
              <strong><?=htmlspecialchars($c['name'])?></strong><br><small><?=htmlspecialchars($c['description'] ?? '')?></small>
            </div>
            <form method="post" style="margin:0">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<?=htmlspecialchars($c['id'])?>">
              <button class="btn btn-sm btn-danger">Delete</button>
            </form>
          </li>
        <?php endforeach; ?>
      </ul>
    </div>
    <div class="col-md-6">
      <h4>Add Category</h4>
      <?php if(!empty($error)): ?><div class="alert alert-danger"><?=$error?></div><?php endif; ?>
      <form method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add">
        <div class="mb-2"><input class="form-control" name="name" placeholder="Name" required></div>
        <div class="mb-2"><textarea class="form-control" name="description" placeholder="Description"></textarea></div>
        <div class="mb-2"><input type="file" class="form-control" name="image"></div>
        <div class="form-check mb-2"><input class="form-check-input" type="checkbox" name="is_featured" id="cf1"><label class="form-check-label" for="cf1">Featured</label></div>
        <button class="btn btn-primary">Add Category</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>
