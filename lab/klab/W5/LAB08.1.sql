CREATE DATABASE QLTH
USE QLTH
SET DATEFORMAT DMY
-- Bảng Khoa
CREATE TABLE Khoa (
    makhoa CHAR(10) PRIMARY KEY,
    tenkhoa VARCHAR(40) NOT NULL
);

-- Bảng Môn Học
CREATE TABLE Monhoc (
    mamh CHAR(10) PRIMARY KEY,
    tenmh VARCHAR(40) NOT NULL,
    sotiet INT
);

-- Bảng Sinh Viên
CREATE TABLE Sinhvien (
    masv CHAR(10) PRIMARY KEY,
    hosv VARCHAR(40) NOT NULL,
    tensv VARCHAR(40) NOT NULL,
    ngaysinh DATE,
    phai VARCHAR(10),
    makhoa CHAR(10),
    FOREIGN KEY (makhoa) REFERENCES Khoa(makhoa)
);

-- Bảng Kết Quả
CREATE TABLE Ketqua (
    mamh CHAR(10),
    masv CHAR(10),
    lanthi INT,
    diem float,
    PRIMARY KEY (mamh, masv, lanthi),
    FOREIGN KEY (mamh) REFERENCES Monhoc(mamh),
    FOREIGN KEY (masv) REFERENCES Sinhvien(masv)
);

--cau 1

CREATE PROC themSV (
	@masv char(10),
	@hosv varchar(40),
	@tensv varchar(40),
	@ngaysinh date,
	@phai varchar(10),
	@makhoa char(10)
	)
as
begin
	insert into Sinhvien values
	(@masv, @hosv, @tensv, @ngaysinh, @phai, @makhoa)
end

--cau 2--

CREATE PROC themSV_1 (
	@masv char(10),
	@hosv varchar(40),
	@tensv varchar(40),
	@ngaysinh date,
	@phai varchar(10),
	@makhoa char(10)
	)
as
begin
	if @maKhoa not in (select maKhoa from Khoa)
		print 'loi khoa'
	else
		begin
			if DATEDIFF(year,@ngaysinh,getdate()) < 18 or DATEDIFF(year,@ngaysinh,getdate()) > 40
				print 'loi tuoi'
			else
				begin
					if @masv in (select masv from Sinhvien)
						print 'loi masv'
					else
						begin
							insert into Sinhvien values
							(@masv, @hosv, @tensv, @ngaysinh, @phai, @makhoa)
						end
				end
		end
end

insert into Khoa values ('K01', 'CNTT')
exec themSV_1 'S09','Mai', 'Trang', '18/02/2014', 'Nu', 'K01'

-- cau 3 -- 

create proc ck_kq (
					@mamh char(10),
					@masv char(10),
					@lanthi int,
					@diem float
					)
as
begin
	if @mamh not in (select mamh from Monhoc)
		print 'ko co mh'
	else
		begin
			if @masv not in (select masv from Sinhvien)
				print 'ko co sv'
			else
				begin
					insert into Ketqua values
					(@mamh, @masv, @lanthi, @diem)
				end
		end
end


insert into Monhoc values
('M01','CTRR',4)
exec ck_kq 'M01', 'S01', 1, 9.9

-- cau 4 -- 
create proc sh_totalS (@makhoa char(10))
as
begin
	declare @soluong int
	set @soluong = (select count(masv) from Sinhvien where @makhoa = makhoa)
	print @soluong
end

select * from Sinhvien
exec sh_totalS 'K01'

-- CAU 5 --

create function showSV (@makhoa char(10))
returns table
as
return select * from Sinhvien where @makhoa = makhoa

select * from dbo.showSV('K01')
-- cau 6 --
create function ck_Khoa()
returns table
as
	return (
	select k.makhoa, k.tenkhoa, count(sv.masv) as 'So luong SV'
	from Sinhvien as sv
	join Khoa as k on sv.makhoa = k.makhoa
	group by k.makhoa, k.tenkhoa )
select * from dbo.ck_Khoa()
exec total_F

-- cau 7 --

create function rsSV(@masv char(10))
returns table
as
return (
		select * from Ketqua as kq where @masv = kq.masv
		)

select * from dbo.rsSV('S01')

-- cau 8 --

create function slsv(@makhoa char(10))
returns table
as
return
	(
	select sv.makhoa, count(sv.masv) as 'SLSV'
	from Sinhvien as sv
	where @makhoa = sv.makhoa
	group by sv.makhoa
	)

select * from dbo.slsv('K01')