CREATE DATABASE QuanlySV

USE QuanlySV

CREATE TABLE KHOA (
	MaSo char(10),
	Ten nvarchar(50),
	NamThanhLap int,
	constraint pk_khoa_maKhoa primary key (MaSo)
)

CREATE TABLE SINHVIEN (
	Tensv nvarchar(50),
	Masv char(10),
	namsinh int ,
	Makhoa char(10),
	constraint pk_sv_maSV primary key (Masv),
	constraint fk_sv_maKhoa foreign key (Makhoa) references KHOA(MaSo), 
	constraint cdt_sv_namsinh check (namsinh in (1,4)) 
)

CREATE TABLE MONHOC (
	Tenmh nvarchar(50),
	Mamh char(10),
	TinChi int,
	Makhoa char(10),
	constraint pk_mh_maMH primary key (Mamh),
	constraint fk_mh_maKhoa foreign key (Makhoa) references KHOA(MaSo),
)

CREATE TABLE DIEUKIEN (
	Mamh char(10),
	Mamh_Truoc char(10),
	constraint pk_dk_maMH primary key (Mamh, Mamh_Truoc),
	constraint fk_dk_maMH foreign key (Mamh) references KHOA(MaSo),
	constraint fk_dk_maMH_T foreign key (Mamh_Truoc) references KHOA(MaSo)
)

CREATE TABLE HOCPHAN (
	Mahp char(10),
	Mamh char(10),
	HocKy char(10),
	Nam int,
	GiaoVien nvarchar(50),
	constraint pk_hp_maHP primary key (Mahp)
)

alter table HOCPHAN add constraint fk_hp_maMH foreign key (Mamh) references MONHOC(Mamh)

CREATE TABLE KETQUA (
	Masv char(10),
	Mahp char(10),
	Diem char(5),
	constraint pk_kq_maSV_maHP primary key (Masv, Mahp),
	constraint fk_kq_maSV foreign key (Masv) references SINHVIEN(Masv),
	constraint fk_kq_maHP foreign key (Mahp) references HOCPHAN(Mahp)
)



