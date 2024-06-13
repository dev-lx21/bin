#!/bin/bash
# lx-tools script von -lx-


# -------------------------------------------------------------------------------------
# --- BILDER in ein bestimmtes format/aufloesung umwandeln: -----------------------------------------
# -------------------------------------------------------------------------------------
#
# -checken ob format groesser ist als HD 1280x960, falls ja muss umgewandelt werden:


if ( [ "$1" == "-R" ] )
    then
    flagFRAGErename="true"
    pfad=$2
    flag_update=$3
    flag_aufruf_intern=$4
else
    flagFRAGErename="false"
    pfad=$1
    flag_update=$2
    flag_aufruf_intern=$3
fi

#pfad=$1
#flag_update=$2
#flag_aufruf_intern=$3
zeit_start=`date`
flag_rename="false"

# START pfad-kontrolle -----------------------------------
# den pfad pruefen, ggf korrigieren, ggf FEHLER ausgeben!
# -ist bei internem aufruf nicht erforderlich:
if ( [ "$flag_aufruf_intern" != "true" ] )
  then
  if ( [ "$pfad" == "" ] )
    then
    #echo -e "--- pfad-ist-leer ---"
    # aktueller ort wird als pfad angenommen:
    pfad=`pwd`
    #kdialog --msgbox="Pfad: $pfad"
  fi
  #echo -e "--- pfad-ist-nicht-leer ---"
  # pfad wurde uebergeben oder mittels pwd gesetzt!
  # pfad pruefen und ggf FEHLER ausgeben:
  if ( [ -d "$pfad" ] )
    then
    # wenn pfad auf ein existierendes Verzeichnis zeigt: kein fehler
    # WICHTIG: den slash an den pfad haengen:
    pfad=$pfad"/"
    fehler=0
  elif ( [ -f "$pfad" ] )
    then
    # wenn pfad auf eine existierende datei zeigt: kein fehler
    #kdialog --msgbox="Pfad: $pfad"
    fehler=0
  else
    fehler=1
    kdialog --title="FEHLER" --error="FEHLER:\nDas Verzeichnis lässt sich nicht öffnen. Bitte überprüfen Sie Ihre Eingabe! Vielleicht ein Tippfehler oder ungenügende Zugriffsrechte.\n\nVerzeichnis:\n$pfad\n\n\nDas Script wird beendet."
    exit 0;
  fi
fi
# ENDE pfad-kontrolle -----------------------------------





# -----------------------------------------------
# --- parameter liste beachten ------------------
extension=".*"
#name_datei_playliste="00_alle_pls.m3u"
#name_datei_update="00_alle_pls_update.sh"
#echo -e "$extension"
#suchpfad_speichern_pls=*$extension
suchpfad=$pfad*$extension
#echo -e "$suchpfad"
flag_stop=0
# -----------------------------------------------
# -----------------------------------------------



# wird nur beim ersten aufruf der datei ausgefuehrt:
if ( [ "$flag_aufruf_intern" != "true" ] )
    then
    # script namen und zeit_start anzeigen:
    echo -e "***"
    echo -e "***"
    echo -e "*** START: $zeit_start"
    echo -e "***************************************************************"
    echo -e "***************** convert pics script von -lx- ****************"
    echo -e "*** FORMAT: JPG"
    echo -e "*** AUFLOESUNG: 1280x960 bzw 720x960"
    if ( [ "$flagFRAGErename" == "true" ] )
        then
        kdialog --title="lx-RENAME starten?" --caption="Pics 2 1280" --warningcontinuecancel="=== lx-pic: =====================================<br><br>
    -Beim Rename Prozess werden Leer- und Sonderzeichen entfernt. Dieser<br>
    &nbsp;Vorgang ist sehr rechenintensiv, haben Sie daher etwas Geduld.<br>
    -Standard ist ohne Rename fort zu fahren. Um diesen Prozess trotzdem<br>
    &nbsp;zu starten klicken Sie bitte auf \"Mit RENAME\"!<br><br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Wollen Sie das <b>lx-RENAME</b> Script starten?<br><br>
    <br><hr><br>
    -Beim Rename Prozess werden Leer- und Sonderzeichen entfernt. Dieser<br>
    &nbsp;Vorgang ist sehr rechenintensiv, haben Sie daher etwas Geduld.<br>
    -Standard ist ohne Rename fort zu fahren. <b>ENTER</b><br>
    -Um den Rename Prozess zu starten, klicken Sie auf: <b>Mit RENAME</b><br><br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Wollen Sie das lx-RENAME Script starten?<br><br>
    <br><hr><br>
    Beim Rename Prozess werden Leer- und Sonderzeichen entfernt. Dieser Vorgang<br>
    ist sehr rechenintensiv, haben Sie daher etwas Geduld.<br><br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Das <b>lx-RENAME</b> Script starten?<br><br>
    Zum Starten des Rename Prozess klicken Sie bitte auf \"Mit RENAME\"!<br>
    Standard ist ohne Rename zu starten.<br><br>
    <br><hr><br>
    Falls die Dateinamen bzgl. Leer- und Sonderzeichen bereinigt<br>
    werden sollen, wählen Sie bitte <b>Mit RENAME</b>!<br>
    Da der Rename Prozess sehr rechenintensiv ist, wird er<br>
    normalerweise nicht gestartet. Bitte haben Sie daher ggf.<br>
    etwas Geduld.<br><br>" --continue-label="Ohne RENAME" --cancel-label="Mit RENAME"
        flag_rename=$(echo -e "$?")
        #echo $flag_rename
    fi
    #exit 0;
fi



txtbox_pfad="\n\nVerzeichnis:\n$pfad"
if ( [ -f "$pfad" ] )
    then
    txtbox_pfad="\n\nDatei:\n$pfad"
fi

if ( [ "$flag_update" != "true" ] )
    then
    flag_update=false
fi

if ( [ "$flag_aufruf_intern" != "true" ] )
    then
    flag_aufruf_intern=false
fi



# ---------------------------------------------------------------------------------------
# ----- START CheckRenameConvert
# --- diese funktion erledigt das RENAME (falls gewollt), kontrolliert die aufloesung,
# --- startet bei bedarf AVCONV und erstellt die SICHERUNGSDATEI *.bak
# ---------------------------------------------------------------------------------------
function CheckRenameConvert () {
    # ----- erwartet nur $i -----
    i_check=${i//[a-zA-Z0-9_\-\.\/]/}
    if ( [ -n "$i_check" ] && [ "$flag_rename" == "2" ] )
        then
        debug="Pfad: $pfad - I: $i --- vor rename aufruf ---\n"
        #echo $debug
        #kdialog --title="DEBUG: $debug" --warningcontinuecancel="$txtbox_debug1$debug$txtbox_debug2$txtbox_weiter"
        /home/lx21/bin/lxRENAME "$i" "false" "einzelne_datei"
        #echo -e "alter dateiname: $i"
        i=${i// /_}
        i=${i//[^a-zA-Z0-9_\-\.\/]/x}
        i=${i//_\-_YouTube/}
        i=${i//YouPorn_\-_/}
        #echo -e "neuer dateiname: $i"
    fi
    # -aufloesung usw. auslesen:
    #  mediainfo --Inform='Video;%Width%' video.mp* 
    i_width=`mediainfo --Inform='Image;%Width%' $i`
    i_height=`mediainfo --Inform='Image;%Height%' $i`
    #echo -e "--- aufloesung: $i_width x $i_height"
    if ( [ $i_width -gt 1280 ] && [ $i_width -gt $i_height ] )
        then
        # seitenverhaeltnis ermitteln und beibehalten
        # varINT=`echo -e "(8+5)*2" | bc`
        verhaeltnis=`echo -e "$i_width/$i_height" | bc -l`
        max_width=1280
        max_height=`echo -e "scale=0 ; 1280/$verhaeltnis" | bc -l`
        #echo -e "--- NEUE aufloesung: $max_width x $max_height"
        aufloesung=$max_width"x"$max_height
        echo -e "***"
        echo -e "***"
        echo -e "*** Zeit: `date` ...AVCONV wird gestartet!..."
        echo -e "*** Datei: $i"
        #avconv -v info -i $i -vcodec h264 -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
        function befehl () {
            ffmpeg -i $i -s $aufloesung "1280_$i"
            #avconv -v info -i $i -vcodec h264 -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
            #avconv -v info -i $i -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
        }
        befehl_txt='ffmpeg -i $i -s $aufloesung "1280_$i"'
        echo -e "*** $i --- " $befehl_txt
        #befehl
        echo -e "*** Zeit: `date` ...AVCONV wurde beendet!..."
        #mv $i $i".bak"
        echo -e "***"
        echo -e "***"
    else
        if ( [ $i_height -gt 960 ] && [ $i_height -gt $i_width ] )
            then
            # seitenverhaeltnis ermitteln und beibehalten
            # varINT=`echo -e "(8+5)*2" | bc`
            verhaeltnis=`echo -e "$i_height/$i_width" | bc -l`
            max_height=960
            max_width=`echo -e "scale=0 ; 960/$verhaeltnis" | bc -l`
            #echo -e "--- NEUE aufloesung: $max_width x $max_height"
            aufloesung=$max_width"x"$max_height
            echo -e "***"
            echo -e "***"
            echo -e "*** Zeit: `date` ...AVCONV wird gestartet!..."
            echo -e "*** Datei: $i"
            #avconv -v info -i $i -vcodec h264 -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
            function befehl () {
                ffmpeg -i $i -s $aufloesung "1280_$i"
                #avconv -v info -i $i -vcodec h264 -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
                #avconv -v info -i $i -r 25 -s $aufloesung -acodec libmp3lame "${i%.mp4}_HD.mp4"
            }
            befehl_txt='ffmpeg -i $i -s $aufloesung "1280_$i"'
            echo -e "*** $befehl_txt"
            #befehl
            echo -e "*** Zeit: `date` ...AVCONV wurde beendet!..."
            #mv $i $i".bak"
            echo -e "***"
            echo -e "***"
        else
            echo -e "***"
            echo -e "***"
            echo -e "*** Zeit: `date` ...Auflösung korrekt! Nichts zu tun!..."
            echo -e "*** Datei: $i"
            echo -e "***"
            echo -e "***"
        fi
    fi
}
# ---------------------------------------------------------------------------------------
# ----- ENDE CheckRenameConvert
# ---------------------------------------------------------------------------------------



echo -e "***************************************************************"
echo -e "*** Verzeichnis: $pfad"

i=$pfad


debug="Pfad: $pfad - I: $i\n"
#echo $debug
txtbox_debug1="--- DEBUG-Info: ----------------------------------------------\n"
txtbox_debug2="------------------------------------------------------------------\n"
txtbox_weiter="\nMöchten Sie das Skript weiter ausführen oder abbrechen?\n$0\n"
#kdialog --title="DEBUG: $debug" --warningcontinuecancel="$txtbox_debug1$debug$txtbox_debug2$txtbox_weiter"



# SONDERFALL: pfad ist datei
# nur moeglich wenn es kein interner aufruf ist!
if ( [ "$flag_aufruf_intern" != "true" ] && [ -f "$pfad" ] )
    then
    #echo -e "Pfad: $pfad --- ist datei"
    # --- die funktion CheckRenameConvert kuemmert sich um alles ---
    CheckRenameConvert
fi



# NORMALFALL: pfad ist verzeichnis und wird mittels suchpfad abgearbeitet
for i in $suchpfad
    do
    #echo -e "suchpfad: $suchpfad --- datei: $i"
    if ( [ -f "$i" ] )
        then
        nix=$i
        CheckRenameConvert
    fi
done

# --- START schleife um unterVerzeichnisse einzubinden ---------------------
# WICHTIG: wird nur ausgefuehrt wenn pfad wirklich ein verzeichnis ist!!!
if ( [ -d "$pfad" ] )
    then
    nix=$i
    for ia in $(ls --group-directories-first $pfad)
        do
        #echo -e "Pfad: $pfad --- Verzeichnis: $ia"
        uvz="$pfad$ia/"
        if ( [ -d "$uvz" ] )
            then
            echo -e "***"
            #echo -e "sprung in unterverzeichnis: $uvz"
            $0 "$uvz" "$flag_update" "true"
            #continue
        fi
    done
fi
# --- ENDE schleife um unterVerzeichnisse einzubinden ---------------------


zeit_ende=`date`
if ( [ "$flag_aufruf_intern" != "true" ] )
    then
    kdialog --title="INFO" --msgbox="Das Skript\n$0\nwurde erfolgreich ausgeführt!\n$txtbox_pfad\n\n\n"
    echo -e "***"
    echo -e "***"
    echo -e "***************************************************************"
    echo -e "*** ENDE     : normal"
    echo -e "*** Gestartet: $zeit_start"
    echo -e "*** Beendet  : $zeit_ende"
    echo -e "***************************************************************"
fi

















