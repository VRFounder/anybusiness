import csv

def get_spheres(filename):
  """
  Возвращает set из сфер из CSV-файла.

  Args:
    filename: Путь к CSV-файлу.

  Returns:
    Set из сфер.
  """

  with open(filename, "r") as f:
    reader = csv.reader(f, delimiter=",")
    spheres = set()
    for row in reader:
      spheres.update(row[1].split(","))
  return spheres


def write_spheres(filename, spheres):
  with open(filename, "w") as f:
    writer = csv.writer(f, delimiter=",")
    for sphere in spheres:
      writer.writerow([sphere])


if __name__ == "__main__":
  filename = "../data/output.csv"
  spheres = get_spheres(filename)
  write_spheres("../data/spheres.csv", spheres)