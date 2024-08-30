CREATE DATABASE quanlythuctap
	set dateformat ymd
USE quanlythuctap

CREATE TABLE Sinhvien (
	masv char(10) primary key,
	ten nvarchar(50),
	que nvarchar(50),
	ngaysinh date,
	hocluc float
)

CREATE TABLE Detai (
	madt char(10) primary key,
	tendetai nvarchar(30),
	cndetai nvarchar(30),
	kinhphi int
)

CREATE TABLE Sinhvien_Detai (
	masv char(10),
	madt char(10),
	noithuctap nvarchar(30),
	quangduong float,
	ketqua float,
	constraint pk_svdt primary key (masv, madt),
	constraint fk_sv foreign key (masv) references Sinhvien(masv),
	constraint fk_dt foreign key (madt) references Detai(madt)
)

alter table Detai
	add constraint df_kp
		default 0 for kinhphi
alter table Sinhvien
	add constraint ck_hl
		check (hocluc between 0 and 10)
alter table Sinhvien_Detai
	add constraint ck_kq
		check (ketqua between 0 and 10)
alter table Detai
	add constraint ck_kp
		check (kinhphi < 100000000)

INSERT INTO Sinhvien VALUES
	('H01',N'Nguyễn Ngọc Hân','Long An','2004/02/12',7.5),
	('H02',N'Ngô Ngọc Hoài','TPHCM','2004/03/13',6.6),
	('H03',N'Võ Thị Bích',N'Bến Tre','2004/04/14',7.8),
	('H04',N'Hồ Thị Hà',N'Cà Mau','2004/05/15',6.7),
	('H05',N'Nguyễn Ngọc Ngân',N'Bình Định','2004/06/16',8.9),
	('H06',N'Nguyễn Ngọc',N'Định','2004/06/16',10),
	('H07',N'Nguyễn Ngân',N'Bình','2004/06/16',9),
	('H08',N'Nguyễn Ngân',N'Lâm Đồng','2004/06/16',9),
	('H09',N'Nguyễn Ngân Hồng',N'Lâm Đồng','2004/06/16',10),
	('H10',N'Nguyễn Ngân Dung',N'Lâm Đồng','2004/06/16',6),
	('H11',N'Nguyễn Lê','Long An','2004/02/12',7.5)
INSERT INTO Detai VALUES
	('D01',N'Môi trường',N'Nguyễn Ngân',20000000),
	('D02',N'Động vật',N'Võ Bảo',10000000),
	('D03',N'Thực vật',N'Huỳnh Hoa',10000000),
	('D04',N'Dinh dưỡng',N'Vũ Yến',20000000),
	('D05',N'Thú cưng',N'Hà Ngọc',15000000)
INSERT INTO Sinhvien_Detai VALUES
	('H01','D01',N'Long An',14,7.9),
	('H02','D02',N'Tây Nguyên',20,8.0),
	('H03','D03',N'Đồng Tháp',15,7.6),
	('H04','D04',N'TPHCM',14,8.8),
	('H05','D05',N'Bến Tre',21,8.0),
	('H06','D05',N'Bến Tre',22,5.0),
	('H07','D05',N'Bến Tre',26,9.0),
	('H08','D04',N'Bến Tre',24,10),
	('H09','D02',N'Bến Tre',19,6),
	('H10','D01',N'Bến Tre',29,9)
	
CREATE VIEW cau2_a
	AS
	SELECT *
	FROM Sinhvien
	WHERE datediff(year,getdate(),ngaysinh) < 20 and hocluc > 8.5
CREATE VIEW cau2_b
	AS
	SELECT *
	FROM Detai
	WHERE kinhphi > 1000000
CREATE VIEW cau2_c
	AS
	SELECT sv.*
	FROM Sinhvien sv
	INNER JOIN Sinhvien_Detai svdt
	ON sv.masv = svdt.masv
	WHERE datediff(year,getdate(),ngaysinh) < 20
		  and hocluc > 8
		  and ketqua > 8
CREATE VIEW cau2_d
	AS
	SELECT dt.cndetai
	FROM Detai dt
	INNER JOIN Sinhvien_Detai svdt ON dt.madt = svdt.madt
	INNER JOIN Sinhvien sv ON svdt.masv = sv.masv
	WHERE sv.que = 'TPHCM'
CREATE VIEW cau2_e
	AS
	SELECT *
	FROM Sinhvien
	WHERE year(ngaysinh) < 1980 and que = N'Hải Phòng'
CREATE VIEW cau2_f
	AS
	SELECT hocluc
	FROM Sinhvien
	WHERE que = N'Hà Nội'
CREATE VIEW cau2_g
	AS
	SELECT noithuctap
	FROM Sinhvien_Detai
	WHERE madt = 'D05'
CREATE VIEW cau2_h
AS
SELECT que, count(masv) as masv_count
FROM Sinhvien
GROUP BY que
--cau 3 a--
SELECT dt.tendetai, count(sv.masv) as SLSV
FROM Detai dt
JOIN Sinhvien_Detai svdt ON dt.madt = svdt.madt
JOIN Sinhvien sv ON svdt.masv = sv.masv
GROUP BY dt.tendetai
HAVING count(sv.masv) > 2
--cau 3 b--
SELECT sv.masv, sv.ten, sv.hocluc
FROM Sinhvien sv
WHERE hocluc > ALL(select hocluc
				from Sinhvien
				where que = 'TPHCM')
GROUP BY sv.masv, sv.ten, sv.hocluc
---cau 3 c--
CREATE VIEW update_point
AS 
SELECT sv.masv, sv.que, CASE
						WHEN sv.que = N'Lâm Đồng' THEN
						CASE
							WHEN svdt.ketqua + 2 > 10 THEN 10
							ELSE svdt.ketqua + 2
						END
					ELSE
						CASE
							WHEN svdt.ketqua > 10 THEN 10
							ELSE svdt.ketqua
						END
					END AS diem_cuoi
FROM Sinhvien sv, Sinhvien_Detai svdt
WHERE sv.masv = svdt.masv
--cau 3 c--
UPDATE Sinhvien_Detai
SET ketqua = CASE
				WHEN sv.que = N'Lâm Đồng' THEN
					CASE
						WHEN ketqua + 2 > 10 THEN 10
						ELSE ketqua + 2
					END
				ELSE
					CASE
						WHEN ketqua > 10 THEN 10
						ELSE ketqua
					END
				END
FROM Sinhvien_Detai svdt
JOIN Sinhvien sv ON svdt.masv = sv.masv
--cau 3 d--
SELECT sv.*, noithuctap
FROM Sinhvien sv
JOIN Sinhvien_Detai svdt ON svdt.masv = sv.masv
WHERE sv.que = svdt.noithuctap
--cau 3 e--
SELECT *
FROM Sinhvien
WHERE masv not in (SELECT masv FROM Sinhvien_Detai)
--cau 3 f--
SELECT tendetai, hocluc
FROM Detai dt
JOIN Sinhvien_Detai svdt ON svdt.madt = dt.madt
JOIN Sinhvien sv ON svdt.masv = sv.masv
WHERE hocluc >= (SELECT top 1 hocluc FROM Sinhvien ORDER BY hocluc DESC)
--cau 3 g--
SELECT distinct tendetai
FROM Detai dt
JOIN Sinhvien_Detai svdt ON svdt.madt = dt.madt
JOIN Sinhvien sv ON svdt.masv = sv.masv
WHERE  dt.madt not in (
				SELECT distinct dt.madt
				FROM Detai dt
				JOIN Sinhvien_Detai svdt ON svdt.madt = dt.madt
				JOIN Sinhvien sv ON svdt.masv = sv.masv
				WHERE sv.hocluc = (SELECT TOP 1 hocluc FROM Sinhvien ORDER BY hocluc ASC)
				)
--cau 3 h--
SELECT sv.*
FROM Sinhvien sv
JOIN Sinhvien_Detai svdt ON sv.masv = svdt.masv
JOIN Detai dt ON dt.madt = svdt.madt
WHERE kinhphi > (SELECT SUM(kinhphi)/5 FROM Detai)
	
--cau 3 i--
SELECT sv.*
FROM Sinhvien sv
WHERE sv.hocluc > (SELECT AVG(ketqua)
					FROM Sinhvien_Detai svdt
					WHERE svdt.madt = 'D01' )








