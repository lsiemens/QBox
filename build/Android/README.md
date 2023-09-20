# QBox build: Android
Target build directory for Android with some scripts for testing builds
localy.

## Local Testing
This directory contains a makefile to simplify local testing by automatical
extracting the .aab file into a .apk and then installed on a local device.
The script assumes that the build is saved as "QBox.aab".

The make file should be configured so that the following variables are
set correctly for your system.

    - BUNDLETOOL : location of bundletool.jar
    - KEYSTORE : your unity keystore used to sign the .aab file
    - SDK : path to the Android SDK

The command-line tool, bundletool is avaliable at the official github
repository [here](https://github.com/google/bundletool/releases).
