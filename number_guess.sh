#!/bin/bash

# Number Guessing Game

# Prompt for a username
echo -e "\nEnter your username:"
read USER_NAME
# Check for user_id
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")
# If this is a new user
if [[ -z $USER_ID ]]
then
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME')")
  echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(score) FROM games WHERE user_id = $USER_NAME")
  echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi






