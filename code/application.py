from flask import Flask
from datetime import datetime
from os import environ

app = Flask(__name__)


@app.route("/")
def hello():
    # get greeting/timeformat from envvars, with sensible defaults
    greeting = environ.get("GREETING", "hello CTM!")
    time_format = environ.get("TIME_FORMAT", "%d/%m/%Y, %H:%M:%S")
    now = datetime.now().strftime(time_format)
    return f"{greeting} It is {now}\n"


if __name__ == "__main__":
    port = int(environ.get("port", 5000))
    app.run(debug=False, host="127.0.0.1", port=5000)
