<?php
// ============================================================
//  MicroVic – Helpers de respuesta JSON y CORS
//  Archivo: api/helpers.php
// ============================================================

/**
 * Configura headers CORS para que el frontend en otro puerto
 * (ej. index.html abierto directamente) pueda consumir la API.
 */
function setCORSHeaders(): void {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Accept');
    header('Content-Type: application/json; charset=utf-8');

    // Pre-flight OPTIONS request
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(204);
        exit;
    }
}

/**
 * Envía una respuesta JSON exitosa y termina la ejecución.
 */
function jsonOk(mixed $data, int $status = 200): never {
    http_response_code($status);
    echo json_encode([
        'ok'   => true,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

/**
 * Envía una respuesta JSON de error y termina la ejecución.
 */
function jsonError(string $mensaje, int $status = 400): never {
    http_response_code($status);
    echo json_encode([
        'ok'      => false,
        'mensaje' => $mensaje
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

/**
 * Valida que el método HTTP sea el esperado.
 */
function requireMethod(string $method): void {
    if ($_SERVER['REQUEST_METHOD'] !== strtoupper($method)) {
        jsonError('Método no permitido. Se esperaba ' . $method, 405);
    }
}

/**
 * Obtiene y decodifica el JSON del cuerpo de la petición.
 */
function getRequestBody(): array {
    $raw  = file_get_contents('php://input');
    $body = json_decode($raw, true);
    if (!is_array($body)) {
        jsonError('El cuerpo de la petición debe ser JSON válido.', 400);
    }
    return $body;
}

/**
 * Convierte la hora relativa de un timestamp a texto legible.
 * Ej: "hace 5 min", "hace 2 h", "hace 3 días"
 */
function tiempoRelativo(string $timestamp): string {
    $diff = time() - strtotime($timestamp);
    if ($diff < 60)          return 'hace un momento';
    if ($diff < 3600)        return 'hace ' . intdiv($diff, 60) . ' min';
    if ($diff < 86400)       return 'hace ' . intdiv($diff, 3600) . ' h';
    return 'hace ' . intdiv($diff, 86400) . ' días';
}
