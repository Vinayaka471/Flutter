<?php
require_once __DIR__ . '/config.php';
if (isset($_POST['username'])) {
    $u = trim($_POST['username']);
    $p = $_POST['password'];
    if (login_attempt($u, $p)) {
        header('Location: dashboard.php');
        exit;
    } else {
        $error = "Invalid credentials";
    }
}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Admin Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-md-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h4 class="card-title mb-3">Admin Login</h4>
          <?php if(!empty($error)): ?><div class="alert alert-danger"><?=htmlspecialchars($error)?></div><?php endif; ?>
          <form method="post">
            <div class="mb-2">
              <input class="form-control" name="username" placeholder="Username" required>
            </div>
            <div class="mb-3">
              <input class="form-control" name="password" type="password" placeholder="Password" required>
            </div>
            <button class="btn btn-primary w-100">Login</button>
          </form>
          <hr />
          <small class="text-muted">Default: admin / admin123 — change in Settings.</small>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
