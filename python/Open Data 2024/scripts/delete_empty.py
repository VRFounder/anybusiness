import csv

# Открываем файл в режиме чтения
with open("../data/output.csv", "r") as f:
    reader = csv.reader(f)

    # Создаем пустой список для хранения строк с непустыми значениями широты и долготы
    filtered_rows = []

    # Перебираем строки файла
    for row in reader:
        # Проверяем, если значение широты или долготы в строке не пустое
        if row[4] != "" and row[5] != "":
            # Добавляем строку в список
            filtered_rows.append(row)

# Открываем файл в режиме записи
with open("../data/output.csv", "w") as f:
    writer = csv.writer(f)

    # Записываем строки в файл
    writer.writerows(filtered_rows)
