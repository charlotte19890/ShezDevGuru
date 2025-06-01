from core.user import User
from core.activity import Activity
from core.reward import Reward
from db.data_manager import load_json, save_json
from utils.helpers import current_timestamp, speak

def create_user():
    """
    Prompt the user to input a username and email, then create a new User instance.
    The new user is added to the 'users.json' file with initial point values.
    
    Steps:
    - Collect username and email via user input.
    - Create a new User object and convert it to a dictionary.
    - Append the user to the existing users loaded from 'users.json'.
    - Save the updated list back to the file.
    - Print confirmation of user creation.
    """
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
    """
    Log a user activity and update their points based on predefined activity types.

    Steps:
    - Load existing users and display them for selection.
    - Prompt the user to choose an activity type and description.
    - Create a new Activity instance and add it to 'activities.json'.
    - Update the selected user’s points according to POINTS_MAP.
    - Save the updated user list back to 'users.json'.
    - Print a confirmation of the points added.
    """
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
    """
    Display the top 10 users ranked by their points.

    Steps:
    - Load users from 'users.json'.
    - Sort users in descending order of points.
    - Display the top 10 users with their rank and point total.
    """
    users = load_json("users.json")
    leaderboard = sorted(users, key=lambda x: x['points'], reverse=True)
    print("\n🏆 Leaderboard:")
    for i, u in enumerate(leaderboard[:10]):
        print(f"{i + 1}. {u['username']} - {u['points']} pts")
        speak("Here is the leaderboard.")

def join_competition():
    """
    Allow a user to join a monthly competition by contributing points.

    Special Handling:
    - For "toyota_starlet_draw_2025", the user must have spent R800 or more.
    - Other competitions allow manual point entry.

    Steps:
    - Load users and competitions.
    - Prompt selection of user and competition.
    - Validate and calculate points to be added based on competition rules.
    - Update the competition's participant list and save it.
    - Print confirmation of participation and earned points.
    """
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
    """
    Display the leaderboard for a selected competition.

    Steps:
    - Load competitions and display available options.
    - Prompt user to select a competition.
    - Sort and display participants by their earned points.
    - Show user IDs (shortened) and corresponding points.
    """
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
    """
    Allow a user to redeem a reward if they have enough points.

    Steps:
    - Load users and rewards.
    - Prompt selection of user and reward.
    - Check if user has enough points.
    - Deduct points and record the redemption in 'redemptions.json'.
    - Save updated user data and confirm reward redemption.
    """
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
    """
    Add the 'Toyota Starlet Draw 2025' competition to the system if it doesn't already exist.

    The competition requires users to spend at least R800 to qualify.
    Details such as draw date, time, and venue are predefined.
    """
    competitions = load_json("competitions.json")
    for c in competitions:
        if c.get("competition_id") == "toyota_starlet_draw_2025":
            return  # Already added

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
    """
    Entry point for the Swift Fuel Loyalty Console application.

    Runs a continuous loop displaying the main menu, allowing the user to:
    - Create a user
    - Log activity
    - Redeem rewards
    - View leaderboard
    - Join a competition
    - View competition leaderboard
    - Exit the program

    The Toyota Starlet competition is added at startup if not already present.
    """
    add_starlet_competition()

    while True:
        # Display the menu (vertical list)
        print("\n=== Swift Fuel Loyalty Console ===")
        print("Spend R800 to enter Toyota Starlet draw! Draw: 2 August 2025 at 15:00 in Senwabarwana.")
        print("1. Create User")
        print("2. Log Activity")
        print("3. Redeem Reward")
        print("4. View Leaderboard")
        print("5. Join Monthly Competition")
        print("6. Show Competition Leaderboard")
        print("0. Exit")

        # Speak the options (female voice already configured)
        menu_text = (
            "Swift Fuel Loyalty Console. Spend 800 Rand to enter the Toyota Starlet draw. "
            "The draw is on the second of August 2025 at 3 PM in Senwabarwana. "
            "Press 1 to create user. Press 2 to log activity. Press 3 to redeem a reward. "
            "Press 4 to view leaderboard. Press 5 to join monthly competition. "
            "Press 6 to show competition leaderboard. Press 0 to exit."
        )
        speak(menu_text)

        # Get input
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
        elif choice == "0":
            break
        else:
            print("❌ Invalid choice")

if __name__ == "__main__":
    main()