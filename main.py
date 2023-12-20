from src import app
from dotenv import load_dotenv
import os


if __name__ == '__main__':
    load_dotenv()
    app.run(debug=os.environ.get('DEBUG') == 'True',
            host=os.environ.get('HOST'),
            port=os.environ.get('PORT'))
