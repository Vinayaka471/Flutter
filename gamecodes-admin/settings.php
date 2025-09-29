<?php
require_once __DIR__ . '/config.php';
require_auth();

$settings_file = DATA_DIR . '/settings.json';
$settings = file_exists($settings_file) ? json_decode(file_get_contents($settings_file), true) : [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!empty($_POST['admin_user'])) $settings['admin_user'] = trim($_POST['admin_user']);
    if (!empty($_POST['admin_pass'])) $settings['admin_pass_hash'] = password_hash($_POST['admin_pass'], PASSWORD_DEFAULT);
    if (!empty($_POST['api_token'])) $settings['api_token'] = trim($_POST['api_token']);
    if (!empty($_POST['firebase_key'])) $settings['firebase_key'] = trim($_POST['firebase_key']);
    file_put_contents($settings_file, json_encode($settings, JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
    $saved = true;
}

?>
<!doctype html>
<html><head><meta charset="utf-8"><title>Settings</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body class="bg-light">
<div class="container py-4">
  <a href="dashboard.php" class="btn btn-link">&larr; Back</a>
  <h4>Settings</h4>
  <?php if(!empty($saved)): ?><div class="alert alert-success">Saved</div><?php endif; ?>
  <form method="post">
    <div class="mb-2"><input class="form-control" name="admin_user" placeholder="Admin username" value="<?=htmlspecialchars($settings['admin_user'] ?? '')?>"></div>
    <div class="mb-2"><input class="form-control" name="admin_pass" type="password" placeholder="New admin password (leave blank to keep)"></div>
    <div class="mb-2"><input class="form-control" name="api_token" placeholder="API token" value="<?=htmlspecialchars($settings['api_token'] ?? '')?>"></div>
    <div class="mb-2"><input class="form-control" name="firebase_key" placeholder="Firebase Server Key" value="<?=htmlspecialchars($settings['firebase_key'] ?? '')?>"></div>
    <button class="btn btn-primary">Save Settings</button>
  </form>
  <hr>
  <h5>Danger Zone</h5>
  <form method="post" onsubmit="return confirm('Are you sure?');">
    <button name="reset" value="1" class="btn btn-danger">Reset data (clear json)</button>
  </form>
</div>
</body></html>
