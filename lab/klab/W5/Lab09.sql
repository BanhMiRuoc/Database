CREATE DATABASE QLNS
GO
USE QLNS
-- Bảng Nhóm Sách
CREATE TABLE NhomSach (
    MaNhom CHAR(5) PRIMARY KEY,
    TenNhom NVARCHAR(25) NOT NULL
);

-- Bảng Nhân Viên
CREATE TABLE NhanVien (
    MaNV CHAR(5) PRIMARY KEY,
    HoLot NVARCHAR(25) NOT NULL,
    TenNV NVARCHAR(10) NOT NULL,
    Phai NVARCHAR(3),
    NgaySinh SMALLDATETIME,
    DiaChi NVARCHAR(40)
);

-- Bảng Danh Mục Sách
CREATE TABLE DanhMucSach (
    MaSach CHAR(5) PRIMARY KEY,
    TenSach NVARCHAR(40) NOT NULL,
    TacGia NVARCHAR(20),
    MaNhom CHAR(5),
    DonGia NUMERIC(5, 2),
    SLTon NUMERIC(5),
    FOREIGN KEY (MaNhom) REFERENCES NhomSach(MaNhom)
);

-- Bảng Hóa Đơn
CREATE TABLE HoaDon (
    MaHD CHAR(5) PRIMARY KEY,
    NgayBan SMALLDATETIME,
    MaNV CHAR(5),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Chi Tiết Hóa Đơn
CREATE TABLE ChiTietHoaDon (
    MaHD CHAR(5),
    MaSach CHAR(5),
    SoLuong NUMERIC(5),
    PRIMARY KEY (MaHD, MaSach),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    FOREIGN KEY (MaSach) REFERENCES DanhMucSach(MaSach)
);
1/
CREATE TRIGGER Trg_Insert_NhomSach
ON NHOMSACH
AFTER INSERT
AS
BEGIN
    DECLARE @RowCount INT
    SELECT @RowCount = COUNT(*) FROM inserted

    IF @RowCount > 0
    BEGIN
        PRINT 'Có ' + CAST(@RowCount AS NVARCHAR(5)) + ' mẫu tin được chèn'
    END
END;
2/
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HOADON_Luu')
BEGIN
    CREATE TABLE HOADON_Luu
    (
        MaHD char(5) PRIMARY KEY,
        NgayBan SmallDatetime,
        MaNV char(5),
        FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
    );
END
GO
CREATE TRIGGER Trg_Insert_HoaDon
ON HOADON
AFTER INSERT
AS
BEGIN
    -- Chèn mẫu tin vào bảng HOADON_Luu
    INSERT INTO HOADON_Luu (MaHD, NgayBan, MaNV)
    SELECT MaHD, NgayBan, MaNV
    FROM inserted;
END;
3/
-- Bổ sung cột TongTriGia vào bảng HOADON nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'HOADON' AND COLUMN_NAME = 'TongTriGia')
BEGIN
    ALTER TABLE HOADON
    ADD TongTriGia Numeric(10, 2) NULL;
END
GO

-- Tạo trigger cho thao tác INSERT, UPDATE, DELETE trên bảng CHITIETHOADON
CREATE TRIGGER Trg_ChiTietHoaDon_InsertUpdateDelete
ON CHITIETHOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) > 0 OR (SELECT COUNT(*) FROM deleted) > 0
    BEGIN
        -- Cập nhật lại cột TongTriGia trong bảng HOADON
        UPDATE HOADON
        SET TongTriGia = (
            SELECT SUM(SoLuong * DonGia)
            FROM CHITIETHOADON
            WHERE CHITIETHOADON.MaHD = HOADON.MaHD
        )
        WHERE HOADON.MaHD IN (SELECT MaHD FROM inserted UNION SELECT MaHD FROM deleted);
    END
END;
4/
CREATE TRIGGER Trg_ChiTietHoaDon_InsertUpdate
ON CHITIETHOADON
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra ràng buộc liên thuộc tính liên quan
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN DANHMUCSACH d ON i.MaSach = d.MaSach
        WHERE i.GiaBan <> d.DonGia
    )
    BEGIN
        RAISERROR('Ràng buộc liên thuộc tính liên quan GIABAN và DONGIA không được đáp ứng.', 16, 1)
        ROLLBACK;
    END
END;
5/
CREATE TRIGGER Trg_HoaDon_NgayBan
ON HOADON
BEFORE INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.NgayBan < i.NgayLapHoaDon
    )
    BEGIN
        RAISERROR('Ngày bán phải lớn hơn hoặc bằng ngày lập hóa đơn.', 16, 1)
        ROLLBACK;
    END
END;
Bài tập 2
-- Bảng Độc Giả
CREATE TABLE DocGia (
    ma_DocGia INT PRIMARY KEY,
    ho NVARCHAR(50),
    tenlot NVARCHAR(50),
    ten NVARCHAR(50),
    ngaysinh DATE
);

-- Bảng Người Lớn (độc giả người lớn)
CREATE TABLE Nguoilon (
    ma_DocGia INT PRIMARY KEY,
    sonha NVARCHAR(50),
    duong NVARCHAR(50),
    quan NVARCHAR(50),
    dienthoai NVARCHAR(15),
    han_sd DATE,
    FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia)
);

-- Bảng Trẻ Em (độc giả trẻ em)
CREATE TABLE Treem (
    ma_DocGia INT PRIMARY KEY,
    ma_DocGia_nguoilon INT,
    FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia),
    FOREIGN KEY (ma_DocGia_nguoilon) REFERENCES Nguoilon(ma_DocGia)
);

-- Bảng Tựa Sách
CREATE TABLE Tuasach (
    ma_tuasach INT PRIMARY KEY,
    tuasach NVARCHAR(100),
    tacgia NVARCHAR(100),
    tomtat NVARCHAR(MAX)
);

-- Bảng Đầu Sách
CREATE TABLE Dausach (
    isbn CHAR(13) PRIMARY KEY,
    ma_tuasach INT,
    ngonngu NVARCHAR(50),
    bia NVARCHAR(50),
    trangthai NVARCHAR(50),
    FOREIGN KEY (ma_tuasach) REFERENCES Tuasach(ma_tuasach)
);

-- Bảng Cuốn Sách
CREATE TABLE Cuonsach (
    isbn CHAR(13),
    ma_cuonsach CHAR(10),
    tinhtrang NVARCHAR(50),
    PRIMARY KEY (isbn, ma_cuonsach),
    FOREIGN KEY (isbn) REFERENCES Dausach(isbn)
);
1/
-- Trigger 1: tg_delMuon
CREATE TRIGGER tg_delMuon
AFTER DELETE ON MuonSach -- Giả sử có một bảng MuonSach chứa thông tin mượn sách
FOR EACH ROW
BEGIN
    UPDATE Cuonsach
    SET tinhtrang = 'yes'
    WHERE ma_cuonsach = OLD.ma_cuonsach;
END;
2/
-- Trigger 2: tg_insMuon
CREATE TRIGGER tg_insMuon
AFTER INSERT ON MuonSach -- Giả sử có một bảng MuonSach chứa thông tin mượn sách
FOR EACH ROW
BEGIN
    UPDATE Cuonsach
    SET tinhtrang = 'no'
    WHERE ma_cuonsach = NEW.ma_cuonsach;
END;
3/
-- Trigger 3: tg_updCuonSach
CREATE TRIGGER tg_updCuonSach
AFTER UPDATE ON Cuonsach
FOR EACH ROW
BEGIN
    DECLARE ds_tinhtrang VARCHAR(10);
    
    -- Lấy trạng thái của cuốn sách được cập nhật
    SELECT tinhtrang INTO ds_tinhtrang
    FROM Cuonsach
    WHERE ma_cuonsach = NEW.ma_cuonsach;
    
    -- Cập nhật trạng thái của đầu sách
    UPDATE Dausach
    SET trangthai = ds_tinhtrang
    WHERE isbn = (SELECT isbn FROM Cuonsach WHERE ma_cuonsach = NEW.ma_cuonsach);
END;
4/
-- Trigger 4: tg_InfThongBao
CREATE TRIGGER tg_InfThongBao
AFTER INSERT, UPDATE ON Tuasach
FOR EACH ROW
BEGIN
    DECLARE thongbao VARCHAR(255);
    
    -- Kiểm tra loại hành động (Thêm mới hoặc Sửa)
    IF (INSERTING) THEN
        SET thongbao = 'Đã thêm mới tựa sách';
    ELSE
        SET thongbao = 'Đã sửa thông tin tựa sách';
    END IF;
    
    -- In ra thông báo bằng Tiếng Việt
    PRINT thongbao;
END;
5/
-- Trigger: tg_SuaSach
CREATE TRIGGER tg_SuaSach
AFTER UPDATE ON Tuasach
FOR EACH ROW
BEGIN
    DECLARE ma_tuasach_cu VARCHAR(10);
    DECLARE ma_tuasach_moi VARCHAR(10);
    DECLARE ten_tacgia_cu VARCHAR(255);
    DECLARE ten_tacgia_moi VARCHAR(255);

    -- Lấy thông tin cũ từ bảng Deleted
    SELECT ma_tuasach, tacgia INTO ma_tuasach_cu, ten_tacgia_cu
    FROM Deleted
    WHERE ma_tuasach = NEW.ma_tuasach;

    -- Lấy thông tin mới từ bảng Inserted
    SELECT ma_tuasach, tacgia INTO ma_tuasach_moi, ten_tacgia_moi
    FROM Inserted
    WHERE ma_tuasach = NEW.ma_tuasach;

    -- In ra danh sách mã tựa sách vừa được sửa
    PRINT 'Danh sách mã tựa sách vừa được sửa:';
    PRINT ma_tuasach_cu;

    -- In ra danh sách mã tựa sách vừa được sửa và tên tác giả mới
    PRINT 'Danh sách mã tựa sách vừa được sửa và tên tác giả mới:';
    PRINT ma_tuasach_moi + ', ' + ten_tacgia_moi;

    -- In ra danh sách mã tựa sách vừa được sửa và tên tác giả cũ
    PRINT 'Danh sách mã tựa sách vừa được sửa và tên tác giả cũ:';
    PRINT ma_tuasach_cu + ', ' + ten_tacgia_cu;

    -- In ra danh sách mã tựa sách vừa được sửa cùng tên tác giả cũ và tác giả mới
    PRINT 'Danh sách mã tựa sách vừa được sửa cùng tên tác giả cũ và tác giả mới:';
    PRINT ma_tuasach_cu + ', ' + ten_tacgia_cu + ' -> ' + ma_tuasach_moi + ', ' + ten_tacgia_moi;
END;
6/
-- Trigger: tg_KiemTraTrung
CREATE TRIGGER tg_KiemTraTrung
BEFORE INSERT ON Tuasach
FOR EACH ROW
BEGIN
    DECLARE count_duplicate INT;

    -- Kiểm tra xem có tựa sách trùng tên không
    SELECT COUNT(*) INTO count_duplicate
    FROM Tuasach
    WHERE tuasach = NEW.tuasach;

    -- Trường hợp xử lý 1: chỉ thông báo và cho phép insert
    IF (count_duplicate = 0) THEN
        PRINT 'Không có tựa sách trùng tên. Đã thêm mới tựa sách.';
    ELSE
        -- Trường hợp xử lý 2: thông báo và không cho insert
        PRINT 'Tựa sách trùng tên đã tồn tại. Không thể thêm mới.';
        ROLLBACK; -- Hủy thêm mới
    END IF;
END;

