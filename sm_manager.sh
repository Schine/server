#!/bin/bash

#
# Simple Server Manager
#
# Description Following
#
# 
#
#
#
#
#
#
#

# Begin Functions

# Load server config - param: directory to look in
sm_loadserver() {
    if [ -z "$1" ]
        then
            sm_failserver No_Server
            SPATH=""
            CFGPATH=""
        else
            # Load Config
            SPATH="./"
            SPATH+=$1
            SPATH+="/"
            DNAME=$1
            CFGPATH=$SPATH
            CFGPATH+=$CONFIGNAME
            if [ -f $CFGPATH ]
                then source $CFGPATH
                else sm_failserver No_Config
            fi
    fi
}

# Set Failsave config values - param: Add to name
sm_failserver() {
    if [ -z "$1" ]
        then
            # Set Failsave Values (No parameter)
            NAME="ERROR"

        else
            NAME="ERROR ("
            NAME+="$1"
            NAME+=")"
        
    fi
            PORT=""
            SCREENID=""

}

# Display Statusline of current loaded config
sm_summary() {
        TLENGHT=0 # Coloumn is now 0
        # Form Line

        # Name
        let TLENGHT=30 # Reserve chars (color codes!)
        LINE+="$(tput setaf 6)"
        LINE+=$NAME
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE+=" "
        done

        # Port
        let TLENGHT+=24 # Reserve chars (color codes!)
        LINE+="$(tput sgr 0) Port: $(tput setaf 3)"
        LINE+=$PORT
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE+=" "
        done


        # Version
        let TLENGHT+=32 # Reserve chars (color codes!)
        LINE+="$(tput sgr 0) Version: $(tput setaf 3)"

        TMP=$SPATH
        TMP+="StarMade/version.txt"
        if [ -f $TMP ]
            then TMP2=$(cat $TMP)
            else TMP2="error"
        fi
        LINE+=${TMP2%#*}
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE+=" "
        done

        # Screen
        let TLENGHT+=32 # Reserve chars (color codes!)
        LINE+="$(tput sgr 0) Screen: $(tput setaf 4)"
        LINE+=$SCREENID
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE+=" "
        done

        # Status
        let TLENGHT+=38 # Reserve chars (color codes!)
        LINE+="$(tput sgr 0) Status: "
        sm_cstatus
        case $CSTATUS in
            ru*|sta*) LINE+="$(tput setaf 2)$CSTATUS$(tput sgr 0)" ;; # running, starting (green)
            sto*|cr*) LINE+="$(tput setaf 1)$CSTATUS$(tput sgr 0)" ;; # stopped, crashed (red)
            un*) LINE+="$(tput setaf 5)$CSTATUS$(tput sgr 0)" ;; # unknown (orange)
            *) LINE+="$(tput setaf 3)$CSTATUS$(tput sgr 0)" ;;        # anything else (yellow)
        esac
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE+=" "
        done

        # Output
        echo "$LINE $(tput sgr 0)"
}

# Screen stuff - start server
sm_start() {
    if [ -n "$1" ]
        then

            echo "run" > $WANTPATH
            sm_cstatus
            case $CSTATUS in
                shut*|run*) # shutdown or running (still running, no special handler)
                    if [ -n "$SCREENID" ]
                        then
                        if [ -f $INFOPATH ]
                            then
                            echo "running" > $INFOPATH
                        fi
                        screen -S "$SCREENID" -p 0 -X stuff "/server_message_broadcast info \"Server-Manager\\\nreturning to normal\\\nShutdown cancelled\"`echo -ne '\015'`"
                        screen -S "$SCREENID" -p 0 -X stuff "/shutdown -1`echo -ne '\015'`"
                    fi ;;

                *) # Start-Server in Screen
                    # Prevent double start?
                    if [ -n "$(eval "screen -list | grep $SCREENID")" ]
                        then
                            # Other Screen found
                            echo "Screenname $SCREENID already in use, skipping start"
                        else
                            # No other screen found
                            echo "Starting Server: $NAME"
                            echo "Screenname: $SCREENID"
                            echo "starting" > $INFOPATH
                            screen -dmSL $SCREENID -s /bin/bash ./sm_manager.sh loop $DNAME
                    fi
                    sleep 1 ;;

            esac

    fi
}

# Screen stuff - stop server
sm_stop() {
    if [ -n "$1" ]
        then

            echo "stop" > $WANTPATH
            if [ -f $SPATH/StarMade/logs/logstarmade.0.log.lck ]
                then
                    echo "shutdown" > $INFOPATH
                    if [ -n "$SCREENID" ]
                        then
                            screen -S "$SCREENID" -p 0 -X stuff "/server_message_broadcast error \"Server-Manager\\\nShutdown initiated\\\nNO RESTART\"`echo -ne '\015'`"
                            screen -S "$SCREENID" -p 0 -X stuff "/shutdown 300`echo -ne '\015'`"
                    fi
                else
                    echo "stopped" > $INFOPATH 
            fi
    fi
}

# Screen stuff - restart server
sm_restart() {
    if [ -n "$1" ]
        then

            echo "restart" > $WANTPATH
            if [ -f $INFOPATH ]
                then
                    echo "shutdown" > $INFOPATH
            fi
            if [ -n "$SCREENID" ]
                then
                screen -S "$SCREENID" -p 0 -X stuff "/server_message_broadcast error \"Server-Manager\\\nRestarting Server\"`echo -ne '\015'`"
                screen -S "$SCREENID" -p 0 -X stuff "/shutdown 60`echo -ne '\015'`"

            fi

    fi
}


# Screen stuff - update server
sm_update() {
    if [ -n "$1" ]
        then
            sm_getupdate "$UPDCHAN"

            echo "Channel: $UPDCHAN"
            echo "Current Zip: $CURZIP"
            echo "Current Version: $CURVER"
            echo "Channel: installed"
            TMP=$SPATH
            TMP+="StarMade/version.txt"
            if [ -f $TMP ]
                then INSTVER=$(cat $TMP)
                else INSTVER="error"
            fi
            echo "Installed Version: $INSTVER"
            if [ "$CURVER" = "$INSTVER" ]
                then
                    # Version matching - All fine
                    echo "No Update Needed"

                else
                    # Version not matching
                    echo "Update found"

                    echo "update" > $WANTPATH
                    echo "shutdown" > $INFOPATH
                    if [ -n "$SCREENID" ]
                        then
                        screen -S "$SCREENID" -p 0 -X stuff "/server_message_broadcast info \"Server-Manager\\\nUpdate to Version:\\\n$CURVER\"`echo -ne '\015'`"
                        screen -S "$SCREENID" -p 0 -X stuff "/shutdown 60`echo -ne '\015'`"
                    fi

                    sleep 5
                    

            fi

    fi
}

# Update - Channel
sm_getupdate() {
    if [ -z "$1" ]
        then
            # Error Param - Do all?
            echo "No parameter given"
            exit 0

        elif [ "$1" = "rel" ]
            then
                # Load Release Channel
                wget -q -O tmp.html $RELPATH
                RELEASE_URL=`cat tmp.html | grep -o -E "[^<>]*?.zip" | tail -1`
                rm tmp.html
                if [ -f $RELEASE_URL ]
                    then
                        echo "Found local copy of $RELEASE_URL unsing it for updates."
                    else
                        wget --user dev --password dev $RELPATH/$RELEASE_URL
                fi
                CURZIP=$RELEASE_URL
            
        elif [ "$1" = "dev" ]
            then
                # Load dev Channel
                wget -q -O tmp.html $DEVPATH
                DEV_URL=`cat tmp.html | grep -o -E "[^<>]*?.zip" | tail -1`
                rm tmp.html
                if [ -f $DEV_URL ]
                    then
                        echo "Found local copy of $DEV_URL using it for updates."
                    else
                        wget --user dev --password dev $DEVPATH/$DEV_URL
                fi
                CURZIP=$DEV_URL
        elif [ "$1" = "pre" ]
            then
                # Load pre Channel
                wget -q -O tmp.html $PREPATH
                PRE_URL=`cat tmp.html | grep -o -E "[^<>]*?.zip" | tail -1`
                rm tmp.html
                if [ -f $PRE_URL ]
                    then
                        echo "Found local copy of $PRE_URL using it for updates."
                    else
                        wget --user dev --password dev $PREPATH/$PRE_URL
                fi
                CURZIP=$PRE_URL

        elif [ "$1" = "man" ]
            then
                # Load Manual Files
                CURZIP=$MANPATH

        else
            echo "Error Detected - Script malfunction"
            sleep 5
            exit 0

    fi
    # CURZIP defined - prepare comparing of variables

    CURVER=$(unzip -p $CURZIP version.txt)
}


# Get Current Status
sm_cstatus() {
        INFOPATH=$SPATH
        INFOPATH+=$STATUSNAME
        if [ -f $INFOPATH ]
            then
                CSTATUS="$(cat $INFOPATH)" # Content managed by loopscript/UPD requests
            else
                CSTATUS="unknown"
            
        fi
}

# Get Wanted Status
sm_wstatus() {
        WANTPATH=$SPATH
        WANTPATH+=$STATUSWANT
        if [ -f $WANTPATH ]
            then
                WSTATUS="$(cat $WANTPATH)" # Content managed by Controlscript
            else
                WSTATUS="unknown"
            
        fi
}

# Main Menu
sm_mainmenu() {
    clear
    echo "MainMenu"
    echo ""

    if [ -n "$SERVER1" ] 
        then
            # Load Config
            sm_loadserver $SERVER1
            LINE="1: "
            sm_summary
    fi
    if [ -n "$SERVER2" ] 
        then
            # Load Config
            sm_loadserver $SERVER2
            LINE="2: "
            sm_summary
    fi
    if [ -n "$SERVER3" ] 
        then
            # Load Config
            sm_loadserver $SERVER3
            LINE="3: "
            sm_summary
    fi

    if [ -n "$SERVER4" ] 
        then
            # Load Config
            sm_loadserver $SERVER4
            LINE="4: "
            sm_summary
    fi

    if [ -n "$SERVER5" ] 
        then
            # Load Config
            sm_loadserver $SERVER5
            LINE="5: "
            sm_summary
    fi

    if [ -n "$SERVER6" ] 
        then
            # Load Config
            sm_loadserver $SERVER6
            LINE="6: "
            sm_summary
    fi

    if [ -n "$SERVER7" ] 
        then
            # Load Config
            sm_loadserver $SERVER7
            LINE="7: "
            sm_summary
    fi

    if [ -n "$SERVER8" ] 
        then
            # Load Config
            sm_loadserver $SERVER8
            LINE="8: "
            sm_summary
    fi

    if [ -n "$SERVER9" ] 
        then
            # Load Config
            sm_loadserver $SERVER9
            LINE="9: "
            sm_summary
    fi
}

# Mainmenu (input)
sm_maininput() {

    echo "Maininput - $INPUT"
    # Input to Server
    if [ "$INPUT" = "1" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER1
    elif [ "$INPUT" = "2" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER2
    elif [ "$INPUT" = "3" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER3
    elif [ "$INPUT" = "4" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER4
    elif [ "$INPUT" = "5" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER5
    elif [ "$INPUT" = "6" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER6
    elif [ "$INPUT" = "7" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER7
    elif [ "$INPUT" = "8" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER8
    elif [ "$INPUT" = "9" ]
        then 
            PROGSTATE=1
            sm_loadserver $SERVER9
    elif [ "$INPUT" = "r" ]
        then 
            $PROGSTATE=0
    fi
}

# Servermenu (Display)
sm_servermenu() {
    clear
    echo "ServerMenu"
    echo ""

        TLENGHT=30
        # Name
        LINE="Servername: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$NAME
        echo "$LINE $(tput sgr 0)"

        # Port
        LINE="Server-Port: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$PORT
        echo "$LINE $(tput sgr 0)"


        # visualVM-Port
        LINE="VisualVM-Port: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$[$PORT - 909]
        echo "$LINE $(tput sgr 0)"


        # Version
        LINE="Version: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        TMP=$SPATH
        TMP+="StarMade/version.txt"

        if [ -f $TMP ]
            then 
                TMP2=$(cat $TMP) 
                LINE+=${TMP2%#*}
            else 
                TMP2=""
        fi
        echo "$LINE $(tput sgr 0)"

        # Build
        LINE="Build: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        TMP=$SPATH
        TMP+="StarMade/version.txt"

        if [ -f $TMP ]
            then 
                TMP2=$(cat $TMP) 
                LINE+=${TMP2#*#}
            else 
                TMP2=""
        fi
        echo "$LINE $(tput sgr 0)"

        # Expected status
        LINE="Expected Status: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        sm_wstatus
        case $WSTATUS in
            ru*|sta*) LINE+="$(tput setaf 2)$WSTATUS" ;; # running, starting (green)
           sto*|cr*) LINE+="$(tput setaf 1)$WSTATUS" ;; # stopped, crashed (red)
            un*) LINE+="$(tput setaf 5)$WSTATUS" ;; # unknown (orange)
            *) LINE+="$(tput setaf 3)$WSTATUS" ;;        # anything else (yellow)
        esac
        echo "$LINE $(tput sgr 0)"

        # Current Status
        LINE="Current Status: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        sm_cstatus
        case $CSTATUS in
            ru*|sta*) LINE+="$(tput setaf 2)$CSTATUS" ;; # running, starting (green)
           sto*|cr*) LINE+="$(tput setaf 1)$CSTATUS" ;; # stopped, crashed (red)
            un*) LINE+="$(tput setaf 5)$CSTATUS" ;; # unknown (orange)
            *) LINE+="$(tput setaf 3)$CSTATUS" ;;        # anything else (yellow)
        esac
        echo "$LINE $(tput sgr 0)"

        # Path
        LINE="Folder: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$SPATH
        echo "$LINE $(tput sgr 0)"

        # CFG-Path
        LINE="Config: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$CFGPATH
        echo "$LINE $(tput sgr 0)"

        # ScreenID
        LINE="SceenID: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$SCREENID
        echo "$LINE $(tput sgr 0)"

        # UPD
        LINE="Update Mode: $(tput setaf 6)"
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        if [ -z "$UPDCHAN" ]
            then
                LINE+="Off"
            else
                LINE+="$UPDCHAN"
        fi

        echo "$LINE $(tput sgr 0)"
        # LOG
        LINE="Timestamp (log): "

        TMP=$SPATH
        TMP+="StarMade/logs/logstarmade.0.log"
        TIME1=$(date +%s)
        if [ -f $TMP ]
            then TIME2=$(stat -c %Y $TMP)
            else TIME2=0
        fi
        
        let DIFF=( $TIME1 - $TIME2 )
        if [ $DIFF -lt 300 ]
            then  LINE+="$(tput setaf 2)"
            else  LINE+="$(tput setaf 1)"
        fi
 
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        LINE+=$DIFF
        LINE+=" seconds ago"
        echo "$LINE $(tput sgr 0)"

        # Startup
        LINE="Last start: $(tput setaf 6)"
        TMP=$SPATH
        TMP+="StarMade/logs/logstarmade.0.log.lck"
        TIME1=$(date +%s)
        if [ -f $TMP ]
            then TIME2=$(stat -c %Z $TMP)
            else TIME2=0
        fi
        let DIFF=( $TIME1 - $TIME2 )
        while [ ${#LINE} -lt $TLENGHT  ] # TempExtension - Looking for better way to do this
            do LINE=" $LINE"
        done
        let DIFF=( $DIFF / 3600 )
        LINE+=$DIFF
        LINE+=" hours ago"
        echo "$LINE $(tput sgr 0)"

        sm_wstatus

        if [ "$WSTATUS" != "run"  ]
            then echo "1: $(tput setaf 2)start$(tput sgr 0)"
            else echo "1:"
        fi

        if [ "$WSTATUS" = "run" ]
            then echo "2: $(tput setaf 2)restart$(tput sgr 0)"
            else echo "2:"
        fi

        if [ "$WSTATUS" != "stop" ]
            then echo "3: $(tput setaf 2)stop$(tput sgr 0)"
            else echo "3:"
        fi

        if [ "$WSTATUS" != "update" -a -n "$UPDCHAN" ]
            then echo "4: $(tput setaf 2)update$(tput sgr 0)"
            else echo "4:"
        fi
        if [ -n "RELPATH" -o -n "DEVPATH" ]
            then echo "5: $(tput setaf 2)change Update source$(tput sgr 0)"
            else echo "5:"
        fi

        echo "r: $(tput setaf 3)return to main$(tput sgr 0)"
}

# Mainmenu (input)
sm_serverinput() {

    sm_wstatus

    if [ "$INPUT" = "1" -a "$WSTATUS" != "run" ]
        then
            # Start Server
            sm_start $SPATH

    elif [ "$INPUT" = "2" -a "$WSTATUS" = "run" ]
        then
            # Restart Server
            sm_restart $SPATH
    elif [ "$INPUT" = "3" -a "$WSTATUS" != "stop" ]
        then
            # Stop Server
            sm_stop $SPATH
    elif [ "$INPUT" = "4" -a "$WSTATUS" != "update" ]
        then
            # Update Server
            sm_update $SPATH
    elif [ "$INPUT" = "r" ]
        then 
            PROGSTATE=0
    fi

}



# End Functions

# Begin Main Code

# Load settings

if [ -f sm_config.cfg ]
    then 
        source "sm_config.cfg"
        PROGSTATE=0

    else
        PROGSTATE=200
        
fi



if [ -z $1 ] 
    then 
        # No Params - MenuMode

        
        INPUT=""

        while [ $PROGSTATE -lt 100 ]

            # PROGSTATES
            # 0    = Mainmenu
            # 1-9  = Servermenu
            # 100  = Exit

            do

            # Mainmenu
            if [ $PROGSTATE -eq 0 ] 
                then sm_mainmenu
            elif [ $PROGSTATE -ge 1 ]  
                then sm_servermenu
            fi

            # Wait for Input
            echo "q: $(tput setaf 1)quit$(tput sgr 0)"
            printf "Input:"
            read INPUT

            # Process input (Menu)
            if [ $PROGSTATE -eq 0 ]
                then sm_maininput
            elif [ $PROGSTATE -eq 1 ]
                then sm_serverinput
            fi

            # Process input (Global)
            if [ "$INPUT" = "q" ]
                then PROGSTATE=100
            fi
        done

    else
        # Parameter added - Loopmode
        if [ "$1" = "loop" ]
            # Loopmode to spawn in screen
            then
                # load config
                if [ -f "./sm_config.cfg" ]
                    then
                        echo "Reloading main config"
                        source ./sm_config.cfg
                    else
                        echo "Warning - Main Config file missing"
                        exit 0
                fi
                # Load Server
                if [ -n "$2" ]
                then
                    echo "Loading Server $2"
                    sm_loadserver $2
                else 
                    echo "This mode is designated to use by manager itself"
                    echo "Parameters required: 2"
                    exit 2
                    
                fi
                # Validate server
                if [ -f $CFGPATH ] 
                    then
                        echo "Config loaded from $CFGPATH"
                        echo "Changing to: $(pwd)/$DNAME"
                        cd $(pwd)/$DNAME
                        # Check config sanity
                        # Wanted status?
                        if [ -f $STATUSWANT ]
                            then 
                                WSTATUS=$(cat $STATUSWANT)
                                echo "Expected Status: $WSTATUS"
                            else
                                echo "Could not read wanted status, please start this script via Server-Manager"
                                exit 0 
                        fi
                        # Current status
                        if [ -f $STATUSNAME ]
                            then 
                                CSTATUS=$(cat $STATUSNAME)
                                echo "Current Status: $CSTATUS"
                            else
                                echo "Could not read current status..."
                                if [ -f ./StarMade/logs/logstarmade.0.log.lck ]
                                    then 
                                        echo "...Server seems running, please remove $(pwd)/$DNAME/StarMade/logs/logstarmade.0.log.lck"
                                        exit 0
                                    else
                                        echo "...Server not running creating statusfile"
                                        echo "stopped" > $STATUSNAME
                                fi
                        fi
                    else
                        echo "Error - No Config file found at $CFGPATH"
                        exit 0
                fi
    
                # Mark Current status
                echo "Starting" > $STATUSNAME
    
                # Entering loop - base config OK
                while true;
                    do
                    # Reload main config
                    if [ -f "./../sm_config.cfg" ]
                        then
                            echo "Reloading main config"
                            source ./../sm_config.cfg
                        else
                            echo "Warning - Main Config file missing"
                            exit 0
                    fi
                    # Prequel (Reload Server) - Begin Main Loop
                    if [ -f $CONFIGNAME ] 
                        then
                            echo "Config (re)loaded from $CONFIGNAME"
                            source $CONFIGNAME
                            # Check config sanity
                            # Wanted status?
                            if [ -f $STATUSWANT ]
                                then 
                                    WSTATUS=$(cat $STATUSWANT)
                                    echo "Expected Status: $WSTATUS"
                                else
                                    echo "Could not read wanted status, file missing ($STATUSWANT)"
                                    echo "ConfigError - Wanted status" > $STATUSNAME
                                    exit 0
                            fi
                            # Current status
                            if [ -f $STATUSNAME ]
                                then 
                                    CSTATUS=$(cat $STATUSNAME)
                                    echo "Current Status: $CSTATUS"
                                else
                                    echo "Could not read wanted status, file missing ($STATUSWANT)"
                                    echo "ConfigError - Current status" > $STATUSNAME
                                    exit 0
                            fi
                        else
                            echo "Error - No Config file found at $CONFIGNAME"
                            exit 0
                    fi

                    # Prequel Passed - ready to work
                    # Update Current Status
                    if [ "$CSTATUS" = "running" ]
                        then
                            # Reaching prestart, while expected running -> assume crash
                            # or manual shutdown (avoid false positive on crash by taillog?)
                            echo "crashed" > $STATUSNAME
                            CSTATUS="crashed"
                        else
                            echo "stopped" > $STATUSNAME
                            CSTATUS="stopped"
                    fi

                    # Save Logs
                    LOGNAME="Build"
                    if [ -f ./StarMade/version.txt ]
                        then 
                            TMP=$(cat ./StarMade/version.txt) 
                            LOGNAME+=${TMP#*#}
                        else 
                            LOGNAME+="undef"
                    fi
                    LOGNAME+="-$DNAME-"
                    if [ "$CSTATUS" = "crashed" ]
                        then
                            LOGNAME+="crash"
                        else
                            LOGNAME+="$WSTATUS"
                    fi
                    LOGNAME+="on$(date '+%Y%m%d-%H%M%S')"
                    mv -f ./StarMade/logs $LOGDIR/$LOGNAME

                    # Update
                    if [ "$WSTATUS" = "update" ] 
                        then
                            echo "updating" > $STATUSNAME
                            CSTATUS="updating"
                            echo "run" > $STATUSWANT
                            WSTATUS="run"
                            cd ..
                            sm_getupdate $UPDCHAN
                            cd $DNAME
                            unzip -o ./../$CURZIP -d $(pwd)/StarMade

                    fi


                    # Go for Startup
                    if [ "$WSTATUS" = "stop" ]
                        then
                            echo "Shutdown requested, NOT restarting."
                            sleep 5
                            exit 0
                    fi


                    # Pause before start
                    echo "(re)entering loop"
                    echo "Name: $NAME"
                    echo "Port: $PORT"
                    echo "Path: $(pwd)"
                    echo "MAX-MEMORY: $MAXMEM"
                    echo "MIN-MEMORY: $MINMEM"
                    echo "Hit ctrl + c now, to exit loop (5sec)"
                    sleep 5
                    echo "starting...."
    
                    echo "running" > $STATUSNAME
                    cd StarMade

                    java -Dcom.sun.management.jmxremote.host=144.76.174.130 -Dcom.sun.management.jmxremote.port=$[$PORT - 909] -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -XX:-OmitStackTraceInFastThrow -Xms$MINMEM -Xmx$MAXMEM -server -jar StarMade.jar -server -port:$PORT
                    sleep 5
                    cd ..
                    echo "exited...."
    



                done

                PROGSTATE=130
                sleep 5
        elif [ "$1" = "config" ] 
            # Config mode (Create?)
            then
                echo "Configmode"
                PROGSTATE=180
                sleep 5
        fi

fi


echo "Exited (5 sec delay) PROG: $PROGSTATE"
sleep 5

