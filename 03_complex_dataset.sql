-- 1. Ampliación del Plan General Contable (Nuevas Cuentas)
INSERT INTO Cuentas_PGC (codigo_cuenta, nombre_cuenta, grupo, subgrupo) VALUES
('1000000', 'Capital Social', '1', '10'),
('2130000', 'Maquinaria y Equipos', '2', '21'),
('2813000', 'Amortización Acumulada de Maquinaria', '2', '28'),
('5720000', 'Bancos e Instituciones de Crédito', '5', '57'),
('6400000', 'Sueldos y Salarios', '6', '64'),
('6420000', 'Seguridad Social a cargo de la empresa', '6', '64'),
('6810000', 'Amortización del Inmovilizado Material', '6', '68'),
('4751000', 'Hacienda Pública, acreedora por retenciones (IRPF)', '4', '47'),
('4760000', 'Organismos de la Seguridad Social acreedores', '4', '47')
ON CONFLICT (codigo_cuenta) DO NOTHING;

-- 2. Nuevos Terceros
INSERT INTO Terceros (nif, razon_social, tipo_tercero) VALUES
('A00000000', 'Banco Santander SA', 'Otro'),
('G88888888', 'Tesorería General de la Seguridad Social', 'Otro'),
('Q2826000H', 'Agencia Tributaria (AEAT)', 'Otro')
ON CONFLICT (nif) DO NOTHING;

-- 3. Asientos Contables Complejos (Diario Contable)

-- Asiento 3: Aportación inicial de Capital en Banco (01/10/2026)
INSERT INTO Diario_Contable (num_asiento, fecha, codigo_cuenta, debe, haber, id_tercero, concepto) VALUES
(3, '2026-10-01', '5720000', 50000.00, 0.00, 3, 'Aportación inicial socios'),
(3, '2026-10-01', '1000000', 0.00, 50000.00, NULL, 'Constitución Capital Social');

-- Asiento 4: Compra de Maquinaria al contado (02/10/2026)
INSERT INTO Diario_Contable (num_asiento, fecha, codigo_cuenta, debe, haber, id_tercero, concepto) VALUES
(4, '2026-10-02', '2130000', 10000.00, 0.00, 2, 'Adquisición maquinaria industrial'),
(4, '2026-10-02', '4720000', 2100.00, 0.00, 2, '21% IVA soportado compra maquinaria'),
(4, '2026-10-02', '5720000', 0.00, 12100.00, 3, 'Pago por transferencia compra maquinaria');

-- Asiento 5: Devengo de Nómina mensual (31/10/2026)
INSERT INTO Diario_Contable (num_asiento, fecha, codigo_cuenta, debe, haber, id_tercero, concepto) VALUES
(5, '2026-10-31', '6400000', 3000.00, 0.00, NULL, 'Sueldos brutos plantilla'),
(5, '2026-10-31', '6420000', 900.00, 0.00, 4, 'Seguridad Social cuota patronal'),
(5, '2026-10-31', '4751000', 0.00, 450.00, 5, 'Retención IRPF empleados'),
(5, '2026-10-31', '4760000', 0.00, 1150.00, 4, 'Cuotas SS a ingresar'),
(5, '2026-10-31', '5720000', 0.00, 2300.00, 3, 'Pago nóminas netas por banco');

-- Asiento 6: Amortización mensual de Maquinaria (31/10/2026)
INSERT INTO Diario_Contable (num_asiento, fecha, codigo_cuenta, debe, haber, id_tercero, concepto) VALUES
(6, '2026-10-31', '6810000', 200.00, 0.00, NULL, 'Dotación amortización técnica mensual'),
(6, '2026-10-31', '2813000', 0.00, 200.00, NULL, 'Amortización acumulada maquinaria');