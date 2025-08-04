from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    db_pass = os.environ.get("DB_PASSWORD", "Not Found")
    # In a real app, you'd use this password to connect to a DB.
    # Here we just display a part of it for demonstration.
    return f"<h1>Hello from the Guestbook App!</h1><p>DB Password starts with: {db_pass[:3]}...</p>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)