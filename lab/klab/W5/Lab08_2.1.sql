CREATE DATABASE QLCHNGK
GO
USE QLCHNGK
-- Bảng Nhà Sản Xuất (NSX)
CREATE TABLE NSX (
    maNSX INT PRIMARY KEY,
    tenNSX VARCHAR(255) NOT NULL
);

-- Bảng Nguyên Liệu, Giai Khát (NGK)
CREATE TABLE NGK (
    MaNGK INT PRIMARY KEY,
    TenNGK VARCHAR(255) NOT NULL,
    DVT VARCHAR(50), -- Đơn vị tính
    soluong INT,
    dongia DECIMAL(10, 2),
    Maloai INT,
    FOREIGN KEY (Maloai) REFERENCES NSX(maNSX)
);

-- Bảng Hóa Đơn (Hoadon)
CREATE TABLE Hoadon (
    sohd INT PRIMARY KEY,
    ngaylap DATE
);

-- Bảng Chi Tiết Hóa Đơn (CTHD)
CREATE TABLE CTHD (
    sohd INT,
    MaNGK INT,
    soluong INT,
    dongia DECIMAL(10, 2),
    PRIMARY KEY (sohd, MaNGK),
    FOREIGN KEY (sohd) REFERENCES Hoadon(sohd),
    FOREIGN KEY (MaNGK) REFERENCES NGK(MaNGK)
);
a/
CREATE FUNCTION fn_phatsinhsohd()
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @ngaylap DATE;
    DECLARE @sothutu INT;

    SET @ngaylap = GETDATE();

    SELECT @sothutu = MAX(sohd) + 1
    FROM Hoadon
    WHERE ngaylap = @ngaylap;

    RETURN CONCAT(@ngaylap, RIGHT('000' + CAST(@sothutu AS VARCHAR(3)), 3));
END;
b/
CREATE FUNCTION fn_themhoadon()
RETURNS INT
AS
BEGIN
    DECLARE @sohd VARCHAR(10);
    DECLARE @ngaylap DATE;

    SET @ngaylap = GETDATE();
    SET @sohd = fn_phatsinhsohd();

    INSERT INTO Hoadon (sohd, ngaylap)
    VALUES (@sohd, @ngaylap);

    RETURN @@IDENTITY;
END;
c/
CREATE FUNCTION fn_themNGK()
RETURNS INT
AS
BEGIN
    DECLARE @maNSX VARCHAR(5);
    DECLARE @tenNGK VARCHAR(50);
    DECLARE @dvt VARCHAR(5);
    DECLARE @soluong INT;
    DECLARE @dongia DECIMAL(10, 2);
    DECLARE @maloai VARCHAR(5);
    DECLARE @sohd INT;

    DECLARE @maNGK VARCHAR(10);
    DECLARE @sothutu INT;

    SET @maNSX = 'COCA';
    SET @tenNGK = 'Coca Cola';
    SET @dvt = 'chai';
    SET @soluong = 12;
    SET @dongia = 10000;
    SET @maloai = 'Nước ngọt';

    SET @sohd = fn_phatsinhsohd();

    SELECT @sothutu = MAX(MaNGK) + 1
    FROM NGK
    WHERE MaNSX = @maNSX AND Maloai = @maloai;

    SET @maNGK = CONCAT(@maNSX, RIGHT('000' + CAST(@sothutu AS VARCHAR(3)), 3));

    INSERT INTO NGK (MaNGK, TenNGK, DVT, Soluong, Dongia, Maloai)
    VALUES (@maNGK, @tenNGK, @dvt, @soluong, @dongia, @maloai);

    RETURN @@IDENTITY;
END;
d/
CREATE FUNCTION fn_themCTHD(
    @sohd INT,
    @maNGK VARCHAR(10),
    @soluong INT
)
RETURNS INT
AS
BEGIN
    DECLARE @maNSX VARCHAR(5);
    DECLARE @tenNGK VARCHAR(50);
    DECLARE @dvt VARCHAR(5);
    DECLARE @dongia DECIMAL(10, 2);
    DECLARE @maloai VARCHAR(5);

    DECLARE @soLuongNGK INT;

    SELECT @maNSX, @tenNGK, @dvt, @dongia, @maloai, @soLuongNGK
    FROM NGK
    WHERE MaNGK = @maNGK;

    IF @soluong > @soLuongNGK
        RETURN -1;

    INSERT INTO CTHD (sohd, MaNGK, Soluong)
    VALUES (@sohd, @maNGK, @soluong);

    RETURN @@IDENTITY;
END;
e/
CREATE FUNCTION fn_tongtienhoadon(
    @sohd INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @tongtien DECIMAL(10, 2);

    SELECT @tongtien = SUM(soluong * dongia)
    FROM CTHD
    WHERE sohd = @sohd;

    RETURN @tongtien;
END;
f/
CREATE FUNCTION fn_NGKban3thang2016()
RETURNS TABLE
AS
RETURN
(
    SELECT
        MaNGK,
        TenNGK,
        DVT,
        Soluong,
        Dongia,
        Maloai
    FROM NGK
    INNER JOIN CTHD
    ON NGK.MaNGK = CTHD.MaNGK
    WHERE ngaylap BETWEEN '2016/03/01' AND '2016/03/31'
);

