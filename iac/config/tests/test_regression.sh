#!/bin/bash
echo "Starting container..."
echo "------------"
sudo docker run -d --name web -p 80:8080 gerbut/pet-clinic:latest
echo "------------"
echo "Container is started"
echo "------------"
echo "Waiting for site availablity..."

COUNTER=0
while [  $COUNTER -lt 300 ]; do
      response_code=$(curl --connect-timeout 5 -LI http://127.0.0.1 -o /dev/null -w '%{http_code}\n' -s )
      if [ ${response_code} -eq 200 ]; then
         break
      fi
      let COUNTER=COUNTER+1
      sleep 1
done

echo "Started in: $COUNTER sec"
echo "------------"

function page_test {
    echo -n "Test: $1..."
    curl http://127.0.0.1/$2 -s | grep -q "$3"
    res=$?
    if [ $res == 0 ] ; then
        echo 'OK'
    else
        echo "FAILED"
    fi
    echo -e '----------------'
    return $res
}

page_test "Main page" "" '<img class="img-responsive" src="/resources/images/pets.png"/>'
test_main=$?

page_test "Search page" "owners?lastName=" 'Maria Escobito'
test_search=$?

page_test "Search Davis" "owners?lastName=Davis" '6085553198'
test_davis=$?

page_test "Vets page" "vets.html" 'Henry Stevens'
test_vets=$?

sudo docker rm -f web >>/dev/null
echo "Container is removed!"

result=$(( $test_main + $test_search + $test_davis + $test_vets ))

if [ ${result} == 0 ]; then
    echo '======= Test Passed! ======'
    exit 0
else
    echo "======= Test Failed! ======"
    exit 1
fi

