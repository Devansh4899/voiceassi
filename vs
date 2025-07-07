import speech_recognition as sr
import pyttsx3
import datetime
import wikipedia
import webbrowser
import pywhatkit


engine = pyttsx3.init()
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[1].id)

def speak(text):
    engine.say(text)
    engine.runAndWait()

def wish_user():
    hour = datetime.datetime.now().hour
    if hour < 12:
        speak("Good morning!")
    elif hour < 18:
        speak("Good afternoon!")
    else:
        speak("Good evening!")
    speak("I'm your assistant. How can I help you?")

def take_command():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        print("Listening...")
        r.pause_threshold = 1
        audio = r.listen(source)
    try:
        print("Recognizing...")
        query = r.recognize_google(audio, language='en-in')
        print(f"You said: {query}")
    except Exception:
        speak("Sorry, I didn't catch that. Please say it again.")
        return None
    return query.lower()

def run_assistant():
    wish_user()
    while True:
        query = take_command()
        if query is None:
            continue

        if "wikipedia" in query:
            speak("Searching Wikipedia...")
            result = wikipedia.summary(query.replace("wikipedia", ""), sentences=2)
            speak(result)

        elif "open youtube" in query:
            webbrowser.open("https://youtube.com")

        elif "open google" in query:
            webbrowser.open("https://www.google.com")

        elif "what is time" in query:
            time_str = datetime.datetime.now().strftime("%H:%M:%S")
            speak(f"The time is {time_str}")

        elif"open spotify" in query:
            webbrowser.open("https://open.spotify.com/")
        
        elif "play" in query and "on youtube" in query:
                song = query.replace("play", "").replace("on youtube", "").strip()
                speak(f"Playing {song} on YouTube.")
                pywhatkit.playonyt(song)

        elif "exit" in query or "stop" in query:
            speak("Goodbye!")
            break

run_assistant()
