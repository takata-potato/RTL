# Evaluated by the simulator at time zero, before the first run.
database -open waves -shm -into waves.shm -default
probe -create -shm [scope -tops] -all -depth all
