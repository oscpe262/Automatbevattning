#!/bin/bash
if [ -z ${1+x} ]; then 
  echo -e "No pump or pumptime given. Proper syntax is: $0 [PUMP (1-4)] [TIME in seconds to pump].\nE.g: $0 1 10 #will use pump 1 for 10 seconds."
  exit 1
fi

if [ -z ${2+x} ]; then 
  echo -e "You've missed either pump or pumptime. Proper syntax is: $0 [PUMP (1-4)] [TIME in seconds to pump].\nE.g: $0 1 10 #will use pump 1 for 10 seconds."
  exit 2
fi

PUMP=$1
PUMPTIME=$2

if [ $PUMPTIME -gt 31 ]; then
  echo -e "For safety reasons, the maximum pump time is set to 31 seconds. Run this script several time or adjust the limit if needed."
  exit 3
fi

if [ $PUMPTIME -lt 0 ]; then
  echo -e "Pump time less than 0 is not allowed."
  exit 4
fi

echo "TRACE: PUMP $PUMP"

case $PUMP in
	1)
	  PUMPPIN=22
	  ;;
	2)
	  PUMPPIN=27
	  ;;
	3)
	  PUMPPIN=17
	  ;;
	4)
	  PUMPPIN=4
	  ;;
	*)
	  echo "PUMP $PUMP IS NOT AVAILABLE"
	  exit $PUMP
	  ;;
esac

echo "TRACE: PUMP PIN $PUMPPIN"
echo "TRACE: PUMP TIME $PUMPTIME"

/root/pinout.sh $PUMPPIN 1
sleep $PUMPTIME
/root/pinout.sh $PUMPPIN 0
exit 0
