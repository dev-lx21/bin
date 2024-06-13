#!/bin/bash
# script von -lx-


extVORBELEGUNG="$1"
extDATEI="$2"
extTITEL="$3"


# -Display testen:
if [[ `tty` != *dev* ]]
then
    # -wenn KEIN Display vorhanden ist, handelt es sich um einen Cronjob, also kann
    #  die Sicherheitsfrage nicht beantwortet werden! deshalb hier abbrechen:
    exit 0;
fi




#strSICHERHEITSFRAGE=$(kdialog --title="Sicherheitsfrage $extDATEI" --menu="<br>Gestartet wird: <b>$extDATEI</b><br><br>Möchten Sie wirklich fortfahren und $extDATEI jetzt starten?" 0 "Besser abbrechen!" 2  "Start fortsetzen!"); echo -e "Sicherheitsfrage: $strSICHERHEITSFRAGE\\nStatus: "$(echo -e "$?")

# kdialog --title="Sicherheitsfrage $extDATEI" --warningcontinuecancel=\
# "Gestartet wird: <b>$extDATEI</b><br>"\
# "Beschreibung: \ \ <b>$extTITEL</b><br><br>"\
# "Möchten Sie wirklich fortfahren und $extDATEI jetzt starten?<br>" \
# --continue-label="Besser abbrechen!" --cancel-label="Start fortsetzen!"

strSICHERHEITSFRAGE=$(kdialog --title="Sicherheitsfrage $extDATEI" --menu="<br>Gestartet wird: <b>$extDATEI</b><br><br>Möchten Sie wirklich fortfahren und $extDATEI jetzt starten?" 0 "Besser abbrechen!" 2  "Start fortsetzen!")
checkDIALOG=$(echo -e "$?")
checkEXITcode=$?

checkDIALOGsts=$checkDIALOG
checkDIALOG=$strSICHERHEITSFRAGE

checkDIALOGfehler="|- Der Vorgang wurde durch einen anderen Prozess, einen internen Fehler oder den Benutzer abgebrochen!\\n|- Das Skript wird daher beendet."

# -WICHTIG: $strEXITcode wird an Elternprozess übergeben!
strEXITcode=$checkDIALOG
txtDEBUG="|- DEBUG-Infos: checkDIALOG: $checkDIALOG - checkEXITcode: $checkEXITcode"
# -Case für Dialogüberwachung: warningcontinuecancel, inputbox
# -Case für Prozessüberwachung
case "$checkDIALOG" in
    (0)
        # -warningcontinuecancel: Keine Fehler und keinen Button angeklickt...
        # -EXITcode: Keine Fehler!
        checkDIALOGfehler=""
        ;;
    (1)
        # -warningcontinuecancel: Keine Fehler, continue, Benutzer hat geklickt oder Return mit Fokus gedrückt!
        # -EXITcode: Abbruch durch anderen Prozess, internen Fehler oder den Benutzer:
        checkDIALOGfehler="|- Der Vorgang wurde durch einen anderen Prozess, einen internen Fehler oder den Benutzer abgebrochen!\\n|- Das Skript wird daher beendet."
        strEXITcode="1"
        ;;
    (2)
        # -warningcontinuecancel: Keine Fehler, cancel, Benutzer hat geklickt oder Return mit Fokus gedrückt!
        # -EXITcode: Abbruch durch den Benutzer:
        checkDIALOGfehler="|- Der Vorgang wurde durch den Benutzer abgebrochen!\\n|- Das Skript wird daher beendet."
        strEXITcode="2"
        ;;
    (*)
        # -warningcontinuecancel, EXITcode:
        #  Ein interner Fehler ist aufgetreten! Der EXITcode enthält die Fehlernummer, allerdings nur wenn der
        #  fehlerverursachende Prozess diese übergibt. Wenn eine Prozessüberwachung den Fehler bemerkt hat, versucht
        #  diese die Fehlernummer auszulesen. Funktioniert das nicht, wird (hoffentlich) ein entsprechender eigener
        #  EXITcode ausgegeben.
        checkDIALOGfehler="|- Der Vorgang wurde durch einen anderen Prozess, einen internen Fehler oder den Benutzer abgebrochen!\\n|- Das Skript wird daher beendet."
        strEXITcode="30"
        ;;
esac

if [[ "$checkDIALOG" == "2" ]]
then
    # -Abbrechen wurde gewählt: siehe cancel Label (Start fortsetzen!)
    # -Abbrechen ist Weiter. Damit Benutzer wirklich bewusst den Prozess fortsetzt.
    # -Erfolgreich EXITcode setzen: 0 - Keine Fehler!
    # --Standard EXITcode wird überschrieben:
    strEXITcode="0"
    exit $strEXITcode;
else
    # -Weiter wurde gewählt: Benutzer muss bewusst Weiter wählen, daher ist das normale Weiter ein Abbrechen!
    # --Standard EXITcode wird überschrieben:
    strEXITcode="1"
    exit $strEXITcode;
fi













