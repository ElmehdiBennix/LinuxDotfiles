#!/bin/env bash

if hyprctl devices | grep -B 6 "main: yes" | grep -q "capsLock: yes"; then
    echo "󰪛"
fi
