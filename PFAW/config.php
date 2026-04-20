<?php
// ============================================================
//  MicroVic – Configuración de base de datos
//  Archivo: api/config.php
// ============================================================

define('DB_HOST', 'localhost');
define('DB_PORT', 3306);
define('DB_NAME', 'microvic');
define('DB_USER', 'root');      // Cambia si tienes otro usuario en XAMPP
define('DB_PASS', '');          // Por defecto XAMPP no tiene contraseña

/**
 * Crea y retorna una conexión PDO a MySQL.
 * Lanza una excepción si no se puede conectar.
 */
function getDB(): PDO {
    static $pdo = null;
    if ($pdo !== null) return $pdo;

    $dsn = sprintf(
        'mysql:host=%s;port=%d;dbname=%s;charset=utf8mb4',
        DB_HOST, DB_PORT, DB_NAME
    );

    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
    } catch (PDOException $e) {
        http_response_code(500);
        header('Content-Type: application/json');
        echo json_encode([
            'error' => true,
            'mensaje' => 'No se pudo conectar a la base de datos: ' . $e->getMessage()
        ]);
        exit;
    }

    return $pdo;
}
