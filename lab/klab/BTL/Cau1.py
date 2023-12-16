# Đọc dữ liệu từ file input.txt
with open('input01.txt', 'r') as file:
    lines = file.readlines()

# Tạo các bảng dữ liệu và danh sách quan hệ
tables = {}
relations = []

# Tìm chỉ số của dòng chứa '=====' để phân tách dữ liệu của các bảng và quan hệ
split_index = lines.index('========================================\n')

# Xử lý thông tin bảng
for line in lines[:split_index]:
    table_info = line.strip().split(': ')
    table_name = table_info[0]
    columns = table_info[1].split(', ')
    tables[table_name] = {'columns': columns, 'data': []}

# Xử lý thông tin mối quan hệ
for line in lines[split_index + 1:]:
    relation_info = line.strip().split(': ')
    relations.append({'type': relation_info[0], 'data': relation_info[1]})

# Xử lý mối quan hệ giữa các bảng
for relation in relations:
    type_val, content = relation['type'], relation['data']
    if type_val == '(n-n)':
        table1, table2, table3 = content.split(' - ')[0], content.split(' - ')[1], content.split(' - ')[1]
        tables[table1]['columns'].append(f'{table3}(n-n)')
        tables[table2]['columns'].append(f'{table1}(n-n)')
    elif type_val == '(1-n)':
        table1, table2 = content.split(' - ')[0], content.split(' - ')[1]
        tables[table2]['columns'].append(f'{table1}(1-n)')
    elif type_val == '(1-1)':
        table1, table2 = content.split(' - ')[0], content.split(' - ')[1]
        tables[table2]['columns'].append(f'{table1}(1-1)')
        tables[table1]['columns'].append(f'{table2}(1-1)')
    elif type_val == '(Ch-C)' or type_val == '(M-Y)':
        table1, table2 = content.split(' - ')[0], content.split(' - ')[1]
        tables[table2]['columns'].append(f'{table1}(Ch-C)')

# Ghi dữ liệu vào file output.txt
with open('output01.txt', 'w') as file:
    for table_name, table_info in tables.items():
        file.write(f"{table_name}: {', '.join(table_info['columns'])}\n")
