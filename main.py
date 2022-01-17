import os
from flask import Flask
app = Flask(__name__)

# environment = os.environ.get("ENV", "NO_ENV")
# var_1 = os.environ.get("VAR_1", "NO_VAR_1")

@app.route('/')
def hello_world():
    return 'Devops Interview App 1 \n message: {}'.format(os.environ.get("MESSAGE", "No message"))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
