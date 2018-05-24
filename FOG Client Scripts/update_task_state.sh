#!/bin/bash

mac='aa:bb:cc:dd:ee:11'


#get our tasks as json
tasks=$(curl -H 'fog-api-token: MzkyNmQ3MWNkMjNjOTk1MzNiZDU0MzM2MTg3OTQ3MjZiZmI1NjhiNDlhMjM2NDkxMmU5ZjE0YWNkNGUyNGM4MmJhYmZjMDkzMjkyZjFiODIzY2Y0ODQ3M2ZmZjAxYjNmYmZmMDc2NzY1ZmY0ZjExOTk5ZmE4NGMwZWY3ODZmNjI' -H 'fog-user-token: OTc3YjkzNDY2NzY5YjQ1OGEzOWE1MTE2Yjc2ZGVlYzI3YzE3ZmQ4MGMyMDZiNjUyYTk3YjRlMjIyYTllYjM0ZGJhYWY3NGE2NGE3Yjc3YTlmN2U0MmQ4ZGNjYzUyYjUwYmU3NzM1YzBiMDg5YmQ1ZWI2NjkwZDFlZGU5ZjY0Yjg=' -H 'Content-Type: application/json' -X GET 'http://fog.home/fog/task/active')

#tasks=$(curl -H 'Content-Type: application/json' 'http://fog.home/fog/task/active' -u 'api':'password')

#get the number of tasks
count=$(echo $tasks | jq '.count')
echo "task count = $count"

#generate the top index
top_index=$(($count-1))

#interate through indices
for i in $(seq 0 $top_index); do
	task=$(echo $tasks | jq ".tasks[$i]")

	#check if this task has our MAC
	mac_match=$(echo $task | jq ".host.macs | contains([\"$mac\"])")

	#check if this task is the right type (MDT)
	type_match=$(echo $task | jq ".type.id"  | sed 's/"//g' )

	#if both match we have found our task
	if [ $mac_match = 'true' ] && [ $type_match = 23 ]; then
		task_id=$(echo $task | jq ".id" | sed 's/"//g')
		echo "Task: $task_id"
	fi
done


