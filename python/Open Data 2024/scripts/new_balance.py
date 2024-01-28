import csv
import random

# Открываем файл output.csv
with open("../data/output.csv", "r") as csvfile:

    # Читаем данные из файла
    reader = csv.reader(csvfile, delimiter=",")

    # Создаем новый список для хранения данных с четвертым столбцом
    new_data = []

    # Перебираем все строки из файла
    for row in reader:

        # Создаем новую строку с четвертым столбцом
        new_row = row + [random.uniform(1, 5)]

        # Добавляем новую строку в новый список
        new_data.append(new_row)

# Открываем файл output.csv для записи
with open("../data/output.csv", "w") as csvfile:

    # Создаем новый объект writer для записи в файл
    writer = csv.writer(csvfile, delimiter=",")

    # Записываем данные из нового списка в файл
    writer.writerows(new_data)