#!/usr/bin/sh

if [ ! -d "env" ]; then
    python3 -m venv env
    source env/bin/activate
    pip install -r requirements.txt
fi

if [ "x$(which python)" != "x$VIRTUAL_ENV/bin/python" ]; then
  echo "You are not in the virtual environment. Run 'source env/bin/activate' to activate it."
  . env/bin/activate
  echo "Virtual environment activated only for script execution."
fi

python main.py
