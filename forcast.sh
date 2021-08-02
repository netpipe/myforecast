#!/bin/bash
metric=1
echo -e "Enter city name or cityname,country:"
read city
echo "Entered city is $city"
city_search="https://www.myforecast.com/search_results.php?search=""$city"
curl -s "$city_search" > city_cwid.log
#grep cwid city_tmp.log | head -2 | tail -1
city_cwid=`grep cwid city_cwid.log | head -2 | tail -1  | awk -F 'href="|&language' '{print $2}'`
city_get_temp="https://www.myforecast.com/""$city_cwid"
if [ $metric == 1 ]; then
city_get_temp=$city_get_temp"&metric=true"
fi
curl -s "$city_get_temp"  > city_tmp.log
count=0
tmp_times=">9:00 am<,>12:00 pm<,>6:00 pm<,>10:00 pm<"
RED='\033[1;31m'
NC='\033[0m'
fun_display()
{
        if [ $1 == "9:00 am" ];then
                v_time="Morning"
        elif [ $1 == "12:00 pm" ];then
                v_time="Noon"
        elif [ $1 == "6:00 pm" ];then
                v_time="Evening"
        else
                v_time="Night"
        fi
        v_condition=`cat city_tmp.log | sed -n "$(($2+5))"p | cut -d '>' -f2 | cut -d '<' -f1`
        v_temperature=`cat city_tmp.log | sed -n "$(($2+1))"p | cut -d '>' -f2 | cut -d '<' -f1`
        v_prep=`cat city_tmp.log | sed -n "$(($2+11))"p | cut -d '>' -f2 | cut -d '<' -f1`
        v_wind=`cat city_tmp.log | sed -n "$(($2+10))"p |     cut -d '>' -f3 | cut -d '/' -f1  `
        echo "$v_time,$v_condition,$v_temperature,$v_wind,$v_prep"
}
SAVEIFS=$IFS
IFS=,
if  [ -f file_itr.txt ];then
        rm -f file_itr.txt
fi
for day_state in $tmp_times
do
        day_state_count=`cat city_tmp.log |   grep  -n 'td class="nobr"' | grep "$day_state" | wc -l`
        cat city_tmp.log |   grep  -n 'td class="nobr"' | grep "$day_state" | awk -v        th=$day_state '{print $1}' >> file_itr.txt
        #echo "$day_state count is $day_state_count"
        if [ $day_state == ">9:00 am<" ] && [ $day_state_count -ne 7 ];then
                count=1
        elif [ $day_state == ">12:00 pm<" ] && [ $day_state_count -ne 7 ];then
                count=2
        elif [ $day_state == ">6:00 pm<" ] && [ $day_state_count -ne 7 ];then
                count=3
        elif  [ $day_state == ">10:00 pm<" ] && [ $day_state_count -ne 7 ];then
                count=4
        fi
done
#echo "final count is $count"
echo "| Time   | Condition | Temperature | Wind | Prep-Probability |"
echo  "                                           ________________                  "
echo  "__________________________________________|`date +"%a %b-%d-%Y"` |__________________________"
echo  "                                           ________________                  "
echo  "_____________________________________________________________________________________"

itr=1
day_itr=1
#while [ $itr -lt
sort -k 1n file_itr.txt > file_itr1.txt
#cat file_itr1.txt
while [ $(($itr+$count)) -le 28 ]
do
        if [ $((($count+$itr)%4)) -eq 1 ] && [ $(($count+$itr)) -gt 4 ];then
        echo  "                                           ________________                  "
        echo  "__________________________________________|`date -d "+${day_itr}  day"  +"%a %b-%d-%Y"` |__________________________"
        echo  "                                           ________________                  "
        echo  "_____________________________________________________________________________________"
        day_itr=$(($day_itr+1))
        fi
        line=`cat file_itr1.txt| sed -n "$itr"p | cut -d ':' -f1`
        #echo $line
        v_time=`cat city_tmp.log | sed -n "$line"p | cut -d '>' -f2 | cut -d '<' -f1`
        #echo $v_time
        fun_display $v_time $line
        itr=$(($itr+1))
done
