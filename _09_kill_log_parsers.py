import sys 
import os



is_running = "is_running_controller_00.txt"
is_terminating = "is_terminating_controller_00.txt"

if __name__ == "__main__":
    
    if len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " <anything>")
        exit(1)

    # Add is_sterminating
    with open(is_terminating, 'w') as fp:
        pass
    # Remove is_running
    if os.path.exists(is_running):
        os.remove(is_running)
    
