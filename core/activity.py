from utils.helpers import generate_id, current_timestamp


class Activity:
    def __init__(self, user_id, activity_type, description):
        self.activity_id = generate_id()
        self.user_id = user_id
        self.activity_type = activity_type
        self.description = description
        self.date_created = current_timestamp()

    def to_dict(self):
        return self.__dict__
