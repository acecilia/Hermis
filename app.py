from flask import Flask
from flask import jsonify
from flask import request
from transport_estimator import estimate_transportation_prices


app = Flask(__name__)

@app.route('/')
def index():
  city = request.args.get('city')
  airport = request.args.get('airport')
  return jsonify(estimate_transportation_prices(city=city, airport=airport))

if __name__ == '__main__':
  app.run(debug=True)
