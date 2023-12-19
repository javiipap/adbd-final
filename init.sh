#!/usr/bin/sh

if [ ! -d "env" ]; then
    echo "\033[1;34mNo environment found. Creating one...\033[0m"
    python3 -m venv env
    . env/bin/activate
    echo "\033[0;34mVirtual environment created and activated for script execution.\033[0m"
    echo "-------------------------------"
    echo "\033[0;32mInstalling requirements...\033[0m"
    pip install -r requirements.txt
fi

if [ "x$(which python)" != "x$VIRTUAL_ENV/bin/python" ]; then
  echo "\033[1;33m-------------------------------"
  echo "You are not in the virtual environment. Run 'source env/bin/activate' to activate it.\033[0m"
  . env/bin/activate
  echo "\033[0;33mVirtual environment activated only for script execution."
  echo "-------------------------------\033[0m"
fi

echo "\033[0;34mStarting app...\033[0m"
python main.py
