import pyttsx3

def speak(text):
    engine = pyttsx3.init()
    engine.say("This is a test of the speak function.")
    engine.runAndWait()

speak("Hello Sharlot! Your voice system is working.")
