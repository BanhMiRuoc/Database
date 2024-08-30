--TAO COSODULIEU--

CREATE DATABASE QLNV
USE QLNV
SET DATEFORMAT mdy

--TAO BANG--

CREATE TABLE PHONG (
	maPhong char(3) primary key not null,
	tenPhong nvarchar(40),
	diaChi nvarchar(50),
	tel char(10)
)

CREATE TABLE DMNN (
	maNN char(2) primary key not null,
	tenNN nvarchar(20)
)

CREATE TABLE NHANVIEN (
	maNV char(5) primary key not null,
	hoTen varchar(40),
	gioiTinh char(3),
	ngaySinh date,
	luong int,
	maPhong char(3),
	sdt char(10),
	ngayBC date,
	constraint fk_nv_maPhong foreign key (maPhong) references PHONG(maPhong)
)

CREATE TABLE TDNN (
	maNV char(5) not null,
	maNN char(2) not null,
	tDO char(1),
	constraint pk_tdnn primary key (maNV, maNN),
	constraint fk_tdnn_maNV foreign key (maNV) references NHANVIEN(maNV),
	constraint fk_tdnn_maNN foreign key (maNN) references DMNN(maNN)
)

--THEM DU LIEU VAO CAC BANG--

INSERT INTO PHONG VALUES
('HCA','HANH CHINH TO HOP','123, LANG HA, DONG DA, HA NOI','048585793'),
('KDA','KINH DOANH','123, LANG HA, DONG DA, HA NOI','048574943'),
('KTA','KY THUAT','123, LANG HA, DONG DA, HA NOI','049480485'),
('QTA','QUAN TRI','123, LANG HA, DONG DA, HA NOI','048508585')

INSERT INTO DMNN VALUES
('01','ANH'),
('02','NGA'),
('03','PHAP'),
('04','NHAT'),
('05','TRUNG QUOC'),
('06','HAN QUOC')

INSERT INTO NHANVIEN VALUES

('HC001','NGUYEN THI HA','NU','8/27/1950',2500000,'HCA','','2/8/1975'),
('HC002','TRAN VAN NAM','NAM','6/12/1975',3000000,'HCA','','6/8/1997'),
('HC003','NGUYEN THANH HUYEN','NU','7/3/1978',1500000,'HCA','','9/24/1999'),
('KD001','LE TUYET ANH','NU','2/3/1977',2500000,'KDA','','10/2/2001'),
('KD002','NGUYEN ANH TU','NAM','7/4/1942',2600000,'KDA','','9/24/1999'),
('KD003','PHAM AN THAI','NAM','5/9/1977',1600000,'KDA','','9/24/1999'),
('KD004','LE VAN HAI','NAM','1/2/1976',2700000,'KDA','','6/8/1997'),
('KD005','NGUYEN PHUONG MINH','NAM','1/2/1980',2000000,'KDA','','10/2/2001'),
('KT001','TRAN DINH KHAM','NAM','12/2/1981',2700000,'KTA','','1/1/2005'),
('KT002','NGUYEN MANH HUNG','NAM','8/6/1980',2300000,'KTA','','1/1/2005'),
('KT003','PHAM THANH SON','NAM','8/20/1984',2000000,'KTA','','1/1/2005'),
('KT004','VU THI HOAI','NU','12/5/1980',2500000,'KTA','','10/2/2001'),
('KT005','NGUYEN THU LAN','NU','10/5/1977',3000000,'KTA','','10/2/2001'),
('KT006','TRAN HOAI NAM','NAM','7/2/1978',2800000,'KTA','','6/8/1997'),
('KT007','HOANG NAM SON','NAM','12/3/1940',3000000,'KTA','','7/2/1965'),
('KT008','LE THU TRANG','NU','7/5/1950',2500000,'KTA','','8/2/1968'),
('KT009','KHUC NAM HAI','NAM','7/22/1980',2000000,'KTA','','1/1/2005'),
('KT010','PHUNG TRUNG DUNG','NAM','8/28/1978',2200000,'KTA','','9/24/1999')

INSERT INTO TDNN VALUES
('HC001','01','A'),
('HC001','02','B'),
('HC002','01','C'),
('HC002','03','C'),
('HC003','01','D'),
('KD001','01','C'),
('KD001','02','B'),
('KD002','01','D'),
('KD002','02','A'),
('KD003','01','B'),
('KD003','02','C'),
('KD004','01','C'),
('KD004','04','A'),
('KD004','05','A'),
('KD005','01','B'),
('KD005','02','D'),
('KD005','03','B'),
('KD005','04','B'),
('KT001','01','D'),
('KT001','04','E'),
('KT002','01','C'),
('KT002','02','B'),
('KT003','01','D'),
('KT003','03','C'),
('KT004','01','D'),
('KT005','01','C')

-- BAI 3--
 
 INSERT INTO NHANVIEN VALUES 
 ('QT001', 'MAI NGUYEN PHUONG TRANG', 'NU', '02/18/2004', 150000, 'QTA', '', '')

 INSERT INTO TDNN VALUES 
 ('QT001', '01', 'C'),
 ('QT001', '04', 'A')

/*
	*: TẤT CẢ CÁC THÔNG TIN
	JOIN .(1). ON .(2). : KẾT NỐI BẢNG, (1) BẢNG KẾT NỐI, (2) ĐIỀU KIỆN KẾT NỐI
	WHERE: ĐIỀU KIỆN ĐỂ TRUY VẤN DỮ LIỆU
*/
 SELECT *
 FROM NHANVIEN as NV
 JOIN TDNN ON NV.maNV = TDNN.maNV
 WHERE hoTen = 'MAI NGUYEN PHUONG TRANG'

--BAI 4 - CAU 1--

SELECT *
FROM NHANVIEN
WHERE maNV = 'KT001'

--BAI 4 - CAU 2--

ALTER TABLE NHANVIEN
	ALTER COLUMN hoTen nvarchar(40)

--BAI 4 - CAU 3--

SELECT *
FROM NHANVIEN
WHERE gioiTinh = 'NU'

--BAI 4 - CAU 4--

SELECT hoTen
FROM NHANVIEN
WHERE hoTen LIKE N'NGUYEN%'

--BAI 4 - CAU 5--

SELECT hoTen
FROM NHANVIEN
WHERE hoTen LIKE N'%VAN%'

--BAI 4 - CAU 6--

SELECT *, YEAR(GETDATE()) - YEAR(ngaySinh) AS 'TUOI'
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(ngaySinh) < 30

--BAI 4 - CAU 7--

SELECT *, YEAR(GETDATE()) - YEAR(ngaySinh) AS 'TUOI'
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(ngaySinh) BETWEEN 25 AND 30

--BAI 4 - CAU 8--

SELECT maNV
FROM TDNN
WHERE tDO >= 'C' AND maNN ='01'

--BAI 4 - CAU 9--

SELECT *
FROM NHANVIEN
WHERE YEAR(ngayBC) < 2000

--BAI 4 - CAU 10--

SELECT *
FROM NHANVIEN
WHERE DATEDIFF(YEAR,ngayBC, getdate()) > 10

--BAI 4 - CAU 11--

SELECT *, DATEDIFF(YEAR, ngaySinh, getdate()) AS 'TUOI'
FROM NHANVIEN
WHERE  (DATEDIFF(YEAR, ngaySinh, getdate()) >= 60 AND gioiTinh = 'NAM') or
		(DATEDIFF(YEAR, ngaySinh, getdate()) >= 55 AND gioiTinh = 'NU')

--BAI 4 - CAU 12--

SELECT maPhong, tenPhong, tel
FROM PHONG

 --BAI 4 - CAU 13--
 /*
	TOP(): CHỌN RA SỐ DÒNG DỮ LIỆU THEO THỨ TỰ
	SYNTAX ĐẦY ĐỦ: SELECT TOP(SỐ DÒNG) [WITH TIES] BIỂU THỨC 
	FORM BẢNG 
	[WHERE ĐIỀU KIỆN] 
	[ORDER BY BIỂU THỨC [ ASC | DESC ]]
	VỚI:
		- WITH TIES: loại bỏ giá trị trùng
		- ORDER BY: sắp xếp ASC tăng dần, DESC giảm dần
	TRONG NGOẶC VUÔNG ([]) THÌ CÓ THỂ CÓ HOẶC KHÔNG
 */

 SELECT TOP(2) hoTen, ngaySinh, ngayBC
 FROM NHANVIEN
 
 --BAI 4 - CAU 14--

 /*
	BETWEEN (1) AND (2): (1) GIÁ TRỊ BẮT ĐẦU, (2) GIÁ TRỊ KẾT THÚC
	BETWEEN AND SẼ LẤY GIÁ TRỊ THEO ĐOẠN GIÁ TRỊ 
	VD: [2000000, 3000000] : lấy cả 2000000, 3000000 và các giá trị nằm giữa
*/

SELECT maNV, hoTen, ngaySinh, luong
FROM NHANVIEN
WHERE luong between 2000000 and 3000000

--BAI 4 - CAU 15--

SELECT * 
FROM NHANVIEN 
WHERE sdt = '';

--BAI 4 - CAU 16--

SELECT * 
FROM NHANVIEN 
WHERE MONTH(ngaySinh) = 3

--BAI 4 - CAU 17--

SELECT * 
FROM NHANVIEN 
ORDER BY luong;

--BAI 4 - CAU 18--

SELECT AVG(luong) AS 'Trung binh luong'
FROM NHANVIEN as NV
WHERE NV.maPhong = 'KDA';

--BAI 4 - CAU 19--

SELECT COUNT(maNV) AS 'SLNV', AVG(LUONG) AS 'Trung binh luong'
FROM NHANVIEN
WHERE NHANVIEN.MAPHONG = 'KDA'

--BAI 4 - CAU 20--

SELECT tenPhong, SUM(luong) AS 'Tong Luong'
FROM NHANVIEN 
JOIN PHONG ON NHANVIEN.maPhong = PHONG.maPhong
GROUP BY tenPhong

--BAI 4 - CAU 21--

SELECT tenPhong
FROM PHONG 
JOIN NHANVIEN ON NHANVIEN.maPhong = PHONG.maPhong
GROUP BY tenPhong
HAVING SUM(luong) > 5000000

--BAI 4 - CAU 22--

SELECT maNV, hoTen, NHANVIEN.maPhong, tenPhong 
FROM NHANVIEN, PHONG 
WHERE NHANVIEN.maPhong = PHONG.maPhong;

--BAI 4 - CAU 23--

SELECT * 
FROM NHANVIEN
LEFT JOIN PHONG ON NHANVIEN.maPhong = PHONG.maPhong;

--BAI 4 - CAU 24--
SELECT P.maPhong, P.tenPhong, P.diaChi, P.tel,
       STRING_AGG(NV.maNV +' - ' + NV.hoTen, ', ') AS danhSachNhanVien
FROM PHONG P
LEFT JOIN NHANVIEN NV ON P.maPhong = NV.maPhong
GROUP BY P.maPhong, P.tenPhong, P.diaChi, P.tel
ORDER BY P.maPhong;

