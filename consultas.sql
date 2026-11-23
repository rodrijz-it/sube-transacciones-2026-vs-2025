-- Proyecto SUBE: transacciones del 1/01 al 31/10, 2026 vs. 2025
-- Fuente: datos.gob.ar (SUBE - Cantidad de transacciones (usos) por fecha)

-- 1) Tabla (en sqlite3: .import --csv --skip 1 <archivo.csv> sube, una vez por cada ano)
CREATE TABLE sube (DIA_TRANSPORTE TEXT, NOMBRE_EMPRESA TEXT, LINEA TEXT, AMBA TEXT, TIPO_TRANSPORTE TEXT, JURISDICCION TEXT, PROVINCIA TEXT, MUNICIPIO TEXT, CANTIDAD INTEGER, DATO_PRELIMINAR TEXT);

-- 2) Control: mismos dias en los dos anos (el archivo de 2026 llega hasta el 2/11, se corta al 31/10)
SELECT substr(DIA_TRANSPORTE,1,4) AS anio, MIN(DIA_TRANSPORTE) AS desde, MAX(DIA_TRANSPORTE) AS hasta, COUNT(*) AS filas, SUM(CANTIDAD) AS transacciones
FROM sube
WHERE substr(DIA_TRANSPORTE,6,5) <= '10-31'
GROUP BY anio;

-- 3) Control: peso de los datos preliminares
SELECT substr(DIA_TRANSPORTE,1,4) AS anio, DATO_PRELIMINAR, COUNT(*) AS filas, SUM(CANTIDAD) AS transacciones, MIN(DIA_TRANSPORTE) AS desde, MAX(DIA_TRANSPORTE) AS hasta
FROM sube
WHERE substr(DIA_TRANSPORTE,6,5) <= '10-31'
GROUP BY 1,2;

-- 4) Resumen por ano, mes y provincia (CABA unificada; el subte, que viene sin provincia, se asigna a CABA)
SELECT substr(DIA_TRANSPORTE,1,4) AS anio,
       substr(DIA_TRANSPORTE,6,2) AS mes,
       CASE WHEN PROVINCIA IN ('C.A.B.A','') OR PROVINCIA LIKE 'CIUDAD%' THEN 'CABA' ELSE PROVINCIA END AS provincia,
       SUM(CANTIDAD) AS transacciones
FROM sube
WHERE substr(DIA_TRANSPORTE,6,5) <= '10-31'
GROUP BY 1,2,3
ORDER BY 1,2,3;
