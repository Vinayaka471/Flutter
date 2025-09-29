<?php
require_once __DIR__ . '/config.php';
require_auth();

$gamecodes = load_json(GAMECODES_FILE);
$categories = load_json(CATEGORIES_FILE);
$editing = false;
$item = null;
if (!empty($_GET['id'])) {
    [$idx, $found] = find_by_id($gamecodes, $_GET['id']);
    if ($found) { $editing = true; $item = $found; }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $type = $_POST['type'] ?? 'text';
    $content = $_POST['content'] ?? '';
    $cats = $_POST['categories'] ?? [];
    $tags = array_filter(array_map('trim', explode(',', $_POST['tags'] ?? '')));
    $is_new = !empty($_POST['is_new']);
    $is_featured = !empty($_POST['is_featured']);

    if ($title==='') $error = "Title required";
    else {
        $imagePath = $item['image'] ?? '';
        if (!empty($_FILES['image']['tmp_name'])) {
            $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
            $id = $editing ? $item['id'] : generate_id();
            $filename = $id . '.' . $ext;
            move_uploaded_file($_FILES['image']['tmp_name'], UPLOADS_DIR . '/' . $filename);
            $imagePath = 'uploads/images/' . $filename;
        }

        if ($editing) {
            [$idx, $old] = find_by_id($gamecodes, $item['id']);
            $gamecodes[$idx] = array_merge($old, [
                'title'=>$title,'description'=>$description,'type'=>$type,'content'=>$content,
                'categories'=>$cats,'tags'=>$tags,'image'=>$imagePath,
                'is_new'=>$is_new,'is_featured'=>$is_featured,
                'updated_at'=>date(DATE_ATOM)
            ]);
        } else {
            $new = [
                'id'=>generate_id(),
                'title'=>$title,
                'description'=>$description,
                'type'=>$type,
                'content'=>$content,
                'categories'=>$cats,
                'tags'=>$tags,
                'image'=>$imagePath,
                'is_new'=>$is_new,
                'is_featured'=>$is_featured,
                'views'=>0,'clicks'=>0,'downloads'=>0,
                'created_at'=>date(DATE_ATOM),
                'updated_at'=>date(DATE_ATOM)
            ];
            $gamecodes[] = $new;
        }

        if (!save_json(GAMECODES_FILE, $gamecodes)) $error = "Save failed (invalid JSON?)";
        else header('Location: dashboard.php');
    }
}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title><?= $editing ? 'Edit' : 'Add' ?> Game Code</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
  <a href="dashboard.php" class="btn btn-link">&larr; Back</a>
  <div class="card p-3">
    <h4><?= $editing ? 'Edit' : 'Add' ?> Game Code</h4>
    <?php if(!empty($error)): ?><div class="alert alert-danger"><?=$error?></div><?php endif; ?>
    <form method="post" enctype="multipart/form-data">
      <div class="mb-2"><input class="form-control" name="title" placeholder="Title" value="<?=htmlspecialchars($item['title'] ?? '')?>" required></div>
      <div class="mb-2"><textarea class="form-control" name="description" placeholder="Description"><?=htmlspecialchars($item['description'] ?? '')?></textarea></div>
      <div class="mb-2">
        <label>Type</label>
        <select class="form-select" name="type">
          <option value="text" <?=($item['type'] ?? '')==='text'?'selected':''?>>Text</option>
          <option value="link" <?=($item['type'] ?? '')==='link'?'selected':''?>>Link</option>
          <option value="download" <?=($item['type'] ?? '')==='download'?'selected':''?>>Download</option>
        </select>
      </div>
      <div class="mb-2"><input class="form-control" name="content" placeholder="Content (code/link/path)" value="<?=htmlspecialchars($item['content'] ?? '')?>"></div>

      <div class="mb-2">
        <label>Categories (ctrl/cmd click to multi-select)</label>
        <select class="form-select" name="categories[]" multiple>
          <?php foreach($categories as $c): ?>
            <option value="<?=htmlspecialchars($c['id'])?>" <?=in_array($c['id'], $item['categories'] ?? []) ? 'selected':''?>><?=htmlspecialchars($c['name'])?></option>
          <?php endforeach;?>
        </select>
      </div>

      <div class="mb-2"><input class="form-control" name="tags" placeholder="Comma separated tags" value="<?=htmlspecialchars(implode(',', $item['tags'] ?? []))?>"></div>
      <div class="mb-2"><input type="file" class="form-control" name="image"></div>
      <div class="form-check mb-2">
        <input class="form-check-input" type="checkbox" name="is_new" id="is_new" <?=!empty($item['is_new']) ? 'checked':''?>>
        <label class="form-check-label" for="is_new">Is New</label>
      </div>
      <div class="form-check mb-3">
        <input class="form-check-input" type="checkbox" name="is_featured" id="is_featured" <?=!empty($item['is_featured']) ? 'checked':''?>>
        <label class="form-check-label" for="is_featured">Featured</label>
      </div>

      <button class="btn btn-primary"><?= $editing ? 'Save Changes' : 'Add Game Code' ?></button>
    </form>
  </div>
</div>
</body>
</html>
