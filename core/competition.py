from utils.helpers import generate_id

class Competition:
    def __init__(self, name, description, start_date, end_date, prize):
        self.competition_id = generate_id()
        self.name = name
        self.description = description
        self.start_date = start_date
        self.end_date = end_date
        self.prize = prize
        self.participants = {}  # {user_id: points}

    def to_dict(self):
        return {
            "competition_id": self.competition_id,
            "name": self.name,
            "description": self.description,
            "start_date": self.start_date,
            "end_date": self.end_date,
            "prize": self.prize,
            "participants": self.participants
        }

    def add_points(self, user_id, points):
        self.participants[user_id] = self.participants.get(user_id, 0) + points
