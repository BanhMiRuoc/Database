CREATE DATABASE Quanlysinhvien
GO
USE Quanlysinhvien
CREATE TABLE KHOA(
	MAKHOA CHAR(10) NOT NULL,
	TENKHOA NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_KHOA PRIMARY KEY(MAKHOA)
)
SET DATEFORMAT MDY
CREATE TABLE SINHVIEN(
	HOSV NVARCHAR(20) NOT NULL,
	TENSV NVARCHAR(15) NOT NULL,
	MASV CHAR(10) NOT NULL,
	NGAYSINH DATE NOT NULL,
	PHAI CHAR(5) NOT NULL,
	MAKHOA CHAR(10) NOT NULL,
	CONSTRAINT PK_SINHVIEN PRIMARY KEY(MASV),
	CONSTRAINT FK_MAKHOA_KHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)
)
CREATE TABLE MONHOC(
	TENMH NVARCHAR(20) NOT NULL,
	MAMH CHAR(10) NOT NULL,
	SOTIET INT,
	CONSTRAINT PK_MONHOC PRIMARY KEY(MAMH)
)
CREATE TABLE KETQUA(
	MASV CHAR(10) NOT NULL,
	MAMH CHAR(10) NOT NULL,
	LANTHI INT,
	DIEM INT,
	CONSTRAINT PK_KETQUA PRIMARY KEY(MASV, MAMH, LANTHI),
	CONSTRAINT FK_MASV_SINHVIEN FOREIGN KEY(MASV) REFERENCES SINHVIEN(MASV),
	CONSTRAINT FK_MAMH_MONHOC FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)
)
--XOA CAC RANG BUOC KHOA NGOAI THAM CHIEU DEN BANG SINH VIEN VA MON HOC
ALTER TABLE KETQUA DROP CONSTRAINT FK_MASV_SINHVIEN
ALTER TABLE KETQUA DROP CONSTRAINT FK_MAMH_MONHOC
ALTER TABLE SINHVIEN DROP CONSTRAINT FK_MAKHOA_KHOA
--XOA BANG KHOA VA MONHOC
DROP TABLE KHOA
DROP TABLE MONHOC
--TAO LAI CAC KHOA NGOAI DA XOA
ALTER TABLE KETQUA ADD CONSTRAINT FK_MASV_SINHVIEN FOREIGN KEY(MASV) REFERENCES SINHVIEN(MASV)
ALTER TABLE KETQUA ADD CONSTRAINT FK_MAMH_MONHOC FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)
ALTER TABLE SINHVIEN ADD CONSTRAINT FK_MAKHOA_KHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)
--NHAP DU LIEU CHO CAC BANG
INSERT INTO KHOA VALUES
('AVAN', 'Khoa anh Van'),
('CNTT', 'Cong Nghe Thong tin'),
('DTVT', 'Dien Tu Vien Thong'),
('QTKD', 'Quan Tri Kinh Doanh')
INSERT INTO SINHVIEN VALUES
('Tran Minh', 'Son', 'S001', '5/1/1985', 'Nam', 'CNTT'),
('Nguyen Quoc', 'Bao', 'S002', '5/15/1986', 'Nam', 'CNTT'),
('Phan Anh', 'Tung', 'S003', '12/20/1983', 'Nam', 'QTKD'),
('Bui Thi Anh', 'Thu', 'S004', '2/1/1985', 'Nu', 'QTKD'),
('Le Thi Lan Anh', 'Anh', 'S005', '7/3/1987', 'Nu', 'DTVT'),
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
--SUA SO TIET CUA MON TRI TUE NHAN TAO LAI 30 TIET
UPDATE MONHOC
SET SOTIET = 30
WHERE TENMH = 'Tri Tue Nhan Tao';
--XOA KET QUA CUA SINH VIEN S001
DELETE FROM KETQUA
WHERE MASV = 'S001'
--CHEN CAC BO CUA SINH VIEN S001 VUA XOA
INSERT INTO KETQUA VALUES
('S001', 'CSDL', 1, 4),
('S001', 'TCC', 1, 6)
--SUA SV NGUYEN THI LAM THANH NGUYEN VAN LAM VA PHAI NU THANH PHAI NAM
UPDATE SINHVIEN
SET HOSV = 'Nguyen Van', PHAI = 'Nam'
WHERE HOSV = 'Nguyen Thi'
--CHUYEN SINH VIEN LE THI LAN ANH SANG KHOA CNTT
UPDATE SINHVIEN
SET MAKHOA = 'CNTT'
WHERE HOSV = 'Le Thi Lan Anh'

