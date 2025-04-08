#!/bin/bash

# Number Guessing Game

# Prompt for a username
echo -e "\nEnter your username:"
read USER_NAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")
if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."





