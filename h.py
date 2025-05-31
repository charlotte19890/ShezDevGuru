# seed/seed_competitions.py
from db.data_manager import save_json
from utils.helpers import generate_id

def seed_competitions():
    competitions = [
        {
            "competition_id": generate_id(),
            "name": "May Fuel Challenge",
            "description": "Top 3 users who purchase the most fuel win big prizes.",
            "start_date": "2025-05-01",
            "end_date": "2025-05-31",
            "prize": "Free fuel vouchers",
            "participants": {},
            "is_active": True
        },
        {
            "competition_id": generate_id(),
            "name": "Referral King",
            "description": "Refer as many new users as possible in June.",
            "start_date": "2025-06-01",
            "end_date": "2025-06-30",
            "prize": "1 year of free car washes",
            "participants": {},
            "is_active": True
        }
    ]
    save_json("competitions.json", competitions)
    print("✅ Competitions seeded.")

if __name__ == "__main__":
    seed_competitions()
