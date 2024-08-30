CREATE DATABASE LAB802
USE LAB802

SET DATEFORMAT DMY

CREATE TABLE LOP (
	maLop char(10) primary key,
	tenLop varchar(40)
)

CREATE TABLE SINHVIEN (
	maSV char(10) primary key,
	hoTen varchar(40),
	ngaysinh date,
	maLop char(10),
	foreign key (maLop) references LOP(maLop)
)

CREATE TABLE MONHOC (
	maMH char(10) primary key,
	tenMH varchar(40)
)

CREATE TABLE KETQUA (
	maSV char(10),
	maMH char(10),
	diem float,
	primary key (maSV, maMH),
	foreign key (maSV) references SINHVIEN(maSV),
	foreign key (maMH) references MONHOC(maMH)
)

-- Insert   
INSERT INTO LOP VALUES
('CT123', 'Công nghệ thông tin 123'),
('DT456', 'Điện tử 456'),
('HT789', 'Hệ thống thông tin 789'),
('CN101', 'Công nghệ phần mềm 101'),
('KT202', 'Kỹ thuật phần mềm 202');

-- Insert data into SINHVIEN table
INSERT INTO SINHVIEN VALUES
('SV001', 'Nguyễn Văn A', '1999-11-22', 'CT123'),
('SV002', 'Trần Thị B', '2000-03-15', 'DT456'),
('SV003', 'Lê Văn C', '1998-07-08', 'HT789'),
('SV004', 'Phạm Thị D', '2001-05-20', 'CT123'),
('SV005', 'Vũ Minh E', '2002-09-12', 'DT456');

-- Insert data into MONHOC table
INSERT INTO MONHOC VALUES
('MH001', 'Cơ sở dữ liệu'),
('MH002', 'Lập trình hướng đối tượng'),
('MH003', 'Mạng máy tính'),
('MH004', 'Hệ điều hành'),
('MH005', 'Giải tích 1');

-- Insert data into KETQUA table
INSERT INTO KETQUA VALUES
('SV001', 'MH001', 8.0),
('SV002', 'MH002', 7.5),
('SV003', 'MH003', 9.0),
('SV004', 'MH001', 6.8),
('SV005', 'MH002', 8.2);

CREATE FUNCTION getInfoS(@maLop char(10))
RETURNS TABLE
AS
	RETURN (select (upper(left(hoTen, 1)) + substring(hoTen, 2, len(hoTen)-1)) as hoTen, CONVERT (VARCHAR(10), ngaySinh, 103) as ngaySinh
			from SINHVIEN
			where @maLop = maLop 
			)

select * from dbo.getInfoS('CT123')

CREATE FUNCTION getPoint()
returns table
as
return (select maSV, maMH, str(diem,5,2) as diem from KETQUA)
select * from getPoint()

CREATE FUNCTION getDayStu()
RETURNS TABLE
AS
RETURN (SELECT hoTen, ngaySinh, DATENAME(dw, ngaySinh) as thu from SINHVIEN)

select * from getDayStu()

CREATE FUNCTION getInfoAllS()
RETURNS TABLE
AS
	RETURN 
	(select maSV, 
		reverse(
			substring(reverse(hoTen), charIndex(' ', reverse(hoTen))+1, len(hoTen) - len(left(reverse(hoTen), charIndex(' ', reverse(hoTen)))))) as hoLot, reverse(substring(reverse(hoTen),1, charIndex(' ', reverse(hoTen)))) as ten from SINHVIEN)

SELECT * FROM getInfoAllS()

CREATE FUNCTION getID(@maLop char(10))
returns CHAR(10)
AS
BEGIN
	RETURN
	(
	SELECT top 1 maSV from SINHVIEN where maLop = @maLop order by maSV desc
	)
END
DROP FUNCTION getID
PRINT DBO.getID('CT123')

CREATE PROC ADDSTU
	(@hoTen varchar(40),
	@ngaysinh date,
	@maLop char(10))
as
	declare @masv char(10)
	set @masv = dbo.getID(@maLop)
	declare @stt int
	set @stt = cast(right(@maSV, 3) as int) + 1

	if @stt < 10
	begin
	set @masv = @maLop + '00' + cast (@stt as varchar(1))
	end
	else if @stt < 100
	begin
		set @masv = @maLop + '0' + cast (@stt as varchar(2))
	end
	else
	begin
	set @masv = @maLop + cast (@stt as varchar(3))
	end
	insert into sinhvien values (@masv, @hoTen, @ngaysinh, @maLop)

exec ADDSTU N'Nguyễn Lâm', '3/30/1990', 'CT123'

create function caug()
returns table
as
return (select sv.maSV, hoTen, str(avg(diem),5,2) as
dtb
from sinhvien AS sv, ketqua as kq where sv.maSV = kq.maSV
group by sv.maSV, hoTen
having avg(diem) >=5)
go
select * from caug()

