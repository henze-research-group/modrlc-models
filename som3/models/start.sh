#!/bin/bash
echo "TESTING: starting BOPTEST"
cd ../../..
ls
sudo gnome-terminal -x sh -c "make run TESTCASE=som3"
#sudo xterm -hold -e make run TESTCASE=som3
