from utils.helpers import generate_id, current_timestamp

class User:
    def __init__(self, username, email):
        self.user_id = generate_id()
        self.username = username
        self.email = email
        self.points = 0
        self.tier = "Bronze"
        self.created_at = current_timestamp()

    def to_dict(self):
        return self.__dict__
