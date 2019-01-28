from threading import Thread, Lock
from datetime import datetime
import time


shared_resource = ""
lock = Lock()

modify_readers = Lock();
n_readers = 0;

def wait(): time.sleep(2)

def acquire_reader():
    global n_readers, modify_readers
    modify_readers.acquire()

    n_readers += 1;
    if(n_readers == 1): lock.acquire()

    modify_readers.release()
###

def release_reader():
    global n_readers, modify_readers
    modify_readers.acquire()

    n_readers -= 1;
    if(n_readers == 0): lock.release()

    modify_readers.release()
###

def write_normal():
    while True:
        lock.acquire()

        print("Writing normal")
        global shared_resource
        shared_resource = datetime.now()

        lock.release()
        wait()
###

def write_reverse():
    while True:
        lock.acquire()

        print("Writing reverse")
        global shared_resource
        shared_resource = str(datetime.now() )[::-1]

        lock.release()
        wait()
###

def read():
    while True:
        acquire_reader();

        #print("Reading")
        global shared_resource
        print(shared_resource);

        release_reader();
        wait()
###

w1 = Thread(target=write_normal)
w2 = Thread(target=write_reverse)

r1 = Thread(target=read)
r2 = Thread(target=read)
r3 = Thread(target=read)

w1.start();
w2.start();
#print("Writers running.")

r1.start();
r2.start();
r3.start();
#print("Readers running.")
