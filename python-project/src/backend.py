from flask import Flask, jsonify

app = Flask(__name__)

# Example data to return
data = [
    {"name": "Ronaldo", "age": 40},
    {"name": "Hazard", "age": 34},
    {"name": "Leo", "age": 37},
    {"name": "Ibra", "age": 41},
    {"name": "Kane", "age": 34},
]

@app.route('/api/players')
def get_players():
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
