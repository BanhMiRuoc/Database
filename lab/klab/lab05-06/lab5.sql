﻿CREATE DATABASE LAB5
GO
USE LAB5
GO

--CAU 1
CREATE TABLE SINHVIEN
(
	MASV CHAR(2) NOT NULL,
	TEN NVARCHAR(40),
	QUEQUAN NVARCHAR(40),
	NGAYSINH DATE,
	HOCLUC TINYINT CHECK(HOCLUC <= 10 AND HOCLUC >=0),
	PRIMARY KEY(MASV),

)

CREATE TABLE DETAI
(
	MADT CHAR(4) NOT NULL,
	TENDETAI NVARCHAR(40),
	CHUNHIEMDETAI NVARCHAR(40),
	KINHPHI INT DEFAULT 0 CHECK(KINHPHI < 100000000),
	PRIMARY KEY(MADT)
)

ALTER TABLE DETAI ALTER COLUMN TENDETAI NVARCHAR(150)

CREATE TABLE SV_DT
(
	MASV CHAR(2) NOT NULL,
	MADT CHAR(4) NOT NULL,
	NOITHUCTAP NVARCHAR(40),
	QUANGDUONG INT,
	KETQUA TINYINT CHECK(KETQUA <= 10 AND KETQUA >=0),
	PRIMARY KEY(MASV, MADT),
	CONSTRAINT FK_SV_DT_MASV FOREIGN KEY(MASV) REFERENCES SINHVIEN(MASV),
	CONSTRAINT FK_SV_DT_MADT FOREIGN KEY(MADT) REFERENCES DETAI(MADT)
)

SET DATEFORMAT YMD

INSERT INTO SINHVIEN VALUES
	('A1', N'Nguyễn Văn A', N'Hà Nội', N'1999-01-01', 9),
	('B2', N'Trần Thị B', N'TP. Hồ Chí Minh', N'2000-02-02', 8),
	('C3', N'Lê Quang C', N'Đà Nẵng', N'2001-03-03', 7),
	('D4', N'Phan Thị D', N'Cần Thơ', N'2002-04-04', 6),
	('E5', N'Đỗ Quốc E', N'Bắc Giang', N'2003-05-05', 5),
	('F6', N'Lê Công Tuấn', N'Lâm Đồng', N'2004-01-03', 5);
	

INSERT INTO DETAI VALUES
	('DT01', N'Nghiên cứu phát triển hệ thống trí tuệ nhân tạo', N'GS. Pino Pinochio', 99999999),
	('DT02', N'Xây dựng hệ thống cơ sở dữ liệu quản lý sinh viên', N'TS. Trần Thị B', 50000000),
	('DT03', N'Phát triển ứng dụng di động quản lý sức khỏe', N'PGS.TS. Lê Quang C', 30000000),
	('DT04', N'Nghiên cứu chế tạo vật liệu mới thân thiện với môi trường', N'TS. Phan Thị D', 20000000),
	('DT05', N'Ứng dụng công nghệ thông tin trong quản lý giáo dục', N'TS. Đỗ Quốc E', 1000000),
	('DT06', N'Ứng dụng công nghệ thông tin vào xây dựng', N'CN. Phan Hoàng Phúc Vinh', 100000);

INSERT INTO SV_DT VALUES
	('A1', 'DT01', N'Hà Nội', 3, 9),
	('B2', 'DT01', N'Royal Melbourne Institute of Technology', 1001, 10),
	('B2', 'DT02', N'TP. Hồ Chí Minh', 2, 8),
	('C3', 'DT03', N'Đà Nẵng', 1, 7),
	('D4', 'DT04', N'TP. Hồ Chí Minh', 1, 6),
	('D4', 'DT05', N'Cần Thơ', 1, 6),
	('E5', 'DT05', N'TP. Hồ Chí Minh', 1, 5);

--CAU 2
--2a
CREATE VIEW CAU2_A AS
	SELECT *, Tuoi = Year(GETDATE()) - Year(NGAYSINH)
	FROM SINHVIEN 
	WHERE Year(GETDATE()) - Year(NGAYSINH) < 20 AND hocLuc > 8.5

--2b
CREATE VIEW CAU2_B AS
	SELECT * FROM DETAI WHERE KINHPHI > 1000000

--2c
CREATE VIEW CAU2_C AS
	SELECT TEN, Tuoi = Year(GETDATE()) - Year(NGAYSINH), HOCLUC, KETQUA
	FROM SINHVIEN SV, SV_DT
	WHERE SV.MASV = SV_DT.MASV AND Year(GETDATE()) - Year(SV.NGAYSINH) < 20 AND SV.HOCLUC > 8 AND SV_DT.KETQUA > 8

--2d
CREATE VIEW CAU2_D AS
	SELECT CHUNHIEMDETAI FROM SINHVIEN SV, DETAI DT, SV_DT
	WHERE SV.MASV = SV_DT.MASV AND SV_DT.MADT = DT.MADT AND SV.QUEQUAN = N'TP. Hồ Chí Minh'

--2e
CREATE VIEW CAU2_E AS
	SELECT * FROM SINHVIEN
	WHERE Year(NGAYSINH) < 1980 AND  QUEQUAN = N'Hải Phòng'

--2f
INSERT INTO SINHVIEN VALUES
	('A9', N'Lê Công Toản', N'Hà Nội', N'1999-01-01', 5);
CREATE VIEW CAU2_F AS
	SELECT DTB = AVG(HOCLUC) FROM SINHVIEN
	WHERE QUEQUAN = N'Hà Nội'

--2g
CREATE VIEW CAU2_G AS
	SELECT NOITHUCTAP FROM SV_DT, DETAI DT
	WHERE SV_DT.MADT = DT.MADT AND DT.MADT = 'DT05'

--2h
CREATE VIEW CAU2_H AS
	SELECT QUEQUAN, SOSV = COUNT(MASV) FROM SINHVIEN
	GROUP BY QUEQUAN


--CAU 3
--3a
SELECT TENDETAI, SoThamGia = COUNT(MASV) FROM SV_DT, DETAI DT
WHERE SV_DT.MADT = DT.MADT
GROUP BY SV_DT.MADT, DT.TENDETAI
HAVING COUNT(MASV) > 1

--3b
SELECT * FROM SINHVIEN
WHERE HOCLUC > ALL (
						SELECT MAX(HOCLUC) FROM SINHVIEN
						WHERE QUEQUAN = N'TP. Hồ Chí Minh'
					)

--3c
UPDATE SV_DT
SET ketqua = (
	SELECT 
	CASE WHEN ketqua+2>10
	THEN 10
	ELSE ketqua+2 END
)
FROM Sinhvien, SV_DT
WHERE Sinhvien.masv = SV_DT.masv AND Sinhvien.quequan = N'Hải Phòng'

--3d
SELECT SV.MASV, TEN, QUEQUAN, NOITHUCTAP FROM SINHVIEN SV, SV_DT 
WHERE SV.MASV = SV_DT.MASV AND SV.QUEQUAN = SV_DT.NOITHUCTAP

--3e
SELECT TENDETAI FROM DETAI 
WHERE MADT NOT IN(SELECT MADT FROM SV_DT)

--3f
SELECT TENDETAI
FROM DETAI DT, SINHVIEN SV, SV_DT
WHERE SV.MASV = SV_DT.MASV AND SV_DT.MADT = DT.MADT AND SV.MASV IN
(
	SELECT MASV FROM SINHVIEN WHERE HOCLUC IN (SELECT MAX(HOCLUC) FROM SINHVIEN)
)

--3g
SELECT TENDETAI
FROM DETAI DT, SINHVIEN SV, SV_DT
WHERE SV.MASV = SV_DT.MASV AND SV_DT.MADT = DT.MADT AND SV.MASV IN
(
	SELECT MASV FROM SINHVIEN WHERE HOCLUC IN (SELECT MIN(HOCLUC) FROM SINHVIEN)
)

--3h
SELECT SV.*
FROM DETAI DT, SINHVIEN SV, SV_DT
WHERE SV.MASV = SV_DT.MASV AND SV_DT.MADT = DT.MADT AND KINHPHI >
(
	SELECT SUM(KINHPHI)/5 FROM DETAI
)

--3i
SELECT SV.* FROM SINHVIEN SV, SV_DT
WHERE SV_DT.MADT = 'DT01' AND SV.MASV = SV_DT.MASV AND SV.HOCLUC > SV_DT.KETQUA