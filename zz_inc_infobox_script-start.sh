#!/bin/bash
# script von -lx-


# pfad="$1"
# flag_update=$2
# flag_aufruf_intern=$3
# zeit_start=`date`
# flag_rename="false"


txt_script_name="$1"




kdialog --title="Info zum Script:" --caption="$txt_script_name" --warningcontinuecancel="== Informationen zum Start: =========<br><br>Das lx-RENAME Script starten?<br><br>Falls die Dateinamen bzgl. Leer- und Sonderzeichen<br>kontrolliert und korrigiert werden sollen, wählen<br>Sie bitte <b>Mit RENAME</b>!<br>" --continue-label="Ohne RENAME" --cancel-label="Mit RENAME"
flag_rename=$(echo -e "$?")
if [[ "$flag_rename" == "2" ]]
    then
    echo -e "*** Sonder- und Leerzeichen in Dateinamen korrigieren:"
    # eventuelle sonder- und leerzeichen aus den dateinamen loeschen:
    /home/lx21/bin/lxRENAME "$pfad" "false" "true"
    echo -e "***"
fi





