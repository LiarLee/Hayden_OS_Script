#!/usr/bin/env python3
import redis
from faker import Faker
from multiprocessing import Process
import random


HOST = "redis.liarlee.site"
rc = redis.StrictRedis(host=HOST, port=6379, db=0, ssl=False)
# pool = redis.ConnectionPool(host='192.168.0.79', port=6379, decode_responses=True)
# rc = redis.Redis(connection_pool=pool)
print(rc.ping())

def adddata():
    while True:
        fake = Faker()
        ip = fake.ipv4(network=False, address_class=None, private=None)
        address = fake.address()
        city = fake.city()
        phonenumber = fake.phone_number()
        id = fake.ssn()
        email = fake.email()
        pipe = rc.pipeline()
        # pipeline command numbers.
        for i in range(2):
            name = str(random.random())
            pipe.hset(
                name,
                mapping={
                    "name": ip,
                    "addredd": address,
                    "province": city,
                    "phonenumber": phonenumber,
                    "id": id,
                    "email": email,
                },
            )
            # print("insert many record: {} -> {}", name, email)
        pipe.execute()
        # time.sleep(1)



if 1 == 1:
    process_list = []

# Process number.
    for i in range(1000):
        p = Process(target=adddata, args=("hhh",))
        p.start()
        process_list.append(p)

    for i in process_list:
        p.join()

    print("end test")
