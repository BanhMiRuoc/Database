CREATE DATABASE QLWS
GO
SET DATEFORMAT DMY
-- tao bang khach hang
CREATE TABLE KhachHang (
  maKH CHAR(10) NOT NULL,
  hoTen NVARCHAR(255) NOT NULL,
  ngaySinh DATE NOT NULL,
  gioiTinh NVARCHAR(5) NOT NULL,
  SDT CHAR(10) NOT NULL,
  diaChi NVARCHAR(255) NOT NULL,
  hang NVARCHAR(255),
  CONSTRAINT pk_maKHoKH PRIMARY KEY (maKH)
)
-- tao bang the thanh vien
CREATE TABLE TheThanhVien (
  maKH CHAR(10) NOT NULL PRIMARY KEY,
  diemTL INT,
  CONSTRAINT fk_maKHoTTV FOREIGN KEY (maKH) REFERENCES KhachHang(maKH)
)
-- tao bang hang cua the thanh vien
CREATE TABLE Hang (
  maKH CHAR(10) PRIMARY KEY,
  bac NVARCHAR(10),
  quyenLoi INT,
  diemTL INT,
  CONSTRAINT fk_maKHoHang FOREIGN KEY (maKH) REFERENCES TheThanhVien(maKH)
)
-- tao bang cua hang
CREATE TABLE CuaHang (
  maCH CHAR(10) NOT NULL,
  tenCH NVARCHAR(255) NOT NULL,
  diaChi NVARCHAR(255) NOT NULL,
  phiGiaoHang int,
  CONSTRAINT pk_maCHoCH PRIMARY KEY (maCH)
)
-- tao bang san pham
CREATE TABLE SanPham (
  maSP CHAR(10) NOT NULL,
  tenSP NVARCHAR(255) NOT NULL,
  loaiSP NVARCHAR(255) NOT NULL,
  mauSac NVARCHAR(10),
  kichCo VARCHAR(10),
  donGia INT NOT NULL,
  maCH CHAR(10),
  CONSTRAINT pk_maSPoSP PRIMARY KEY (maSP),
  CONSTRAINT fk_maCHoSP FOREIGN KEY (maCH) REFERENCES CuaHang(maCH)
)
-- tao bang hoa don
CREATE TABLE HoaDon (
  maHD CHAR(10) NOT NULL,
  ngayTaoDon DATE NOT NULL,
  diaChiGiaoHang NVARCHAR(255) NOT NULL,
  phiGiaoHang INT NOT NULL,
  tongTien INT NOT NULL,
  soLuong INT NOT NULL,
  maKH CHAR(10) NOT NULL,
  maCH CHAR(10) NOT NULL,
  diem INT,
  khuyenMai INT,
  CONSTRAINT pk_maHDoHD PRIMARY KEY (maHD),
  CONSTRAINT fk_maKHoHD FOREIGN KEY (maKH) REFERENCES khachHang (maKH),
  CONSTRAINT fk_maCHoHD FOREIGN KEY (maCH) REFERENCES CuaHang (maCH)
)
-- tao bang chi tiet hoa don
CREATE TABLE ChiTietHoaDon (
  maHD CHAR(10) NOT NULL,
  maSP CHAR(10) NOT NULL,
  soLuong INT NOT NULL,
  tenSP NVARCHAR(255) NOT NULL,
  donGia INT NOT NULL,
  kichCo VARCHAR(10),
  mauSac NVARCHAR(10),
  thanhTien INT NOT NULL,
  PRIMARY KEY (maHD, maSP),
  CONSTRAINT pk_maHDoCTHD FOREIGN KEY (maHD) REFERENCES HoaDon (maHD),
  CONSTRAINT pl_maSPoCTHD FOREIGN KEY (maSP) REFERENCES SanPham (maSP)
)
--tao ham them du lieu cho bang khach hang
CREATE FUNCTION themKhachHang()
RETURNS CHAR(10)
AS
BEGIN
  DECLARE @maKH CHAR(10)
  DECLARE @maxMaKH CHAR(10);

  SELECT @maxMaKH = MAX(maKH) FROM KhachHang

  IF @maxMaKH IS NULL
  BEGIN
    SET @maKH = 'KH1';
  END
  ELSE
  BEGIN
    DECLARE @nextID INT = CAST(RIGHT(@maxMaKH, 8) AS INT) + 1;
    SET @maKH = 'KH' + RIGHT('00000000' + CAST(@nextID AS CHAR(8)), 8);
  END
  RETURN @maKH
END
-- tao thu tuc de them du lieu vao bang
CREATE PROC themKH (@hoTen NVARCHAR(255), @ngaySinh DATE, @gioiTinh NVARCHAR(5), @SDT CHAR(10), @diaChi NVARCHAR(255), @hang NVARCHAR(255))
AS
BEGIN
	DECLARE @maKH CHAR(10) = dbo.themKhachHang();
	INSERT INTO KhachHang VALUES(@maKH, @hoTen, @ngaySinh, @gioiTinh, @SDT, @diaChi, @hang)
END
-- goi thu tuc va them du lieu
EXEC themKH N'Mai Trang', '18/02/2004', N'Nữ', '0123456789', 'TP.HCM', N'Vàng'
EXEC themKH N'Võ Luyện', '25/12/2003', N'Nam', '0123456789', 'Ninh Thuận', N'Bạc'
EXEC themKH N'Nguyễn Vũ Gia Phương', '27/04/2004', N'Nam', '0123456789', N'Bình Thuận', N'Bạch Kim'
EXEC themKH N'Nguyễn Thanh Sơn', '27/07/2004', N'Nam', '0123456789', 'Long An', N'Bạch Kim'
EXEC themKH N'Nguyễn Hoàng Khoa', '27/05/2003', N'Nam', '0123456789', 'Long An', N'Bạch Kim'
-- tao ham them du lieu vao bang cua hang
CREATE FUNCTION themCuaHang()
RETURNS CHAR(10)
AS
BEGIN
  DECLARE @maCH CHAR(10)
  DECLARE @maxMaCH CHAR(10);
  
  SELECT @maxMaCH = MAX(maCH) FROM CuaHang

  IF @maxMaCH IS NULL
  BEGIN
    SET @maCH = 'CH1';
  END
  ELSE
  BEGIN
    DECLARE @nextID INT = CAST(RIGHT(@maxMaCH, 8) AS INT) + 1;
    SET @maCH = 'CH' + RIGHT('00000000' + CAST(@nextID AS CHAR(8)), 8);
  END
  RETURN @maCH
END
-- tao thu tuc them du lieu vao bang cua hang
CREATE PROC themCH (@tenCH NVARCHAR(255), @diaChi NVARCHAR(255), @phiGiaoHang int)
AS
BEGIN
	DECLARE @maCH CHAR(10) = dbo.themCuaHang();
	INSERT INTO CuaHang VALUES(@maCH, @tenCH, @diaChi, @phiGiaoHang)
END
-- goi thu tuc va them du lieu
EXEC themCH N'POSER', 'TP.HCM', 15000
EXEC themCH N'FLOWER', N'Trà Vinh', 50000
EXEC themCH N'Cửa hàng sắc hoa', N'Ninh Bình', 30000
-- tao ham them du lieu vao bang san pham
CREATE FUNCTION themSanPham()
RETURNS CHAR(10)
AS
BEGIN
  DECLARE @maSP CHAR(10)
  DECLARE @maxMaSP CHAR(10);
  
  SELECT @maxMaSP = MAX(maSP) FROM SanPham

  IF @maxMaSP IS NULL
  BEGIN
    SET @maSP = 'SP1';
  END
  ELSE
  BEGIN
    DECLARE @nextID INT = CAST(RIGHT(@maxMaSP, 8) AS INT) + 1;
    SET @maSP = 'SP' + RIGHT('00000000' + CAST(@nextID AS CHAR(8)), 8);
  END
  RETURN @maSP
END
-- tao thu tuc de them du lieu vao bang san pham
CREATE PROC themSP (@tenSP NVARCHAR(255), @loaiSP NVARCHAR(255), @mauSac NVARCHAR(10), @kichCo VARCHAR(10), @giaBan int, @maCH CHAR(10))
AS
BEGIN
	DECLARE @maSP CHAR(10) = dbo.themSanPham();
	INSERT INTO SanPham VALUES(@maSP, @tenSP, @loaiSP, @mauSac, @kichCo, @giaBan, @maCH)
END
-- goi thu tuc va them du lieu
EXEC themSP N'Áo cánh dơi', N'Quần áo', N'Đỏ', 'L', 50000, 'CH1'
EXEC themSP N'Quần jean dài', N'Quần áo', N'Xanh', 'XL',15000, 'CH1' 
EXEC themSP N'Hoa tai ngôi sao', N'Phụ kiện', N'Vàng chanh', 'NA', 10000,'CH2'
EXEC themSP N'Nón tai mèo', N'Phụ kiện', N'Hồng', 'NA', 70000, 'CH1'
EXEC themSP N'Dép lê', N'Giày dép', N'Xanh biển', '38', 90000, 'CH2'
-- viet trigger kiem tra kich co cua san pham
CREATE TRIGGER kiemTraKichCo
ON SanPham
AFTER INSERT
AS
BEGIN
	DECLARE @type NVARCHAR(255)
	DECLARE @size NVARCHAR(10)

	SELECT @type = loaiSP, @size = kichCo
	FROM inserted

	IF @type = N'Quần áo'
	BEGIN
		IF @size NOT IN ('S', 'M', 'L', 'XL', 'XXL')
		BEGIN
			PRINT(N'Kích cỡ không phù hợp.')
			ROLLBACK TRANSACTION
		END
	END
	ELSE IF @type = N'Giày dép'
	BEGIN
		IF NOT ISNUMERIC(@size) = 1
		BEGIN
			PRINT(N'Kích cỡ không phù hợp.')
			ROLLBACK TRANSACTION
		END
	END
	ELSE IF @type = N'Phụ kiện'
	BEGIN
		IF @size != 'NA'
		BEGIN
			PRINT(N'Kích cỡ không phù hợp.')
			ROLLBACK TRANSACTION
		END
	END
	ELSE
	BEGIN
		PRINT(N'Sai loại sản phẩm.')
		ROLLBACK TRANSACTION
	END
END
-- tao trigger kiem tra phi giao hang cua cua hang
CREATE TRIGGER kiemTraPGH
ON CuaHang
AFTER INSERT
AS
BEGIN
    DECLARE @phiGH INT;

    SELECT @phiGH = phiGiaoHang FROM inserted
    IF @phiGH NOT IN (15000, 10000, 30000, 50000)
    BEGIN
        PRINT('Phí giao hàng không tồn tại. Phí giao hàng phải là một trong những giá trị sau: 15000, 10000, 30000, or 50000.')
        ROLLBACK TRANSACTION;
    END
END
-- nhap du lieu va kiem tra trigger phi gia hang
-- du lieu dung
EXEC themCH N'BanhMiRuoc', N'Vĩnh Long', 10000
EXEC themCH N'Baesad', N'Ninh Thuận', 50000
-- du lieu sai
EXEC themCH N'PinoPino', N'Bình Thuận', 35000
EXEC themCH N'Koha', N'Long An', 55000
-- nhap du lieu va kiem tra kich co cua san pham
-- du lieu dung
EXEC themSP N'Áo sơ mi', N'Quần áo', N'Đỏ', 'L', 50000
EXEC themSP N'Váy babydoll', N'Quần áo', N'Xanh', 'XL', 150000
-- du lieu sai
EXEC themSP N'Sandal', N'Giày dép', N'Hồng', 'NA', 70000
EXEC themSP N'Dây chuyền bạc', N'Phụ Kiện', N'Xanh biển', '38', 90000
EXEC themSP N'Sơn móng tay', N'Trang điểm', N'Xanh biển', '38', 90000