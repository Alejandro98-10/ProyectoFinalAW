# MicroVic – Guía de Rutas de Transporte Público
### Ciudad Victoria, Tamaulipas · Proyecto Final Aplicaciones Web

---

## Descripción

MicroVic es una Progressive Web App (PWA) que permite a los ciudadanos de Ciudad Victoria consultar y planificar sus viajes en microbús de forma fácil, accesible y funcional incluso sin conexión a internet.

---

## Funcionalidades implementadas

| # | Funcionalidad | Estado |
|---|---------------|--------|
| 1 | Planificador origen → destino con sugerencia de ruta | ✅ |
| 2 | Listado de rutas activas con números y nombres oficiales | ✅ |
| 3 | Mapa interactivo con trazado de ida y vuelta | ✅ |
| 4 | Tiempo estimado de caminata hasta parada sugerida | ✅ |
| 5 | Tabla de tarifas (general, estudiante, 3ra edad) | ✅ |
| 6 | Reportes anónimos de incidentes en tiempo real | ✅ |
| 7 | Caché offline (PWA / Service Worker) | ✅ |
| 8 | Puntos de interés (UAT, hospitales, comercios, etc.) | ✅ |

---

## Estructura de archivos

```
microvic/
├── index.html        ← App principal (SPA completa)
├── sw.js             ← Service Worker para modo offline/PWA
├── manifest.json     ← Manifiesto PWA (instalable en móvil)
├── icons/            ← Iconos de la app (192x192, 512x512)
└── README.md         ← Este archivo
```

---

## Instrucciones de despliegue

### Opción 1 – Local (desarrollo)
```bash
# Requiere servidor HTTP (no funciona abriendo index.html directo)
# Opción A: Python
python -m http.server 8080

# Opción B: Node.js
npx serve .

# Luego visita: http://localhost:8080
```

### Opción 2 – Producción recomendada
- **Netlify Drop**: Arrastra la carpeta `microvic/` a https://app.netlify.com/drop
- **Vercel**: `vercel deploy`
- **GitHub Pages**: sube a un repositorio y habilita Pages

> El Service Worker requiere HTTPS para funcionar (excepto en localhost).

---

## Rutas incluidas

| Núm | Nombre | Corredor |
|-----|--------|----------|
| 01  | Ruta 1 | Centro ↔ Parque Bicentenario |
| 06  | Ruta 6 | Col. del Maestro ↔ UAT |
| 12  | Ruta 12 | Hospital IMSS ↔ Central Camiones |
| 17  | Ruta 17 | Las Flores ↔ Soriana Reforma |
| B   | Ruta Blanca | Lomas Norte ↔ Col. G. Zúñiga |
| N   | Ruta Nocturna | Centro ↔ Colonias |

> **Nota**: Los trazados son representativos. Para datos oficiales precisos, 
> integrar con la API de la Dirección de Transporte Municipal de Cd. Victoria 
> o con el GTFS (General Transit Feed Specification) del municipio.

---

## Tecnologías utilizadas

- **HTML5 / CSS3 / Vanilla JavaScript** – Sin frameworks pesados
- **Leaflet.js 1.9.4** – Mapas interactivos con OpenStreetMap
- **Service Worker API** – Caché offline y comportamiento PWA
- **localStorage** – Persistencia de rutas cacheadas en el navegador
- **Web Geolocation API** – Detección de ubicación del usuario
- **Google Fonts** – Barlow + Barlow Condensed

---

## Para extender el proyecto

### Agregar rutas reales con GTFS
```javascript
// Descargar GTFS del municipio y parsear shapes.txt
fetch('/data/shapes.txt')
  .then(r => r.text())
  .then(data => parseGTFSShapes(data));
```

### Conectar API de reportes en tiempo real
```javascript
// Sustituir el array local `reportes` por una llamada a backend:
async function cargarReportes() {
  const res = await fetch('https://api.microvic.mx/reportes');
  reportes = await res.json();
  renderReportList();
}
```

### Push Notifications para incidentes
```javascript
// En sw.js, agregar listener de push:
self.addEventListener('push', event => {
  const data = event.data.json();
  self.registration.showNotification(data.titulo, {
    body: data.descripcion,
    icon: '/icons/icon-192.png'
  });
});
```

---

## Autor
Proyecto Final · Materia: Aplicaciones Web  
Tecnológico / Universidad · Ciudad Victoria, Tamaulipas · 2025
