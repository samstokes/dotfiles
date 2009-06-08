#!/usr/bin/python

from BaseHTTPServer import HTTPServer
from SimpleHTTPServer import SimpleHTTPRequestHandler

def serve(server_address = ('', 80)):
  server = HTTPServer(server_address, SimpleHTTPRequestHandler)
  server.serve_forever()

if __name__ == "__main__":
  from sys import argv
  if argv[1:]:
    serve((argv[1], int(argv[2])))
  else:
    serve()
