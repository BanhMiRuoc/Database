reverse
	(substring
		(reverse(hoTen),
		charindex(' ',reverse(hoTen)) + 1,
		len(hoTen)- len(left(reverse(hoTen),charindex(' ',reverse(hoTen))))
		)
	)

mai nguyen phuong trang = 23

gnart gnouhp neyugn iam - chuỗi nguồn

6

23 - 6


(select maSV, 
reverse
	(substring
		(reverse(hoTen),
		charIndex(' ', reverse(hoTen)+1),
		 len(hoTen) - len(left(reverse(hoTen), charIndex(' ', reverse(hoTen)))))) as hoLot,
reverse
	(substring
		(reverse(hoTen)1, charIndex(' ', reverse(hoTen)))) as ten from SINHVIEN)


