from core.user import User
from core.activity import Activity
from core.reward import Reward
from db.data_manager import load_json, save_json
from utils.helpers import current_timestamp, speak
from core import spin
from core.spin import spin_wheel



def create_user():
    username = input("Username: ")
    email = input("Email: ")
    user = User(username, email)
    users = load_json("users.json")
    users.append(user.to_dict())
    save_json("users.json", users)
    print(f"✅ Created user {username}")
    speak(f"User {username} created successfully.")

POINTS_MAP = {
    "fuel_purchase": 10,
    "login": 1,
    "referral": 25
}

def log_activity():
    users = load_json("users.json")
    if not users:
        print("❌ No users found.")
        return

    for i, u in enumerate(users):
        print(f"{i + 1}. {u['username']} ({u['email']})")
    choice = int(input("Select user by number: ")) - 1
    user = users[choice]

    act_type = input("Activity type (fuel_purchase, login, referral): ").strip().lower()
    description = input("Description: ")

    activity = Activity(user['user_id'], act_type, description)
    activities = load_json("data/activities.json")
    activities.append(activity.to_dict())
    save_json("activities.json", activities)

    earned = POINTS_MAP.get(act_type, 0)
    user['points'] += earned
    users[choice] = user
    save_json("users.json", users)

    print(f"✅ Activity logged. {earned} points added to {user['username']}.")
    speak("Activity logged successfully.")

def view_leaderboard():
    users = load_json("users.json")
    leaderboard = sorted(users, key=lambda x: x['points'], reverse=True)
    print("\n🏆 Leaderboard:")
    for i, u in enumerate(leaderboard[:10]):
        print(f"{i + 1}. {u['username']} - {u['points']} pts")
        speak("Here is the leaderboard.")

def join_competition():
    users = load_json("users.json")
    competitions = load_json("competitions.json")

    if not users or not competitions:
        print("❌ Missing data.")
        return

    for i, u in enumerate(users):
        print(f"{i + 1}. {u['username']}")
    u_idx = int(input("Select user: ")) - 1
    user = users[u_idx]

    for i, c in enumerate(competitions):
        print(f"{i + 1}. {c['name']} ({c['start_date']} - {c['end_date']})")
    c_idx = int(input("Select competition: ")) - 1
    competition = competitions[c_idx]

    if competition['competition_id'] == "toyota_starlet_draw_2025":
        amount_spent = float(input("Enter amount spent: R"))
        if amount_spent < 800:
            print("❌ Minimum R800 spend required to enter.")
            return
        points = int(amount_spent // 10)
    else:
        points = int(input("Points earned this month: "))

    comp_participants = competition.get("participants", {})
    comp_participants[user['user_id']] = comp_participants.get(user['user_id'], 0) + points
    competition["participants"] = comp_participants

    competitions[c_idx] = competition
    save_json("competitions.json", competitions)

    print(f"✅ {user['username']} earned {points} pts in {competition['name']}")
    speak("You have joined the competition.")

def show_competition_leaderboard():
    competitions = load_json("competitions.json")
    for i, c in enumerate(competitions):
        print(f"{i + 1}. {c['name']}")
    c_idx = int(input("View which competition? ")) - 1
    comp = competitions[c_idx]
    if not comp["participants"]:
        print("No participants yet.")
        return
    sorted_lb = sorted(comp["participants"].items(), key=lambda x: x[1], reverse=True)
    print(f"\nLeaderboard for {comp['name']}:")
    for i, (uid, pts) in enumerate(sorted_lb):
        print(f"{i + 1}. User ID {uid[:8]}... - {pts} pts")
        speak("This is the competition leaderboard.")

def redeem_reward():
    users = load_json("users.json")
    rewards = load_json("rewards.json")

    if not users or not rewards:
        print("❌ Users or rewards data is missing.")
        return

    for i, u in enumerate(users):
        print(f"{i + 1}. {u['username']} - {u['points']} pts")
    u_idx = int(input("Select user: ")) - 1
    user = users[u_idx]

    for i, r in enumerate(rewards):
        print(f"{i + 1}. {r['name']} - {r['cost']} pts")
    r_idx = int(input("Select reward to redeem: ")) - 1
    reward = rewards[r_idx]

    if user['points'] >= reward['cost']:
        user['points'] -= reward['cost']
        redemption = {
            "user_id": user['user_id'],
            "reward_id": reward['reward_id'],
            "timestamp": current_timestamp(),
            "reward_name": reward['name']
        }
        redemptions = load_json("redemptions.json")
        redemptions.append(redemption)
        save_json("redemptions.json", redemptions)

        users[u_idx] = user
        save_json("users.json", users)

        print(f"🎁 {user['username']} redeemed {reward['name']}")
    else:
        print("❌ Not enough points")

def add_starlet_competition():
    competitions = load_json("competitions.json")
    for c in competitions:
        if c.get("competition_id") == "toyota_starlet_draw_2025":
            return

    competition = {
        "competition_id": "toyota_starlet_draw_2025",
        "name": "Win a Toyota Starlet",
        "description": "Spend R800 to stand a chance to win a Toyota Starlet!",
        "start_date": "2025-06-01",
        "end_date": "2025-08-02",
        "draw_date": "2025-08-02",
        "draw_time": "15:00",
        "venue": "Senwabarwana",
        "entry_requirement": "Spend R800",
        "participants": {}
    }
    competitions.append(competition)
    save_json("competitions.json", competitions)
    print("✅ Toyota Starlet competition added.")
    speak("Reward redeemed.")

def main():
    add_starlet_competition()

    while True:
        print("\n=== Swift Fuel Loyalty Console ===")
        print("Spend R800 to enter Toyota Starlet draw! Draw: 2 August 2025 at 15:00 in Senwabarwana.")
        print("1. Create User")
        print("2. Log Activity")
        print("3. Redeem Reward")
        print("4. View Leaderboard")
        print("5. Join Monthly Competition")
        print("6. Show Competition Leaderboard")
        print("7. Spin the Wheel")
        print("0. Exit")

        menu_text = (
            "Swift Fuel Loyalty Console. Spend 800 Rand to enter the Toyota Starlet draw. "
            "The draw is on the second of August 2025 at 3 PM in Senwabarwana. "
            "Press 1 to create user. Press 2 to log activity. Press 3 to redeem a reward. "
            "Press 4 to view leaderboard. Press 5 to join monthly competition. "
            "Press 6 to show competition leaderboard. Press 7 to spin the wheel. Press 0 to exit."
        )
        speak(menu_text)

        choice = input("Choose: ")

        if choice == "1":
            create_user()
        elif choice == "2":
            log_activity()
        elif choice == "3":
            redeem_reward()
        elif choice == "4":
            view_leaderboard()
        elif choice == "5":
            join_competition()
        elif choice == "6":
            show_competition_leaderboard()
        elif choice == "7":
            result = spin_wheel()
            print(f"🎉 Result: {result}")
            speak(result)
        elif choice == "0":
            break
        else:
            print("❌ Invalid choice")

if __name__ == "__main__":
    main()