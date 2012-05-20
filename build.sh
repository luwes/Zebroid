#!/bin/bash

FLEXPATH=/Developer/SDKs/flex_sdk_4.5

echo "Compiling..."
cd src
$FLEXPATH/bin/mxmlc ./Main.as -sp ./ -o ../bin/main.swf -debug=true
