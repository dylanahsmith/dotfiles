import rlcompleter
import readline
import sys
if sys.version_info[0] > 2:
    readline.parse_and_bind("tab: complete")
elif sys.version_info[0] == 2 and sys.version_info[1] >= 6:
    readline.parse_and_bind("bind ^I rl_complete")
