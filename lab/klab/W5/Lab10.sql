-- Tạo cơ sở dữ liệu
CREATE DATABASE QuanLySinhVien;

-- Sử dụng cơ sở dữ liệu vừa tạo
USE QuanLySinhVien;

-- Tạo bảng Lop
CREATE TABLE Lop (
    malop INT PRIMARY KEY,
    tenlop VARCHAR(255)
);

-- Tạo bảng Sinhvien
CREATE TABLE Sinhvien (
    masv INT PRIMARY KEY,
    hoten VARCHAR(255),
    ngaysinh DATE,
    malop INT,
    FOREIGN KEY (malop) REFERENCES Lop(malop)
);

-- Tạo bảng Monhoc
CREATE TABLE Monhoc (
    mamh INT PRIMARY KEY,
    tenmh VARCHAR(255),
    tinchi INT
);

-- Tạo bảng Ketqua
CREATE TABLE Ketqua (
    masv INT,
    mamh INT,
    diem FLOAT,
    PRIMARY KEY (masv, mamh),
    FOREIGN KEY (masv) REFERENCES Sinhvien(masv),
    FOREIGN KEY (mamh) REFERENCES Monhoc(mamh)
);
-- Tạo tài khoản đăng nhập
EXEC sp_addlogin 'admin', 'your_password', 'QuanLySinhVien';
Use QuanLySinhVien
Go
sp_adduser'login1'
USE QuanLySinhVien;

-- Cấp quyền CREATE, DROP, ALTER trên toàn bộ schema dbo
use master
GRANT control to login1;
GRANT SELECT ON DATABASE::QuanLySinhVien TO login1;
