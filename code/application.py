from flask import Flask
import datetime, os

app = Flask(__name__)

@app.route("/")
def hello():
    # get greeting/timeformat from envvars, with sensible defaults
    greeting = os.environ.get("GREETING", "hello CTM!")
    time_format = os.environ.get("TIME_FORMAT", "%d/%m/%Y, %H:%M:%S")
    now = datetime.datetime.now().strftime(time_format)
    return f"{greeting}, it is {now}\n"


if __name__ == "__main__":
    port = int(os.environ.get("port", 5000))
    app.run(debug=True,host='0.0.0.0',port=5000)