-- ============================================================
--  MicroVic – Base de Datos
--  Motor: MySQL 5.7+ / MariaDB 10.4+
--  Importar en: phpMyAdmin o mysql -u root -p < microvic_db.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS microvic
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE microvic;

-- ──────────────────────────────────────────
--  TABLA: rutas
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS rutas (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  clave        VARCHAR(20)  NOT NULL UNIQUE,          -- 'r01', 'r12', 'rblanca'
  numero       VARCHAR(10)  NOT NULL,                 -- '01', '12', 'B'
  nombre       VARCHAR(120) NOT NULL,
  descripcion  VARCHAR(255) NOT NULL,
  color_hex    VARCHAR(7)   NOT NULL DEFAULT '#2e7d46',
  activa       TINYINT(1)   NOT NULL DEFAULT 1,
  creado_en    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ──────────────────────────────────────────
--  TABLA: ruta_coordenadas
--  Almacena los puntos del trazado (ida/vuelta)
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ruta_coordenadas (
  id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ruta_id   INT UNSIGNED NOT NULL,
  sentido   ENUM('ida','vuelta') NOT NULL,
  orden     SMALLINT UNSIGNED NOT NULL,   -- posición en el polilínea
  latitud   DECIMAL(10,7) NOT NULL,
  longitud  DECIMAL(10,7) NOT NULL,
  FOREIGN KEY (ruta_id) REFERENCES rutas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ──────────────────────────────────────────
--  TABLA: puntos_interes (POIs)
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS puntos_interes (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(120) NOT NULL,
  descripcion VARCHAR(255),
  tipo       VARCHAR(10)  NOT NULL,   -- emoji / código de ícono
  latitud    DECIMAL(10,7) NOT NULL,
  longitud   DECIMAL(10,7) NOT NULL,
  activo     TINYINT(1)   NOT NULL DEFAULT 1,
  creado_en  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ──────────────────────────────────────────
--  TABLA: reportes
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS reportes (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tipo        ENUM('cierre','desvio','accidente','manifestacion','inundacion','otro') NOT NULL,
  ruta_id     INT UNSIGNED NULL,                    -- puede ser NULL (todas las rutas)
  descripcion TEXT NOT NULL,
  activo      TINYINT(1)   NOT NULL DEFAULT 1,      -- 0 = resuelto/archivado
  creado_en   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ruta_id) REFERENCES rutas(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ──────────────────────────────────────────
--  TABLA: tarifas  (para completitud futura)
-- ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tarifas (
  id             INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tipo_usuario   VARCHAR(60) NOT NULL,
  precio         DECIMAL(6,2) NOT NULL,
  condiciones    VARCHAR(255),
  vigente_desde  DATE NOT NULL,
  activa         TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ============================================================
--  DATOS INICIALES
-- ============================================================

-- ── Rutas ──
INSERT INTO rutas (clave, numero, nombre, descripcion, color_hex) VALUES
('r01',      '01', 'Ruta 1 – Centro / Parque Bicentenario',   'Centro Histórico ↔ Col. Libertad ↔ Parque Bicentenario', '#e53935'),
('r06',      '06', 'Ruta 6 – Col. del Maestro / UAT',         'Col. del Maestro ↔ Centro ↔ UAT Campus Victoria',        '#1565c0'),
('r12',      '12', 'Ruta 12 – Hospital IMSS / Central',       'Hospital IMSS ↔ Centro ↔ Central Camiones',              '#2e7d46'),
('r17',      '17', 'Ruta 17 – Las Flores / Soriana',          'Col. Las Flores ↔ Plaza Victoria ↔ Soriana Reforma',     '#f57c00'),
('rblanca',  'B',  'Ruta Blanca – Norte / Sur',               'Col. Lomas ↔ Centro ↔ Col. Guillermo Zúñiga',           '#6d4c41'),
('rnocturna','N',  'Ruta Nocturna – Centro Histórico',        'Servicio nocturno · Centro ↔ Colonias principales',      '#4a148c');

-- ── Coordenadas: Ruta 01 ida ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(1,'ida',1,23.7369,-99.1467),(1,'ida',2,23.7350,-99.1480),(1,'ida',3,23.7330,-99.1500),
(1,'ida',4,23.7310,-99.1520),(1,'ida',5,23.7290,-99.1540),(1,'ida',6,23.7270,-99.1560),
(1,'ida',7,23.7250,-99.1580),(1,'ida',8,23.7230,-99.1600);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(1,'vuelta',1,23.7230,-99.1600),(1,'vuelta',2,23.7250,-99.1590),(1,'vuelta',3,23.7270,-99.1570),
(1,'vuelta',4,23.7290,-99.1550),(1,'vuelta',5,23.7310,-99.1530),(1,'vuelta',6,23.7330,-99.1510),
(1,'vuelta',7,23.7350,-99.1490),(1,'vuelta',8,23.7369,-99.1467);

-- ── Coordenadas: Ruta 06 ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(2,'ida',1,23.7500,-99.1350),(2,'ida',2,23.7480,-99.1370),(2,'ida',3,23.7460,-99.1390),
(2,'ida',4,23.7440,-99.1410),(2,'ida',5,23.7420,-99.1430),(2,'ida',6,23.7400,-99.1450),
(2,'ida',7,23.7369,-99.1467),(2,'ida',8,23.7340,-99.1480),(2,'ida',9,23.7310,-99.1490);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(2,'vuelta',1,23.7310,-99.1490),(2,'vuelta',2,23.7340,-99.1480),(2,'vuelta',3,23.7369,-99.1467),
(2,'vuelta',4,23.7390,-99.1460),(2,'vuelta',5,23.7420,-99.1440),(2,'vuelta',6,23.7450,-99.1420),
(2,'vuelta',7,23.7480,-99.1390),(2,'vuelta',8,23.7500,-99.1350);

-- ── Coordenadas: Ruta 12 ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(3,'ida',1,23.7550,-99.1550),(3,'ida',2,23.7520,-99.1530),(3,'ida',3,23.7490,-99.1510),
(3,'ida',4,23.7460,-99.1490),(3,'ida',5,23.7430,-99.1470),(3,'ida',6,23.7400,-99.1467),
(3,'ida',7,23.7369,-99.1467),(3,'ida',8,23.7340,-99.1480),(3,'ida',9,23.7300,-99.1500);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(3,'vuelta',1,23.7300,-99.1500),(3,'vuelta',2,23.7330,-99.1490),(3,'vuelta',3,23.7369,-99.1467),
(3,'vuelta',4,23.7400,-99.1460),(3,'vuelta',5,23.7430,-99.1470),(3,'vuelta',6,23.7460,-99.1490),
(3,'vuelta',7,23.7490,-99.1510),(3,'vuelta',8,23.7520,-99.1530),(3,'vuelta',9,23.7550,-99.1550);

-- ── Coordenadas: Ruta 17 ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(4,'ida',1,23.7200,-99.1300),(4,'ida',2,23.7230,-99.1320),(4,'ida',3,23.7260,-99.1340),
(4,'ida',4,23.7290,-99.1360),(4,'ida',5,23.7320,-99.1380),(4,'ida',6,23.7369,-99.1410),
(4,'ida',7,23.7400,-99.1440),(4,'ida',8,23.7420,-99.1460);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(4,'vuelta',1,23.7420,-99.1460),(4,'vuelta',2,23.7400,-99.1445),(4,'vuelta',3,23.7369,-99.1415),
(4,'vuelta',4,23.7340,-99.1395),(4,'vuelta',5,23.7310,-99.1375),(4,'vuelta',6,23.7280,-99.1355),
(4,'vuelta',7,23.7250,-99.1330),(4,'vuelta',8,23.7200,-99.1300);

-- ── Coordenadas: Ruta Blanca ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(5,'ida',1,23.7650,-99.1467),(5,'ida',2,23.7620,-99.1467),(5,'ida',3,23.7590,-99.1467),
(5,'ida',4,23.7560,-99.1467),(5,'ida',5,23.7530,-99.1467),(5,'ida',6,23.7500,-99.1467),
(5,'ida',7,23.7469,-99.1467),(5,'ida',8,23.7440,-99.1467),(5,'ida',9,23.7410,-99.1467),
(5,'ida',10,23.7369,-99.1467),(5,'ida',11,23.7340,-99.1467),(5,'ida',12,23.7300,-99.1467);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(5,'vuelta',1,23.7300,-99.1480),(5,'vuelta',2,23.7340,-99.1480),(5,'vuelta',3,23.7369,-99.1480),
(5,'vuelta',4,23.7410,-99.1480),(5,'vuelta',5,23.7440,-99.1480),(5,'vuelta',6,23.7469,-99.1480),
(5,'vuelta',7,23.7500,-99.1480),(5,'vuelta',8,23.7530,-99.1480),(5,'vuelta',9,23.7560,-99.1480),
(5,'vuelta',10,23.7590,-99.1480),(5,'vuelta',11,23.7620,-99.1480),(5,'vuelta',12,23.7650,-99.1467);

-- ── Coordenadas: Ruta Nocturna ──
INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(6,'ida',1,23.7369,-99.1467),(6,'ida',2,23.7380,-99.1450),(6,'ida',3,23.7395,-99.1430),
(6,'ida',4,23.7410,-99.1410),(6,'ida',5,23.7430,-99.1395),(6,'ida',6,23.7450,-99.1380);

INSERT INTO ruta_coordenadas (ruta_id, sentido, orden, latitud, longitud) VALUES
(6,'vuelta',1,23.7450,-99.1380),(6,'vuelta',2,23.7430,-99.1395),(6,'vuelta',3,23.7410,-99.1420),
(6,'vuelta',4,23.7395,-99.1440),(6,'vuelta',5,23.7380,-99.1455),(6,'vuelta',6,23.7369,-99.1467);

-- ── POIs ──
INSERT INTO puntos_interes (nombre, descripcion, tipo, latitud, longitud) VALUES
('Centro Histórico / Plaza de Armas', 'Corazón de Ciudad Victoria',              '🏛️', 23.7369, -99.1467),
('UAT Campus Victoria',               'Universidad Autónoma de Tamaulipas',       '🎓', 23.7500, -99.1330),
('Hospital IMSS',                     'IMSS – Unidad Médica Familiar',            '🏥', 23.7550, -99.1550),
('Hospital General',                  'Hospital General del Estado de Tamaulipas','🏥', 23.7310, -99.1490),
('Central Camiones Norte',            'Terminal de Autobuses Foráneos',           '🚌', 23.7300, -99.1500),
('Plaza Victoria',                    'Centro Comercial',                         '🏬', 23.7420, -99.1460),
('Parque Bicentenario',               'Parque urbano principal',                  '🌳', 23.7230, -99.1600),
('Mercado Hidalgo',                   'Mercado tradicional municipal',            '🛒', 23.7355, -99.1475),
('CBTIS 118',                         'Centro de Bachillerato Tecnológico',       '🏫', 23.7200, -99.1300);

-- ── Reportes de ejemplo ──
INSERT INTO reportes (tipo, ruta_id, descripcion) VALUES
('cierre',  5, 'Av. Hidalgo cerrada entre calle 13 y 14 por bacheo'),
('desvio',  3, 'Desvío por calle Morelos por obra de drenaje'),
('otro',    2, 'Microbús descompuesto frente al ISSSTE');

-- ── Tarifas ──
INSERT INTO tarifas (tipo_usuario, precio, condiciones, vigente_desde) VALUES
('Público en general',           10.00, NULL,                                              '2025-01-01'),
('Estudiantes',                   6.00, 'Credencial vigente, lunes a viernes horario escolar', '2025-01-01'),
('Adultos mayores (+60 años)',    5.00, 'Credencial INAPAM',                              '2025-01-01'),
('Personas con discapacidad',     5.00, 'Credencial oficial',                             '2025-01-01'),
('Niños menores de 5 años',       0.00, 'Acompañados de un adulto',                       '2025-01-01');
