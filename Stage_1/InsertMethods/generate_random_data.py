import random
from faker import Faker
from datetime import timedelta

fake = Faker()
NUM_HUGE = 20000
NUM_REGULAR = 500
EXISTING_IDS = list(range(1, 501))

print("Generating full randomized data for ALL remaining tables...")

with open('full_data_insert.sql', 'w', encoding='utf-8') as f:
    
    # 1. INCIDENTS (20,000)
    f.write("-- SECTION: INCIDENTS\n")
    for i in range(1, NUM_HUGE + 1):
        start = fake.date_between(start_date='-2y', end_date='today')
        end = start + timedelta(minutes=random.randint(10, 120))
        f.write(f"INSERT INTO INCIDENTS VALUES ({i}, '{start}', '{end}', {random.randint(1,5)}, 'Resolved', {random.choice(EXISTING_IDS)}, {random.choice(EXISTING_IDS)});\n")

    # 2. LOCATIONS (20,000) - Missing previously
    f.write("\n-- SECTION: LOCATIONS\n")
    for i in range(1, NUM_HUGE + 1):
        f.write(f"INSERT INTO LOCATIONS VALUES ({i}, '{fake.city().replace("'", "")}', '{fake.street_name().replace("'", "")}', {random.randint(1,100)}, {random.randint(0,10)}, 'Code123', {round(random.uniform(31,33),6)}, {round(random.uniform(34,36),6)}, {i});\n")

    # 3. EMERGENCY_DISPATCHES (20,000) - Missing previously
    f.write("\n-- SECTION: EMERGENCY_DISPATCHES\n")
    for i in range(1, NUM_HUGE + 1):
        d_time = fake.date_between(start_date='-2y', end_date='today')
        f.write(f"INSERT INTO EMERGENCY_DISPATCHES VALUES ({i}, 'VEH-{random.randint(100,999)}', '{d_time}', '{d_time + timedelta(minutes=10)}', '{d_time + timedelta(minutes=40)}', {i});\n")

    # 4. MEDICAL_MEASUREMENTS (20,000)
    f.write("\n-- SECTION: MEDICAL_MEASUREMENTS\n")
    for i in range(1, NUM_HUGE + 1):
        systolic = random.randint(110, 160)
        f.write(f"INSERT INTO MEDICAL_MEASUREMENTS VALUES ({i}, '2024-01-01', {systolic}, {systolic-40}, {random.randint(60,100)}, {random.randint(95,100)}, {i}, {random.choice(EXISTING_IDS)});\n")

    # 5. PROCEDURES_PERFORMED (500) - Missing previously
    f.write("\n-- SECTION: PROCEDURES_PERFORMED\n")
    for i in range(1, NUM_REGULAR + 1):
        f.write(f"INSERT INTO PROCEDURES_PERFORMED VALUES ({i}, 'Checkup', '2024-01-01', 'Success', {random.randint(1, NUM_HUGE)}, {random.choice(EXISTING_IDS)});\n")

    # 6. TRANSFER_SUMMARIES (500) - Missing previously
    f.write("\n-- SECTION: TRANSFER_SUMMARIES\n")
    for i in range(1, NUM_REGULAR + 1):
        f.write(f"INSERT INTO TRANSFER_SUMMARIES VALUES ({i}, 'Dr. Levi', 'Patient Stable', '2024-01-01', {random.randint(1, NUM_HUGE)}, {random.choice(EXISTING_IDS)});\n")

print("Done! All 10 tables are now covered in the SQL file.")