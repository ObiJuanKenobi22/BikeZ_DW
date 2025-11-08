-- ************ LOTE 1: CREAR LA BASE DE DATOS (SI NO EXISTE) ************
USE [master]
GO

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikeZ_DW')
BEGIN
    PRINT 'Creando la base de datos [BikeZ_DW]...';
    
    -- He copiado la configuración de tu script original para la BD
    CREATE DATABASE [BikeZ_DW]
     CONTAINMENT = NONE
     ON  PRIMARY 
    ( NAME = N'BikeZ_DW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BikeZ_DW.mdf' , SIZE = 401408KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
     LOG ON 
    ( NAME = N'BikeZ_DW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BikeZ_DW_log.ldf' , SIZE = 3022848KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
     WITH CATALOG_COLLATION = DATABASE_DEFAULT;
    
    PRINT 'Base de datos [BikeZ_DW] creada.';
END
ELSE
BEGIN
    PRINT 'La base de datos [BikeZ_DW] ya existe. No se crea.';
END
GO -- Fin del Lote 1

-- ************ LOTE 2: CONFIGURAR Y USAR LA BASE DE DATOS ************
-- (Este lote aplica las configuraciones avanzadas y cambia el contexto)
USE [BikeZ_DW]
GO

ALTER DATABASE [BikeZ_DW] SET COMPATIBILITY_LEVEL = 150;
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BikeZ_DW].[dbo].[sp_fulltext_database] @action = 'enable'
end
ALTER DATABASE [BikeZ_DW] SET ANSI_NULL_DEFAULT OFF;
ALTER DATABASE [BikeZ_DW] SET ANSI_NULLS OFF;
ALTER DATABASE [BikeZ_DW] SET ANSI_PADDING OFF;
ALTER DATABASE [BikeZ_DW] SET ANSI_WARNINGS OFF;
ALTER DATABASE [BikeZ_DW] SET ARITHABORT OFF;
ALTER DATABASE [BikeZ_DW] SET AUTO_CLOSE OFF;
ALTER DATABASE [BikeZ_DW] SET AUTO_SHRINK OFF;
ALTER DATABASE [BikeZ_DW] SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE [BikeZ_DW] SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE [BikeZ_DW] SET CURSOR_DEFAULT  GLOBAL;
ALTER DATABASE [BikeZ_DW] SET CONCAT_NULL_YIELDS_NULL OFF;
ALTER DATABASE [BikeZ_DW] SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE [BikeZ_DW] SET QUOTED_IDENTIFIER OFF;
ALTER DATABASE [BikeZ_DW] SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE [BikeZ_DW] SET  DISABLE_BROKER;
ALTER DATABASE [BikeZ_DW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE [BikeZ_DW] SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE [BikeZ_DW] SET TRUSTWORTHY OFF;
ALTER DATABASE [BikeZ_DW] SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE [BikeZ_DW] SET PARAMETERIZATION SIMPLE;
ALTER DATABASE [BikeZ_DW] SET READ_COMMITTED_SNAPSHOT OFF;
ALTER DATABASE [BikeZ_DW] SET HONOR_BROKER_PRIORITY OFF;
ALTER DATABASE [BikeZ_DW] SET RECOVERY FULL;
ALTER DATABASE [BikeZ_DW] SET  MULTI_USER;
ALTER DATABASE [BikeZ_DW] SET PAGE_VERIFY CHECKSUM;
ALTER DATABASE [BikeZ_DW] SET DB_CHAINING OFF;
ALTER DATABASE [BikeZ_DW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF );
ALTER DATABASE [BikeZ_DW] SET TARGET_RECOVERY_TIME = 60 SECONDS;
ALTER DATABASE [BikeZ_DW] SET DELAYED_DURABILITY = DISABLED;
ALTER DATABASE [BikeZ_DW] SET ACCELERATED_DATABASE_RECOVERY = OFF;
EXEC sys.sp_db_vardecimal_storage_format N'BikeZ_DW', N'ON';
ALTER DATABASE [BikeZ_DW] SET QUERY_STORE = OFF;
GO -- Fin del Lote 2


-- ************ LOTE 3: CREAR TABLAS Y FKs (SI NO EXISTEN) ************
USE [BikeZ_DW]
GO

-- Verificamos si la tabla principal (Hechos) ya existe.
-- Si no existe, asumimos que ninguna tabla existe y creamos todo.
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FT_VENTA]') AND type in (N'U'))
BEGIN
    PRINT 'Creando todas las tablas y llaves foráneas en [BikeZ_DW]...';
    
    -- IMPORTANTE:
    -- Todo el script de creación debe ir en UN SOLO BLOQUE (BEGIN...END)
    -- Por eso, he quitado todos los 'GO' intermedios de tu script original.
    
    SET ANSI_NULLS ON;
    SET QUOTED_IDENTIFIER ON;

    CREATE TABLE [dbo].[DT_Almacen](
        [AlmacenID] [int] NOT NULL,
        [Almacen] [nvarchar](50) NOT NULL,
        [TerritorioID] [int] NULL,
     CONSTRAINT [PK_DT_Almacen] PRIMARY KEY CLUSTERED 
    ( [AlmacenID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Categoria_Producto](
        [CategoriaID] [int] NOT NULL,
        [Categoria] [nvarchar](50) NOT NULL,
     CONSTRAINT [PK_DT_Categoria_Producto] PRIMARY KEY CLUSTERED 
    ( [CategoriaID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Cliente](
        [ClienteID] [int] NOT NULL,
        [Nom_Cliente] [nvarchar](255) NOT NULL,
     CONSTRAINT [PK_DT_Cliente] PRIMARY KEY CLUSTERED 
    ( [ClienteID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Empleado](
        [EmpleadoID] [int] NOT NULL,
        [Cargo] [nvarchar](50) NOT NULL,
        [FechaNacimiento] [date] NOT NULL,
        [EstadoCivil] [nchar](1) NOT NULL,
        [Genero] [nchar](1) NOT NULL,
        [FechaContratacion] [date] NOT NULL,
        [HorasVacaciones] [smallint] NOT NULL,
        [TerritorioID] [int] NULL,
     CONSTRAINT [PK_DT_Empleado] PRIMARY KEY CLUSTERED 
    ( [EmpleadoID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_FechaCom](
        [FechaComID] [int] NOT NULL,
        [dia] [int] NOT NULL,
        [semana] [int] NOT NULL,
        [mes] [int] NOT NULL,
        [semestre] [int] NOT NULL,
        [annio] [int] NOT NULL,
     CONSTRAINT [PK_DT_Tiempo] PRIMARY KEY CLUSTERED 
    ( [FechaComID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_FechaEnv](
        [FechaEnvID] [int] NOT NULL,
        [dia] [int] NOT NULL,
        [semana] [int] NOT NULL,
        [mes] [int] NOT NULL,
        [semestre] [int] NOT NULL,
        [annio] [int] NOT NULL,
     CONSTRAINT [PK_DT_FechaEnv] PRIMARY KEY CLUSTERED 
    ( [FechaEnvID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Pais_Almacen](
        [PaisID] [nvarchar](3) NOT NULL,
        [Pais] [nvarchar](50) NOT NULL,
     CONSTRAINT [PK_Pais_Almacen] PRIMARY KEY CLUSTERED 
    ( [PaisID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Pais_Empleado](
        [PaisID] [nvarchar](3) NOT NULL,
        [Pais] [nvarchar](50) NOT NULL,
     CONSTRAINT [PK_Pais_Empleado] PRIMARY KEY CLUSTERED 
    ( [PaisID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Pais_Venta](
        [PaisID] [nvarchar](3) NOT NULL,
        [Pais] [nvarchar](50) NULL,
     CONSTRAINT [PK_DT_Pais_Venta] PRIMARY KEY CLUSTERED 
    ( [PaisID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Producto](
        [ProductoID] [int] NOT NULL,
        [NomProducto] [nvarchar](50) NULL,
        [Color] [nvarchar](15) NULL,
        [CategoriaID] [int] NOT NULL, -- Corregido del script anterior
     CONSTRAINT [PK_DT_Producto] PRIMARY KEY CLUSTERED 
    ( [ProductoID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Territorio_Almacen](
        [TerritorioID] [int] NOT NULL,
        [Territorio] [nvarchar](50) NOT NULL,
        [Grupo] [nvarchar](50) NOT NULL,
        [PaisID] [nvarchar](3) NOT NULL,
     CONSTRAINT [PK_DT_Territorio_Almacen] PRIMARY KEY CLUSTERED 
    ( [TerritorioID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Territorio_Empleado](
        [TerritorioID] [int] NOT NULL,
        [Territorio] [nvarchar](50) NOT NULL,
        [Grupo] [nvarchar](50) NOT NULL,
        [PaisID] [nvarchar](3) NOT NULL,
     CONSTRAINT [PK_DT_Territorio_Empleado] PRIMARY KEY CLUSTERED 
    ( [TerritorioID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    CREATE TABLE [dbo].[DT_Territorio_Venta](
        [TerritorioID] [int] NOT NULL,
        [Territorio] [nvarchar](50) NOT NULL,
        [Grupos] [nvarchar](50) NOT NULL,
        [PaisID] [nvarchar](3) NULL,
     CONSTRAINT [PK_DT_Territorio_Ventas] PRIMARY KEY CLUSTERED 
    ( [TerritorioID] ASC )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    -- Esta tabla estaba en tu script original
    CREATE TABLE [dbo].[Empleado_Paso](
        [EmpleadoID] [int] NULL,
        [Cargo] [nvarchar](50) NULL,
        [FechaNacimiento] [date] NULL,
        [EstadoCivil] [nvarchar](1) NULL,
        [Genero] [nvarchar](1) NULL,
        [FechaContratacion] [date] NULL,
        [HorasVacaciones] [smallint] NULL,
        [TerritorioID] [int] NULL
    ) ON [PRIMARY];

    -- Tabla de Hechos (Fact Table)
    CREATE TABLE [dbo].[FT_VENTA](
        [VentaID] [int] NOT NULL,
        [ProductoID] [int] NOT NULL,
        [EmpleadoID] [int] NOT NULL,
        [ClienteID] [int] NOT NULL,
        [FechaComID] [int] NOT NULL,
        [FechaEnvID] [int] NOT NULL,
        [TerritorioVenID] [int] NOT NULL,
        [Cantidad] [smallint] NOT NULL,
        [PrecioUnitario] [money] NOT NULL,
        [Total_Venta] [int] NULL,
     CONSTRAINT [PK_FT_VENTA] PRIMARY KEY CLUSTERED 
    (
        [VentaID] ASC, [ProductoID] ASC, [EmpleadoID] ASC, [ClienteID] ASC, [FechaComID] ASC, [FechaEnvID] ASC, [TerritorioVenID] ASC
    )
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
    ) ON [PRIMARY];

    
    -- Creación de todas las llaves foráneas (FK)
    
    ALTER TABLE [dbo].[DT_Almacen]  WITH CHECK ADD  CONSTRAINT [FK_DT_Almacen_DT_Territorio_Almacen] FOREIGN KEY([TerritorioID])
    REFERENCES [dbo].[DT_Territorio_Almacen] ([TerritorioID]);
    ALTER TABLE [dbo].[DT_Almacen] CHECK CONSTRAINT [FK_DT_Almacen_DT_Territorio_Almacen];

    ALTER TABLE [dbo].[DT_Empleado]  WITH CHECK ADD  CONSTRAINT [FK_DT_Empleado_DT_Territorio_Empleado] FOREIGN KEY([TerritorioID])
    REFERENCES [dbo].[DT_Territorio_Empleado] ([TerritorioID]);
    ALTER TABLE [dbo].[DT_Empleado] CHECK CONSTRAINT [FK_DT_Empleado_DT_Territorio_Empleado];

    -- Esta es la FK correcta (Producto -> Categoria)
    ALTER TABLE [dbo].[DT_Producto]  WITH CHECK ADD  CONSTRAINT [FK_DT_Producto_DT_Categoria_Producto] FOREIGN KEY([CategoriaID])
    REFERENCES [dbo].[DT_Categoria_Producto] ([CategoriaID]);
    ALTER TABLE [dbo].[DT_Producto] CHECK CONSTRAINT [FK_DT_Producto_DT_Categoria_Producto];

    ALTER TABLE [dbo].[DT_Territorio_Almacen]  WITH CHECK ADD  CONSTRAINT [FK_DT_Territorio_Almacen_DT_Pais_Almacen] FOREIGN KEY([PaisID])
    REFERENCES [dbo].[DT_Pais_Almacen] ([PaisID]);
    ALTER TABLE [dbo].[DT_Territorio_Almacen] CHECK CONSTRAINT [FK_DT_Territorio_Almacen_DT_Pais_Almacen];

    ALTER TABLE [dbo].[DT_Territorio_Empleado]  WITH CHECK ADD  CONSTRAINT [FK_DT_Territorio_Empleado_DT_Pais_Empleado] FOREIGN KEY([PaisID])
    REFERENCES [dbo].[DT_Pais_Empleado] ([PaisID]);
    ALTER TABLE [dbo].[DT_Territorio_Empleado] CHECK CONSTRAINT [FK_DT_Territorio_Empleado_DT_Pais_Empleado];

    ALTER TABLE [dbo].[DT_Territorio_Venta]  WITH CHECK ADD  CONSTRAINT [FK_DT_Territorio_Venta_DT_Pais_Venta] FOREIGN KEY([PaisID])
    REFERENCES [dbo].[DT_Pais_Venta] ([PaisID]);
    ALTER TABLE [dbo].[DT_Territorio_Venta] CHECK CONSTRAINT [FK_DT_Territorio_Venta_DT_Pais_Venta];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_Cliente] FOREIGN KEY([ClienteID])
    REFERENCES [dbo].[DT_Cliente] ([ClienteID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_Cliente];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_Empleado] FOREIGN KEY([EmpleadoID])
    REFERENCES [dbo].[DT_Empleado] ([EmpleadoID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_Empleado];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_FechaCom] FOREIGN KEY([FechaComID])
    REFERENCES [dbo].[DT_FechaCom] ([FechaComID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_FechaCom];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_FechaEnv] FOREIGN KEY([FechaEnvID])
    REFERENCES [dbo].[DT_FechaEnv] ([FechaEnvID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_FechaEnv];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_Producto] FOREIGN KEY([ProductoID])
    REFERENCES [dbo].[DT_Producto] ([ProductoID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_Producto];

    ALTER TABLE [dbo].[FT_VENTA]  WITH CHECK ADD  CONSTRAINT [FK_FT_VENTA_DT_Territorio_Venta] FOREIGN KEY([TerritorioVenID])
    REFERENCES [dbo].[DT_Territorio_Venta] ([TerritorioID]);
    ALTER TABLE [dbo].[FT_VENTA] CHECK CONSTRAINT [FK_FT_VENTA_DT_Territorio_Venta];

    PRINT 'Script completado. Las tablas y FKs han sido creadas en [BikeZ_DW].';
    
END -- Fin del IF NOT EXISTS FT_VENTA
ELSE
BEGIN
    PRINT 'La tabla [FT_VENTA] ya existe. No se ejecuta el script de creación de tablas.';
END
GO -- Fin del Lote 3


-- ************ LOTE 4: FINALIZAR ************
USE [master]
GO
ALTER DATABASE [BikeZ_DW] SET  READ_WRITE 
GO -- Fin del Lote 4