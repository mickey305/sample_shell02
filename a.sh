
cd /Volumes/QVO2020/tmp
while true
do
  perl a.pl; df | grep '/dev/disk3s2' | awk '{print $1, $9, $4}'; perl -MTime::HiRes=sleep -e sleep -e $1 ;
done

