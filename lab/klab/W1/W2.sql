CREATE DATABASE Quanlysinhvien 
set dateformat mdy
USE Quanlysinhvien

--EX1 CREATE TABLE -- 

CREATE TABLE KHOA (
	maKhoa char(10),
	tenKhoa nvarchar(50),
	constraint pk_khoa_maKhoa primary key (maKhoa)
)

CREATE TABLE SINHVIEN (
	hoSV nvarchar(30),
	tenSV nvarchar(30),
	maSV char(10),
	ngaySinh date,
	phai nvarchar(5),
	maKhoa char(10)
	constraint pk_sv_maSV primary key (maSV),
	constraint fk_sv_maKhoa foreign key (maKhoa) references KHOA(maKhoa)
)

CREATE TABLE MONHOC (
	tenMH nvarchar(30),
	maMH char(10),
	soTiet int,
	constraint pk_mh_maMH primary key (maMH)
)

CREATE TABLE KETQUA (
	maSV char(10),
	maMH char(10),
	lanThi int,
	diem float,
	constraint pk_kq primary key (maSV, maMH, lanThi),
	constraint fk_kq_maSV foreign key (maSV) references SINHVIEN(maSV),
	constraint fk_kq_maMH foreign key (maMH) references MONHOC(maMH)
)

-- Ex2 DELETE FOREIGN KEY CONSTRAINT TO THE SINHVIEN & MONHOC -- 

ALTER TABLE SINHVIEN DROP CONSTRAINT fk_sv_maKhoa
ALTER TABLE KETQUA DROP CONSTRAINT fk_kq_maSV
ALTER TABLE KETQUA DROP CONSTRAINT fk_kq_maMH 

-- Ex3 DROP TABLE KHOA & MONHOC -- 

DROP TABLE KHOA
DROP TABLE MONHOC

-- Ex4 CREATE TABLE KHOA, MONHOC --

CREATE TABLE MONHOC (
	tenMH nvarchar(30),
	maMH char(10),
	soTiet int,
	constraint pk_mh_maMH primary key (maMH)
)

CREATE TABLE KHOA (
	maKhoa char(10),
	tenKhoa nvarchar(50),
	constraint pk_khoa_maKhoa primary key (maKhoa)
)

ALTER TABLE SINHVIEN add constraint fk_sv_maKhoa foreign key (maKhoa) references KHOA(maKhoa)
ALTER TABLE KETQUA add constraint fk_kq_maSV foreign key (maSV) references SINHVIEN(maSV)
ALTER TABLE KETQUA add constraint fk_kq_maMH foreign key (maMH) references MONHOC(maMH)

--Ex5 INSERT VALUES-- 

INSERT INTO KHOA VALUES
('AVAN', N'Khoa Anh Van'),
('CNTT',N'Cong Nghe Thong Tin'),
('DTVT',N'Dien Tu Vien Thong'),
('QTKD',N'Quan Tri Kinh Doanh')

INSERT INTO SINHVIEN VALUES
('Tran Minh', 'Son', 'S001', '5/1/1985', 'Nam', 'CNTT'),
('Nguyen Quoc', 'Bao', 'S002', '5/15/1986', 'Nam', 'CNTT'),
('Phan Anh', 'Tung', 'S003', '12/20/1983', 'Nam', 'QTKD'),
('Bui Thi Anh', 'Thu', 'S004', '2/1/1985', 'Nu', 'QTKD'),
('Le Thi Lan', 'Anh', 'S005', '7/3/1987', 'Nu', 'DTVT'),
('Nguyen Thi', 'Lam', 'S006', '11/25/1984', 'Nu', 'DTVT'),
('Phan Thi', 'Ha', 'S007', '7/3/1988', 'Nu', 'CNTT'),
('Tran The', 'Dung', 'S008', '10/21/1985', 'Nam', 'CNTT')

INSERT INTO MONHOC VALUES
('Anh Van', 'AV', 45),
('Co So Du Lieu', 'CSDL', 45),
('Ki Thuat Lap Trinh', 'KTLT', 60),
('Ke Toan Tai Chinh', 'KTTC', 45),
('Toan Cao Cap', 'TCC', 60),
('Tin Hoc Van Phong', 'THVP', 30),
('Tri Tue Nhan Tao', 'TTNT', 45)

INSERT INTO KETQUA VALUES
('S001', 'CSDL', 1, 4),
('S001', 'TCC', 1, 6),
('S002', 'CSDL', 1, 3),
('S002', 'CSDL', 2, 6),
('S003', 'KTTC', 1, 5),
('S004', 'AV', 1, 8),
('S004', 'THVP', 1, 4),
('S004', 'THVP', 2, 8),
('S006', 'TCC', 1, 5),
('S007', 'AV', 1, 2),
('S007', 'AV', 2, 9),
('S007', 'KTLT', 1, 6),
('S008', 'AV', 1, 7)

-- Ex6 Update SoTiet of Tri Tue Nhan Tao by 30

UPDATE MONHOC SET soTiet = 30 WHERE tenMH = N'Tri Tue Nhan Tao' 

-- Ex7 Delete KETQUA of S001

DELETE FROM KETQUA WHERE maSV = 'S001'

-- Ex8 Insert KETQUA of S001

INSERT INTO KETQUA VALUES 
('S001', 'CSDL', 1, 4),
('S001', 'TCC', 1, 6)

-- Ex9 Update name of SINHVIEN from Nguyen Thi Lam to Nguyen Van Lam & phai = Nam

UPDATE SINHVIEN SET hoSV = 'Nguyen Van', phai = 'Nam'
WHERE hoSV = 'Nguyen Thi' and tenSV = 'Lam'

-- Ex10 Le Thi Lan Anh form CNTT

UPDATE SINHVIEN SET maKhoa = 'CNTT' WHERE hoSV = 'Le Thi Lan'


	