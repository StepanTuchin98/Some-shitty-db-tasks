USE master 
GO 

IF EXISTS(SELECT * FROM sys.databases WHERE name='Atelier2') 
BEGIN 
DROP DATABASE Atelier2
END 
GO 

CREATE DATABASE Atelier2
GO 

USE Atelier2
GO

CREATE TABLE [Client](
	[IDClient] [int] IDENTITY(1,1) NOT NULL ,
	[Surname] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Patronymic] [varchar](50) NULL,
	[Phone] [varchar](15) NULL,
);

CREATE TABLE [Client_Size_Boots](
	[ID_Size_Boots] [int] IDENTITY(1,1) NOT NULL,
	[IDClient] [int] NOT NULL,
	[Size] [int] NOT NULL,
);

CREATE TABLE [Client_Size_Clothes](
	[ID_Size_Clothes] [int] IDENTITY(1,1) NOT NULL,
	[IDClient] [int] NOT NULL,
	[Size] [varchar](10) NOT NULL,
);

CREATE TABLE [Worker](
	[IDWorker] [int] IDENTITY(1,1) NOT NULL,
	[Salary] [money] NULL,
	[Name] [varchar](50) NOT NULL,
	[Surname] [varchar](50) NOT NULL,
	[Patronic] [varchar](50) NULL,
	[Phone] [varchar](15) NULL,
	[License] [bit] NULL,
	[INN] [char](12) NULL,
);

CREATE TABLE [Material](
	[IDMaterial] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
);

CREATE TABLE [Provider](
	[IDProvider] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](50) NULL,
	[Phone] [varchar](15) NULL,
);

CREATE TABLE [Material_Provider](
	[IDMaterial_Provider] [int] IDENTITY(1,1) NOT NULL,
	[IDMaterial] [int] NOT NULL,
	[IDProvider] [int] NOT NULL,
	[Cost] [int] NOT NULL,
);

CREATE TABLE [Model](
	[IDModel] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Cost] [money] NULL,
);

CREATE TABLE [Model_Material_Quantity](
	[IDModel_Material_Quantity] [int] IDENTITY(1,1) NOT NULL,
	[IDMaterial] [int] NOT NULL,
	[IDModel] [int] NOT NULL,
	[Quantity] [int] NOT NULL
);

CREATE TABLE [MaterialOrder](
	[IDMaterialOrder] [int] IDENTITY(1,1) NOT NULL,
	[IDModel_Material_Quantity] [int] NOT NULL,
	[IDMaterial_Provider] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
);

CREATE TABLE [Order](
	[IDOrder] [int] IDENTITY(1,1) NOT NULL,
	[IDClient] [int] NOT NULL,
	[ID_Size_Boots] [int] NOT NULL,
	[ID_Size_Clothes] [int] NOT NULL,
	[IDWork] [int] NOT NULL,
	[Cost] [money] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
);

CREATE TABLE [Work](
	[IDWork] [int] IDENTITY(1,1) NOT NULL,
	[IDMaterialOrder] [int] NOT NULL,
	[IDWorker] [int] NULL,
	[Term] [date] NOT NULL,
);

CREATE TABLE [Comment](
	[IDComment] [int] IDENTITY(1,1) NOT NULL,
	[IDClient] [int] NOT NULL,
	[IDOrder] [int] NOT NULL,
	[IDWorker] [int] NOT NULL,
	[Comment] [varchar](100) NULL,
);

CREATE CLUSTERED INDEX CL_INDEX_Worker_COMPOSITE --СОСТАВНОЙ
ON [dbo].Worker([Name], [Surname], [Salary])

CREATE CLUSTERED INDEX CL_INDEX_Order --СОСТАВНОЙ
ON [dbo].[Order]([Cost])

create clustered index CL_INDEX_Order_material --уникальный
ON [dbo].[MaterialOrder]([IDMaterialOrder])



ALTER TABLE  [Client] ADD CONSTRAINT [PK_Client] primary key ([IDClient]);
ALTER TABLE  [Client_Size_Boots] ADD CONSTRAINT [PK_Client_Size_Boots] primary key ([ID_Size_Boots]);
ALTER TABLE  [Client_Size_Clothes] ADD CONSTRAINT [PK_Client_Size_Clothes] primary key ([ID_Size_Clothes]);
ALTER TABLE  [Worker] ADD CONSTRAINT [PK_Worker] primary key ([IDWorker]);
ALTER TABLE  [Material] ADD CONSTRAINT [PK_Material] primary key ([IDMaterial]);
ALTER TABLE  [Material_Provider] ADD CONSTRAINT [PK_Material_Provider] primary key ([IDMaterial_Provider]);
ALTER TABLE  [Provider] ADD CONSTRAINT [PK_Provider] primary key ([IDProvider]);
ALTER TABLE  [Model] ADD CONSTRAINT [PK_Model] primary key ([IDModel]);
ALTER TABLE  [Model_Material_Quantity] ADD CONSTRAINT [PK_Model_Material_Quantity] primary key ([IDModel_Material_Quantity]);
ALTER TABLE  [MaterialOrder] ADD CONSTRAINT [PK_MaterialOrder] primary key ([IDMaterialOrder]);
ALTER TABLE  [Order] ADD CONSTRAINT [PK_Order] primary key ([IDOrder]);
ALTER TABLE  [Work] ADD CONSTRAINT [PK_Work] primary key ([IDWork]);
ALTER TABLE  [Comment] ADD CONSTRAINT [PK_Comment] primary key ([IDComment]);

ALTER TABLE [MaterialOrder]  WITH CHECK ADD  CONSTRAINT [FK_Material_Provider_MaterialOrder]
FOREIGN KEY([IDMaterial_Provider]) REFERENCES [Material_Provider] ([IDMaterial_Provider])

ALTER TABLE [Model_Material_Quantity]  WITH CHECK ADD  CONSTRAINT [FK_Model_Model_Material_Quantity]
FOREIGN KEY([IDModel]) REFERENCES [Model] ([IDModel])

ALTER TABLE [Material_Provider]  WITH CHECK ADD  CONSTRAINT [FK_Material_Provider_Material] 
FOREIGN KEY([IDMaterial]) REFERENCES Material ([IDMaterial])

ALTER TABLE [Material_Provider]  WITH CHECK ADD  CONSTRAINT [FK_Material_Provider_Provider] 
FOREIGN KEY([IDProvider]) REFERENCES [Provider] ([IDProvider])

ALTER TABLE [Client_Size_Boots]  WITH CHECK ADD  CONSTRAINT [FK_Client_Size_Boots_Client] 
FOREIGN KEY([IDClient]) REFERENCES [Client] ([IDClient])

ALTER TABLE [Client_Size_Clothes]  WITH CHECK ADD  CONSTRAINT [FK_Client_Size_Clothes_Client]
FOREIGN KEY([IDClient]) REFERENCES [Client] ([IDClient])

ALTER TABLE [Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Client] FOREIGN KEY([IDClient])
REFERENCES [Client] ([IDClient])

ALTER TABLE [Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Order] FOREIGN KEY([IDOrder])
REFERENCES [Order] ([IDOrder])

ALTER TABLE [Comment]  WITH CHECK ADD  CONSTRAINT [FK_Comment_Worker] FOREIGN KEY([IDWorker])
REFERENCES [Worker] ([IDWorker])

ALTER TABLE [Model_Material_Quantity]  WITH CHECK ADD  CONSTRAINT [FK_Model_Material_Quantity_Material] FOREIGN KEY([IDMaterial])
REFERENCES [Material] ([IDMaterial])

ALTER TABLE [Model_Material_Quantity]  WITH CHECK ADD  CONSTRAINT [FK_Model_Material_Quantity_Model] FOREIGN KEY([IDModel])
REFERENCES [Model] ([IDModel])

ALTER TABLE [Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Client] FOREIGN KEY([IDClient])
REFERENCES [Client] ([IDClient])

ALTER TABLE [Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Client_Size_Boots] FOREIGN KEY([ID_Size_Boots])
REFERENCES [Client_Size_Boots] ([ID_Size_Boots])

ALTER TABLE [Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Client_Size_Clothes] FOREIGN KEY([ID_Size_Clothes])
REFERENCES [Client_Size_Clothes] ([ID_Size_Clothes])

ALTER TABLE [Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Work] FOREIGN KEY([IDWork])
REFERENCES [Work] ([IDWork])

ALTER TABLE [Work]  WITH CHECK ADD  CONSTRAINT [FK_Work_MaterialOrder] FOREIGN KEY([IDMaterialOrder])
REFERENCES [MaterialOrder] ([IDMaterialOrder])

ALTER TABLE [Work]  WITH CHECK ADD  CONSTRAINT [FK_Work_Worker] FOREIGN KEY([IDWorker])
REFERENCES [Worker] ([IDWorker])


USE Atelier2
INSERT INTO [dbo].[Client]
([Surname], [Name], [Patronymic], [Phone])
 VALUES
('Иванов', 'Александр', 'Алексеевич', '89243541496'),
('Булкин', 'Никита', 'Андреевич', '89245581496'),
('Михалов', 'Петр', 'Андреевич', '89245581496'),
('Иванов', 'Серп', 'Алексеевич', '89243441496'),
('Петров', 'Булак', 'Александрович', '89245581496'),
('Шалашов', 'Иона', 'Сарбенович', '89245581464'),
('Борзов', 'Сидл', 'Александрович', '89222441496'),
('Булкин', 'Порк', 'Андреевич', '89245585226'),
('Кулкин', 'Супк', 'Андреевич', '89245581453'),
('Бутараев', 'Робин', 'Алексеевич', '89543541496'),
('Лесин', 'Никита', 'Александрович', '89245581596'),
('Шашков', 'Петр', 'Андреевич', '89245581466'),
('Петров', 'Александр', 'Алексеевич', '89243541496'),
('Булкин', 'Кошка', 'Александрович', '89245511496'),
('Архазов', 'Петр', 'Артемов', '89245586496'),
('Архазов', 'Саша', 'Артемов', '89243541496'),
('Архазов', 'Никита', 'Андреевич', '89245681496'),
('Михалов', 'Петр', 'Булевич', '89245583496'),
('Тупкин', 'Александр', 'Сирович', '89643541496'),
('Сулкин', 'Клавдий', 'Андреевич', '89245521496'),
('Михалов', 'Петр', 'Кулькапович', '89245586496'),
('Иванов', 'Паркиа', 'Сирпанович', '89543541496'),
('Шопов', 'Кнопка', 'Александрович', '89245583496'),
('Маразов', 'Петр', 'Артемов', '89245585496'),
('Топов', 'Александр', 'Иосифович', '89243541496'),
('Топский', 'Никита', 'Петрович', '89245181496'),
('Булеев', 'Петр', 'Петрович', '89245581596'),
('Соболев', 'Александр', 'Алексеевич', '86243541496'),
('Булкин', 'Иосиф', 'Андреевич', '89245531496'),
('Торошкин', 'Петр', 'Андреевич', '89245531496'),
('Тупкин', 'Иосиф', 'Петрович', '89643541496'),
('Шопотом', 'Иван', 'Андреевич', '89245581496'),
('Пахов', 'Иосиф', 'Кириллович', '89245581456'),
('Салов', 'Иосиф', 'Кириллович', '89253541496'),
('Нерях', 'Иван', 'Кириллович', '89245585496'),
('Тупков', 'Иосиф', 'Андреевич', '89245581396');

INSERT INTO [dbo].[Client_Size_Boots]
([IDClient], [Size])
 VALUES
('1', '42'),
('2', '39'),
('3', '42'),
('4', '39'),
('5', '42'),
('6', '31'),
('7', '46'),
('8', '31'),
('9', '41'),
('10', '37'),
('11', '44'),
('12', '36'),
('13', '44'),
('14', '32'),
('15', '41'),
('16', '45'),
('17', '31'),
('18', '44'),
('19', '45'),
('20', '33'),
('21', '42'),
('22', '32'),
('23', '52'),
('24', '39'),
('25', '52'),
('26', '44'),
('27', '31'),
('28', '43'),
('29', '35'),
('30', '32'),
('31', '35'),
('32', '36'),
('33', '31'),
('34', '35'),
('35', '31'),
('36', '39');


INSERT INTO [dbo].[Client_Size_Clothes]
([IDClient], [Size])
values
('1', 'M'),
('2','XL'),
('3', 'M'),
('4', 'M'),
('5', 'M'),
('6', 'M'),
('7', 'M'),
('8', 'L'),
('9', 'L'),
('10', 'L'),
('11', 'L'),
('12', 'L'),
('13', 'L'),
('14', 'L'),
('15', 'M'),
('16', 'X'),
('17', 'M'),
('18', 'L'),
('19', 'x'),
('20', 'X'),
('21', 'S'),
('22', 'S'),
('23', 'S'),
('24', 'S'),
('25', 'S'),
('26', 'S'),
('27', 'S'),
('28', 'M'),
('29', 'L'),
('30', 'M'),
('31', 'L'),
('32', 'S'),
('33', 'S'),
('34', 'S'),
('35', 'S'),
('36', 'S');

INSERT INTO [dbo].[Worker]
(Surname, Name, [Patronic], [Phone], [Salary], [License], [INN])
values
('Иванов', 'Иван', 'Иванович', '89472226655', '15000', NULL, '159753684265'),
('Петров', 'Пётр', 'Петрович', '89465263214', '20044', NULL, '154786523215'),
('Смирнов', 'Алексей', 'Степанович', '89264586547', '17400', '1111111111', '222222222222'),
('Серов', 'Семён', 'Пуренович', '89175455644', '12000', '52698745152', '465231987454'),
('Подгоров', 'Илья', 'Эдуардович', '89602545566', '16000', '41253698745', '562148932545'),
('Андреев', 'Павел', 'Артёмович', '87855556985', '142200', '58964235874', '453215896541'),
('Иванов', 'Иван', 'Иванович', '89472226655', '15010', '45698213654', '159753684265'),
('Петров', 'Пётр', 'Петрович', '89465263214', '20010', '56974516597', '154786523215'),
('Смирнов', 'Алексей', 'Степанович', '89264586547', '170050', '1111111111', '222222222222'),
('Новогоднев', 'Семён', 'Андреевич', '89175455644', '19020', '52698745152', '465231987454'),
('Чередников', 'Илья', 'Эдуардович', '89602545566', '18050', '41253698745', '562148932545'),
('Андреев', 'Павел', 'Артёмович', '87855556985', '210000', '58964235874', '453215896541'),
('Иванов', 'Иван', 'Иванович', '89472226655', '150342', '45698213654', '159753684265'),
('Петров', 'Пётр', 'Петрович', '89465263214', '20212', '56974516597', '154786523215'),
('Архазов', 'Алексей', 'Степанович', '89264586547', '17000', '1111111111', '222222222222'),
('Новогоднев', 'Семён', 'Андреевич', '89175455644', '29000', '52698745152', '465231987454'),
('Топов', 'Илья', 'Эдуардович', '89602545566', '18040', '41253698745', '562148932545'),
('Андреев', 'Павел', 'Артёмович', '87855556985', '11000', '58964235874', '453215896541'),
('Топов', 'Иван', 'Иванович', '89472226655', '15050', '45698213654', '159753684265'),
('Сиерог', 'Пётр', 'Петрович', '89465263214', '20100', '56974516597', '154786523215'),
('Смирнов', 'Алексей', 'Степанович', '89264586547', '17000', '1111111111', '222222222222'),
('Петров', 'Семён', 'Андреевич', '89175455644', '13000', '52698745152', '465231987454'),
('Архазов', 'Илья', 'Эдуардович', '89602545566', '18000', '41253698745', '562148932545'),
('Топов', 'Иван', 'Иванович', '89472226655', '15001', '45698213654', '159753684265'),
('Петров', 'Пётр', 'Петрович', '89465263214', '20100', '56974516597', '154786523215'),
('Архазов', 'Алексей', 'Степанович', '89264586547', '17000', '1111111111', '222222222222'),
('Новогоднев', 'Семён', 'Андреевич', '89175455644', '12000', '52698745152', '465231987454'),
('Чередников', 'Илья', 'Эдуардович', '89602545566', '15000', '41253698745', '562148932545'),
('Петров', 'Иван', 'Иванович', '89472226655', '15000', '45698213654', '159753684265'),
('Топов', 'Пётр', 'Петрович', '89465263214', '20000', '56974516597', '154786523215'),
('Смирнов', 'Алексей', 'Степанович', '89264586547', '17000', '1111111111', '222222222222'),
('Новогоднев', 'Семён', 'Андреевич', '89175455644', '19000', '52698745152', '465231987454'),
('Подгоров', 'Илья', 'Эдуардович', '89602545566', '18000', '41253698745', '562148932545'),
('Андреев', 'Павел', 'Артёмович', '87855556985', '14000', '58964235874', '453215896541'),
('Андреев', 'Павел', 'Артёмович', '87855556985', '14000', '58964235874', '453215896541'),
('Топов', 'Павел', 'Артёмович', '87855556985', '14000', '58964235874', '453215896541');

INSERT INTO [dbo].[Material]
([Name])
values
('Шёлк'),
('Хлопок'),
('Бязь'),
('Полистер')

INSERT [dbo].[Provider]
([CompanyName], [Phone])
values
('Кроем всё', '446445'),
('Материалист', '555555'),
('Хозяин-барин', '555323'),
('Звоните как хотите', NULL)

INSERT [dbo].[Material_Provider]
([IDMaterial], [IDProvider], [Cost])
values
('1', '1','200'),
('2', '2','1500'),
('3', '3','2020'),
('1', '3','400'),
('2', '2','1900'),
('3', '1','1320')

INSERT [dbo].[Model]
([Name], [Cost])
values
('Шляпа', '1000'),
('Платье', '15000'),
('Туфли', '9000')

INSERT [dbo].[Model_Material_Quantity]
([IDMaterial], [IDModel], [Quantity])
values
('1', '1', '3'),
('2', '1', '5'),
('3', '1', '2'),
('1', '2', '2'),
('2', '2', '3'),
('3', '2', '1'),
('1', '3', '5'),
('2', '3', '2'),
('3', '3', '1')

INSERT [dbo].[MaterialOrder]
([IDModel_Material_Quantity], [IDMaterial_Provider], [StartDate], [EndDate])
values
('1', '1', '2018-03-03', '2018-08-03'),
('2', '2', '2018-05-03', '2018-08-03'),
('3', '3', '2018-05-03', '2018-08-03')

INSERT [dbo].[Work]
([IDMaterialOrder], [IDWorker], [Term])
values
('1', '1', '2018-12-25'),
('2', '2', '2018-11-25'),
('3', '3', '2018-10-25')

INSERT [dbo].[Work]
([IDMaterialOrder], [Term])
values
('1', '2018-10-25')


INSERT [dbo].[Order]
([IDClient], [ID_Size_Boots], [ID_Size_Clothes], [IDWork], [Cost], [StartDate], [EndDate])
values
('1', '1', '1', '1', '12000', cast(getdate() as date), '2020-03-09'),
('1', '1', '1', '2', '1250', '2017-11-22', '2018-02-01'),
('3', '2', '2', '2', '1210', '2017-10-05', '2018-01-27'),
('4', '1', '1', '1', '12000', cast(getdate() as date), '2020-03-09'),
('5', '1', '1', '2', '1250', '2017-11-22', '2018-02-01'),
('6', '2', '2', '2', '1210', '2017-10-05', '2018-01-27'),
('7', '1', '1', '1', '12000', cast(getdate() as date), '2020-03-09'),
('8', '1', '1', '2', '1250', '2017-11-22', '2018-02-01'),
('9', '2', '2', '2', '1210', '2017-10-05', '2018-01-27');

INSERT [dbo].[Comment]
([IDClient], [IDOrder], [IDWorker], [Comment])
values
('1', '1', '1', 'GOOD')


GO
--INSERT TRIGGER
CREATE TRIGGER Insert_Order_Cost_Trigger ON [Order] FOR INSERT
AS
IF @@ROWCOUNT = 1
	BEGIN
	IF EXISTS (
		SELECT *
		FROM inserted
		WHERE inserted.Cost <= 0)
	BEGIN
		ROLLBACK
		PRINT('ERROR! Cost cannot be less than zero')
	END
	IF EXISTS(
		SELECT *
		FROM inserted
		WHERE inserted.StartDate > inserted.EndDate)
	BEGIN
		ROLLBACK
		PRINT('ERROR! Order is finished earlier than accepted')
	END
END

--Insted of
GO
CREATE TRIGGER Instead_of_Insert_Trigger ON Material INSTEAD OF INSERT
AS 
BEGIN 
	DECLARE @Name_material varchar(50)
	SET @Name_material = (SELECT [Name] FROM inserted); 
	IF EXISTS(

		SELECT [Name] 
		FROM Material
		WHERE [Name] = @Name_material) 
		Begin
		PRINT ('ERROR! Duplicate material')
	ROLLBACK
	END
	
	ELSE
	INSERT Material
	([Name])
	VALUES
	(@Name_material)
END
GO

--UPDATE TRIGGER
GO
CREATE TRIGGER Update_Material_Name_Trigger ON Material FOR UPDATE
AS
		ROLLBACK
		PRINT ('ERROR! Can not edit material')
GO

CREATE TRIGGER Update_Order_Date_Trigger ON [Order] FOR UPDATE
AS
	DECLARE @ID_order int
	DECLARE @StartDate date
	SELECT @ID_order = i.IDOrder FROM inserted i;
	SELECT @StartDate = i.StartDate FROM inserted i;
	IF UPDATE(StartDate)
		ROLLBACK
		PRINT ('ERROR! It is not possible to change the start date')
GO

--DELETE TRIGGER
GO
CREATE TRIGGER Delete_Comment_Trigger ON [Comment] FOR DELETE
AS
BEGIN
	IF EXISTS (
	SELECT * 
	FROM deleted
	WHERE Comment = 'Bad Work' )
	BEGIN
		ROLLBACK
		PRINT ('ERROR! Prohibition on remove bad comments')
		RETURN
	END
END
GO

GO
CREATE TRIGGER Delete_Material_Trigger ON Material FOR DELETE
AS
BEGIN
	IF EXISTS (
		SELECT * 
		FROM deleted INNER JOIN Material ON deleted.[Name] = Material.[Name])
		ROLLBACK
		PRINT ('ERROR! Prohibition on remove of material name')
		RETURN
END
GO

GO
CREATE TRIGGER Instead_of_Update_Trigger ON [MaterialOrder] INSTEAD OF UPDATE
AS
BEGIN 
	DECLARE @IDMaterialOrder int
	DECLARE @IDMaterial_ProviderIns int
	DECLARE @IDMaterial_ProviderDel int
	DECLARE @EndDateInserted date
	DECLARE @EndDateDeleted date
	
	SET @IDMaterialOrder = (SELECT IDMaterialOrder FROM inserted);
	SET @EndDateInserted = (SELECT [EndDate] FROM inserted);
	SET @EndDateDeleted = (SELECT [EndDate] FROM deleted);
	SET @IDMaterial_ProviderIns = (SELECT [IDMaterial_Provider] FROM inserted);
	SET @IDMaterial_ProviderDel = (SELECT [IDMaterial_Provider] FROM deleted);
	
	IF UPDATE (EndDate)
		BEGIN
			UPDATE [Work]
			SET [Term] = DATEADD(DAY, DATEDIFF(DAY, @EndDateDeleted, @EndDateInserted), [Work].[Term]) 
			WHERE IDMaterialOrder = @IDMaterialOrder

			UPDATE [MaterialOrder]
			SET [EndDate] = @EndDateInserted 
			WHERE [MaterialOrder].IDMaterialOrder = @IDMaterialOrder
		END
	IF UPDATE (IDMaterial_Provider)
		BEGIN
				UPDATE [MaterialOrder]
				SET IDMaterial_Provider = @IDMaterial_ProviderIns  WHERE MaterialOrder.IDMaterial_Provider = @IDMaterial_ProviderDel
		END
END
GO

GO
CREATE TRIGGER Instead_of_Delete_Trigger ON [Provider] INSTEAD OF DELETE
AS
BEGIN
	DECLARE @ProviderName [varchar](50)
	DECLARE @TempProviderID [int]
	
	SET @ProviderName = (SELECT CompanyName FROM deleted);
	SET @TempProviderID = (SELECT mo.IDMaterial_Provider
								FROM [MaterialOrder] mo INNER JOIN (SELECT DISTINCT IDMaterial_Provider 
								FROM [Material_Provider] m 
								INNER JOIN [Provider] p ON p.IDProvider = m.IDProvider
								WHERE CompanyName = @ProviderName) t ON mo.IDMaterial_Provider = t.IDMaterial_Provider)
	ALTER TABLE Material_Provider  nocheck constraint all
	DELETE FROM [Provider]
	WHERE [Provider].IDProvider = (SELECT IDProvider FROM deleted)

	ALTER TABLE MaterialOrder  nocheck constraint all
	DELETE FROM [Material_Provider]
	WHERE [Material_Provider].IDProvider = (SELECT IDProvider FROM deleted)

	UPDATE [MaterialOrder]
	SET IDMaterial_Provider = -1  
	WHERE MaterialOrder.IDMaterial_Provider = @TempProviderID
END
GO


ALTER AUTHORIZATION ON DATABASE::Atelier2 TO sa;