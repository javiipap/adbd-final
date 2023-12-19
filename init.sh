#!/usr/bin/sh

if [ ! -d "env" ]; then
    python3 -m venv env
    source env/bin/activate
    pip install -r requirements.txt
fi

if [ "x$(which python)" != "x$VIRTUAL_ENV/bin/python" ]; then
  echo "\033[1;33m-------------------------------"
  echo "You are not in the virtual environment. Run 'source env/bin/activate' to activate it.\033[0m"
  . env/bin/activate
  echo "\033[0;33mVirtual environment activated only for script execution."
  echo "-------------------------------\033[0m"
fi

python main.py
