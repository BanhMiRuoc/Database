#so sánh hai tập hợp của 2 thuộc tính
def compare_to_u(U, closure):
    if len(U) != len(closure):
        return False
    tmp = closure.split(", ")
    for i in tmp:
        if i not in U:
            return False
    return True
#kiểm tra arr có chứa key
def array_contains(arr, key):
    return key in arr
#chuyển đổi item thành chuỗi (string)
def convert_to_string(item):
    return ', '.join(item)
#tìm bao đóng của thuộc tính item
def closure(map, item):
    check = True
    while check:
        length_check = len(item)
        for map_key in map:
            values = map[map_key]
            key = item.split(", ")
            flag = True
            if len(key) >= len(map_key):
                for left_attr in map_key:
                    if not array_contains(key, left_attr):
                        flag = False
                        break
                if flag:
                    for value_attr in values:
                        if not array_contains(key, value_attr):
                            item += ", " + value_attr
        if length_check == len(item):
            check = False
        else:
            length_check = len(item)
    return item
#tìm con của tập hợp
def child(TG_List):
    list = []
    for i in range(1, int(2 ** len(TG_List))):
        binary = bin(i)[2:]
        bi_len = len(binary)
        sub = ""
        binary = "0" * (len(TG_List) - bi_len) + binary

        for j in range(len(TG_List)):
            if binary[j] == '1':
                if len(sub) == 0:
                    sub += TG_List[j]
                else:
                    sub += ", " + TG_List[j]
        list.append(sub)
    return list
#kiểm tra chuỗi str có chứa key 
def string_contains_string(str, key):
    tmp = key.split(", ")
    for i in tmp:
        if i not in str:
            return False
    return True
#đọc file và xử lí yêu cầu theo người dùng nhập vào
try:
    with open("input02.txt", 'r') as file, open("output02.txt", 'w') as writer:
        print("SINHVIEN: MaSV(bao dong co khoa chinh), HoTen, NgaySinh.")
        print("LOP: MaLop(bao dong co khoa chinh), NienKhoa.")
        print("MONHOC: MaMH(bao dong co khoa chinh), SoTinChi.")
        print("GIANGVIEN: MaGV(bao dong co khoa chinh).")
        print("Nhap tim bao dong cho cac bang: ")
        sc = input

        while True:
            table = file.readline().strip()
            if not table:
                break

            U = file.readline().strip()
            F = file.readline().strip()
            file.readline()

            map = {}
            dependence = F.split("; ")
            exist_index = []

            for i in range(len(dependence)):
                depend_pair = dependence[i].split(" -> ")
                left_attr = depend_pair[0].split(", ")
                right = depend_pair[1]

                if i not in exist_index:
                    exist_index.append(i)
                else:
                    continue

                for j in range(i + 1, len(dependence)):
                    j_depend_pair = dependence[j].split(" -> ")
                    if depend_pair[0] == j_depend_pair[0]:
                        right += ", " + j_depend_pair[1]
                        exist_index.append(j)
                right_attr = right.split(", ")
                map[tuple(left_attr)] = right_attr

            U_arr = U.split(", ")
            TN_List = [U_attr for U_attr in U_arr if all(not array_contains(map[key], U_attr) for key in map)]

            TG_List = [U_attr for U_attr in U_arr if any(array_contains(key, U_attr) and array_contains(map[key], U_attr) for key in map)]

            key_list = []
            TN = convert_to_string(TN_List)

            if compare_to_u(U, closure(map, TN)):
                key_list.append(TN)
            else:
                for i in child(TG_List):
                    check = TN + ", " + i
                    if compare_to_u(U, closure(map, check)):
                        key_list.append(check)

            for _ in range(2):
                for i in range(len(key_list) - 1):
                    for j in range(i + 1, len(key_list)):
                        if string_contains_string(key_list[j], key_list[i]):
                            key_list.remove(key_list[j])

            key = "; ".join("[" + i + "]" for i in key_list)
            res = sc(f'({closure(map, table)}):' + " ")
            writer.write(table + "\n")
            writer.write("Bao dong cua (" + res + "): " + closure(map, res) + "\n")
            writer.write("Danh sach cac khoa: " + key + "\n\n")

except FileNotFoundError as e:
    print(e)
except IOError as e:
    print(e)
