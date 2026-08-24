DROP TABLE IF EXISTS Diario_Contable CASCADE;
DROP TABLE IF EXISTS Terceros CASCADE;
DROP TABLE IF EXISTS Cuentas_PGC CASCADE;

CREATE TABLE Cuentas_PGC (
    codigo_cuenta VARCHAR(10) PRIMARY KEY,
    nombre_cuenta VARCHAR(100) NOT NULL,
    grupo CHAR(1) NOT NULL,
    subgrupo CHAR(2) NOT NULL
);

CREATE TABLE Terceros (
    id_tercero SERIAL PRIMARY KEY,
    nif VARCHAR(15) UNIQUE NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    tipo_tercero VARCHAR(20) CHECK (tipo_tercero IN ('Cliente', 'Proveedor', 'Otro'))
);

CREATE TABLE Diario_Contable (
    id_apunte SERIAL PRIMARY KEY,
    num_asiento INT NOT NULL,
    fecha DATE NOT NULL,
    codigo_cuenta VARCHAR(10) NOT NULL,
    debe NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    haber NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    id_tercero INT,
    concepto TEXT,
    CONSTRAINT fk_cuenta FOREIGN KEY (codigo_cuenta) REFERENCES Cuentas_PGC (codigo_cuenta),
    CONSTRAINT fk_tercero FOREIGN KEY (id_tercero) REFERENCES Terceros (id_tercero),
    CONSTRAINT chk_debe_haber CHECK (debe >= 0 AND haber >= 0)
);