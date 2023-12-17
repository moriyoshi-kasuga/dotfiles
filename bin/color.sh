#!/usr/bin/env sh
# shellcheck disable=2034

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# COLOR OUTPUT (3/4 bit version)
NC="[0m" # Color reset

# Normal (0;)
BLACK="[0;30m"
RED="[0;31m"
GREEN="[0;32m"
YELLOW="[0;33m"
BLUE="[0;34m"
PURPLE="[0;35m"
CYAN="[0;36m"
WHITE="[0;37m"

# Bold (1;)
BLACK_B="[1;30m"
RED_B="[1;31m"
GREEN_B="[1;32m"
YELLOW_B="[1;33m"
BLUE_B="[1;34m"
PURPLE_B="[1;35m"
CYAN_B="[1;36m"
WHITE_B="[1;37m"

# Italic (3;)
BLACK_I="[3;30m"
RED_I="[3;31m"
GREEN_I="[3;32m"
YELLOW_I="[3;33m"
BLUE_I="[3;34m"
PURPLE_I="[3;35m"
CYAN_I="[3;36m"
WHITE_I="[3;37m"

# Underlined (4;)
BLACK_U="[4;30m"
RED_U="[4;31m"
GREEN_U="[4;32m"
YELLOW_U="[4;33m"
BLUE_U="[4;34m"
PURPLE_U="[4;35m"
CYAN_U="[4;36m"
WHITE_U="[4;37m"

# Blinking (5;)
BLACK_BL="[5;30m"
RED_BL="[5;31m"
GREEN_BL="[5;32m"
YELLOW_BL="[5;33m"
BLUE_BL="[5;34m"
PURPLE_BL="[5;35m"
CYAN_BL="[5;36m"
WHITE_BL="[5;37m"

# Background (4*m)
BLACK_BG="[40m"
RED_BG="[41m"
GREEN_BG="[42m"
YELLOW_BG="[43m"
BLUE_BG="[44m"
PURPLE_BG="[45m"
CYAN_BG="[46m"
WHITE_BG="[47m"

# High Intensty
BLACK_HI="[0;90m"
RED_HI="[0;91m"
GREEN_HI="[0;92m"
YELLOW_HI="[0;93m"
BLUE_HI="[0;94m"
PURPLE_HI="[0;95m"
CYAN_HI="[0;96m"
WHITE_HI="[0;97m"

# High Intensty Bold
BLACK_HI_B="[1;90m"
RED_HI_B="[1;91m"
GREEN_HI_B="[1;92m"
YELLOW_HI_B="[1;93m"
BLUE_HI_B="[1;94m"
PURPLE_HI_B="[1;95m"
CYAN_HI_B="[1;96m"
WHITE_HI_B="[1;97m"

# High Intensty Background
BLACK_HI_BG="[0;100m"
RED_HI_BG="[0;101m"
GREEN_HI_BG="[0;102m"
YELLOW_HI_BG="[0;103m"
BLUE_HI_BG="[0;104m"
PURPLE_HI_BG="[10;95m"
CYAN_HI_BG="[0;106m"
WHITE_HI_BG="[0;107m"
