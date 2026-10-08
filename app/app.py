#!/usr/bin/env python3
"""DevOps student application.

Prints student information and starts a small web server that returns
the same information. Values are taken from environment variables,
if a variable is not set the default value from config/app.conf is used.
"""

import os
import signal
import sys
from datetime import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG_FILE = os.path.join(BASE_DIR, "config", "app.conf")


def read_config(path):
    """Read KEY=VALUE lines from the config file."""
    config = {}
    if not os.path.exists(path):
        log("WARNING", f"Config file {path} not found")
        return config
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            config[key.strip()] = value.strip()
    return config


def log(level, message):
    time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{time} {level} {message}", flush=True)


def get_value(key, default=""):
    # environment variable has priority over the config file
    return os.environ.get(key) or CONFIG.get(key, default)


def build_message():
    line = "=" * 32
    return "\n".join([
        line,
        "DevOps Student Application",
        line,
        f"Name: {get_value('STUDENT_NAME')}",
        f"Surname: {get_value('STUDENT_SURNAME')}",
        f"Group: {get_value('STUDENT_GROUP')}",
        f"Student ID: {get_value('STUDENT_ID')}",
        "",
        "Application is running successfully!",
    ])


class StudentHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = "OK\n"
        else:
            body = build_message() + "\n"
        data = body.encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, format, *args):
        log("INFO", f"Request {self.command} {self.path} from {self.client_address[0]}")


def stop(signum, frame):
    # docker stop sends SIGTERM, Ctrl+C sends SIGINT
    log("INFO", f"Application stopped (signal {signum})")
    sys.exit(0)


CONFIG = read_config(CONFIG_FILE)


def main():
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    print(build_message(), flush=True)

    port = int(get_value("APP_PORT", "8000"))
    server = HTTPServer(("0.0.0.0", port), StudentHandler)
    log("INFO", f"Web server started on port {port}")
    try:
        server.serve_forever()
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
