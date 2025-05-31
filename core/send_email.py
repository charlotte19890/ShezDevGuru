import smtplib

sender_email = "your_email@gmail.com"
app_password = "your_app_password"  # Use App Password from Google
receiver_email = "recipient@example.com"
message = "Subject: Hello\n\nThis is a test email."

with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
    server.login(sender_email, app_password)
    server.sendmail(sender_email, receiver_email, message)

print("Email sent successfully.")