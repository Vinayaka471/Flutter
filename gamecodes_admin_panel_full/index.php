<?php
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/functions.php';
if (empty($_SESSION['is_admin'])) {
    header('Location: /gamecodes_admin_panel_full/auth/login.php');
    exit;
}
ensure_categories_file();
$cats = read_json_file(CATEGORIES_FILE)['categories'] ?? [];
$gamecodes = read_json_file(GAMECODES_FILE)['gamecodes'] ?? [];
$total_categories = count($cats);
$total_gamecodes = count($gamecodes);
$featured_count = 0;
foreach($gamecodes as $g) if(!empty($g['featured'])) $featured_count++;
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Admin Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="/gamecodes_admin_panel_full/">GameCodes Admin</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="/gamecodes_admin_panel_full/categories.php">Categories</a></li>
        <li class="nav-item"><a class="nav-link" href="/gamecodes_admin_panel_full/gamecodes.php">Game Codes</a></li>
        <li class="nav-item"><a class="nav-link" href="/gamecodes_admin_panel_full/auth/logout.php">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>
<div class="container mt-4">
  <div class="row">
    <div class="col-md-4">
      <div class="card p-3">
        <h5>Total Categories</h5>
        <h2><?= $total_categories ?></h2>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card p-3">
        <h5>Total Game Codes</h5>
        <h2><?= $total_gamecodes ?></h2>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card p-3">
        <h5>Featured Items</h5>
        <h2><?= $featured_count ?></h2>
      </div>
    </div>
  </div>

  <div class="mt-4">
    <h4>Quick actions</h4>
    <a class="btn btn-primary" href="/gamecodes_admin_panel_full/category_edit.php">Add Category</a>
    <a class="btn btn-secondary" href="/gamecodes_admin_panel_full/gamecode_edit.php">Add Game Code</a>
  </div>
</div>
</body>
</html>
