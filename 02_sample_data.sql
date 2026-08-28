INSERT INTO Cuentas_PGC (codigo_cuenta, nombre_cuenta, grupo, subgrupo) VALUES
('7000000', 'Ventas de mercaderías', '7', '70'),
('6000000', 'Compras de mercaderías', '6', '60'),
('4300000', 'Clientes', '4', '43'),
('4000000', 'Proveedores', '4', '40'),
('4770000', 'Hacienda Pública, IVA repercutido', '4', '47'),
('4720000', 'Hacienda Pública, IVA soportado', '4', '47');

INSERT INTO Terceros (nif, razon_social, tipo_tercero) VALUES
('B12345678', 'Logística del Levante SL', 'Cliente'),
('A98765432', 'Suministros Industriales SA', 'Proveedor');

INSERT INTO Diario_Contable (num_asiento, fecha, codigo_cuenta, debe, haber, id_tercero, concepto) VALUES
(1, '2026-10-01', '4300000', 1210.00, 0.00, 1, 'Factura emitidamente v/favor'),
(1, '2026-10-01', '7000000', 0.00, 1000.00, 1, 'Ingreso por venta mercadería'),
(1, '2026-10-01', '4770000', 0.00, 210.00, 1, '21% IVA Repercutido'),
(2, '2026-10-05', '6000000', 500.00, 0.00, 2, 'Compra de material de almacén'),
(2, '2026-10-05', '4720000', 105.00, 0.00, 2, '21% IVA Soportado'),
(2, '2026-10-05', '4000000', 0.00, 605.00, 2, 'Factura n/contra');

-- Asiento 5: Ingresos por Consultoría (Para revertir ROE y ROA negativos)
INSERT INTO Diario_Contable (num_asiento, codigo_cuenta, debe, haber) VALUES
(5, '4300000', 18150, 0),    -- Clientes (Aumenta Activo Corriente en 18.150 €)
(5, '7000000', 0, 15000),    -- Prestación de servicios (Genera Beneficio de 15.000 €)
(5, '4770000', 0, 3150);     -- IVA Repercutido (Aumenta Pasivo Corriente en 3.150 €)

-- Asiento 6: Préstamo Bancario a Corto Plazo (Para bajar la liquidez a la tierra)
INSERT INTO Diario_Contable (num_asiento, codigo_cuenta, debe, haber) VALUES
(6, '5720000', 25000, 0),    -- Bancos (Aumenta Activo Corriente en 25.000 €)
(6, '5200000', 0, 25000);    -- Deudas a c/p con entidades de crédito (Aumenta Pasivo Corriente en 25.000 €)