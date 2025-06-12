import random
import uuid

SPIN_REWARDS = [
    "Try again next time",
    "You have won 5% off your next fueling",
    f"You have won R150 Galito’s voucher - Voucher No: {uuid.uuid4().int % 100000000}",
    "You have won a free coffee",
    "You have won R12 airtime",
    "You have won another spin"
]

def spin_wheel():
    return random.choice(SPIN_REWARDS)