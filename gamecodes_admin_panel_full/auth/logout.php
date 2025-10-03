<?php
require_once __DIR__ . '/../includes/config.php';
session_destroy();
header('Location: /gamecodes_admin_panel_full/auth/login.php');
exit;
