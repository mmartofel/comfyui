#!/usr/bin/python3

"""
A script that starts ComfyUI and then kills it 
once it gets to the point when it awaits access via web UI.

When you start ComfyUI for the first time, 
its plugins download required dependencies automatically.
I want to run this during docker container build 
so these dependencies would be written into the image.
"""

import subprocess
import time
import os
import signal
import tempfile
import psutil

def kill_all(proc):
	parent = psutil.Process(proc.pid)
	for child in parent.children(recursive=True):
		child.kill()
	parent.kill()

def run_command(command, target_text):
	#####################
	# from https://stackoverflow.com/a/53495265

	temp_file = tempfile.NamedTemporaryFile(delete=False)
	temp_file.close()
	path = temp_file.name
	command = command + [" > ", path]

	# Start the subprocess
	process = subprocess.Popen(" ".join(command), stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)

	try:
		while True:
			with open(path, 'r') as f:
				data = f.read()
			if target_text in data:
				kill_all(process)
				break

			time.sleep(5)

	except KeyboardInterrupt:
		# Handle keyboard interrupt (Ctrl+C)
		print("Process interrupted. Terminating subprocess.")
		kill_all(process)
	finally:
		# Close the subprocess
		process.communicate()
		process.wait()

		os.unlink(path)


# Example usage:
command_to_run = ["python3", "main.py", "--listen=0.0.0.0", "--preview-method", "auto", "--cpu"]
target_output_text = "To see the GUI go to:"

run_command(command_to_run, target_output_text)
