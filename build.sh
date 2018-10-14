#!/bin/bash

#duration
START_TIME=$SECONDS

#cd /Users/chris/Downloads/Temp
#cd  /Users/ccomeau/Documents/Temp

#cleanup
clear

echo "Building..."

#old?
#xcodebuild -workspace /Users/chris/Documents/RepositoryBitbucket/CoinBlock/CoinBlock.xcworkspace -scheme "CoinBlock"  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | tee xcodebuild.log | xcpretty

#good, no codesign
#xcodebuild -workspace /Users/ccomeau/Documents/Temp/test2/coinblock/CoinBlock.xcworkspace -scheme "CoinBlock"  CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | tee xcodebuild.log | xcpretty

#test, debug, simulator?
#xcodebuild -workspace /Users/ccomeau/Documents/Temp/test2/coinblock/CoinBlock.xcworkspace -scheme "CoinBlock"  -configuration "Debug" -arch i386 -sdk iphoneos11.2 CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | tee xcodebuild.log | xcpretty
xcodebuild -workspace /Users/ccomeau/Documents/Temp/temp2/coinblock/CoinBlock.xcworkspace -scheme "CoinBlock"  -configuration "Debug" -destination 'platform=iOS Simulator,name=iPhone X,OS=11.2' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO | tee xcodebuild.log | xcpretty


#duration
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"

#remove log
rm xcodebuild.log

#wait
echo "Done."

#sleep 300
#tail -f /dev/null
