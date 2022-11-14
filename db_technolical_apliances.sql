-- DROP DB
USE master
GO

DROP DATABASE IF EXISTS db_technological_appliances
GO

-- CREATE DB
CREATE DATABASE db_technological_appliances
GO

USE db_technological_appliances
GO
-------------------- Table --------------------
CREATE TABLE Users
(
    Username    VARCHAR(40) PRIMARY KEY,
    Name        NVARCHAR(100),
    Email       VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(25) UNIQUE,
    DateOfBirth DATE,
    Address     NVARCHAR(200) NOT NULL,
    Gender      BIT
)
GO
CREATE TABLE Account
(
    Username VARCHAR(40) FOREIGN KEY REFERENCES dbo.Users (Username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Password VARCHAR(60) NOT NULL,
    PRIMARY KEY (Username),
    Role     INTEGER     NOT NULL DEFAULT 0
)
CREATE TABLE PasswordResetToken
(
    Id       INTEGER PRIMARY KEY IDENTITY,
    Username VARCHAR(40) FOREIGN KEY REFERENCES dbo.Users (Username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Token    VARCHAR(60) NOT NULL,
    Expiry   DATETIME    NOT NULL
)
GO
CREATE TABLE Categories
(
    CategoryId VARCHAR(20) PRIMARY KEY,
    Name       NVARCHAR(100) NOT NULL
)
GO
CREATE TABLE Brands
(
    BrandId  VARCHAR(20) PRIMARY KEY,
    Name     NVARCHAR(100) NOT NULL,
    Email    VARCHAR(100)  NOT NULL,
    Logo     NVARCHAR(200),
    Location NVARCHAR(200)
)
GO
CREATE TABLE Products
(
    ProductId   VARCHAR(20) PRIMARY KEY,
    Name        NVARCHAR(100),
    CategoryId  VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES dbo.Categories (CategoryId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    BrandId     VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES dbo.Brands (BrandId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Image       NVARCHAR(MAX),
    Quantity    INTEGER CHECK (Quantity >= 0) DEFAULT 0,
    SaleDate    DATETIME DEFAULT GETDATE(),
    RAM         INTEGER,
    ROM         VARCHAR(20),
    FrontCam    NVARCHAR(200),
    BackCam     NVARCHAR(200),
    OS          NVARCHAR(100),
    Screen      NVARCHAR(200),
    CPU         VARCHAR(50),
    Battery     VARCHAR(100),
    Weight      VARCHAR(20),
    VGA         NVARCHAR(100),
    Description nvarchar(max),
    Price       FLOAT       NOT NULL
)
GO
CREATE TABLE Reviews
(
    ReviewId  VARCHAR(20) PRIMARY KEY,
    Username  VARCHAR(40) FOREIGN KEY REFERENCES dbo.Users (Username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ProductId VARCHAR(20) FOREIGN KEY REFERENCES dbo.Products (ProductId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Content   NVARCHAR(max),
    Rate      INTEGER,
    Time      DATETIME
)
GO
CREATE TABLE Deliveries
(
    DeliveryId  VARCHAR(20) PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    Email       VARCHAR(100)  NOT NULL,
    PhoneNumber VARCHAR(20)   NOT NULL,
    Location    NVARCHAR(200)
)
GO
CREATE TABLE Coupons
(
    CouponId      VARCHAR(40) PRIMARY KEY,
    Discount      FLOAT NOT NULL,
    ExpiredTime   DATETIME,
    EffectiveTime DATETIME,
    Description   NVARCHAR(300)
)
GO
CREATE TABLE Orders
(
    OrderId       VARCHAR(20) PRIMARY KEY,
    Username      VARCHAR(40) FOREIGN KEY REFERENCES dbo.Users (Username)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    Name          NVARCHAR(100) NOT NULL,
    Address       NVARCHAR(200) NOT NULL,
    PhoneNumber   VARCHAR(20)   NOT NULL,
    PurchaseDate  DATETIME,
    TotalPrices   FLOAT,
    DeliveryId    VARCHAR(20) FOREIGN KEY REFERENCES dbo.Deliveries (DeliveryId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    Status        NVARCHAR(200),
    CouponId      VARCHAR(40) FOREIGN KEY REFERENCES dbo.Coupons (CouponId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    DiscountPrice FLOAT
)
GO
CREATE TABLE OrderDetails
(
    OrderId    VARCHAR(20) FOREIGN KEY REFERENCES dbo.Orders (OrderId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ProductId  VARCHAR(20) FOREIGN KEY REFERENCES dbo.Products (ProductId)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    Quantity   INTEGER NOT NULL CHECK (Quantity > 0),
    Price      FLOAT,
    TotalPrice FLOAT,
    PRIMARY KEY (OrderId, ProductId)
)
GO
CREATE TABLE CartDetails
(
    Username  VARCHAR(40) FOREIGN KEY REFERENCES dbo.Users (Username)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ProductId VARCHAR(20) FOREIGN KEY REFERENCES dbo.Products (ProductId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    Quantity  INTEGER NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (Username, ProductId)
)
GO
-------------------- Stored Procedure --------------------

-- 1 User
-- 1.1 GetByUserName
DROP PROC IF EXISTS sp_getByUserName
GO
CREATE PROC sp_getByUserName(@Username VARCHAR(40))
AS
SELECT *
FROM dbo.Users
WHERE Username = @Username
GO
-- 1.2 InsertUser
DROP PROC IF EXISTS sp_insertUser
GO
CREATE PROC sp_insertUser(@Username VARCHAR(40), @Name NVARCHAR(100), @Email VARCHAR(100), @PhoneNumber VARCHAR(25),
                          @DateOfBirth DATE, @Address NVARCHAR(200), @Gender BIT)
AS
INSERT INTO dbo.Users(Username, Name, Email, PhoneNumber, DateOfBirth, Address, Gender)
VALUES (@Username, @Name, @Email, @PhoneNumber, @DateOfBirth, @Address, @Gender)
GO
-- 1.3 UpdateRole
-- 1.4 UpdateUser
DROP PROC IF EXISTS sp_updateUser
GO
CREATE PROC sp_updateUser(@Username VARCHAR(40), @Name NVARCHAR(100), @Email VARCHAR(100), @PhoneNumber VARCHAR(25),
                          @DateOfBirth DATE, @Address NVARCHAR(200), @Gender BIT)
AS
UPDATE dbo.Users
SET Name=@Name,
    Email=@Email,
    PhoneNumber=@PhoneNumber,
    DateOfBirth=@DateOfBirth,
    Address=@Address,
    Gender=@Gender
WHERE Username = @Username
GO
-- 1.5 DeleteUser
DROP PROC IF EXISTS sp_deleteUser
GO
CREATE PROC sp_deleteUser(@Username VARCHAR(40))
AS
DELETE dbo.Users
WHERE Username = @Username
GO

-- 2 Account
-- 2.1 GetByUserName
DROP PROC IF EXISTS sp_getAccount
GO
CREATE PROC sp_getAccount(@Username VARCHAR(40), @Password VARCHAR(40))
AS
SELECT Username
FROM dbo.Account
WHERE Username = @Username
  AND Password = @Password
GO
-- 2.2 InsertAccount
DROP PROC IF EXISTS sp_insertAccount
GO
CREATE PROC sp_insertAccount(@Username VARCHAR(40), @Password VARCHAR(40))
AS
INSERT INTO dbo.Account(Username, Password)
VALUES (@Username, @Password)
GO
-- 2.3 UpdateAccount
DROP PROC IF EXISTS sp_updateAccount
GO
CREATE PROC sp_updateAccount(@Username VARCHAR(40), @Password VARCHAR(40))
AS
UPDATE dbo.Account
SET Password=@Password
WHERE Username = @Username
GO
-- 2.4 DeleteAccount
DROP PROC IF EXISTS sp_deleteAccount
GO
CREATE PROC sp_deleteAccount(@Username VARCHAR(40))
AS
DELETE dbo.Account
WHERE Username = @Username
GO
-- 3 Categories
-- 3.1 GetAll
DROP PROC IF EXISTS sp_getAllCategories
GO
CREATE PROC sp_getAllCategories
AS
SELECT *
FROM dbo.Categories
GO
-- 3.2 GetById
DROP PROC IF EXISTS sp_getByIdCategoty
GO
CREATE PROC sp_getByIdCategoty(@CategoryId VARCHAR(20))
AS
SELECT *
FROM dbo.Categories
WHERE CategoryId = @CategoryId
GO
-- 3.3 InsertCategory
DROP PROC IF EXISTS sp_insertCategory
GO
CREATE PROC sp_insertCategory(@CategoryId VARCHAR(20), @Name NVARCHAR(100))
AS
INSERT INTO dbo.Categories(CategoryId, Name)
VALUES (@CategoryId, @Name)
GO
-- 3.4 UpdateCategory
DROP PROC IF EXISTS sp_updateCategory
GO
CREATE PROC sp_updateCategory(@CategoryId VARCHAR(20), @Name NVARCHAR(100))
AS
UPDATE dbo.Categories
SET Name = @Name
WHERE CategoryId = @CategoryId
GO
-- 3.5 DeleteCategory
DROP PROC IF EXISTS sp_deleteCategory
GO
CREATE PROC sp_deleteCategory(@CategoryId VARCHAR(20))
AS
DELETE dbo.Categories
WHERE CategoryId = @CategoryId
GO

-- 4 Brands
-- 4.1 GetAll
DROP PROC IF EXISTS sp_getAllBrands
GO
CREATE PROC sp_getAllBrands
AS
SELECT *
FROM dbo.Brands
GO
-- 4.2 GetById
DROP PROC IF EXISTS sp_getByIdBrand
GO
CREATE PROC sp_getByIdBrand(@BrandId VARCHAR(20))
AS
SELECT *
FROM dbo.Brands
WHERE BrandId = @BrandId
GO
-- 4.3 InsertBrand
DROP PROC IF EXISTS sp_insertBrand
GO
CREATE PROC sp_insertBrand(@BrandId VARCHAR(20), @Name NVARCHAR(100), @Email VARCHAR(100), @Logo NVARCHAR(200),
                           @Location NVARCHAR(200))
AS
INSERT INTO dbo.Brands(BrandId, Name, Email, Logo, Location)
VALUES (@BrandId, @Name, @Email, @Logo, @Location)
GO
-- 4.4 UpdateBrand
DROP PROC IF EXISTS sp_updateBrand
GO
CREATE PROC sp_updateBrand(@BrandId VARCHAR(20), @Name NVARCHAR(100), @Email VARCHAR(100), @Logo NVARCHAR(200),
                           @Location NVARCHAR(200))
AS
UPDATE dbo.Brands
SET Name=@Name,
    Email=@Email,
    Logo=@Logo,
    Location=@Location
WHERE BrandId = @BrandId
GO
-- 4.5 DeleteBrand
DROP PROC IF EXISTS sp_deleteBrand
GO
CREATE PROC sp_deleteBrand(@BrandId VARCHAR(20))
AS
DELETE dbo.Brands
WHERE BrandId = @BrandId
GO

-- 5 Products
-- 5.1 GetAll
DROP PROC IF EXISTS sp_getAllProducts
GO
CREATE PROC sp_getAllProducts
AS
SELECT *
FROM dbo.Products
GO
-- 5.2 GetById
DROP PROC IF EXISTS sp_getByIdProduct
GO
CREATE PROC sp_getByIdProduct(@ProductId VARCHAR(20))
AS
SELECT*
FROM dbo.Products
WHERE ProductId = @ProductId
GO
-- 5.3 InsertProduct
DROP PROC IF EXISTS sp_insertProduct
GO
CREATE PROC sp_insertProduct @Name NVARCHAR(100),
                             @CategoryId VARCHAR(20),
                             @BrandId VARCHAR(20),
                             @Image NVARCHAR(MAX),
                             @Quantity INTEGER,
                             @SaleDate DATETIME,
                             @RAM INTEGER,
                             @ROM VARCHAR(20),
                             @FrontCam NVARCHAR(200),
                             @BackCam NVARCHAR(200),
                             @OS NVARCHAR(100),
                             @Screen NVARCHAR(200),
                             @CPU VARCHAR(50),
                             @Battery VARCHAR(100),
                             @Weight VARCHAR(20),
                             @VGA NVARCHAR(100),
                             @Description nvarchar(max),
                             @Price FLOAT
AS
INSERT INTO dbo.Products(Name, -- Name - nvarchar(100)
                         CategoryId, -- CategoryId - varchar(20)
                         BrandId, -- BrandId - varchar(20)
                         Image, -- Image - nvarchar(max)
                         Quantity, -- Quantity - integer
                         SaleDate, -- SaleDate - datetime
                         RAM, -- RAM - integer
                         ROM, -- ROM - varchar(20)
                         FrontCam, -- FrontCam - nvarchar(200)
                         BackCam, -- BackCam - nvarchar(200)
                         OS, -- OS - nvarchar(100)
                         Screen, -- Screen - nvarchar(200)
                         CPU, -- CPU - varchar(50)
                         Battery, -- Battery - varchar(100)
                         Weight, -- Weight - varchar(20)
                         VGA, -- VGA - nvarchar(100)
                         Description, -- Description - text
                         Price)
VALUES (@Name, -- Name - nvarchar(100)
        @CategoryId, -- CategoryId - varchar(20)
        @BrandId, -- BrandId - varchar(20)
        @Image, -- Image - nvarchar(max)
        @Quantity, -- Quantity - integer
        @SaleDate, -- SaleDate - datetime
        @RAM, -- RAM - integer
        @ROM, -- ROM - varchar(20)
        @FrontCam, -- FrontCam - nvarchar(200)
        @BackCam, -- BackCam - nvarchar(200)
        @OS, -- OS - nvarchar(100)
        @Screen, -- Screen - nvarchar(200)
        @CPU, -- CPU - varchar(50)
        @Battery, -- Battery - varchar(100)
        @Weight, -- Weight - varchar(20)
        @VGA, -- VGA - nvarchar(100)
        @Description, -- Description - text
        @Price -- Price - float
       )
GO
-- 5.4 UpdateProduct
DROP PROC IF EXISTS sp_updateProduct
GO
CREATE PROC sp_updateProduct @ProductId VARCHAR(20),
                             @Name NVARCHAR(100),
                             @CategoryId VARCHAR(20),
                             @BrandId VARCHAR(20),
                             @Image NVARCHAR(MAX),
                             @Quantity INTEGER,
                             @SaleDate DATETIME,
                             @RAM INTEGER,
                             @ROM VARCHAR(20),
                             @FrontCam NVARCHAR(200),
                             @BackCam NVARCHAR(200),
                             @OS NVARCHAR(100),
                             @Screen NVARCHAR(200),
                             @CPU VARCHAR(50),
                             @Battery VARCHAR(100),
                             @Weight VARCHAR(20),
                             @VGA NVARCHAR(100),
                             @Description nvarchar(max),
                             @Price FLOAT
AS
UPDATE dbo.Products
SET Name        = @Name,
    CategoryId  = @CategoryId,
    BrandId     = @BrandId,
    Image       = @Image,
    Quantity    = @Quantity,
    SaleDate    = @SaleDate,
    RAM         = @RAM,
    ROM         = @ROM,
    FrontCam    = @FrontCam,
    BackCam     = @BackCam,
    OS          = @OS,
    Screen      = @Screen,
    CPU         = @CPU,
    Battery     = @Battery,
    Weight      = @Weight,
    VGA         = @VGA,
    Description = @Description,
    Price       = @Price
WHERE ProductId = @ProductId
GO
-- 5.5 DeleteProduct
DROP PROC IF EXISTS sp_deleteProduct
GO
CREATE PROC sp_deleteProduct(@ProductId VARCHAR(20))
AS
DELETE dbo.Products
WHERE ProductId = @ProductId
GO

-- 6 Review
-- 6.1 GetAllByProductId
DROP PROC IF EXISTS sp_getByProductId
GO
CREATE PROC sp_getByProductId(@ProductId VARCHAR(20))
AS
SELECT *
FROM dbo.Reviews
WHERE ProductId = @ProductId
GO
-- 6.2 GetById
DROP PROC IF EXISTS sp_getById
GO
CREATE PROC sp_getById(@ReviewId VARCHAR(20))
AS
SELECT *
FROM dbo.Reviews
WHERE ReviewId = @ReviewId
GO
-- 6.3 InsertReviews
DROP PROC IF EXISTS sp_insertReview
GO
CREATE PROC sp_insertReview @Username VARCHAR(40),
                            @ProductId VARCHAR(20),
                            @Content NVARCHAR(max),
                            @Rate INTEGER,
                            @Time DATETIME
AS
INSERT INTO dbo.Reviews(Username, ProductId, Content, Rate, Time)
VALUES (@Username, -- Username - varchar(40)
        @ProductId, -- ProductId - varchar(20)
        @Content, -- Content - nvarchar(max)
        @Rate, -- Rate - integer
        @Time -- Time - datetime
       )
GO
-- 6.4 UpdateReviews
DROP PROC IF EXISTS sp_updateReview
GO
CREATE PROC sp_updateReview @ReviewId VARCHAR(20),
                            @Username VARCHAR(40),
                            @ProductId VARCHAR(20),
                            @Content NVARCHAR(max),
                            @Rate INTEGER,
                            @Time DATETIME
AS

UPDATE dbo.Reviews
SET Username  = @Username,
    ProductId = @ProductId,
    Content   = @Content,
    Rate      = @Rate,
    Time      = @Time
WHERE ReviewId = @ReviewId
GO
-- 6.5 DeleteReview
DROP PROC IF EXISTS sp_deleteReview
GO
CREATE PROC sp_deleteReview(@ReviewId VARCHAR(20))
AS
DELETE dbo.Reviews
WHERE ReviewId = @ReviewId
GO

-- 7 Deliveries
-- 7.1 Get
DROP PROC IF EXISTS sp_getAllDeliveries
GO
CREATE PROC sp_getAllDeliveries
AS
SELECT *
FROM Deliveries
GO
-- 7.2 Get by id
DROP PROC IF EXISTS sp_getDeliveryById
GO
CREATE PROC sp_getDeliveryById @Id VARCHAR(20)
AS
SELECT *
FROM Deliveries
WHERE DeliveryId = @Id
GO
-- 7.3 Insert
DROP PROC IF EXISTS sp_insertDelivery
GO
CREATE PROC sp_insertDelivery @DeliveryId VARCHAR(20),
                              @Name NVARCHAR(100),
                              @Email VARCHAR(100),
                              @PhoneNumber VARCHAR(20),
                              @Location NVARCHAR(200)
AS
INSERT INTO Deliveries
VALUES (@DeliveryId, @Name, @Email, @PhoneNumber, @Location)
GO
-- 7.4 Update
DROP PROC IF EXISTS sp_updateDelivery
GO
CREATE PROC sp_updateDelivery @DeliveryId VARCHAR(20),
                              @Name NVARCHAR(100),
                              @Email VARCHAR(100),
                              @PhoneNumber VARCHAR(20),
                              @Location NVARCHAR(200)
AS
UPDATE Deliveries
SET Name        = @Name,
    Email       = @Email,
    PhoneNumber = @PhoneNumber,
    Location    = @Location
WHERE DeliveryId = @DeliveryId
GO
-- 7.5 Delete
DROP PROC IF EXISTS sp_deleteDelivery
GO
CREATE PROC sp_deleteDelivery @DeliveryId VARCHAR(20)
AS
DELETE Deliveries
WHERE DeliveryId = @DeliveryId
GO

-- 8 Coupons
-- 8.1 Get
DROP PROC IF EXISTS sp_getAllCoupons
GO
CREATE PROC sp_getAllCoupons
AS
SELECT *
FROM Coupons
GO
-- 8.2 Get by id
DROP PROC IF EXISTS sp_getCouponById
GO
CREATE PROC sp_getCouponById @CouponId VARCHAR(40)
AS
SELECT *
FROM Coupons
WHERE CouponId = @CouponId
GO
-- 8.3 Insert
DROP PROC IF EXISTS sp_insertCoupon
GO
CREATE PROC sp_insertCoupon @CouponId VARCHAR(40),
                            @Discount FLOAT,
                            @ExpiredTime DATETIME,
                            @EffectiveTime DATETIME,
                            @Description NVARCHAR(300)
AS
INSERT INTO Coupons
VALUES (@CouponId, @Discount, @ExpiredTime, @EffectiveTime, @Description)
GO
-- 8.4 Update
DROP PROC IF EXISTS sp_updateCoupon
GO
CREATE PROC sp_updateCoupon @CouponId VARCHAR(40),
                            @Discount FLOAT,
                            @ExpiredTime DATETIME,
                            @EffectiveTime DATETIME,
                            @Description NVARCHAR(300)
AS
UPDATE Coupons
SET Discount      = @Discount,
    ExpiredTime   = @ExpiredTime,
    EffectiveTime = @EffectiveTime,
    Description   = @Description
WHERE CouponId = @CouponId
GO
-- 8.5 Delete
DROP PROC IF EXISTS sp_deleteCoupon
GO
CREATE PROC sp_deleteCoupon @CouponId VARCHAR(40)
AS
DELETE Coupons
WHERE CouponId = @CouponId
GO

-- 9 Orders
-- 9.1 Get
DROP PROC IF EXISTS sp_getAllOrders
GO
CREATE PROC sp_getAllOrders
AS
SELECT *
FROM Orders
GO
-- 9.2 Get by id
DROP PROC IF EXISTS sp_getOrderById
GO
CREATE PROC sp_getOrderById @OrderId INTEGER
AS
SELECT *
FROM Orders
WHERE OrderId = @OrderId
GO
-- 9.3 Insert
DROP PROC IF EXISTS sp_insertOrder
GO
CREATE PROC sp_insertOrder @OrderId VARCHAR(20),
                           @Username VARCHAR(40),
                           @Name NVARCHAR(100),
                           @Address NVARCHAR(200),
                           @PhoneNumber VARCHAR(20),
                           @PurchaseDate DATETIME,
                           @TotalPrices FLOAT,
                           @DeliveryId VARCHAR(20),
                           @Status NVARCHAR(200),
                           @CouponId INTEGER,
                           @DiscountPrice FLOAT
AS
INSERT INTO Orders
VALUES (@OrderId, @Username, @Name, @Address, @PhoneNumber, @PurchaseDate,
        @TotalPrices, @DeliveryId, @Status, @CouponId, @DiscountPrice)
GO
-- 9.4 Update
DROP PROC IF EXISTS sp_updateOrder
GO
CREATE PROC sp_updateOrder @OrderId VARCHAR(20),
                           @Username VARCHAR(40),
                           @Name NVARCHAR(100),
                           @Address NVARCHAR(200),
                           @PhoneNumber VARCHAR(20),
                           @PurchaseDate DATETIME,
                           @TotalPrices FLOAT,
                           @DeliveryId VARCHAR(20),
                           @Status NVARCHAR(200),
                           @CouponId INTEGER,
                           @DiscountPrice FLOAT
AS
UPDATE Orders
SET Username      = @Username,
    Name          = @Name,
    Address       = @Address,
    PhoneNumber   = @PhoneNumber,
    PurchaseDate  = @PurchaseDate,
    TotalPrices   = @TotalPrices,
    DeliveryId    = @DeliveryId,
    Status        = @Status,
    CouponId      = @CouponId,
    DiscountPrice = @DiscountPrice
WHERE OrderId = @OrderId
GO
-- 9.5 Delete
DROP PROC IF EXISTS sp_deleteOrder
GO
CREATE PROC sp_deleteOrder @OrderId VARCHAR(20)
AS
DELETE Orders
WHERE OrderId = @OrderId
GO

-- 10 OrderDetails
-- 10.1 Get
DROP PROC IF EXISTS sp_getAllOrderDetails
GO
CREATE PROC sp_getAllOrderDetails
AS
SELECT *
FROM OrderDetails
GO
-- 10.2 Get by OrderId
DROP PROC IF EXISTS sp_getOrderDetailsByOrderId
GO
CREATE PROC sp_getOrderDetailsByOrderId @OrderId VARCHAR(20)
AS
SELECT *
FROM OrderDetails
WHERE OrderId = @OrderId
GO
-- 10.3 Insert
DROP PROC IF EXISTS sp_insertOrderDetails
GO
CREATE PROC sp_insertOrderDetails @OrderId VARCHAR(20),
                                  @ProductId VARCHAR(20),
                                  @Quantity INTEGER
AS
INSERT INTO OrderDetails
VALUES (@OrderId, @ProductId, @Quantity, 0.0, 0.0)
GO
-- 10.4 Update
DROP PROC IF EXISTS sp_updateOrderDetails
GO
CREATE PROC sp_updateOrderDetails @OrderId VARCHAR(20),
                                  @ProductId VARCHAR(20),
                                  @Quantity INTEGER
AS
UPDATE OrderDetails
SET Quantity = @Quantity
WHERE OrderId = @OrderId
  and ProductId = @ProductId
GO
-- 10.5 Delete
DROP PROC IF EXISTS sp_deleteOrderDetails
GO
CREATE PROC sp_deleteOrderDetails @OrderId VARCHAR(20),
                                  @ProductId VARCHAR(20)
AS
DELETE OrderDetails
WHERE OrderId = @OrderId
  and ProductId = @ProductId
GO

-- 11 CartDetails
-- 11.1 Get
DROP PROC IF EXISTS sp_getAllCartDetails
GO
CREATE PROC sp_getAllCartDetails
AS
SELECT *
FROM CartDetails
GO
-- 11.2 Get by OrderId
DROP PROC IF EXISTS sp_getCartDetailsByUsername
GO
CREATE PROC sp_getCartDetailsByUsername @Username VARCHAR(40)
AS
SELECT *
FROM CartDetails
WHERE Username = @Username
GO
-- 11.3 Insert
DROP PROC IF EXISTS sp_insertCartDetails
GO
CREATE PROC sp_insertCartDetails @Username VARCHAR(40),
                                 @ProductId VARCHAR(20),
                                 @Quantity INTEGER
AS
INSERT INTO CartDetails
VALUES (@Username, @ProductId, @Quantity)
GO
-- 11.4 Update
DROP PROC IF EXISTS sp_updateCartDetails
GO
CREATE PROC sp_updateCartDetails @Username VARCHAR(40),
                                 @ProductId VARCHAR(20),
                                 @Quantity INTEGER
AS
UPDATE CartDetails
SET Quantity = @Quantity
WHERE Username = @Username
  and ProductId = @ProductId
GO
-- 11.5 Delete
DROP PROC IF EXISTS sp_deleteCartDetails
GO
CREATE PROC sp_deleteCartDetails @Username VARCHAR(40),
                                 @ProductId VARCHAR(20)
AS
DELETE CartDetails
WHERE Username = @Username
  and ProductId = @ProductId
GO

--------- TRIGGER ----------
-- Insert, update OrderDetails
drop trigger if exists after_insert_update_OrderDetails
go
create trigger after_insert_update_OrderDetails
    on OrderDetails
    after insert,
    update as
    declare
        @OrderId varchar(20), @TotalPrice float, @Username varchar(40), @ProductID varchar(20), @Quantity int, @Price float, @QuantityInStock int
    select @OrderId = new.OrderId,
           @TotalPrice = new.Quantity * p.Price,
           @Price = p.Price,
           @QuantityInStock = p.Quantity,
           @Username = ord.username,
           @ProductID = new.ProductId,
           @Quantity = new.quantity
    from inserted new,
         Products p,
         Orders ord
    where new.ProductId = p.ProductId
      and new.OrderId = ord.OrderId
begin
    if (@Quantity > @QuantityInStock)
        begin
            raiserror (N'Quantity not valid! ProductId: %s, Quantity: %d, QuantityInStock: %d', 16, 1, @ProductID, @Quantity, @QuantityInStock)
            rollback;
        end
    else
        begin
            update OrderDetails
            set Price      = @Price,
                TotalPrice = @TotalPrice
            where OrderId = @OrderId
              and ProductId = @ProductID

            update Orders
            set TotalPrices = (select sum(TotalPrice) from OrderDetails where OrderDetails.OrderId = @OrderId)
            where OrderId = @OrderId

            delete CartDetails
            where CartDetails.ProductId = @ProductID
              and CartDetails.Username = @Username

            update Products
            set Quantity -= @Quantity
            where ProductId = @ProductID
        end
end
go

-- Insert, update CartDetails
drop trigger if exists after_insert_update_CartDetails
go
create trigger after_insert_update_CartDetails
    on CartDetails
    after insert,
    update as
    declare
        @ProductId varchar(20), @Quantity int, @QuantityInStock int
    select @ProductId = new.ProductId, @Quantity = new.Quantity, @QuantityInStock = p.Quantity
    from inserted new,
         Products p
    where new.ProductId = p.ProductId
    if (@Quantity > @QuantityInStock)
        begin
            raiserror (N'Quantity not valid! ProductId: %s, Quantity: %d, QuantityInStock: %d', 16, 1, @ProductId, @Quantity, @QuantityInStock)
            rollback;
        end
go

drop trigger if exists Trigger_Delete_OrderDetail
go
CREATE TRIGGER Trigger_Delete_OrderDetail
    on OrderDetails
    for delete
    as
    DECLARE
        @Product_ID VARCHAR(20), @Order_ID VARCHAR(20), @Total int, @CouponId VARCHAR(40)
begin
    --Lấy ra product Id và Order Id từ cột vừa xóa
    SELECT @Product_ID = Deleted.ProductId, @Order_ID = Deleted.OrderId FROM Deleted
    --Cập nhật lại số lượng product trong kho
    UPDATE dbo.Products
    SET Quantity = Quantity +
                   (SELECT Deleted.Quantity FROM Deleted)
    WHERE ProductId = @Product_ID
    --Tính tổng tiền các sản phẩm còn lại
    SELECT @Total = SUM(TotalPrice)
    FROM dbo.OrderDetails
    WHERE OrderId = @Order_ID
    --Lấy mã coupon
    SELECT @CouponId = CouponId FROM dbo.Orders
    --Set lại tổng tiền
    UPDATE dbo.Orders
    SET TotalPrices   = @Total,
        DiscountPrice = @Total - (SELECT Discount from Coupons WHERE CouponId = @CouponId)
    WHERE OrderId = @Order_ID
end
go

-- SAMPLE DATAS --
USE [db_technological_appliances]
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'admin', N'admin', N'admin@email.com', N'0999999999', CAST(N'2001-01-01' AS Date), N'TP.HCM', 1)
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'nam', N'Thái Thành Nam', N'nam@email.com', N'0981771024', CAST(N'2001-11-28' AS Date), N'Bến Tre', 1)
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'phuong', N'Trịnh Xuân Phương', N'phuong@email.com', N'0999999995', CAST(N'2001-01-01' AS Date), N'Bến Tre', 1)
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'tan', N'Cao Hoài Tấn', N'tan@email.com', N'0999999998', CAST(N'2001-01-01' AS Date), N'Bến Tre', 1)
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'toan', N'Nguyễn Phúc Thanh Toàn', N'toan@email.com', N'0999999996', CAST(N'2001-01-01' AS Date), N'Tây Ninh',
        1)
GO
INSERT [dbo].[Users] ([Username], [Name], [Email], [PhoneNumber], [DateOfBirth], [Address], [Gender])
VALUES (N'trung', N'Nguyễn Ngọc Trung', N'trung@email.com', N'0999999997', CAST(N'2001-01-01' AS Date), N'Phú Yên', 1)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'admin', N'$2a$10$EIJuGNzAYSpm0neUemi.3.eWA44XqltUMszWRqZo64my/IF3tCZI.', 1)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'nam', N'$2a$10$j5aLIfYSOIbU2Ihkpti2KOh9o4b2J64zvFIRpvUwpy7d/h0bXxO7q', 0)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'phuong', N'$2a$10$77/xC5K89B3z7SecIu1Wm.PSDnw0qu0z6y6poYQjXTgsLqNeVVCbm', 0)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'tan', N'$2a$10$FGRitRqmuYpQq8KuGAA4quTRVgBt9LvnEUsF7CyScwa4efCRspXaW', 0)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'toan', N'$2a$10$dk8yjCKXGgQ.rCKjoGkizetL52Ay..w6IB80Kx7A/Lk161DrXykqy', 0)
GO
INSERT [dbo].[Account] ([Username], [Password], [Role])
VALUES (N'trung', N'$2a$10$/osmVYwaRKMrNydGUcmRa.Ho1NScl3JuVuT4YTSTHlaYoP.xsUdke', 0)
GO
INSERT [dbo].[Categories] ([CategoryId], [Name])
VALUES (N'C01', N'Laptop')
GO
INSERT [dbo].[Categories] ([CategoryId], [Name])
VALUES (N'C02', N'SmartPhone')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B01', N'Samsung', N'samsung@email.com', N'link', N'Korea')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B02', N'Apple', N'apple@gmail.com', N'', N'USA')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B03', N'Oppo', N'oppo@gmail.com', N'', N'China')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B04', N'Vivo', N'vivo@gmail.com', N'', N'China')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B05', N'Asus', N'asus@gmail.com', N'', N'VN')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B06', N'MSI', N'msi@gmail.com', N'', N'China')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B07', N'Xiaomi', N'xiaomi@mail.com', N'link', N'China')
GO
INSERT [dbo].[Brands] ([BrandId], [Name], [Email], [Logo], [Location])
VALUES (N'B08', N'Lenovo', N'lenovo@mail.com', N'link', N'America')
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00001', N'Samsung Galaxy A03 32GB', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/168163cd-0a4d-4db8-83f0-91ed1b4ac7a8.jpg","image4":"http://localhost:8080/getImage/348a98e8-1623-4dde-a880-f35ec8b35387.jpg","image1":"http://localhost:8080/getImage/586de82f-93a2-4913-b4af-c6cf3a04e3b6.jpg","image2":"http://localhost:8080/getImage/21dacf8f-3382-4b90-be36-8be5c88fb271.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 32, N'32', N'5', N'48', N'Android', N'6.5',
        N'Unisoc T606 8 nhân', N'5000mAh', N'', N'',
        N'Camera chính có độ phân giải 48MP cho chất lượng hình ảnh rõ nét, chân thực Camera Xóa Phông 2MP làm nổi bật chủ thể và tùy chỉnh hiệu ứng ánh sáng Camera selfie độ phân giải 5MP mang đến những bức ảnh Selfie đẹp tự nhiên Galaxy A03 có dung lượng pin lớn 5,000mAh có thể sử dụng lên đến 2 ngày Vi xử lý 8 nhân mạnh mẽ cho trải nghiệm nhanh chóng, mượt mà mọi tác vụ',
        2650000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00002', N' Samsung Galaxy S20 FE 8GB/256GB', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/2caaa350-4edf-4ac9-857f-22cd72786e8a.jpg","image4":"http://localhost:8080/getImage/ddca3bde-e8b5-4f1e-b7b3-63e4b2e53719.jpg","image1":"http://localhost:8080/getImage/fdefeab1-1a64-4b91-b48c-f515922f2ec0.jpg","image2":"http://localhost:8080/getImage/09e2ed22-f7d3-4380-92fb-25bcf1475499.jpg"}',
        8, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256', N'32', N'12 ', N'', N'6.5 ',
        N'Qualcomm SM8250 Snapdragon 865 5G (7 nm+)', N'4500 mAh', N'', N'',
        N'Điện thoại Samsung Galaxy S20 FE 8GB/256GB thu hút mọi ánh nhìn với màn hình tràn viền sống động Infinity-O Super AMOLED 6.5 inch. Độ phân giải Full HD hiển thị hình ảnh sắc nét màu sắc chân thực cho cảm giác trải nghiệm thực sự sống động. Đặc biệt, tần số quét màn hình của S20 FE lên tới 120 Hz giúp cho trải ngiệm cho mọi trải nghiệm chạm, lướt mượt mà và trơn tru.',
        10390000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00003', N'IPhone 13 256GB', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/a1304c2d-6b6a-4ce9-8199-135372445793.jpg","image4":"http://localhost:8080/getImage/53a75a32-d26d-43eb-a07f-d3703b0b3ba5.jpg","image1":"http://localhost:8080/getImage/0a0291f2-bf20-420d-bce5-06244f252553.jpg","image2":"http://localhost:8080/getImage/ace387e8-f445-46b2-813f-654b96c5cb84.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'256', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A15 Bionic', N'', N'', N'',
        N'Màn hình OLED Super Retina XDR 6.1'''' hiển thị sắc nét, màu sắc chân thực Chip Apple A15 Bionic mạnh mẽ xử lý tác vụ tốt, trải nghiệm game mượt mà Mạng di động 5G giúp xem trực tuyến, tải xuống các ứng dụng nhanh chóng Cụm camera sau thiết kế đặt chéo, camera chính 12 MP chụp ảnh sắc nét Camera trước có độ phân giải 12 MP chụp selfie rõ nét, đẹp tự nhiên iPhone 13 kháng nước và bụi chuẩn IP68 cho bạn yên tâm sử dụng hơn Khung viền được làm từ nhôm cùng mặt lưng kính sang trọng, cao cấp',
        23990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00004', N'IPhone 12 128GB', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/01b0cf73-a04b-409d-a10a-8ae2550a4637.jpg","image4":"http://localhost:8080/getImage/8e1d57fd-6f43-4cc3-80e6-878fc3968514.jpg","image1":"http://localhost:8080/getImage/d44d8ec9-d754-4de7-84de-680f0423acc9.jpg","image2":"http://localhost:8080/getImage/be748631-8c23-4d27-a676-e49b794fc2dc.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128', N'12', N'12', N'iOS 14.1', N'6.1',
        N'Apple A14 Bionic', N'4500 mAh', N'', N'',
        N'Apple ra mắt iPhone 12 128GB Đỏ với cạnh khung vuông vắn. Với thiết kế iPhone 12 128GB Đỏ sẽ tạo được độ chắc chắn khi người dùng cầm nắm thiết bị hơn so với khung bo tròn như trước đây iPhone 11, X,... Điện thoại Apple iPhone 12 mang đến độ bền vượt trội và diện mạo bóng bẩy sang trọng hơn. Màu đỏ nổi bật thể hiện rõ nét cá tính của người dùng.',
        18990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00005', N' Laptop Asus UX425E i5-1135G7/8GB/512GB/Win 11 UX425EA-KI839W', N'C01', N'B05',
        N'{"image3":"http://localhost:8080/getImage/a717cea5-01d6-47bf-9aa0-d709d42d13c6.jpg","image4":"http://localhost:8080/getImage/8ca898b7-a77c-4fe1-a0db-65ad552a3325.jpg","image1":"http://localhost:8080/getImage/4a40bf55-100d-407b-90fe-ba563a3b7691.jpg","image2":"http://localhost:8080/getImage/67fcd42f-fdd4-4263-8b0e-9694d61750b9.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512', N'8', N'8', N'Win 11', N'14', N'Intel Core i5',
        N'', N'', N'',
        N'Chip Intel Core i5 Tiger Lake 1135G7 giúp bạn xử lý nhẹ nhàng mọi tác vụ Màn hình 14 inch có tần số quét 60 Hz cung cấp chất lượng hình ảnh sắc nét Hiện đại, sang chảnh với lớp vỏ kim loại nguyên khối có gam màu xám chủ đạo Nâng cao hiệu suất làm việc và học tập nhờ hệ điều hành Windows 11 Trọng lượng máy chỉ 1.17 kg giúp bạn di chuyển linh hoạt mọi lúc mọi nơi',
        19990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00006', N'Laptop MSI GF63 Thin 10SC-812VN i7-10750H/8GB/512GB/Win10', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/672ff554-3c2e-4425-b57b-67118957c2cb.jpg","image4":"http://localhost:8080/getImage/045cc947-6fb4-44b5-bd5c-df37bd363a51.jpg","image1":"http://localhost:8080/getImage/a7a30b83-cbf1-4073-b529-3fc16d9f347d.jpg","image2":"http://localhost:8080/getImage/19080248-361f-4861-8713-ab8eb149be5d.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512', N'12', N'12', N'Win 11', N'15.6',
        N'Intel® Core™ I7-10750H', N'', N'1.86', N'',
        N'Màn hình 15.6'''' FHD cho trải nghiệm hình ảnh sắc nét, sống động Bộ vi xử lý i7-10750H xử lý mượt mà các tác vụ văn phòng, học tập RAM 8GB chạy tốt nhiều tác vụ cùng lúc, chuyển đổi qua lại mượt mà Ổ cứng SSD 512GB giúp khởi động máy, mở ứng dụng nhanh chóng Tận hưởng âm thanh sống động cực đã với công nghệ Nahimic Audio',
        20990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00007', N'IPhone 13 128GB', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/a02230f7-29f8-45c9-b696-ffcb75bfbd02.jpg","image4":"http://localhost:8080/getImage/16e9977b-7169-4953-9e4e-b8e2e8594dab.jpg","image1":"http://localhost:8080/getImage/03c055fd-e5c5-4a50-b4d4-ff772585e98e.jpg","image2":"http://localhost:8080/getImage/c4ac590d-34b2-4283-84f4-e5d4ee52d5b3.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A14 Bionic', N'5000mAh', N'188g', N'',
        N'Điện thoại iPhone 13 128GB Đen được trang bị con chip A15 Bionic sản xuất siêu mạnh trên tiến trình 5nm, nhờ đó điện thoại đạt được hiệu năng ấn tượng, CPU nhanh hơn 50%, GPU nhanh hơn 30% khi so với các mẫu đối thủ cùng phân khúc. Đồng thời, với hiệu năng được cải tiến, người dùng có được những trải nghiệm tốt hơn trên điện thoại khi dùng các ứng dụng chỉnh sửa ảnh hay “phá đảo” các tựa game đồ họa cao mượt mà. iPhone 13 cũng được tích hợp sẵn bộ nhớ trong 128GB dung lượng lý tưởng cho phép bạn thỏa thích lưu trữ mọi nội dung theo ý muốn mà không lo tình trạng bị đầy bộ nhớ. Tốc độ mạng 5G cũng được cải thiện với nhiều băng tần hơn, cho phép điện thoại iPhone 13 xem trực tuyến hoặc tốc độ tải xuống ứng dụng, tài liệu nhanh chóng. Không chỉ vậy, siêu phẩm mới này còn có chế độ dữ liệu thông minh, tự động phát hiện và giảm tải tốc độ mạng để tiết kiệm năng lượng khi không cần dùng tốc độ cao.',
        21790000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00008', N'IPhone 13 128GB Trắng', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/724327ea-4bce-48f8-b5b5-926f8ca6c60c.jpg","image4":"http://localhost:8080/getImage/8e7162ca-8c9b-4fb5-b168-ce867e3265d3.jpg","image1":"http://localhost:8080/getImage/fa73edcd-a638-42b3-a7d8-295e33adb006.jpg","image2":"http://localhost:8080/getImage/1e2a1f4c-420b-4f3f-8ff6-c3c11403a42a.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A15 Bionic', N'5000mAh', N'188g', N'',
        N'Điện thoại iPhone 13 128GB Trắng được trang bị con chip A15 Bionic sản xuất siêu mạnh trên tiến trình 5nm, nhờ đó điện thoại đạt được hiệu năng ấn tượng, CPU nhanh hơn 50%, GPU nhanh hơn 30% khi so với các mẫu đối thủ cùng phân khúc. Đồng thời, với hiệu năng được cải tiến, người dùng có được những trải nghiệm tốt hơn trên điện thoại khi dùng các ứng dụng chỉnh sửa ảnh hay “phá đảo” các tựa game đồ họa cao mượt mà. iPhone 13 cũng được tích hợp sẵn bộ nhớ trong 128GB dung lượng lý tưởng cho phép bạn thỏa thích lưu trữ mọi nội dung theo ý muốn mà không lo tình trạng bị đầy bộ nhớ. Tốc độ mạng 5G cũng được cải thiện với nhiều băng tần hơn, cho phép điện thoại iPhone 13 xem trực tuyến hoặc tốc độ tải xuống ứng dụng, tài liệu nhanh chóng. Không chỉ vậy, siêu phẩm mới này còn có chế độ dữ liệu thông minh, tự động phát hiện và giảm tải tốc độ mạng để tiết kiệm năng lượng khi không cần dùng tốc độ cao.',
        21790000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00009', N' IPhone 13 128GB Đỏ', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/35fe4d3c-3e62-4e85-b641-25aa0e192046.jpg","image4":"http://localhost:8080/getImage/a38af810-050b-4bbc-9e0f-e2f294ad0213.jpg","image1":"http://localhost:8080/getImage/6a097db1-60e7-4258-8cc9-51edce96aa88.jpg","image2":"http://localhost:8080/getImage/c97c605f-e506-4e72-a3a8-78d684bf30b6.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A15 Bionic', N'5000mAh', N'188g', N'',
        N'Điện thoại iPhone 13 128GB Đỏ được trang bị con chip A15 Bionic sản xuất siêu mạnh trên tiến trình 5nm, nhờ đó điện thoại đạt được hiệu năng ấn tượng, CPU nhanh hơn 50%, GPU nhanh hơn 30% khi so với các mẫu đối thủ cùng phân khúc. Đồng thời, với hiệu năng được cải tiến, người dùng có được những trải nghiệm tốt hơn trên điện thoại khi dùng các ứng dụng chỉnh sửa ảnh hay “phá đảo” các tựa game đồ họa cao mượt mà. iPhone 13 cũng được tích hợp sẵn bộ nhớ trong 128GB dung lượng lý tưởng cho phép bạn thỏa thích lưu trữ mọi nội dung theo ý muốn mà không lo tình trạng bị đầy bộ nhớ. Tốc độ mạng 5G cũng được cải thiện với nhiều băng tần hơn, cho phép điện thoại iPhone 13 xem trực tuyến hoặc tốc độ tải xuống ứng dụng, tài liệu nhanh chóng. Không chỉ vậy, siêu phẩm mới này còn có chế độ dữ liệu thông minh, tự động phát hiện và giảm tải tốc độ mạng để tiết kiệm năng lượng khi không cần dùng tốc độ cao.',
        21890000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00010', N'IPhone 13 256GB Hồng', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/9cef1364-4938-469b-96de-5e1e9a30aff9.jpg","image4":"http://localhost:8080/getImage/d41e4812-0b7a-4dc8-a7df-9e8cb84f9eaf.jpg","image1":"http://localhost:8080/getImage/c0fcc659-e719-4b2d-a1ff-a9b747d0dc3e.jpg","image2":"http://localhost:8080/getImage/fdc2a72a-a3df-46b9-8026-28de904d4664.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A15 Bionic', N'1', N'188g', N'',
        N'Điện thoại iPhone 13 256GB Hồng được trang bị con chip A15 Bionic sản xuất siêu mạnh trên tiến trình 5nm, nhờ đó điện thoại đạt được hiệu năng ấn tượng, CPU nhanh hơn 50%, GPU nhanh hơn 30% khi so với các mẫu đối thủ cùng phân khúc. Đồng thời, với hiệu năng được cải tiến, người dùng có được những trải nghiệm tốt hơn trên điện thoại khi dùng các ứng dụng chỉnh sửa ảnh hay “phá đảo” các tựa game đồ họa cao mượt mà. iPhone 13 cũng được tích hợp sẵn bộ nhớ trong 256GB dung lượng lý tưởng cho phép bạn thỏa thích lưu trữ mọi nội dung theo ý muốn mà không lo tình trạng bị đầy bộ nhớ. Tốc độ mạng 5G cũng được cải thiện với nhiều băng tần hơn, cho phép điện thoại iPhone 13 xem trực tuyến hoặc tốc độ tải xuống ứng dụng, tài liệu nhanh chóng. Không chỉ vậy, siêu phẩm mới này còn có chế độ dữ liệu thông minh, tự động phát hiện và giảm tải tốc độ mạng để tiết kiệm năng lượng khi không cần dùng tốc độ cao.',
        21890000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00011', N'IPhone 13 Pro 1TB Xám', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/57796849-0a6a-4c6b-87db-61d250449d1b.jpg","image4":"http://localhost:8080/getImage/0347dcea-756f-4eaf-bd33-ef9b08fcc4c6.jpg","image1":"http://localhost:8080/getImage/7d318dc5-c0cf-4680-ac24-7fd1dc726a71.jpg","image2":"http://localhost:8080/getImage/507bcb5b-d4a9-4a8f-a3c3-0922bf0356c6.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 6, N'1024', N'12', N'12', N'iOS 15', N'6.1',
        N'Apple A15 Bionic', N'5000mAh', N'188g', N'',
        N'Chip Apple A15 Bionic mạnh mẽ xử lý tác vụ tốt, trải nghiệm game mượt mà Màn hình Super Retina XDR với ProMotion hiển thị sắc nét, màu sắc chân thực Tốc độ làm mới màn hình lên đến 120Hz chạm lướt mượt mà, chơi game cực đã iPhone 13 Pro có khả năng kháng nước chuẩn IP68 cho bạn yên tâm sử dụng Hệ thống 3 camera 12MP: Camera tele, Wide và Ultra Wide nâng tầm nhiếp ảnh Camera trước có độ phân giải 12MP chụp ảnh selfie sắc nét, đẹp tự nhiên',
        41490000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00012', N'Laptop MSI Modern 15 A5M R55500U/8GB/512GB/Win11 (238VN)', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/4c7f6ac5-6747-4d65-9eb5-6060e532bca6.jpg","image4":"http://localhost:8080/getImage/494e4992-afed-4b8e-83bf-f3b43a3ff919.jpg","image1":"http://localhost:8080/getImage/1766988c-7aef-4c88-8917-24a7b1fca004.jpg","image2":"http://localhost:8080/getImage/c58256ce-3388-4b60-80f3-8104d213c354.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512', N'8', N'', N'Win 11', N'15.6',
        N'AMD Ryzen 5 5500U', N'3-Cell 52/39Wh battery', N'1.6', N'',
        N'Hiệu năng mạnh mẽ giúp giải quyết công việc nhanh chóng, mượt mà RAM 8GB DDR4 giúp laptop đa nhiệm ổn định, hạn chế tình trạng giật lag Ổ cứng SSD 512GB giúp khởi động máy nhanh, không gian lưu trữ tốt Màn hình 15.6 inch độ phân giải FHD mang đến hình ảnh rõ nét, chân thực Âm thanh Hi-res Audio cho trải nghiệm âm thanh giải trí to, rõ, sống động Thời lượng pin lên đến 10 giờ đáp ứng tốt nhu cầu học tập, làm việc Đèn nền bàn phím hỗ trợ người dùng khi làm việc ở môi trường thiếu sáng',
        15490000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00013', N'Laptop MSI GF63 i7-10750H/8GB/512GB/Win10 (GF6310SC-020VN)', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/fb7ca89d-10c2-47c1-9488-4dc47043d4ac.jpg","image4":"http://localhost:8080/getImage/20f3d948-b200-4914-815f-b3a65fd7d67f.jpg","image1":"http://localhost:8080/getImage/49d4936c-f32a-4fef-8299-545eb119a666.jpg","image2":"http://localhost:8080/getImage/d96c3c0a-831b-43da-b1bf-8dcf8537b2f7.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512', N'8', N'', N'Win 11', N'15.6', N'',
        N'3-Cell 52/39Wh battery', N'1.86', N'',
        N'Thiết kế bằng hợp kim nhôm sang trọng, nặng khoảng 1.9kg dễ mang theo sử dụng Màn hình 15.6 inch FHD IPS 144Hz cho trải nghiệm hình ảnh sắc nét, sống động Bộ vi xử lý Intel Core i7 thế hệ thứ 10 tiên tiến xử lý tác vụ nhanh chóng, mượt mà Thoải sức sáng tạo với Card đồ họa rời NVIDIA GeForce GTX 1650 và Intel UHD Graphics RAM 8GB DDR4 giúp chạy tốt các ứng dụng, chơi game nặng mà không lo lag máy Bộ bàn phím có thêm hệ thống đèn led hỗ trợ sử dụng trong điều kiện thiếu sáng Laptop có thời lượng pin khoảng trên 7 tiếng đáp ứng tốt nhu cầu làm việc và giải trí',
        20990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00014', N'Laptop MacBook Air M1 2020 13 inch 256GB MGND3SA/A Vàng', N'C01', N'B02',
        N'{"image3":"http://localhost:8080/getImage/20971cb0-1463-4049-b1d5-232fccd57aa1.jpg","image4":"http://localhost:8080/getImage/5f5ebe11-9e25-428e-8128-f3977d3df6df.jpg","image1":"http://localhost:8080/getImage/5a914bab-361b-41a3-84c8-c9f881d06bb6.jpg","image2":"http://localhost:8080/getImage/c3084fd0-7f4f-41e6-ba35-1a7d5f30bab8.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256', N'8', N'', N'MacOS', N'13', N'Apple M1', N'5000mAh',
        N'1.29', N'',
        N'Laptop MacBook Air M1 13 inch 256GB MGND3SA/A Vàng trang bị bộ vi xử lý Apple M1 8 core với sức mạnh đột phá giúp Macbook Air trở thành chiếc một trong những chiếc laptop nhỏ gọn, sang trọng với hiệu năng mạnh mẽ nhất từ trước đến nay. Bộ vi xử lý M1 8 nhân cực mạnh mang đến hiệu suất đáng kinh ngạc, tốc độ xử lý tuyệt vời, mượt mà tác vụ đồng thời kéo dài tuổi thọ pin.',
        21990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00015', N'Macbook Pro 14'''' M1 Pro 2021 8-core CPU/14-core GPU/16GB/512GB MKGP3SA/A Xám', N'C01', N'B02',
        N'{"image3":"http://localhost:8080/getImage/7b953ed3-2367-4f94-b1d3-013738864703.jpg","image4":"http://localhost:8080/getImage/c0c8974d-f12f-4b20-961d-725e022426db.jpg","image1":"http://localhost:8080/getImage/87b17ddf-db64-4ed6-8ce3-3619eba960ce.jpg","image2":"http://localhost:8080/getImage/b2d5017a-b71c-4538-bc5f-0cac733cc12e.jpg"}',
        5, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 16, N'512', N'8', N'', N'MacOS', N'14.2',
        N'Apple M1 Pro 8-Core', N'', N'1.6', N'',
        N'Chip Apple M1 Pro cho hiệu suất làm việc cực kỳ cao với tốc độ xử lý nhanh chóng Thoải sức sáng tạo chỉnh sửa ảnh, thiết kế đồ họa chuyên nghiệp với GPU 14-Core RAM 16GB cho khả năng đa nhiệm cực mượt mà, không lo hiện tượng giật lag Ổ cứng SSD 512GB giúp khởi động máy và ứng dụng nhanh, không gian lưu trữ tốt Màn hình Liquid Retina XDR display cho khả năng hiển thị sắc nét, màu sắc rực rỡ Tận hưởng chất lượng âm đỉnh cao hơn bao giờ hết với công nghệ Dolby Atmos Bàn phím có đèn nền giúp bạn làm việc tốt hơn trong môi trường thiếu sáng',
        52990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00016', N'Laptop MSI Gaming GE66 Raider 12UGS-405VN', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/8e6677f6-d7fc-4d09-be50-694656763d39.jpg","image4":"http://localhost:8080/getImage/18ebcce0-d0d9-409f-baee-6fff8820adee.jpg","image1":"http://localhost:8080/getImage/0ef3b0a5-0414-40fd-a839-591c10a3881c.jpg","image2":"http://localhost:8080/getImage/26aa3aa6-34dd-4f89-9b83-910d6f0dd57b.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 32, N'1024', N'16', N'', N'Win 11', N'15.6',
        N'Intel Core i9-12900HK 3.8GHz up to 5.0GHz 24MB', N'4 Cell 99.9WHrs', N'2.66', N'',
        N'GE66 Raider có thiết kế góc cạnh và độc đáo. Cứng cáp và bền bỉ, thiết kế này tượng trưng cho một chiếc phi thuyền không gian. Dải đèn Mystic Light giúp tô điểm thêm cho góc chơi game của bạn. Tất cả để đưa trải nghiệm chơi game của bạn lên một tầm cao mới.',
        75200000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00017', N'Samsung S22 Ultra 12GB/256GB', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/c6419ae4-b817-4d93-9452-89e37811894f.jpg","image4":"http://localhost:8080/getImage/1e0a582d-882e-4604-8c0a-141a48d48420.jpg","image1":"http://localhost:8080/getImage/df068b0c-340d-4287-ac11-c6b6636068c1.jpg","image2":"http://localhost:8080/getImage/e4dc52b8-0130-43c5-9016-f20c5876f5c6.jpg"}',
        50, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 12, N'256', N'40MP',
        N'Camera chính 108MP; Camera góc siêu rộng 12MP; Camera tele 10MP; Camera tele 10MP', N'Android', N'6.8',
        N'Qualcomm Snapdragon 8 Gen 1', N'	5.000 mAh', N'189g', N'8', N'Samsung S22 Ultra 12GB/256GB Đen', 33990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00018', N'Samsung Galaxy S20 FE 8GB/256GB', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/f7856a7d-cb44-4b2b-bb7d-5ac6183a2a27.jpg","image4":"http://localhost:8080/getImage/11ab9179-8093-4555-bb80-15b481bf475a.jpg","image1":"http://localhost:8080/getImage/08d5dca6-b9c5-4129-87ac-cea377255595.jpg","image2":"http://localhost:8080/getImage/380eaf89-f2de-4fc4-9794-f8eb8ca55ed9.jpg"}',
        50, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256', N'32 MP', N'Chính 12 MP, 8 MP, 12 MP', N'', N'6.5',
        N'Qualcomm SM8250 Snapdragon 865 5G (7 nm+)', N'4500 mAh, S?c pin nhanh 25W', N'189g', N'null',
        N'Samsung Galaxy S20 FE 8GB/256GB Xanh', 10390000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00019', N'Asus ZenBook UX325EA-KG538W', N'C01', N'B05',
        N'{"image3":"http://localhost:8080/getImage/137c0eff-87b9-45a1-951b-b61bde9fc52d.jpg","image4":"http://localhost:8080/getImage/500fbab1-b1c0-4af4-9a9f-c9834d6969c7.jpg","image1":"http://localhost:8080/getImage/0d7e81f4-8d48-4efd-9398-c5bfd439e812.jpg","image2":"http://localhost:8080/getImage/78ff6af7-33de-44f7-92e0-689e157da063.jpg"}',
        50, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512',
        N'	HD camera with IR function to support Windows Hello', N'null',
        N'Windows 11 Home - ASUS recommends Windows 11 Pro for business', N'13.3 inch', N'Intel Core™ i5-1135G7',
        N'67WHrs, 4S1P, 4-cell Li-ion', N'1.14 kg', N'null',
        N'Laptop Asus ZenBook UX325EA-KG538W i5-1135G7/8GB/512GB/Win11', 22290000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00020', N'Laptop Asus ZenBook UX425EA', N'C01', N'B05',
        N'{"image3":"http://localhost:8080/getImage/6155902d-4a0a-4f22-b99a-48a43e83315c.jpg","image4":"http://localhost:8080/getImage/258afe6b-97f5-417e-b35d-df516a400881.jpg","image1":"http://localhost:8080/getImage/7b39300c-8ba7-4bf4-8e2d-480d44e4bfa6.jpg","image2":"http://localhost:8080/getImage/91f65e9b-ab4c-4f30-9f2f-953e34447243.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512',
        N'HD camera with IR function to support Windows Hello', N'null',
        N'Windows 11 Home - ASUS recommends Windows 11 Pro for business', N'13.3 inch', N'Intel Core™ i5-1135G7',
        N'67WHrs, 4S1P, 4-cell Li-ion', N'1.14 kg', N'null',
        N'Laptop Asus ZenBook UX425EA i5-1135G7/8GB/512GB/Win11 (KI749W)', 19990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00021', N'Y15s (V2120)', N'C02', N'B04',
        N'{"image3":"http://localhost:8080/getImage/8e181596-e99b-4fe5-acc4-df030854b669.jpg","image4":"http://localhost:8080/getImage/a76fc840-2064-4a3f-ba3e-4a1ac080ddea.jpg","image1":"http://localhost:8080/getImage/84d703c6-25f3-4a47-80cc-8dbcb0d1584b.jpg","image2":"http://localhost:8080/getImage/d0d6c43d-39fb-4615-99f0-451b0f0f4249.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 3, N'32GB', N'f/2.0 (8MP)', N'f/2.2 (13MP) + f/2.4 (2MP)',
        N'Funtouch OS 11.1 (Tùy biến trên Android 11 (Go Edition)', N'HD+ 1600*720 pixels', N'MediaTek Helio P35',
        N'5000mAh (TYP)', N'198g', N'null',
        N'Vivo Y15s sở hữu nhiều điểm tương đồng với những "người anh em" Vivo Y15 của mình khi toàn bộ thân máy làm bằng Polymer cao cấp, thiết kế cong cạnh 3D và kiểu dáng mỏng nhẹ chỉ 8.28 mm đem lại cảm giác cầm máy trong tay khá thoải mái.  Mặt lưng hoàn thiện với họa tiết kẻ sọc mờ với hai tùy chọn màu sắc Xanh Biển Sâu và Trắng có khả năng chuyển sáng xanh vô cùng đẹp mắt.Điện thoại còn được trang bị tính năng bảo mật mở khóa vân tay ở cạnh bên, được tích hợp hoàn hảo với nút nguồn ở vị trí vô cùng thuận lợi giúp người dùng có thể mở khóa cực nhanh chỉ trong 0.232 giây.',
        2990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00022', N'Vivo Y33s 8GB/128GB Xanh Hồng', N'C02', N'B04',
        N'{"image3":"http://localhost:8080/getImage/f6bcf00a-3362-486c-951e-8a2a534ffc5c.jpg","image4":"http://localhost:8080/getImage/ea976961-f083-4b6b-b6af-fc5bd1bdd228.jpg","image1":"http://localhost:8080/getImage/24a895d9-a4e2-4eb7-88b4-3aff4ac675a5.jpg","image2":"http://localhost:8080/getImage/392f5e1b-d0dc-4eb9-9af4-a0a86fb834a5.jpg"}',
        400, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'128GB', N'16MP', N'50MP + 2MP + 2MP',
        N'	Funtouch OS 11.1 (Tuỳ biến trên Android 11)', N'FHD+ (2408×1080) pixels  164.26x76.08x8.00 mm',
        N'MediaTek Helio G80', N'5000mAh (TYP), S?c Siêu T?c 18W', N'180g', N'null',
        N'Trên tay mình hiện tại là Vivo Y33s - chiếc điện thoại này có thiết kế khá tương đồng với các sản phẩm tầm trung mà Vivo cho ra mắt gần đây, vẫn là một sản phẩm có thiết kế trẻ trung với màu đen tráng gương và xanh mộng mơ. Ở phiên bản màu đen được phủ một lớp tráng gương sáng bóng, vào một số trường hợp nó có thể trở thành một chiếc gương soi tiện lợi. Vivo Y33s sử dụng chip Helio G80 cùng bộ nhớ RAM 8 GB, có thể mở rộng thêm 4 GB RAM nhờ công nghệ RAM Mở Rộng, như vậy là bạn sẽ có tổng 12 GB RAM. Mình có đo hiệu năng bằng phần mềm Antutu (bên trái) và PCMark (bên phải)',
        6490000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00023', N' Vivo Y21s 4GB/128GB Trắng', N'C02', N'B04',
        N'{"image3":"http://localhost:8080/getImage/1db11442-582f-4f08-b59e-30a32364fa60.jpg","image4":"http://localhost:8080/getImage/ed6580ca-378d-43c5-a98b-4c398ea43f78.jpg","image1":"http://localhost:8080/getImage/36aa62bd-106b-44b5-b548-e7fdcbb94f30.jpg","image2":"http://localhost:8080/getImage/f282a7bc-1879-4538-a427-f65a3015c546.jpg"}',
        10, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128GB', N'8MP', N'50MP + 2MP + 2MP',
        N'Funtouch OS 11.1 (Tuỳ biến trên Android 11)', N'HD+ (1600*720) pixels', N'Mediatek Helio G80',
        N'5000mAh (TYP), S?c Siêu T?c 18W', N'220g', N'null',
        N'Vivo Y21 chiếc smartphone mang trong mình nhiều ưu điểm nổi bật như màn hình viền mỏng đẹp mắt, hiệu năng ổn định cùng dung lượng pin tận 5000 mAh chắc chắn sẽ đáp ứng nhu cầu sử dụng của bạn cả ngày dài. Máy có một thiết kế nguyên khối tạo cảm giác bền bỉ, chắc chắn. Vivo Y21 còn mang đến trải nghiệm cầm nắm thoải mái với thân máy mỏng chỉ 8 mm và có các cạnh viền bo tròn mịn màng giúp cho mọi thao tác sử dụng trở nên hoàn hảo.',
        3990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00024', N'Điện thoại Vivo V23e 8GB/128GB Đen', N'C02', N'B04',
        N'{"image3":"http://localhost:8080/getImage/83df4022-6a8c-4f65-b215-be0e6308f370.jpg","image4":"http://localhost:8080/getImage/5d1d63fc-b5c9-4c7a-8d0c-6ec2de1813df.jpg","image1":"http://localhost:8080/getImage/9ea2a490-e3e2-408c-91bd-92e33e4389f7.jpg","image2":"http://localhost:8080/getImage/92a48ce6-daa3-4ef7-97c4-c621ac886ff5.jpg"}',
        20, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'128GB', N'50MP',
        N'64MP AF + 8MP (Góc siêu rộng) + 2MP (Siêu cận)', N'Funtouch OS 12 (Tùy biến trên Android 11)',
        N'FHD+ 2400×1080 pixels', N'MediaTek Helio G96', N'4050mAh (TYP)', N'170g', N'null',
        N'Vivo V23e - sản phẩm tầm trung được đầu tư lớn về khả năng selfie cùng ngoại hình mỏng nhẹ, bên cạnh thiết kế vuông vức theo xu hướng hiện tại thì V23e còn có hiệu năng tốt và một viên pin có khả năng sạc cực nhanh.  Vivo V23e vẫn giữ đặc điểm nổi bật của Vivo V Series với thiết kế mỏng 7.36 mm ấn tượng (ở phiên bản màu đen). Viền màn hình 2 cạnh bên có độ mỏng ở mức vừa phải, tuy nhiên thì phần cạnh dưới thì có dày hơn một chút.',
        8490000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00025', N'OPPO A74 5G', N'C02', N'B03',
        N'{"image3":"http://localhost:8080/getImage/1.3.jpg","image4":"http://localhost:8080/getImage/1.4.jpg","image1":"http://localhost:8080/getImage/1.1.jpg","image2":"http://localhost:8080/getImage/1.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 6, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 10000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00026', N'OPPO A15s', N'C02', N'B03',
        N'{"image3":"http://localhost:8080/getImage/2.3.jpg","image4":"http://localhost:8080/getImage/2.4.jpg","image1":"http://localhost:8080/getImage/2.1.jpg","image2":"http://localhost:8080/getImage/2.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 12000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00027', N'OPPO A16', N'C02', N'B03',
        N'{"image3":"http://localhost:8080/getImage/3.3.jpg","image4":"http://localhost:8080/getImage/3.4.jpg","image1":"http://localhost:8080/getImage/3.1.jpg","image2":"http://localhost:8080/getImage/3.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 6990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00028', N'Iphone 13 Mini', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/4.3.jpg","image4":"http://localhost:8080/getImage/4.4.jpg","image1":"http://localhost:8080/getImage/4.1.jpg","image2":"http://localhost:8080/getImage/4.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256 GB', N'18', N'180', N'IOS', N'5.6', N'Snapdragon',
        N'5000mAh', N'188g', N'', N'', 25990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00029', N'Iphone 12 Promax', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/5.3.jpg","image4":"http://localhost:8080/getImage/5.4.jpg","image1":"http://localhost:8080/getImage/5.1.jpg","image2":"http://localhost:8080/getImage/5.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256 GB', N'18', N'180', N'IOS', N'5.6', N'Snapdragon',
        N'5000mAh', N'188g', N'', N'', 20990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00030', N'Iphone 11 Promax', N'C02', N'B02',
        N'{"image3":"http://localhost:8080/getImage/6.3.jpg","image4":"http://localhost:8080/getImage/6.4.jpg","image1":"http://localhost:8080/getImage/6.1.jpg","image2":"http://localhost:8080/getImage/6.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 6, N'128 GB', N'18', N'180', N'IOS', N'5.6', N'Snapdragon',
        N'5000mAh', N'188g', N'', N'', 11990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00031', N'Samsung Galaxy A52s', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/7.3.jpg","image4":"http://localhost:8080/getImage/7.4.jpg","image1":"http://localhost:8080/getImage/7.1.jpg","image2":"http://localhost:8080/getImage/7.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 6, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 10000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00032', N'Samsung Galaxy S22', N'C02', N'B01',
        N'{"image3":"http://localhost:8080/getImage/8.3.jpg","image4":"http://localhost:8080/getImage/8.4.jpg","image1":"http://localhost:8080/getImage/8.1.jpg","image2":"http://localhost:8080/getImage/8.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 25990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00033', N'Xiaomi Redmi Note 11S series', N'C02', N'B07',
        N'{"image3":"http://localhost:8080/getImage/9.3.jpg","image4":"http://localhost:8080/getImage/9.4.jpg","image1":"http://localhost:8080/getImage/9.1.jpg","image2":"http://localhost:8080/getImage/9.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 9, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 1000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00034', N'Xiaomi Redmi Note 11 Series', N'C02', N'B07',
        N'{"image3":"http://localhost:8080/getImage/10.3.jpg","image4":"http://localhost:8080/getImage/10.4.jpg","image1":"http://localhost:8080/getImage/10.1.jpg","image2":"http://localhost:8080/getImage/10.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 4, N'128 GB', N'18', N'180', N'Android', N'5.6',
        N'Snapdragon', N'5000mAh', N'188g', N'', N'', 500000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00036', N'Asus Gaming ROG Flow Z13 GZ301Z', N'C01', N'B05',
        N'{"image3":"http://localhost:8080/getImage/12.3.jpg","image4":"http://localhost:8080/getImage/12.4.jpg","image1":"http://localhost:8080/getImage/12.1.jpg","image2":"http://localhost:8080/getImage/12.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 16, N' 1 TB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 25990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00037', N'MSI Gaming GS66 Stealth 11UG i7 11800H (219VN)', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/13.3.jpg","image4":"http://localhost:8080/getImage/13.4.jpg","image1":"http://localhost:8080/getImage/13.1.jpg","image2":"http://localhost:8080/getImage/13.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 16, N' 1 TB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 30000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00038', N'Lenovo Gaming Legion 5 15ITH6', N'C01', N'B08',
        N'{"image3":"http://localhost:8080/getImage/14.3.jpg","image4":"http://localhost:8080/getImage/14.4.jpg","image1":"http://localhost:8080/getImage/14.1.jpg","image2":"http://localhost:8080/getImage/14.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'512 GB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 25990000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00039', N'MSI Gaming GS66 Stealth 11UG', N'C01', N'B06',
        N'{"image3":"http://localhost:8080/getImage/15.3.jpg","image4":"http://localhost:8080/getImage/15.4.jpg","image1":"http://localhost:8080/getImage/15.1.jpg","image2":"http://localhost:8080/getImage/15.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 16, N' 1 TB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 30000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00041', N'Lenovo IdeaPad Gaming 3 15IHU6', N'C01', N'B08',
        N'{"image3":"http://localhost:8080/getImage/17.3.jpg","image4":"http://localhost:8080/getImage/17.4.jpg","image1":"http://localhost:8080/getImage/17.1.jpg","image2":"http://localhost:8080/getImage/17.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256 GB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 22000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00042', N'Asus TUF Gaming FX506LH ', N'C01', N'B05',
        N'{"image3":"http://localhost:8080/getImage/18.3.jpg","image4":"http://localhost:8080/getImage/18.4.jpg","image1":"http://localhost:8080/getImage/18.1.jpg","image2":"http://localhost:8080/getImage/18.2.jpg"}',
        100, CAST(N'2022-05-19T07:00:00.000' AS DateTime), 8, N'256 GB', N'', N'', N'Windown', N'55.6',
        N'Intel Core I7', N'20000mAh', N'2.5 kg', N'Nvidia', N'', 18000000)
GO
INSERT [dbo].[Products] ([ProductId], [Name], [CategoryId], [BrandId], [Image], [Quantity], [SaleDate], [RAM], [ROM],
                         [FrontCam], [BackCam], [OS], [Screen], [CPU], [Battery], [Weight], [VGA], [Description],
                         [Price])
VALUES (N'P00043', N'MacBook Pro 16 M1 Pro 2021/16 core-GPU', N'C01', N'B02',
        N'{"image3":"http://localhost:8080/getImage/20.3.jpg","image4":"http://localhost:8080/getImage/20.4.jpg","image1":"http://localhost:8080/getImage/20.1.jpg","image2":"http://localhost:8080/getImage/20.2.jpg"}',
        100, CAST(N'2022-05-19T00:00:00.000' AS DateTime), 16, N'512 GB', NULL, NULL, N'MacOS', N'55.6',
        N'Intel Core I7', N'20000mAh', N'1.3 kg', N'Nvidia', NULL, 62990000)
GO
INSERT [dbo].[Reviews] ([ReviewId], [Username], [ProductId], [Content], [Rate], [Time])
VALUES (N'R00001', N'nam', N'P00001', N'Sản phẩm tẹt zời', 5, CAST(N'2022-03-26T07:28:32.000' AS DateTime))
GO
INSERT [dbo].[Deliveries] ([DeliveryId], [Name], [Email], [PhoneNumber], [Location])
VALUES (N'D01', N'GiaoHanhNhanh', N'GHN@emai.com', N'0998877666', N'TP.HCM')
GO
INSERT [dbo].[Orders] ([OrderId], [Username], [Name], [Address], [PhoneNumber], [PurchaseDate], [TotalPrices],
                       [DeliveryId], [Status], [CouponId], [DiscountPrice])
VALUES (N'O00001', N'nam', N'Nam Thái Thành', N'Bến Tre Bến Tre Việt Nam', N'0981771024',
        CAST(N'2022-05-20T08:52:16.800' AS DateTime), 10390000, N'D01', N'preparing', NULL, 0)
GO
INSERT [dbo].[OrderDetails] ([OrderId], [ProductId], [Quantity], [Price], [TotalPrice])
VALUES (N'O00001', N'P00002', 1, 10390000, 10390000)
GO

