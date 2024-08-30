USE QuanLyBanHang
--cau 1--
create proc themncc
	(
	@maCT char(5),
	@tenCT nvarchar(30),
	@tenGiaoDich nvarchar(30),
	@diaChi nvarchar(50),
	@dienThoai char(10),
	@fax char(20),
	@email char(30)
	)
as
begin
	insert into NhaCungCap values
	(@maCT, @tenCT, @tenGiaoDich, @diaChi, @dienThoai, @fax, @email)
end

--cau 2--
create proc themMH
	(
	@maHang char(5),
	@tenHang nvarchar(30),
	@maCT char(5),
	@maLoaiHang char(5),
	@soLuong int,
	@donViTinh nvarchar(10),
	@giaHang float
--constraint pk_mh_maHang primary key (maHang),
--constraint fp_mh_maCT foreign key (maCT) references NhaCungCap(maCT),
--constraint fp_mh_maLoaiHang foreign key (maLoaiHang) references LoaiHang(maLoaiHang)
	)
as
begin
	if @maHang is null or exists (select maHang from MatHang)
		print 'ma hang da ton tai hoac rong'
	else
		begin
			if @maCT is null or not exists (select maCT from NhaCungCap)
				print 'ma cong ti khong ton tai'
			else
				begin
					if @maLoaiHang is null or not exists (select maLoaiHang from LoaiHang)
						print 'ma loai hang khong ton tai'
					else
						begin
							insert into MatHang values
							(@maHang, @tenHang, @maCT, @maLoaiHang, @soLuong, @donViTinh, @giaHang)
						end
				end
		end
end

-- cau 3 --

create proc thongkeSLHH(@maHang char(5))
as
begin
	select maHang, sum(soLuong) as 'Total'
	from ChiTietDatHang
	where @maHang = maHang
	group by maHang
end

