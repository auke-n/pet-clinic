#!/bin/bash
echo "Starting container..."
echo "------------"
sudo docker run -d --name web -p 80:8080 gerbut/pet-clinic:latest
echo "------------"
echo "Container is started"
echo "------------"
echo "Testing site availablity..."
echo "------------"

COUNTER=0
while [  $COUNTER -lt 300 ]; do
      response_code=$(curl --connect-timeout 5 -LI http://127.0.0.1 -o /dev/null -w '%{http_code}\n' -s )
      if [ ${response_code} -eq 200 ]; then
         break
      fi
      let COUNTER=COUNTER+1
      sleep 1
done

echo ""

sudo docker rm -f web >>/dev/null
echo "Container is removed!"

if [ ${response_code} -eq 200 ]; then
    echo '======= Test Passed! ======'
    echo "Attempt # : $COUNTER"
    exit 0
else
    echo "======= Test Failed! ======"
    echo "Response code: ${response_code}"
    echo "Attempt # : $COUNTER"
    exit 1
fi