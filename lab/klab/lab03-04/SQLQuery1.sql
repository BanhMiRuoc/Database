CREATE DATABASE Lab3_4
GO
USE Lab3_4
GO

SET DATEFORMAT mdy

CREATE TABLE PHONG
(
	maPhong CHAR(3) not null,
	tenPhong NVARCHAR(40),
	diaChi NVARCHAR(50),
	tel CHAR(10),
	PRIMARY KEY(maPhong)
)

CREATE TABLE DMNN
(
	maNN CHAR(2) not null,
	tenNN NVARCHAR(20),
	PRIMARY KEY(maNN)
)


CREATE TABLE NHANVIEN 
(
	maNV CHAR(5) not null,
	hoTen NVARCHAR(40),
	gioiTinh CHAR(3),
	ngaySinh DATETIME,
	luong INT,
	maPhong CHAR(3),
	sdt CHAR(10),
	ngayBC DATETIME,
	PRIMARY KEY(maNV),
	CONSTRAINT fk_nv_maPhong FOREIGN KEY(maPhong) REFERENCES PHONG(maPhong)

)	

CREATE TABLE TDNN 
(
	maNV CHAR(5) not null,
	maNN CHAR(2) not null,
	tDo CHAR(1),
	PRIMARY KEY(maNV, maNN),
	CONSTRAINT fk_tdnn_maNV FOREIGN KEY(maNV) REFERENCES NHANVIEN(maNV),
	CONSTRAINT fk_tdnn_maNN FOREIGN KEY(maNN) REFERENCES DMNN(maNN),

)

INSERT INTO PHONG VALUES 
	('HCA', N'Hành chính tổ hợp', N'123 Láng Hạ, Đống Đa, Hà Nội', '04 8585793'),
	('KDA', N'Kinh Doanh', N'123 Láng Hạ, Đống Đa, Hà Nội', '04 8574943'),
	('KTA', N'Kỹ thuật', N'123 Láng Hạ, Đống Đa, Hà Nội', '04 9480485'),
	('QTA', N'Quản trị', N'123 Láng Hạ, Đống Đa, Hà Nội', '04 8508585')

INSERT INTO DMNN VALUES
	('01', N'Anh'),
	('02', N'Nga'),
	('03', N'Pháp'),
	('04', N'Nhật'),
	('05', N'Trung Quốc'),
	('06', N'Hàn Quốc')

INSERT INTO NHANVIEN VALUES
	('HC001', N'Nguyễn Thị Hà', 'Nữ', '8/27/1950', 2500000, 'HCA', '', '2/8/1975'),
	('HC002', N'Trần Văn Nam', 'Nam', '6/12/1975', 3000000, 'HCA', '',  '6/8/1997') ,
	('HC003', N'Nguyễn Thanh Huyền', 'Nữ', '7/3/1978', 1500000, 'HCA', '',  '9/24/1999') ,
	('KD001', N'Lê Tuyết Anh', 'Nữ', '2/3/1977', 2500000, 'KDA', '', '10/2/2001') ,
	('KD002', N'Nguyễn Anh Tú', 'Nam', '7/4/1942', 2600000, 'KDA', '',  '9/24/1999') ,
	('KD003', N'Phạm An Thái', 'Nam', '5/9/1977', 1600000, 'KDA', '',  '9/24/1999') ,
	('KD004', N'Lê Văn Hải', 'Nam', '1/2/1976', 2700000, 'KDA',  '', '6/8/1997'),
	('KD005', N'Nguyễn Phương Minh', 'Nam', '1/2/1980', '2000000', 'KDA', '', '10/2/2001') ,
	('KT001', N'Trần Đình Khâm', 'Nam', '12/2/1981', 2700000, 'KTA', '', '1/1/2005') ,
	('KT002', N'Nguyễn Mạnh Hùng', 'Nam', '8/16/1980', 2300000, 'KTA', '', '1/1/2005') ,
	('KT003', N'Phạm Thanh Sơn', 'Nam', '8/20/1984', 2000000, 'KTA', '', '1/1/2005') ,
	('KT004', N'Vũ Thị Hoài', 'Nữ', '12/5/1980', 2500000, 'KTA', '',  '10/2/2001'),
	('KT005', N'Nguyễn Thu Lan', 'Nữ', '10/5/1977', 3000000, 'KTA', '', '10/2/2001') ,
	('KT006', N'Trần Hoài Nam', 'Nam', '7/2/1978', 2800000, 'KTA', '', '6/8/1997') ,
	('KT007', N'Hoàng Nam Sơn', 'Nam', '12/3/1940', 3000000, 'KTA', '', '7/2/1965') ,
	('KT008', N'Lê Thu Trang', 'Nữ', '7/6/1950', 2500000, 'KTA', '', '8/2/1968') ,
	('KT009', N'Khúc Nam Hải', 'Nam', '7/22/1980', 2000000, 'KTA', '', '1/1/2005') ,
	('KT010', N'Phùng Trung Dũng', 'Nam', '8/28/1978', 2200000, 'KTA', '', '9/24/1999')

INSERT INTO TDNN VALUES
	('HC001', '01', 'A'),
	('KD004', '05', 'A'),
	('HC001', '02', 'B'),
	('KD005', '01', 'B'),
	('HC002', '01', 'C'), 
	('KD005', '02', 'D'),
	('HC002', '03', 'C'),
	('KD005', '03', 'B'),
	('HC003', '01', 'D'),
	('KD005', '04', 'B'),
	('KD001', '01', 'C'), 
	('KT001', '01', 'D'),
	('KD001', '02', 'B'), 
	('KT001', '04', 'E'),
	('KD002', '01', 'D'), 
	('KT002', '01', 'C'),
	('KD002', '02', 'A'),
	('KT002', '02', 'B'),
	('KD003', '01', 'B'), 
	('KT003', '01', 'D'),
	('KD003', '02', 'C'), 
	('KT003', '03', 'C'),
	('KD004', '01', 'C'), 
	('KT004', '01', 'D'),
	('KD004', '04', 'A'), 
	('KT005', '01', 'C')

INSERT INTO NHANVIEN VALUES
	('QT001', N'Mai Nguyễn Phương Trang', 'Nữ', '18/02/2004', 150000, 'QTA', '', '9/24/1999')

INSERT INTO TDNN values
	('QT001', '04', 'A'), 
	('QT001', '01', 'C')

SELECT *
FROM NHANVIEN nv, TDNN tdnn
WHERE nv.maNV = tdnn.maNV and nv.maNV = 'QT001'

--4.1
SELECT * 
FROM NHANVIEN nv, TDNN tdnn
WHERE nv.maNV = tdnn.maNV and nv.maNV = 'KT001'

--4.2
ALTER TABLE NHANVIEN
ALTER COLUMN hoTen NVARCHAR(40)
ALTER TABLE NHANVIEN
ALTER COLUMN gioiTinh NVARCHAR(3)

--4.3
SELECT * 
FROM NHANVIEN
WHERE gioiTinh = 'Nữ'

--4.4
SELECT * 
FROM NHANVIEN
WHERE hoTen like N'Nguyễn%'

--4.5
SELECT *
FROM NHANVIEN
WHERE hoTen like N'%Văn%'

--4.6
SELECT *, year(getDate()) - year(ngaySinh) as N'Tuổi'
FROM NHANVIEN
WHERE year(getDate()) - year(ngaySinh) < 30

--4.7
SELECT *, year(getDate()) - year(ngaySinh) as N'Tuổi'
FROM NHANVIEN
WHERE year(getDate()) - year(ngaySinh) >= 25 and year(getDate()) - year(ngaySinh) <= 30

--4.8
SELECT maNV
FROM TDNN
WHERE tDo >= 'C'

--4.9
SELECT*
FROM NHANVIEN
WHERE year(ngayBC) < 2000

--4.10
SELECT* 
FROM NHANVIEN
WHERE year(getDate()) - year(ngayBC) > 10

--4.11
SELECT* 
FROM NHANVIEN
WHERE (gioiTinh = 'Nam' and year(getDate()) - year(ngaySinh) >= 60) or (gioiTinh = 'Nữ' and year(getDate()) - year(ngaySinh) >= 55)

--4.12
SELECT maPhong, tenPhong, tel
FROM PHONG

--4.13
SELECT TOP(2) hoTen, ngaySinh, ngayBC
FROM NHANVIEN

--4.14
SELECT maNV, hoTen, luong
FROM NHANVIEN
WHERE luong >= 2000000 and luong <= 3000000

--4.15
SELECT *
FROM NHANVIEN
WHERE sdt = ''

--4.16
SELECT *
FROM NHANVIEN
WHERE month(ngaySinh) = 3

--4.17
SELECT *
FROM NHANVIEN
ORDER BY luong ASC

--4.18
SELECT 'TB luong phong KD' =  avg(luong) 
FROM NHANVIEN 
WHERE maPhong = 'KDA'

--4.19
SELECT 'SL nhan vien phong KD' = count(maNV), 'TB luong phong KD' =  avg(luong) 
FROM NHANVIEN
WHERE maPhong = 'KDA'


--4.20
SELECT p.tenPhong, tongLuong = SUM(nv.luong)
FROM PHONG p
inner join NHANVIEN nv ON p.maPhong = nv.maPhong
GROUP BY p.tenPhong, p.maPhong
ORDER BY tongLuong

--4.21
SELECT p.tenPhong, 'Luong' = SUM(nv.luong)
FROM PHONG p
inner join NHANVIEN nv ON p.maPhong = nv.maPhong --join 2 bảng lại
GROUP BY p.tenPhong, nv.maPhong
HAVING SUM(nv.luong) > 5000000 --having là set điều kiện tiên quyết
ORDER BY SUM(nv.luong)

--4.22
SELECT nv.maNV, nv.hoTen, p.maPhong, p.tenPhong
FROM PHONG p, NHANVIEN nv
WHERE nv.maPhong = p.maPhong

--4.23
SELECT *
FROM NHANVIEN nv left join PHONG p ON nv.maPhong = p.maPhong

--4.24
SELECT *
FROM PHONG p left join NHANVIEN nv ON nv.maPhong = p.maPhong