from utils.helpers import generate_id

class Reward:
    def __init__(self, name, description, cost, category):
        self.reward_id = generate_id()
        self.name = name
        self.description = description
        self.cost = cost
        self.category = category
        self.is_active = True

    def to_dict(self):
        return self.__dict__
