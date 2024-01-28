import csv

def count_companies(csv_file):
    companies = {}
    with open(csv_file, 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            company = row[0]
            if company in companies:
                companies[company] += 1
            else:
                companies[company] = 1
    return companies

def set_ratings(csv_file, companies):
    with open(csv_file, 'r') as f:
        reader = csv.reader(f)
        with open('../data/balance.csv', 'w', newline='') as f_out:
            writer = csv.writer(f_out)
            for row in reader:
                company = row[0]
                rating = 3
                if companies[company] >= 5:
                    rating = 4
                row.append(rating)
                writer.writerow(row)

if __name__ == '__main__':
    csv_file = '../data/output.csv'
    companies = count_companies(csv_file)
    set_ratings(csv_file, companies)