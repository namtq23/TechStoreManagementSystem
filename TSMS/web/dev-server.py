#!/usr/bin/env python3
import http.server
import socketserver
import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class ReloadHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.is_directory:
            return
        if event.src_path.endswith(('.html', '.css', '.js')):
            print(f"📁 File changed: {event.src_path}")
            print("🔄 Refresh your browser to see changes")

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

    def log_message(self, format, *args):
        print(f"🌐 {self.address_string()} - {format % args}")

def start_server():
    PORT = 8080
    Handler = CustomHTTPRequestHandler
    
    # File watcher
    event_handler = ReloadHandler()
    observer = Observer()
    observer.schedule(event_handler, '.', recursive=True)
    observer.start()
    
    print(f"🚀 Development server starting...")
    print(f"📂 Serving directory: {os.getcwd()}")
    print(f"🌐 Local URL: http://localhost:{PORT}")
    print(f"📱 Your page: http://localhost:{PORT}/nhap-hang.html")
    print(f"👀 Watching for file changes...")
    print(f"⏹️  Press Ctrl+C to stop")
    print("-" * 50)
    
    try:
        with socketserver.TCPServer(("", PORT), Handler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        observer.stop()
    observer.join()

if __name__ == "__main__":
    start_server()