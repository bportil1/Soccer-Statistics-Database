#!/bin/bash
#dataGenerator.sh function library

clubIDinpGen()
{
	outputFile="clubIDinp.sql"
	clubNameInp=$1
	printf "delete from club;\n" > $outputFile
	clubIDind=37
	dos2unix $clubNameInp 
	while read next_line || [ -n "$next_line" ];
	do
		printf "insert into club\nvalues\n" >> $outputFile
		printf "(\'%04d\', \'$next_line\', \'ACTIVE\');\n" "$clubIDind" >> $outputFile 
		let clubIDind=$clubIDind+2
	done < $clubNameInp
}

clubPersGen()
{
	let club_pers_id=000000
	club_pers_status=ACTIVE
	let club_id=0001
	outputFile=clubPersInp.sql
	printf "delete from club_personnel;\n" > $outputFile
	while read next_line || [ -n "$next_line" ]
	do
		for num in `seq 26`
		do
			if [[ $num == 1 ]]
			then 
				club_pers_role='COACH'
			elif [[ $num == 2 ]]
			then 
				club_pers_role='GOALKEEPER'
			elif [[ $num == 5 ]]
			then 
				club_pers_role='DEFENDER'
			elif [[ $num == 13 ]]
			then 
				club_pers_role='MIDFIELDER'
			elif [[ $num == 21 ]]
			then 
				club_pers_role='FORWARD'
			fi

			fname=`shuf -r -n 1 firstNames.txt`
			lname=`shuf -r -n 1 lastNames.txt`
		
			if [[ $club_pers_role == 'COACH' ]]
			then 
				pers_age=$[ $RANDOM % 35 + 35 ]
			else
				pers_age=$[ $RANDOM % 24 + 16]
			fi
		
			#club_personnel insertion lines
			printf "insert into club_personnel\nvalues\n" >> $outputFile
			printf "(\'$lname\', \'$fname\'" >> $outputFile
			printf ", \'%06d\', \'`shuf -r -n 1 countryNames.txt`\', \'$club_pers_role\', $pers_age, \'$club_pers_status\', \'%04d\');\n" "$club_pers_id" "$club_id" >> $outputFile
			let club_pers_id=club_pers_id+3
		done
		let club_id=club_id+2
	done < $1
}

matchInsertGenBiannual()
{
	#let matchID=1
	let matchID=460
	outputFile="matchInp.sql"
	dateOffset=0
	for clubId in `grep "^(.*;$" clubIDinp.sql | cut -d "(" -f 2 | cut -d "," -f 1`
	do
		teamIdArr[$index]=$clubId
		let index=$index+1
	done
	printf "delete from matches;\n" > $outputFile
	for num in `seq $index`
	do 
		let dateOffset=0
		for num2 in `seq $num $index`
		do
			dateCar=`date --date="$dateOffset day" +%e-%b-%Y`
			gScored1=$[ $RANDOM % 5]
			gScored2=$[ $RANDOM % 5]
			let numCar=$num2-1
			let numCar1=$num-1
			let hvInv=$numCar1+8
			if [[ $numCar -le $hvInv ]] && [[ ! $num == $num2 ]] 
			then
				#sql insert lines
				printf "insert into matches\nvalues\n" >> $outputFile
				printf "(${teamIdArr[$numCar1]}, ${teamIdArr[$numCar]}, $gScored1, $gScored2, \'$dateCar\', \'%06d\', \'0000\', \'000002\');\n" "$matchID" >> $outputFile
				let matchID=$matchID+3
				let dateOffset=$dateOffset+7
			elif [[ $numCar -gt $hvInv ]] && [[ ! $num == $num2 ]]
			then 
				#sql insert lines
				printf "insert into matches\nvalues\n" >> $outputFile
				printf "(${teamIdArr[$numCar]}, ${teamIdArr[$numCar1]}, $gScored1, $gScored2, \'$dateCar\', \'%06d\', \'0000\', \'000002\');\n" "$matchID" >> $outputFile
				let matchID=$matchID+3
				let dateOffset=$dateOffset+7
			fi
		done
	done
}

matchInsertGenAnnual()
{
	let matchID=460 
	outputFile="matchInp.sql" 
	dateCar=`date +%e-%b-%y`
	let dateOffset=0
	for clubId in `grep "^(.*;$" clubIDinp.sql | cut -d "(" -f 2 | cut -d "," -f 1` 
	do 
		teamIdArr[$index]=$clubId 
		let index=$index+1 
	done 
	printf "delete from matches;\n" > $outputFile 
	for num in `seq $index` 
	do 
		let dateOffset=0 
		for num2 in `seq $num $index`
		do
			if [[ $num2 != $num ]]
			then
				dateCar=`date --date="$dateOffset day" +%e-%b-%Y`
				gScored1=$[ $RANDOM % 5]
				gScored2=$[ $RANDOM % 5]
				let numCar=$num2-1
				let numCar1=$num-1

				#sql insert lines 
				printf "insert into matches\nvalues\n" >> $outputFile 
				printf "(${teamIdArr[$numCar1]}, ${teamIdArr[$numCar]}, $gScored1, $gScored2, \'$dateCar\', \'%06d\', \'0001\', \'000003\');\n" "$matchID" >> $outputFile 
				let matchID=$matchID+3 
				let dateOffset=$dateOffset+7
			fi
		done
	done
	dateCar=`date --date="$dateOffset day" +%e-%b-%y`
	for num in `seq $index`
	do
		let dateOffset=0
		for num2 in `seq $num $index`
		do 
			if [[ $num2 != $num ]]
			then
				dateCar=`date --date="$dateOffset day" +%e-%b-%Y`
				gScored1=$[ $RANDOM % 5]
				gScored2=$[ $RANDOM % 5]
				let numCar=$num2-1
				let numCar1=$num-1

				#sql insert lines 
				printf "insert into matches\nvalues\n" >> $outputFile 
				printf "(${teamIdArr[$numCar]}, ${teamIdArr[$numCar1]}, $gScored1, $gScored2, \'$dateCar\', \'%06d\', \'0001\', \'000003\');\n" "$matchID" >> $outputFile 
				let matchID=$matchID+3 
				let dateOffset=$dateOffset+7
			fi
		done 
	done
}


matchInvPersGen()
{
	let gScore1=0
	let gScore2=0
	currHT1=""
	currVT2=""
	outp="matchRostInp.sql"
	persList="clubPersInp.sql"
	grep "^(.*;$" matchInp.sql > matchTempSheet.txt
	printf "delete from match_inv_pers;\n" > $outp

	while read curr_game
	do 
		currHT1=`echo $curr_game | cut -d "(" -f 2 | cut -d "," -f 1`
		currVT2=`echo $curr_game | cut -d "," -f 2` 
		matchid=`echo $curr_game | cut -d "," -f 6`
		let counter=1
		for ind in `seq 5`
		do
			if [[ $ind == 1 ]]
			then
				coachH=`grep "^(.*COACH.*$currHT1.*;$" $persList | shuf -n 1 | cut -d "," -f 3` 
				coachV=`grep "^(.*COACH.*$currVT2.*;$" $persList | shuf -n 1 | cut -d "," -f 3`
				printf "insert into match_inv_pers\nvalues\n(%s, $matchid, \'COACH\', 0);\n" "$coachH" >> $outp
				printf "insert into match_inv_pers\nvalues\n(%s, $matchid, \'COACH\', 0);\n" "$coachV" >> $outp	
			elif [[ $ind == 2 ]]
			then
				let counter=1
				for val in `grep ".*GOALKEEPER.*$currHT1.*;$" $persList | shuf -n 2 | cut -d "," -f 3`
				do 
					goalieH=$val
					if [[ $counter == 1 ]]
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp
						let counter=$counter+1
					else 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi
				done
				let counter=1
				for val in `grep ".*GOALKEEPER.*$currVT2.*;$" $persList | shuf -n 2 | cut -d "," -f 3`
				do
					goalieV=$val
					if [[ $counter == 1 ]]
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieV", $matchid, \'STARTER\', 90);\n" >> $outp
						let counter=$counter+1
					else
						printf "insert into match_inv_pers\nvalues\n("$goalieV", $matchid, \'SUB\', 0);\n" >> $outp
					fi
				done
			elif [[ $ind == 3 ]]
			then
				let timeDiff=$[ $RANDOM % 45 ]
				let totmin=90-$timeDiff
				let counter=1
				for val in `grep ".*DEFENDER.*$currHT1.*;$" $persList | shuf -n 6 | cut -d "," -f 3`
				do
					goalieH=$val 
					if [[ $counter  == 1 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp
						let counter=$counter+1
					elif [[ $counter < 5 ]]
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp
						let counter=$counter+1
					elif [[ $counter == 5 ]]
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp 
						let counter=$counter+1
					else 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi
			 	done
			 	let counter=1
			 	let timeDiff=$[ $RANDOM % 45 ]
			 	let totmin=90-$timeDiff
			 	for val in `grep ".*DEFENDER.*$currVT2.*;$" $persList | shuf -n 6 | cut -d "," -f 3` 
			 	do 
					goalieH=$val 
					if [[ $counter  == 1 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter < 5 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp 
						let counter=$counter+1 
				 	elif [[ $counter == 5 ]]
				 	then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp
					 	let counter=$counter+1
					else 
					 	printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi 
				done 
		
			elif [[ $ind == 4 ]]
			then
				let counter=1
				let timeDiff=$[ $RANDOM % 45 ]
				let totmin=90-$timeDiff
				for val in `grep ".*MIDFIELDER.*$currHT1.*;$" $persList | shuf -n 6 | cut -d "," -f 3` 
				do 
					goalieH=$val  
					if [[ $counter  == 1 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter < 5 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 5 ]] 
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp
						let counter=$counter+1
					else
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi 
				done 
				let counter=1
				let timeDiff=$[ $RANDOM % 45 ]
				let totmin=90-$timeDiff
				for val in `grep ".*MIDFIELDER.*$currVT2.*;$" $persList | shuf -n 6 | cut -d "," -f 3` 
				do 
					goalieH=$val 
					if [[ $counter  == 1 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter < 5 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 5 ]]
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp
						let counter=$counter+1
					else
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi 
				done
			elif [[ $ind == 5 ]] 
			then 
				let counter=1
				let timeDiff=$[ $RANDOM % 45 ]
				let totmin=90-$timeDiff
				for val in `grep ".*FORWARD.*$currHT1.*;$" $persList | shuf -n 4 | cut -d "," -f 3` 
				do 
					goalieH=$val 
					if [[ $counter  == 1 ]] 
					then  
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 2 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 3 ]]
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp 
						let counter=$counter+1
					else
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi 
				done 
				let counter=1 
				let timeDiff=$[ $RANDOM % 45 ]
				let totmin=90-$timeDiff
				for val in `grep ".*FORWARD.*$currVT2.*;$" $persList | shuf -n 4 | cut -d "," -f 3`
				do 
					goalieH=$val 
					if [[ $counter  == 1 ]] 
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', $totmin);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 2 ]]
					then 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'STARTER\', 90);\n" >> $outp 
						let counter=$counter+1 
					elif [[ $counter == 3 ]]
					then
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', $timeDiff);\n" >> $outp
						let counter=$counter+1
					else 
						printf "insert into match_inv_pers\nvalues\n("$goalieH", $matchid, \'SUB\', 0);\n" >> $outp
					fi 
				done
			fi
		done
	done < matchTempSheet.txt
}

mEVPTWriter()
{
	printf "insert into match_event\nvalues\n(%s, %s ,'GOAL', %d, \'%08d\');\n" "$1" "$3" "$2" "$4" >> meGoalInp.sql
	return 0
}

#for subs match_event entry
mEVPTWriter2(){
	printf "insert into match_event\nvalues\n(%s, %s,'SUB', %d, \'%08d\');\n" "$1" "$2" "$3" "$4" >> meSubInp.sql 
	return 0
}

#for cards match_event entry
mEVPTWriter3(){
	printf "insert into match_event\nvalues\n(%s, %s, 'CARD', %d, \'%08d\');\n" "$1" "$2" "$3" "$4" >> meCardinp.sql
	return 0
}

matchGoalGen()
{
	let mEV=$1
	printf "delete from match_event;\n" > meGoalInp.sql

	printf "delete from match_goal;\n" > mGoalInp.sql
	for match in `grep "^(.*;$" matchInp.sql | cut -d "," -f 6`
	do
			htScore=`grep "^(.*$match.*;$" matchInp.sql | cut -d "," -f 3 `
			vtScore=`grep "^(.*$match.*;$" matchInp.sql | cut -d "," -f 4`
			htID=`grep "^(.*$match.*;$" matchInp.sql | cut -d "," -f 1 | cut -d "(" -f 2`
			vtID=`grep "^(.*$match.*;$" matchInp.sql | cut -d "," -f 2`
			for score in `seq $htScore`
			do
				playID=`egrep "^\(.*$match.*([1-8]*[^0]|+[1-8][0]));$" matchRostInp.sql | cut -d "," -f 1 | cut -d "(" -f 2 | shuf -n 1`
				while [[  `grep -c "^(.*$playID.*$htID);$" clubPersInp.sql` == 0 ]] || [[ `egrep "^\(.*$playID.*$match.*);$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1` == 0 ]]			
				do
					playID=`egrep "^\(.*$match.*([1-8]*[^0]|+[1-8][0]));$" matchRostInp.sql | cut -d "," -f 1 | cut -d "(" -f 2 | shuf -n 1` 
				done
				timeField=`grep "^(.*$playID.*$match.*);$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1`
				if [[ $timeField > 45 ]]
				then 
					let goalT=$[ $RANDOM % $timeField + 1 ] 
				else 
					let goalT=$[ $RANDOM % $timeField + 1 ] 
					timeOS=$[ 90-$timeField ]
					goalT=$[ $goalT + $timeOS ]
				fi
				printf "insert into match_goal\nvalues\n(%s, 'GOAL', %s, \'%08d\');\n" "$match" "$playID" "$mEV" >> mGoalInp.sql
				mEVPTWriter $match $goalT $playID $mEV
				let mEV=$mEV+3
			done
			for score in `seq $vtScore`
			do 
				playID=`egrep "^\(.*$match.*([1-8]*[^0]|+[1-8][0]));$" matchRostInp.sql | cut -d "," -f 1 | cut -d "(" -f 2 | shuf -n 1`
				while [[  `grep -c "^(.*$playID.*$vtID);$" clubPersInp.sql` == 0 ]] || [[ `egrep "^\(.*$playID.*$match.*);$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1` == 0 ]] 
				do 
					playID=`egrep "^\(.*$match.*([1-8]*[^0]|+[1-8][0]));$" matchRostInp.sql | cut -d "," -f 1 | cut -d "(" -f 2 | shuf -n 1`
				done 
				declare -i timeField 
				timeField=`grep "^(.*$playID.*$match.*);$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1` 
				if [[ $timeField > 45 ]] 
				then 
					let goalT=$[ $RANDOM % $timeField + 1 ] 
				else 
					let goalT=$[ $RANDOM % $timeField + 1 ]
					timeOS=$[ 90 - $timeField ]
					goalT=$[ $goalT + $timeOS ]
				fi 
				printf "insert into match_goal\nvalues\n(%s, 'GOAL', %s, \'%08d\');\n" "$match" "$playID" "$mEV" >> mGoalInp.sql
				mEVPTWriter $match $goalT $playID $mEV
				let mEV=$mEV+3
			done
	done
}

matchSubGen()
{
	let mEV=$1
	let counter=0
	startId=""
	subID=""
	let switchTime=0
	match_id=""
	
	printf "delete from match_sub;\n" > mSubInp.sql
	while read -r next_line
	do 	
		if [[ counter -eq 0 ]] 
		then 
			startID=`echo $next_line | cut -d "," -f 1 | cut -d "(" -f 2` 
			match_id=`echo $next_line | cut -d "," -f 2` 
			switchTime=`echo $next_line | cut -d "," -f 4 | cut -d ")" -f 1` 
			let counter=counter+1 
		elif [[ counter -eq 1 ]] 
		then 
			subID=`echo $next_line | cut -d "," -f 1 | cut -d "(" -f 2` 
			counter=0
			printf "insert into match_sub\nvalues\n(%s, %s, %s, \'%08d\');\n" "$match_id" "$subID" "$startID" "$mEV" >> mSubInp.sql
			mEVPTWriter2 $match_id $subID $switchTime $mEV
			let mEV=$mEV+3
		fi 
	done < <(egrep "^\(.*(STARTER|SUB).*+[1-89]);$" matchRostInp.sql)
}	

matchCardGen()
{
	let mEV=$1
	printf "delete from match_card;\n" > mCardInp.sql
	for match in `grep "^(.*;$" matchInp.sql | cut -d "," -f 6`
	do
		for mInst in `egrep "^\(.*$match.*+(STARTER|SUB).*+[1-9].*;$" matchRostInp.sql | shuf -n 4 | cut -d "(" -f 2 | cut -d "," -f 1`  
		do 
			let inpL=`grep "^($mInst.*$match.*;$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1 | xargs`  
			if [[ $inpL > 45 ]] 
			then 
				let cTime=$[ $RANDOM % $inpL ] 
				printf "insert into match_card\nvalues\n(%s, %s, 'YELLOW', \'%08d\');\n" "$match" "$mInst" "$mEV" >> mCardInp.sql 
				mEVPTWriter3 $match $mInst $cTime $mEV
				let mEV=$mEV+3
			elif [[ $inpL == 0 ]] 
			then 
				break 
			else 
				let cTime=$[ $RANDOM % $inpL ] 
				let cTime=$cTime+90
				let cTime=$cTime-$inpL 
				printf "insert into match_card\nvalues\n(%s, %s, 'YELLOW', \'%08d\');\n" "$match" "$mInst" "$mEV" >> mCardInp.sql
				mEVPTWriter3 $match $mInst $cTime $mEV
				let mEV=$mEV+3
			fi 
		done 
	done
	for match in `grep "^(.*;$" matchInp.sql | cut -d "," -f 6` 
	do 
		for mInst in `egrep "^\(.*$match.*+(STARTER|SUB).*90.*;$" matchRostInp.sql | shuf -n 2 | cut -d "(" -f 2 | cut -d "," -f 1`
		do 
			let inpL=`grep "^($mInst.*$match.*;$" matchRostInp.sql | cut -d "," -f 4 | cut -d ")" -f 1 | shuf -n 1 | xargs` 
			if [[ $inpL > 45 ]] 
			then 
				let cTime=$[ $RANDOM % $inpL ] 
				printf "insert into match_card\nvalues\n(%s, %s, 'RED', \'%08d\');\n" "$match" "$mInst" "$mEV" >> mCardInp.sql
				mEVPTWriter3 $match $mInst $cTime $mEV
				let mEV=$mEV+3
			elif [[ $inpL == 0 ]] 
			then 
				break 
			else 
				let cTime=$[ $RANDOM % $inpL ] 
				let cTime=$cTime+90 
				let cTime=$cTime-$inpL
				printf "insert into match_card\nvalues\n(%s, %s, 'RED', \'%08d\');\n" "$match" "$mInst" "$mEV" >> mCardInp.sql
				mEVPTWriter3 $match $mInst $cTime $mEV
				let mEV=$mEV+3
			fi 
		done 
	done
}
