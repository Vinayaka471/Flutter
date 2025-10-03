<?php
require_once __DIR__ . '/../includes/config.php';
$err = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $u = $_POST['username'] ?? '';
    $p = $_POST['password'] ?? '';
    if ($u === ADMIN_USER && $p === ADMIN_PASS) {
        $_SESSION['is_admin'] = true;
        header('Location: /gamecodes_admin_panel_full/');
        exit;
    } else {
        $err = 'Invalid credentials';
    }
}
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Admin Login</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/gamecodes_admin_panel_full/assets/css/styles.css">
</head>
<body class="d-flex align-items-center justify-content-center" style="height:100vh;background:#f8f9fa;">
  <div class="card p-4" style="width:360px;">
    <h4 class="mb-3">Admin Login</h4>
    <?php if($err): ?><div class="alert alert-danger"><?=htmlspecialchars($err)?></div><?php endif; ?>
    <form method="post">
      <div class="mb-2">
        <input name="username" class="form-control" placeholder="Username" required>
      </div>
      <div class="mb-3">
        <input name="password" type="password" class="form-control" placeholder="Password" required>
      </div>
      <button class="btn btn-primary w-100" type="submit">Login</button>
    </form>
  </div>
</body>
</html>
