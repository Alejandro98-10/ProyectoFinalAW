<?php
// ============================================================
//  MicroVic – Endpoint: Rutas
//  Archivo: api/rutas.php
//
//  GET  /api/rutas.php          → Lista todas las rutas activas
//  GET  /api/rutas.php?id=3     → Detalle + coordenadas de una ruta
// ============================================================

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/helpers.php';

setCORSHeaders();
requireMethod('GET');

$db = getDB();
$id = isset($_GET['id']) ? (int)$_GET['id'] : null;

// ── Detalle de una sola ruta con sus coordenadas ──
if ($id !== null) {

    // Datos de la ruta
    $stmt = $db->prepare('
        SELECT id, clave, numero, nombre, descripcion, color_hex, activa
        FROM rutas
        WHERE id = ? AND activa = 1
        LIMIT 1
    ');
    $stmt->execute([$id]);
    $ruta = $stmt->fetch();

    if (!$ruta) {
        jsonError('Ruta no encontrada o inactiva.', 404);
    }

    // Coordenadas ordenadas por sentido y orden
    $stmt2 = $db->prepare('
        SELECT sentido, orden, latitud, longitud
        FROM ruta_coordenadas
        WHERE ruta_id = ?
        ORDER BY sentido ASC, orden ASC
    ');
    $stmt2->execute([$id]);
    $coordRows = $stmt2->fetchAll();

    $coords_ida    = [];
    $coords_vuelta = [];

    foreach ($coordRows as $row) {
        $punto = [(float)$row['latitud'], (float)$row['longitud']];
        if ($row['sentido'] === 'ida') {
            $coords_ida[] = $punto;
        } else {
            $coords_vuelta[] = $punto;
        }
    }

    // POIs de la ciudad asociados a esta ruta (todos, para mostrar en el mapa)
    $pois = $db->query('
        SELECT nombre, descripcion, tipo,
               CAST(latitud AS FLOAT)  AS lat,
               CAST(longitud AS FLOAT) AS lng
        FROM puntos_interes
        WHERE activo = 1
        ORDER BY nombre ASC
    ')->fetchAll();

    $ruta['coords_ida']    = $coords_ida;
    $ruta['coords_vuelta'] = $coords_vuelta;
    $ruta['pois']          = $pois;

    jsonOk($ruta);
}

// ── Lista de todas las rutas activas ──
$rutas = $db->query('
    SELECT id, clave, numero, nombre, descripcion, color_hex
    FROM rutas
    WHERE activa = 1
    ORDER BY numero ASC
')->fetchAll();

// Agregar lista de nombres de POIs por ruta para el sidebar
// (simplificado: los POIs son globales, no por ruta en este modelo)
jsonOk($rutas);
