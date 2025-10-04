<?php
require_once __DIR__ . '/includes/functions.php';
require_admin();
ensure_categories_file();
$data = read_json_file(CATEGORIES_FILE);
$categories = $data['categories'] ?? [];
$q = trim($_GET['q'] ?? '');
if ($q !== '') {
    $categories = array_filter($categories, function($c) use($q){
        return stripos($c['name'] ?? '', $q) !== false;
    });
}
?>
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Categories</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css"></head>
<body>
<nav class="navbar navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="/gamecodes_admin_panel_full/">GameCodes Admin</a>
    <div><a class="btn btn-sm btn-light" href="/gamecodes_admin_panel_full/category_edit.php">Add Category</a> <a class="btn btn-sm btn-light" href="/gamecodes_admin_panel_full/auth/logout.php">Logout</a></div>
  </div>
</nav>
<div class="container mt-4">
  <h3>Categories</h3>
  <form class="row g-2 mb-3">
    <div class="col-auto"><input name="q" class="form-control" placeholder="Search" value="<?=htmlspecialchars($q)?>"></div>
    <div class="col-auto"><button class="btn btn-primary">Search</button> <a href="/gamecodes_admin_panel_full/categories.php" class="btn btn-outline-secondary">Reset</a></div>
  </form>

  <table class="table table-striped">
    <thead><tr><th>ID</th><th>Name</th><th>Image</th><th>Subcategories</th><th>Actions</th></tr></thead>
    <tbody>
      <?php foreach($categories as $cat): ?>
        <tr>
          <td><?=htmlspecialchars($cat['id'] ?? '')?></td>
          <td><?=htmlspecialchars($cat['name'] ?? '')?> <?=!empty($cat['featured'])?'<span class="badge bg-warning text-dark">Featured</span>':''?></td>
          <td><?php if(!empty($cat['imageUrl'])): ?><img src="<?=htmlspecialchars($cat['imageUrl'])?>" width="60"><?php endif; ?></td>
          <td><?=count($cat['subcategories'] ?? [])?></td>
          <td><a class="btn btn-sm btn-secondary" href="/gamecodes_admin_panel_full/category_edit.php?id=<?=urlencode($cat['id'])?>">Edit</a>
              <a class="btn btn-sm btn-danger" href="/gamecodes_admin_panel_full/category_edit.php?delete=<?=urlencode($cat['id'])?>" onclick="return confirm('Delete?')">Delete</a></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>
</body>
</html>
