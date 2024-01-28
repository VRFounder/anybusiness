import json
import csv

def json_to_csv(json_file, csv_file):
    with open(json_file, 'r') as f:
        json_data = json.load(f)

    with open(csv_file, 'w', newline='') as f:
        writer = csv.writer(f)
        for row in json_data:
            writer.writerow(row.values())

if __name__ == '__main__':
    json_file = '../data/companies_1.json'
    csv_file = '../data/output.csv'

    json_to_csv(json_file, csv_file)