#!/usr/bin/sh

if [ ! -d "env" ]; then
    python3 -m venv env
    source env/bin/activate
    pip install -r requirements.txt
fi

if [ "x$(which python)" != "x$VIRTUAL_ENV/bin/python" ]; then
  . env/bin/activate
fi

python main.py
