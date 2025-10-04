<?php
require_once __DIR__ . '/includes/functions.php';
require_admin();
ensure_gamecodes_file();
$data = read_json_file(GAMECODES_FILE);
$gamecodes = $data['gamecodes'] ?? [];
?>
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Game Codes</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"><link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css"></head>
<body>
<nav class="navbar navbar-dark bg-dark"><div class="container-fluid"><a class="navbar-brand" href="/gamecodes_admin_panel_full/">GameCodes Admin</a><div><a class="btn btn-sm btn-light" href="/gamecodes_admin_panel_full/gamecode_edit.php">Add Game Code</a></div></div></nav>
<div class="container mt-4">
  <h3>Game Codes</h3>
  <table class="table table-striped">
    <thead><tr><th>ID</th><th>Title</th><th>Category</th><th>Type</th><th>Actions</th></tr></thead>
    <tbody>
      <?php foreach($gamecodes as $g): ?>
        <tr>
          <td><?=htmlspecialchars($g['id'] ?? '')?></td>
          <td><?=htmlspecialchars($g['title'] ?? '')?></td>
          <td><?=htmlspecialchars(is_array($g['categories'])?implode(', ',$g['categories']):($g['category']??''))?></td>
          <td><?=htmlspecialchars($g['type'] ?? '')?></td>
          <td><a class="btn btn-sm btn-secondary" href="/gamecodes_admin_panel_full/gamecode_edit.php?id=<?=urlencode($g['id'])?>">Edit</a>
              <a class="btn btn-sm btn-danger" href="/gamecodes_admin_panel_full/gamecode_edit.php?delete=<?=urlencode($g['id'])?>" onclick="return confirm('Delete?')">Delete</a></td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>
</div>
</body>
</html>
