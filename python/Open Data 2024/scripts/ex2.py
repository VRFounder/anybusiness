import csv

# Откройте файлы CSV
with open("../data/output.csv", "r") as output_file, open("../data/spheres1.csv", "r") as spheres_file:

    # Создайте объект Reader для каждого файла
    output_reader = csv.reader(output_file, delimiter=",")
    spheres_reader = csv.reader(spheres_file, delimiter=",")

    # Прочтите заголовки из первого файла
    header = next(output_reader)

    # Создайте список для хранения измененных строк
    updated_lines = []

    # Переберите строки из первого файла
    for line in output_reader:
        # Получите сферу деятельности из строки
        sphere = line[1]

        # Пройдитесь по строкам из второго файла
        for spheres_line in spheres_reader:
            # Если сфера деятельности из первого файла совпадает со сферой деятельности из второго файла
            if sphere == spheres_line[0]:
                # Замените строку в первом файле на значение сферы деятельности из второго файла
                updated_lines.append([line[0], spheres_line[1], line[2]])
                break

    # Запишите измененные строки во второй файл
    with open("../data/output_updated.csv", "w", newline="") as output_updated_file:
        output_writer = csv.writer(output_updated_file, delimiter=",")
        output_writer.writerow(header)
        output_writer.writerows(updated_lines)
