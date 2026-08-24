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