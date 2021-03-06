USE master 
GO 

IF EXISTS(SELECT * FROM sys.databases WHERE name='Atelier') 
BEGIN
DROP DATABASE Atelier
END 
GO 

CREATE DATABASE Atelier
GO 

USE Atelier
GO

CREATE TABLE [Client](
	[IDClient] [int] IDENTITY(1,1) NOT NULL ,
	[Surname] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Patronymic] [varchar](50) NULL,
	[Phone] [varchar](15) NULL,
	[UserRole] [varchar] (15) NOT NULL DEFAULT 'user',
	[Login] [varchar](35) NOT NULL,
	[Password] [varchar](35) NOT NULL
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


USE Atelier

INSERT INTO [dbo].[Client]
([Surname], [Name], [Patronymic], [Phone], [UserRole], [Login], [Password])
 VALUES
 ('Иванов', 'Александр', 'Алексеевич', '89243541496', 'admin', 'Иванов', 'Александр')

INSERT INTO [dbo].[Client]
([Surname], [Name], [Patronymic], [Phone], [Login], [Password])
 VALUES
('Булкин', 'Никита', 'Андреевич', '89245581496','Булкин', 'Никита'),
('Михалов', 'Петр', 'Андреевич', '89245581496','Михалов', 'Петр'),
('Иванов', 'Серп', 'Алексеевич', '89243441496','Иванов', 'Никита'),
('Петров', 'Булак', 'Александрович', '89245581496','Петров', 'Никита'),
('Шалашов', 'Иона', 'Сарбенович', '89245581464','Шалашов', 'Никита'),
('Борзов', 'Сидл', 'Александрович', '89222441496','Борзов', 'Никита'),
('Булкин', 'Порк', 'Андреевич', '89245585226','Кулкин', 'Никита'),
('Кулкин', 'Супк', 'Андреевич', '89245581453','Булкин1', 'Никита'),
('Бутараев', 'Робин', 'Алексеевич', '89543541496','Булкин2', 'Никита'),
('Лесин', 'Никита', 'Александрович', '89245581596','Булкин3', 'Никита'),
('Шашков', 'Петр', 'Андреевич', '89245581466','Булкин4', 'Никита'),
('Петров', 'Александр', 'Алексеевич', '89243541496','Булкин5', 'Никита'),
('Булкин', 'Кошка', 'Александрович', '89245511496','Булкин6', 'Никита'),
('Архазов', 'Петр', 'Артемов', '89245586496','Булкин7', 'Никита'),
('Архазов', 'Саша', 'Артемов', '89243541496','Булкин8', 'Никита'),
('Архазов', 'Никита', 'Андреевич', '89245681496','Булкин9', 'Никита'),
('Михалов', 'Петр', 'Булевич', '89245583496','Булкин12', 'Никита'),
('Тупкин', 'Александр', 'Сирович', '89643541496','Булкин13', 'Никита'),
('Сулкин', 'Клавдий', 'Андреевич', '89245521496','Булкин11', 'Никита'),
('Михалов', 'Петр', 'Кулькапович', '89245586496','Булкин15', 'Никита'),
('Иванов', 'Паркиа', 'Сирпанович', '89543541496','Булкин243', 'Никита'),
('Шопов', 'Кнопка', 'Александрович', '89245583496','Булкин324', 'Никита'),
('Маразов', 'Петр', 'Артемов', '89245585496','Булки234н', 'Никита'),
('Топов', 'Александр', 'Иосифович', '89243541496','Бул3кин', 'Никита'),
('Топский', 'Никита', 'Петрович', '89245181496','Булк3ин', 'Никита'),
('Булеев', 'Петр', 'Петрович', '89245581596','Булки434н', 'Никита'),
('Соболев', 'Александр', 'Алексеевич', '86243541496','Бул434234кин', 'Никита'),
('Булкин', 'Иосиф', 'Андреевич', '89245531496','Бул64534кин', 'Никита'),
('Торошкин', 'Петр', 'Андреевич', '89245531496','Булпвапкин', 'Никита'),
('Тупкин', 'Иосиф', 'Петрович', '89643541496','Булкываыин', 'Никита'),
('Шопотом', 'Иван', 'Андреевич', '89245581496','Булкаыаин', 'Никита'),
('Пахов', 'Иосиф', 'Кириллович', '89245581456','Булкываин', 'Никита'),
('Салов', 'Иосиф', 'Кириллович', '89253541496','Булсвыкин', 'Никита'),
('Нерях', 'Иван', 'Кириллович', '89245585496','Булкываин', 'Никита'),
('Тупков', 'Иосиф', 'Андреевич', '89245581396','Булывкин', 'Никита');

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
('Иванов', 'Иван', 'Иванович', '89472226655', '15000', '45698213654', '159753684265'),
('Петров', 'Пётр', 'Петрович', '89465263214', '20044', '56974516597', '154786523215'),
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


ALTER AUTHORIZATION ON DATABASE::Atelier TO sa;

GO
Use Atelier


GO
Create PROCEDURE [dbo].[AddClient]
	@Login nvarchar(35),
	@Password nvarchar(35),
	@Name nvarchar(50),
	@Surname nvarchar(50),
	@Patronymic nvarchar(50),
	@Phone nvarchar(12),
	@Client_Size_Clothes nvarchar(50),
	@Client_Size_Boots int,
	@Id int out
AS
BEGIN
	 INSERT INTO Client([Name], [Surname], Patronymic, Phone, [Password],[Login])
		VALUES(@Name, @Surname, @Patronymic, @Phone, @Password, @Login)
		SET @Id = SCOPE_IDENTITY();
	INSERT INTO Client_Size_Clothes(IDClient, Size)
		VALUES(@Id, @Client_Size_Clothes)
	INSERT INTO Client_Size_Boots(IDClient, Size)
		VALUES(@Id, @Client_Size_Boots)

END


GO
CREATE PROCEDURE [dbo].EditClient
	@Login nvarchar(35),
	@Password nvarchar(35),
	@Name nvarchar(50),
	@Surname nvarchar(50),
	@Patronymic nvarchar(50),
	@Phone nvarchar(12),
	@IDClient int
AS
BEGIN
	 Update Client 
	Set [Login] = @Login, 
		[Password] = @Password, 
		[Name] = @Name, 
		Surname = @Surname,
		Patronymic = @Patronymic, 
		Phone = @Phone 
		Where IDClient = @IDClient
END

Go
CREATE PROCEDURE [dbo].[GetByLogin]
	@Login [varchar](35)
AS
BEGIN
	 SELECT u.IDClient, u.[Name], u.Surname, u.Patronymic, u.Phone, u.[Login]
	 FROM Client u 
	 WHERE u.[Login] = @Login
	 
END
GO

CREATE PROCEDURE [dbo].GetUsetRoles
	@UserName [varchar](50)
AS
BEGIN
	 SELECT u.[UserRole]
	 FROM Client u 
	 WHERE  u.[Login] = @UserName
END


GO
CREATE PROCEDURE GetClientById
	@IDClient int
AS
		BEGIN
			SELECT *
			From [Client]
			Where Client.IDClient = @IDClient
		END
GO

GO
CREATE PROCEDURE [dbo].GetAllClients
AS
BEGIN
	 SELECT *
	 FROM Client  
END

GO
CREATE PROCEDURE [dbo].GetAllOrders
AS
BEGIN
	 SELECT o.StartDate, o.EndDate, o.Cost,b.Size As 'Size_Boots',c.Size As 'Size_Clothes', cl.IDClient,cl.[Name]as 'custromer_Name', cl.Surname, cl.Phone, m.[Name],o.IDOrder
	 FROM [Order] o 
	 Join Client_Size_Boots b on o.ID_Size_Boots = b.ID_Size_Boots
	 Join Client_Size_Clothes c on c.ID_Size_Clothes= o.ID_Size_Clothes
	 Join Client cl on cl.IDClient= o.IDClient
	 Join Work w on w.IDWork= o.IDWork
	 Join MaterialOrder mo on mo.IDMaterialOrder = w.IDMaterialOrder
	 Join Model_Material_Quantity mmq on mmq.IDModel_Material_Quantity = mo.IDModel_Material_Quantity 
	 Join Model m on m.IDModel = mmq.IDModel
END


GO
CREATE PROCEDURE [dbo].GetAllOrdersUs
	@Login [varchar](35)
AS
BEGIN

	 SELECT o.Cost, o.EndDate, o.ID_Size_Boots,o.ID_Size_Clothes,o.IDClient,o.IDOrder,o.StartDate,o.IDWork
	 FROM [Order] o Inner Join Client c On 	o.IDClient = c.IDClient 
	 WHERE c.[Login] = 	@Login
END

GO
CREATE PROCEDURE [dbo].DeleteClients
AS
BEGIN

	 ALTER TABLE [Order]  nocheck constraint all
	 ALTER TABLE [Client_Size_Boots]  nocheck constraint all
	 ALTER TABLE [Client_Size_Clothes]  nocheck constraint all
	 ALTER TABLE Comment  nocheck constraint all
	 DELETE u
	 FROM [Client] u 
	 WHERE u.UserRole != 'admin'

	 DELETE ur
	 FROM Client u RIGHT JOIN Comment ur ON u.IDClient=ur.IDClient
	 WHERE u.IDClient is Null 
	 
	 DELETE m
	 FROM Client u RIGHT JOIN [Client_Size_Boots] m ON u.IDClient=m.IDClient
	 WHERE u.IDClient is Null

	 DELETE f
	 FROM Client u RIGHT JOIN [Client_Size_Clothes] f ON u.IDClient=f.IDClient
	 WHERE u.IDClient is Null
END
GO
CREATE PROCEDURE [dbo].DeleteOrders
AS
BEGIN
	 ALTER TABLE [Client_Size_Boots]  nocheck constraint all
	 ALTER TABLE [Client_Size_Clothes]  nocheck constraint all
	 ALTER TABLE Comment  nocheck constraint all
	 ALTER TABLE Client  nocheck constraint all
	 DELETE FROM [Order] 
END
GO
GO
CREATE PROCEDURE [dbo].[LogIn]
	@Login nvarchar(35), 
	@Password nvarchar(35)
AS
BEGIN
	 SELECT * 
	 FROM Client u
	 WHERE u.[Login] = @Login AND u.[Password] = @Password
END

GO
CREATE PROCEDURE [dbo].SearchByName
	@Name [varchar](50)
AS
BEGIN
	 SELECT  u.IDClient, u.[Name], u.Surname, u.Patronymic, u.Phone
	 FROM Client u 
	 WHERE u.[Name] = @Name
	 
END
GO
CREATE PROCEDURE [dbo].SearchBySurname
	@Surname [varchar](50)
AS
BEGIN
	 SELECT  u.IDClient, u.[Name], u.Surname, u.Patronymic, u.Phone
	 FROM Client u 
	 WHERE u.Surname = @Surname
	 
END
GO
CREATE PROCEDURE [dbo].SearchByPhone
	@Phone [varchar](15)
AS
BEGIN
SELECT  u.IDClient, u.[Name], u.Surname, u.Patronymic, u.Phone
	 FROM Client u 
	 WHERE u.Phone = @Phone
	 
END
GO



GO
CREATE PROCEDURE [dbo].[GetAllOrdersbyId]
	@IDClient int
AS
BEGIN
	 SELECT c.Name, c.Surname, c.Phone, o.StartDate, o.EndDate, o.Cost, cm.Comment
	 FROM Client c 
	 INNER JOIN [Order] o  ON o.IDClient = c.IDClient 
	 Inner JOIN Comment cm On cm.IDClient = c.IDClient
END


GO
CREATE PROCEDURE [dbo].DeleteClientById
	@IDClient int
AS
BEGIN
	 ALTER TABLE [Order]  nocheck constraint all
	 ALTER TABLE [Client_Size_Boots]  nocheck constraint all
	 ALTER TABLE [Client_Size_Clothes]  nocheck constraint all
	 ALTER TABLE Comment  nocheck constraint all
	 DELETE u
	 FROM [Client] u 
	 WHERE IDClient = @IDClient

	 DELETE ur
	 FROM Client u RIGHT JOIN Comment ur ON u.IDClient=ur.IDClient
	 WHERE u.IDClient is Null 
	 
	 DELETE m
	 FROM Client u RIGHT JOIN [Client_Size_Boots] m ON u.IDClient=m.IDClient
	 WHERE u.IDClient is Null

	 DELETE f
	 FROM Client u RIGHT JOIN [Client_Size_Clothes] f ON u.IDClient=f.IDClient
	 WHERE u.IDClient is Null
END
GO
CREATE PROCEDURE sp_comment 
		@Comment varchar(50),
		@IDClient int,
		@IDOrder int, 
		@IDWorker int  
	AS
		Insert dbo.Comment
		(IDClient, IDOrder, IDWorker, Comment)
		Values
		(@IDClient, @IDOrder, @IDWorker, @Comment)

GO

CREATE PROCEDURE AddOrder 
		@StartDate date,
		@EndDate date,
		@Cost int, 
		@Login varchar(50)
		
	AS
	Declare @IDClient   int
	Declare @ID_Size_Boots   int
	Declare @ID_Size_Clothes   int
	Set @IDClient = (Select IDClient From Client Where [Login] = @Login)
	Set @ID_Size_Boots = (Select ID_Size_Boots From Client_Size_Boots Where IDClient = @IDClient)
	Set @ID_Size_Clothes = (Select ID_Size_Clothes From Client_Size_Clothes Where IDClient = @IDClient)
		Insert dbo.[Order]
		(IDClient, [ID_Size_Boots], [ID_Size_Clothes], [IDWork], [Cost],[StartDate], [EndDate])
		Values
		(@IDClient, @ID_Size_Boots, @ID_Size_Clothes, 3, @Cost, @StartDate,@EndDate)

GO

CREATE PROCEDURE GetListModels 

	AS
Select  [Name]
From Model

GO

GO
Create PROCEDURE [dbo].DeleteOrder
	@IDUser int, 
	@IDOrder int
AS
BEGIN
	 ALTER TABLE [Client]  nocheck constraint all 
	 ALTER TABLE Comment  nocheck constraint all 
	 ALTER TABLE [Client_Size_Boots]  nocheck constraint all 
	 ALTER TABLE [Client_Size_Clothes]  nocheck constraint all 
	 DELETE FROM [Order] WHERE IDOrder = @IDOrder AND IDClient = @IDUser
END

GO
Create PROCEDURE sp_ordercount
	@StartDate date,
	@EndDate date,
	@sum int output
AS
	SELECT @sum = COUNT(o.IDOrder)
	FROM [Order] as o
	WHERE o.StartDate >= @StartDate AND o.EndDate <= @EndDate


GO
Create PROCEDURE dbo.worker_cursor
	@CursorOut CURSOR VARYING OUTPUT

AS
SET NOCOUNT ON;
SET @CursorOut = CURSOR

FORWARD_ONLY STATIC FOR
	SELECT w.Surname, w.Phone, wr.Term
	FROM Worker as w
	INNER JOIN [Work] wr ON w.IDWorker = wr.IDWorker
OPEN @CursorOut
GO



USE Atelier
GO

CREATE VIEW Worker_UPDATE
AS
SELECT w.INN, w.Salary, License
FROM Worker w 
WHERE (License is NOT NULL) 
WITH CHECK OPTION
GO

CREATE VIEW Size_INSERT 
AS
SELECT [Size], [IDClient]
FROM Client_Size_Boots c
WHERE Size < 50
WITH CHECK OPTION
GO
 

CREATE VIEW View_Worker With SCHEMABINDING, ENCRYPTION
AS
SELECT IDWorker, Surname, Salary 
FROM dbo.Worker
WHERE Salary > 20000
GO

CREATE Unique CLUSTERED INDEX Index_On_View ON View_Worker (IDWorker) 

GO
CREATE VIEW Material_Order_View 
AS
SELECT MO.IDMaterialOrder as 'Номер заказа', MP.Cost as 'Цена материала',P.CompanyName as 'Имя производителя',  M.[Name] as 'Материал'
FROM [MaterialOrder] MO
JOIN [Material_Provider] MP ON MO.IDMaterial_Provider = MP.IDMaterial_Provider
JOIN [Provider] as P ON P.IDProvider = MP.IDProvider
JOIN [Material] as M ON MP.IDMaterial = M.IDMaterial

GO
CREATE VIEW View_Order
AS
SELECT o.IDOrder, o.StartDate, o.EndDate, o.Cost, c.Surname, wr.Phone as 'Number to call'
FROM [Order] as o
JOIN Client as c ON C.IDClient = c.IDClient
JOIN Work as w ON w.IDWork = o.IDWork
JOIN Worker as wr ON wr.IDWorker = w.IDWorker
GO


CREATE VIEW Work_View
AS
SELECT WR.Surname, WR.Salary, W.Term as 'Задействован в работе до' 
FROM Worker as WR
JOIN Work as W ON W.IDWorker = WR.IDWorker