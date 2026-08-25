-- Vista 1: Pérdidas y Ganancias (P&G)
CREATE OR REPLACE VIEW vw_perdidas_y_ganancias AS
SELECT 
    c.grupo,
    c.subgrupo,
    c.codigo_cuenta,
    c.nombre_cuenta,
    SUM(d.debe) AS total_debe,
    SUM(d.haber) AS total_haber,
    CASE 
        WHEN c.grupo = '7' THEN SUM(d.haber) - SUM(d.debe)
        WHEN c.grupo = '6' THEN SUM(d.debe) - SUM(d.haber)
        ELSE 0
    END AS saldo_pyg
FROM Cuentas_PGC c
JOIN Diario_Contable d ON c.codigo_cuenta = d.codigo_cuenta
WHERE c.grupo IN ('6', '7')
GROUP BY c.grupo, c.subgrupo, c.codigo_cuenta, c.nombre_cuenta;

-- Vista 2: Balance de Situación (Activo, Pasivo y Patrimonio Neto)
CREATE OR REPLACE VIEW vw_balance_situacion AS
SELECT 
    c.grupo,
    CASE 
        WHEN c.grupo IN ('2', '3', '5') OR (c.grupo = '4' AND SUM(d.debe) >= SUM(d.haber)) THEN 'ACTIVO'
        WHEN c.grupo IN ('1') OR (c.grupo = '4' AND SUM(d.haber) > SUM(d.debe)) THEN 'PASIVO_Y_PN'
        ELSE 'OTRO'
    END AS masa_patrimonial,
    c.codigo_cuenta,
    c.nombre_cuenta,
    SUM(d.debe) AS total_debe,
    SUM(d.haber) AS total_haber,
    SUM(d.debe) - SUM(d.haber) AS saldo_deudor,
    SUM(d.haber) - SUM(d.debe) AS saldo_acreedor
FROM Cuentas_PGC c
JOIN Diario_Contable d ON c.codigo_cuenta = d.codigo_cuenta
WHERE c.grupo IN ('1', '2', '3', '4', '5')
GROUP BY c.grupo, c.codigo_cuenta, c.nombre_cuenta;