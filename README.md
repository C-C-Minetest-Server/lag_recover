# Recover from irrecoverable lag

Sometimes Minetest runs into memory leaks, ridiculous CPU consumption, or just random errors nobody knows how to solve. This mod workarounds this by restarting the server when it is in extreme lag.

Server administrators should fine-tune the settings to prevent false-positives. To prevent bad values from causing a restart loop, any players sending "hang on" can pause the restart counter.

This mod assumes you have external restart mechanics, e.g. Docker container with `restart: always`, or systemd service with `Restart=always`.
