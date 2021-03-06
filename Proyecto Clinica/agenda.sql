USE [Agenda]
GO
/****** Object:  Table [dbo].[Citas]    Script Date: 27/11/2018 01:56:49 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Citas](
	[Id_Cita] [int] NOT NULL,
	[Hora_Cita] [time](7) NOT NULL,
	[Dia_Cita] [date] NOT NULL,
	[Asunto] [varchar](60) NOT NULL,
	[Id_Doctor] [int] NULL,
	[Id_Consultorio] [int] NULL,
	[Id_Cliente] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clientes]    Script Date: 27/11/2018 01:56:50 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clientes](
	[Id_Cliente] [int] NOT NULL,
	[Nombre] [varchar](60) NOT NULL,
	[Telefono] [varchar](30) NOT NULL,
	[Ciudad] [varchar](50) NULL,
	[Direccion] [varchar](40) NULL,
	[Cp] [int] NULL,
	[Correo] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Consultorio]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Consultorio](
	[Id_Consultorio] [int] NOT NULL,
	[Hora_Inicio] [time](7) NOT NULL,
	[Hora_Final] [time](7) NOT NULL,
	[Id_Doctor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Consultorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[Id_Doctor] [int] NOT NULL,
	[Nombre] [varchar](60) NOT NULL,
	[Correo] [varchar](30) NOT NULL,
	[Telefono] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Doctor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Laboratorio]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Laboratorio](
	[Id_Laboratorio] [int] NOT NULL,
	[Resultados] [varchar](100) NOT NULL,
	[Id_Doctor] [int] NULL,
	[Id_Cliente] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Laboratorio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Receta]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receta](
	[Id_Receta] [int] NOT NULL,
	[cantidad] [int] NULL,
	[Nombre_Medicamento] [varchar](100) NOT NULL,
	[Id_Cliente] [int] NOT NULL,
	[Id_Doctor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Cliente] ASC,
	[Id_Doctor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD FOREIGN KEY([Id_Cliente])
REFERENCES [dbo].[Clientes] ([Id_Cliente])
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD FOREIGN KEY([Id_Consultorio])
REFERENCES [dbo].[Consultorio] ([Id_Consultorio])
GO
ALTER TABLE [dbo].[Citas]  WITH CHECK ADD FOREIGN KEY([Id_Doctor])
REFERENCES [dbo].[Doctor] ([Id_Doctor])
GO
ALTER TABLE [dbo].[Consultorio]  WITH CHECK ADD FOREIGN KEY([Id_Doctor])
REFERENCES [dbo].[Doctor] ([Id_Doctor])
GO
ALTER TABLE [dbo].[Laboratorio]  WITH CHECK ADD FOREIGN KEY([Id_Cliente])
REFERENCES [dbo].[Clientes] ([Id_Cliente])
GO
ALTER TABLE [dbo].[Laboratorio]  WITH CHECK ADD FOREIGN KEY([Id_Doctor])
REFERENCES [dbo].[Doctor] ([Id_Doctor])
GO
ALTER TABLE [dbo].[Receta]  WITH CHECK ADD FOREIGN KEY([Id_Cliente])
REFERENCES [dbo].[Clientes] ([Id_Cliente])
GO
ALTER TABLE [dbo].[Receta]  WITH CHECK ADD FOREIGN KEY([Id_Doctor])
REFERENCES [dbo].[Doctor] ([Id_Doctor])
GO
/****** Object:  StoredProcedure [dbo].[Agregarclientes]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Agregarclientes]
@Id_Cliente int,@Nombre varchar(60),@Telefono varchar(30)
AS
BEGIN
	if not exists(select*From Clientes where (Id_Cliente=@Id_Cliente))
	Begin
	Insert into 
	Clientes(Id_Cliente,Nombre,Telefono)
	Values
	(@Id_Cliente,@Nombre,@Telefono)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[editar_cita]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[editar_cita]
@Id_cita as int,
@Hora_cita as time,
@Dia_Cita as date,
@Asunto as varchar(50),
@Id_Doctor as int,
@Id_Consultorio as int,
@Id_Cliente as int

as
update Citas set Hora_Cita=@Hora_cita,Dia_Cita=@Dia_Cita,Asunto=@Asunto,Id_Doctor=@Id_Doctor,Id_Consultorio=@Id_Consultorio,Id_Cliente=@Id_Cliente
where Id_Cita=@Id_cita
GO
/****** Object:  StoredProcedure [dbo].[editar_cliente]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[editar_cliente]
@Id_Cliente as int,
@Nombre as varchar(60),
@Telefono as varchar(30),
@Ciudad as varchar(50),
@Direccion as varchar(40),
@Cp as int,
@Correo as varchar(50)
as
update Clientes set Nombre=@Nombre,Telefono=@Telefono,Ciudad=@Ciudad,Direccion=@Direccion,cp=@cp,Correo=@Correo
where Id_Cliente=@Id_Cliente
GO
/****** Object:  StoredProcedure [dbo].[editar_doct]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[editar_doct]
@Id_Doctor as int,
@Nombre as varchar(60),
@Correo as varchar(50),
@Telefono as varchar(30)

as
update Doctor set Nombre=@Nombre,Correo=@Correo,Telefono=@Telefono
where Id_Doctor=@Id_Doctor
GO
/****** Object:  StoredProcedure [dbo].[eliminar_Doctor]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminar_Doctor]
@Id_Doctor as integer
as
delete from Doctor where Id_Doctor=@Id_Doctor
GO
/****** Object:  StoredProcedure [dbo].[eliminar_Paciente]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[eliminar_Paciente]
@Id_Cliente as integer
as
delete from Clientes where Id_Cliente=@Id_Cliente
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_citas]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_agregar_citas]
 @pid_cita int, @pHora_cita time,@pDia_Cita date, @pAsunto varchar(50),@pId_Doctor int,@pId_Consultorio int ,@pId_Cliente int
 AS BEGIN 
  if not exists (select*from Citas where(Id_Cita=@pid_cita))  
  begin  INSERT INTO Citas(Id_Cita,Hora_Cita,Dia_Cita,Asunto,Id_Doctor,Id_Consultorio,Id_Cliente)  
  values (@pid_cita,@pHora_cita,@pDia_Cita,@pAsunto,@pId_Doctor,@pId_Consultorio,@pId_Cliente)
  end END 
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_Clientes]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[sp_agregar_Clientes]
 @pid_Cliente int, @pNombre varchar(60),@pTelefono varchar(30), @pCiudad varchar(50) , @pDireccion varchar(40),@pCp int,@pCorreo varchar(30)
 AS BEGIN 
  if not exists (select*from Clientes where(Id_Cliente=@pid_Cliente))  
  begin  INSERT INTO Clientes(Id_Cliente,Nombre,Telefono,Ciudad,Direccion,Cp,Correo)  
  values (@pid_Cliente,@pNombre,@pTelefono,@pCiudad,@pDireccion,@pCp,@pCorreo)
  end END 
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_Consultorios]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[sp_agregar_Consultorios]
 @pid_Consultorio int, @pHora_Inicio time,@pHora_Final time,@pId_Doctor int
 AS BEGIN 
  if not exists (select*from Consultorio where(Id_Consultorio=@pid_Consultorio)  )
  begin  INSERT INTO Consultorio(Id_Consultorio,Hora_Inicio,Hora_Final,Id_Doctor)  
  values (@pid_Consultorio,@pHora_Inicio,@pHora_Final,@pId_Doctor)
  end END 
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_Doctor]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[sp_agregar_Doctor]
 @pid_Doctor int, @pNombre varchar(60),@pCorreo varchar(30),@pTelefono varchar(30)
 AS BEGIN 
  if not exists (select*from Doctor where(Id_Doctor=@pid_Doctor))  
  begin  INSERT INTO Doctor(Id_Doctor,Nombre,Correo,Telefono)  
  values (@pid_Doctor,@pNombre,@pCorreo,@pTelefono)
  end END 
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_laboratorio]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_agregar_laboratorio]
@pid_laboratorio int, @pResultados varchar(100),@pId_Doctor int, @pId_Cliente int
 AS BEGIN
   if not exists (select*from Laboratorio where(id_laboratorio=@pid_laboratorio))
     begin
	   INSERT INTO laboratorio(Id_Laboratorio,Resultados,Id_Doctor,Id_Cliente) 
	    values (@pid_laboratorio,@pResultados,@pId_Doctor,@pId_Cliente) 
		 end END 
GO
/****** Object:  StoredProcedure [dbo].[sp_agregar_receta]    Script Date: 27/11/2018 01:56:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	 CREATE PROCEDURE [dbo].[sp_agregar_receta]
@pid_receta int, @pcantidad int,@pnombre_medicamento varchar(100), @pId_Cliente int,@pId_Doctor int
 AS BEGIN
   if not exists (select*from Receta where(Id_Receta=@pid_receta))
     begin
	   INSERT INTO Receta(Id_Receta,cantidad,Nombre_Medicamento,Id_Doctor,Id_Cliente) 
	    values (@pId_Receta,@pcantidad,@pnombre_medicamento,@pId_Doctor,@pId_Cliente) 
		 end END 
GO
