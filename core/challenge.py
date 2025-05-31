from utils.helpers import generate_id

class Challenge:
    def __init__(self, name, description, points, category):
        self.challenge_id = generate_id()
        self.name = name
        self.description = description
        self.points = points
        self.category = category
        self.is_active = True

    def to_dict(self):
        return self.__dict__
