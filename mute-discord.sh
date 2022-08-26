#!/bin/bash

########################
# Kinbe's Discord Muter#
########################

#==========================================================================================
# This script is based on PipeWire-Pulse and pactl.
# its purpose is to selectivly mute audio input
# to the "Discord" binary, while allowing audio
# input to other applications (e.g. OBS).

# This script works as follows:
# 1) List current PulseAudio (PA) source-outputs.
# 2) Parse output list with AWK to identify Discord's source-output index number.
# 3) Store Discord's identifier as the DISCORD_PACTL_OUTPUT_IDX variable.
# 4) Mute the source-output to Discord w/ pactl.

# In this context, "source-outputs" are applications *receiving* output from
# an audio device (i.e. microphone), and NOT applications *producing* audio output.
#==========================================================================================

# This is a local variable that only exists while the script is ran.

DISCORD_PACTL_OUTPUT_IDX=`pactl list source-outputs | awk -v RS='Source Output #' '/Discord/ {print $1}'` ;

    # This works by setting AWK's "Record Separator" (RS) to be delimited by regex "Source Output #" instead
    # of the normal carriage return (\n), thereby allowing an entire output listing to be considered a single
    # record.  As it is the Record Separator, "Source Output #" is removed from all output.
    # We then simply search for the record containing regex "Discord" and print the first field; the index number.

if [ $DISCORD_PACTL_OUTPUT_IDX -gt 0 ] 2> /dev/null ; then
    pactl set-source-output-mute $DISCORD_PACTL_OUTPUT_IDX toggle ;
else
    printf "ERROR: Variable returned unexpected value.  Is Discord listening for audio?\n" 1>&2
fi ;
