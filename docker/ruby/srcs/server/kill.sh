kill -9 $(ps aux|grep puma|grep -v grep|awk -F ' ' '{print $2}')
