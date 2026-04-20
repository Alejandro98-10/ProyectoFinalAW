<?php
// ============================================================
//  MicroVic – Endpoint: Reportes Ciudadanos
//  Archivo: api/reportes.php
//
//  GET  /api/reportes.php          → Últimos 20 reportes activos
//  POST /api/reportes.php          → Crear nuevo reporte anónimo
//
//  Body POST (JSON):
//    { "tipo": "cierre", "ruta_id": 3, "descripcion": "..." }
//    ruta_id es opcional (null = afecta a todas las rutas)
// ============================================================

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/helpers.php';

setCORSHeaders();

$db = getDB();

// ── GET: listar reportes ──
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $stmt = $db->query('
        SELECT  r.id,
                r.tipo,
                r.descripcion,
                r.creado_en,
                ru.nombre AS ruta_nombre
        FROM reportes r
        LEFT JOIN rutas ru ON ru.id = r.ruta_id
        WHERE r.activo = 1
        ORDER BY r.creado_en DESC
        LIMIT 20
    ');

    $reportes = $stmt->fetchAll();

    // Agregar tiempo relativo
    foreach ($reportes as &$rep) {
        $rep['hace'] = tiempoRelativo($rep['creado_en']);
        unset($rep['creado_en']); // No exponer timestamp exacto
    }
    unset($rep);

    jsonOk($reportes);
}

// ── POST: crear reporte ──
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $body = getRequestBody();

    // Validación del tipo
    $tiposPermitidos = ['cierre','desvio','accidente','manifestacion','inundacion','otro'];
    $tipo = trim($body['tipo'] ?? '');
    if (!in_array($tipo, $tiposPermitidos, true)) {
        jsonError('El campo "tipo" es inválido. Valores permitidos: ' . implode(', ', $tiposPermitidos));
    }

    // Validación de descripción
    $descripcion = trim($body['descripcion'] ?? '');
    if (strlen($descripcion) < 5) {
        jsonError('La descripción debe tener al menos 5 caracteres.');
    }
    if (strlen($descripcion) > 500) {
        jsonError('La descripción no puede exceder 500 caracteres.');
    }

    // ruta_id es opcional
    $rutaId = isset($body['ruta_id']) && is_numeric($body['ruta_id'])
        ? (int)$body['ruta_id']
        : null;

    // Si viene ruta_id, verificar que exista
    if ($rutaId !== null) {
        $check = $db->prepare('SELECT id FROM rutas WHERE id = ? AND activa = 1 LIMIT 1');
        $check->execute([$rutaId]);
        if (!$check->fetch()) {
            jsonError('La ruta especificada no existe o está inactiva.', 404);
        }
    }

    // Insertar
    $stmt = $db->prepare('
        INSERT INTO reportes (tipo, ruta_id, descripcion)
        VALUES (?, ?, ?)
    ');
    $stmt->execute([$tipo, $rutaId, $descripcion]);
    $nuevoId = (int)$db->lastInsertId();

    jsonOk(['id' => $nuevoId, 'mensaje' => 'Reporte registrado exitosamente.'], 201);
}

// Método no soportado
jsonError('Método no permitido.', 405);
