from utils.helpers import generate_id

class Badge:
    def __init__(self, name, description, category):
        self.badge_id = generate_id()
        self.name = name
        self.description = description
        self.category = category
        self.is_active = True

    def to_dict(self):
        return self.__dict__
