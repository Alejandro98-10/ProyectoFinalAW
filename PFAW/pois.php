<?php
// ============================================================
//  MicroVic – Endpoint: Puntos de Interés (POIs)
//  Archivo: api/pois.php
//
//  GET /api/pois.php   → Lista todos los POIs activos
// ============================================================

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/helpers.php';

setCORSHeaders();
requireMethod('GET');

$db   = getDB();
$pois = $db->query('
    SELECT  id,
            nombre,
            descripcion,
            tipo,
            CAST(latitud  AS FLOAT) AS lat,
            CAST(longitud AS FLOAT) AS lng
    FROM puntos_interes
    WHERE activo = 1
    ORDER BY nombre ASC
')->fetchAll();

jsonOk($pois);
