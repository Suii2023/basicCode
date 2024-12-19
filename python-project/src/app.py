from flask import Flask, render_template
import requests

app = Flask(__name__)

#backend exposed at port 5001
BACKEND_URL = "http://backend-python-service:5001/api/players"

@app.route('/')
def hello():
    response = requests.get(BACKEND_URL)
    playersList = response.json()
    return render_template('index.html', playersList=playersList)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
