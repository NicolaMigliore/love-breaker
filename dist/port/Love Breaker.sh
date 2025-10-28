#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"

get_controls

GAMEDIR=/$directory/ports/love_breaker
CONFDIR="$GAMEDIR/conf/"

mkdir -p "$GAMEDIR/conf"
cd $GAMEDIR

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Set the XDG environment variables for config & savefiles
# export XDG_DATA_HOME="$CONFDIR"
export XDG_DATA_HOME="/storage/love_breaker"

#  If XDG Path does not work
# Use bind_directories to reroute that to a location within the ports folder.
# bind_directories ~/.love_breaker $GAMEDIR/conf/.love_breaker 
bind_directories ~/.love_breaker /storage/love_breaker

# export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

source $controlfolder/runtimes/"love_11.5"/love.txt

# Run the love runtime
$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "love" -c "./game.gptk" &
./love game
# $GPTOKEYB "$LOVE_GPTK" &
# pm_platform_helper "$LOVE_BINARY"
# $LOVE_RUN "$GAMEDIR/game"

pm_finish