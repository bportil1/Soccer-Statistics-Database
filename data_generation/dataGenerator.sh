#!/bin/bash

dos2unix dataGenLib.sh

source dataGenLib.sh

echo "Club Selection File Name:"
read clubNames

echo "Writing clubIDinp"
clubIDinpGen $clubNames
echo "Finished Writing clubIDinp"

echo "Writing clubPersInp"
clubPersGen $clubNames
echo "Finshed Writing clubPersInp"

echo "Writing matchInp"
matchInsertGenAnnual
echo "Finished Writing matchInp" 

echo "Writing matchRostInp"
matchInvPersGen
echo "Finished Writing matchRostInp"

echo "Writing match_goal Files"
matchGoalGen mEV
echo "Finished match_goal Files"

echo "Writing match_sub Files"
matchSubGen mEV
echo "Finished match_sub Files"

echo "Writing match_card Files"
matchCardGen mEV
echo "Finished match_card Files"

echo "Finished Data Generator"
