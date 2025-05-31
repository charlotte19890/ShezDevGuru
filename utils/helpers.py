
import uuid
from datetime import datetime
import smtplib
from email.message import EmailMessage

def generate_id():
    return str(uuid.uuid4())

def current_timestamp():
    return datetime.now().isoformat()


def send_email(to_email, subject, body):
    # Replace these with your actual Gmail credentials
    sender_email = "your_email@gmail.com"
    sender_password = "your_app_password"  # Use an App Password if 2FA is enabled

    # Compose the email
    msg = EmailMessage()
    msg["From"] = sender_email
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.set_content(body)

    try:
        # Connect to the Gmail SMTP server
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
            smtp.login(sender_email, sender_password)
            smtp.send_message(msg)
        print(f"📧 Email sent to {to_email}")
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
