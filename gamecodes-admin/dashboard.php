<?php
require_once __DIR__ . '/config.php';
require_auth();

$gamecodes = load_json(GAMECODES_FILE);
$categories = load_json(CATEGORIES_FILE);

$total_gamecodes = count($gamecodes);
$total_categories = count($categories);
$featured_count = count(array_filter($gamecodes, fn($g)=>!empty($g['is_featured'])));

usort($gamecodes, fn($a,$b)=>strcmp($b['updated_at'] ?? '', $a['updated_at'] ?? ''));
$recent = array_slice($gamecodes, 0, 5);
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-white">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">GameCodes Admin</a>
    <div class="d-flex">
      <a class="btn btn-outline-secondary me-2" href="settings.php">Settings</a>
      <a class="btn btn-danger" href="logout.php">Logout</a>
    </div>
  </div>
</nav>

<div class="container my-4">
  <div class="row g-3">
    <div class="col-md-3">
      <div class="card p-3">
        <h6>Total Game Codes</h6><h3><?=$total_gamecodes?></h3>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3">
        <h6>Categories</h6><h3><?=$total_categories?></h3>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3">
        <h6>Featured</h6><h3><?=$featured_count?></h3>
      </div>
    </div>
    <div class="col-md-3">
      <div class="card p-3">
        <h6>Recent Activity</h6>
        <ul class="list-unstyled mb-0">
          <?php foreach($recent as $r): ?>
            <li><?=htmlspecialchars($r['title'] ?? '—')?> <small class="text-muted d-block"><?=htmlspecialchars($r['updated_at'] ?? '')?></small></li>
          <?php endforeach; ?>
        </ul>
      </div>
    </div>
  </div>

  <hr class="my-4">

  <div class="d-flex justify-content-between mb-2">
    <h5>Game Codes</h5>
    <div>
      <a class="btn btn-success" href="gamecode_form.php">Add Game Code</a>
      <a class="btn btn-secondary" href="categories.php">Categories</a>
    </div>
  </div>

  <div class="card">
    <div class="card-body">
      <input id="search" class="form-control mb-2" placeholder="Search title, tags, type...">
      <div class="table-responsive">
        <table class="table table-hover" id="gamecodes-table">
          <thead><tr>
            <th data-key="title">Title</th>
            <th data-key="type">Type</th>
            <th data-key="categories">Categories</th>
            <th data-key="is_new">New</th>
            <th data-key="is_featured">Featured</th>
            <th>Actions</th>
          </tr></thead>
          <tbody>
            <?php foreach($gamecodes as $g): ?>
            <tr data-item='<?=json_encode($g, JSON_UNESCAPED_UNICODE)?>'>
              <td><?=htmlspecialchars($g['title'])?></td>
              <td><?=htmlspecialchars($g['type'])?></td>
              <td><?=htmlspecialchars(implode(', ', $g['categories'] ?? []))?></td>
              <td><?=!empty($g['is_new'])? 'Yes':'No'?></td>
              <td><?=!empty($g['is_featured'])? 'Yes':'No'?></td>
              <td>
                <a class="btn btn-sm btn-primary" href="gamecode_form.php?id=<?=urlencode($g['id'])?>">Edit</a>
                <button class="btn btn-sm btn-danger btn-delete" data-id="<?=htmlspecialchars($g['id'])?>">Delete</button>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>

<script>
document.getElementById('search').addEventListener('input', function(){
  const q = this.value.toLowerCase();
  document.querySelectorAll('#gamecodes-table tbody tr').forEach(tr=>{
    const item = JSON.parse(tr.dataset.item);
    const hay = (item.title + ' ' + (item.tags||[]).join(' ') + ' ' + (item.type||'') + ' ' + (item.categories||[]).join(' ')).toLowerCase();
    tr.style.display = hay.includes(q) ? '' : 'none';
  });
});

document.querySelectorAll('.btn-delete').forEach(b=>{
  b.addEventListener('click', function(){
    if (!confirm('Delete this game code?')) return;
    const id = this.dataset.id;
    fetch('api.php?delete', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({id: id, api_token: '<?=API_TOKEN?>'})
    }).then(r=>r.json()).then(resp=>{
      if (resp.success) location.reload();
      else alert(resp.error || 'Failed');
    });
  });
});
</script>
</body>
</html>
