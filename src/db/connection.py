import os
import psycopg2
from psycopg2 import extras
from flask import g


def get_cursor():
    if 'db' not in g:
        g.db = psycopg2.connect(
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            host=os.environ['DB_HOST'],
            port=os.environ['DB_PORT'],
        )
        g.db.autocommit = True
        g.cursor = g.db.cursor(cursor_factory=extras.RealDictCursor)
    return g.cursor


def close_db(e=None):
    cursor = g.pop('cursor', None)
    if cursor is not None:
        cursor.close()

    db = g.pop('db', None)
    if db is not None:
        db.close()
