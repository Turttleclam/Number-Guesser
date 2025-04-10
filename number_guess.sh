#!/bin/bash

# Number Guessing Game DB
if [[ $1 == test ]]
then 
  PSQL="psql --username=freecodecamp --dbname=numberstest -t --no-align -c"
else 
  PSQL="psql --username=freecodecamp --dbname=numbers -t --no-align -c"
fi
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
# Game Play: Random number generator
RANDOM_NUMBER=$(( (RANDOM % 1000) + 1 ))
# Initialize score variable
SCORE=0
# Game Play: Handle user input
echo -e "\nGuess the secret number between 1 and 1000:"
read USER_GUESS
if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
then
  echo -e "\nThat is not an integer, guess again:"
else
  # While guess is lower
  while (( $USER_GUESS < $RANDOM_NUMBER ))
  do
    $((SCORE++))
    echo -e "\nIt's higher than that, guess again:"
  done
  # While guess is higher
  while (( $USER_GUESS > $RANDOM_NUMBER ))
  do
    $((SCORE++))
    echo -e "\nIt's lower than that, guess again:"
  done
  # If guess is correct
  if [[ $USER_GUESS == $RANDOM_NUMBER ]]
  then 
    $((SCORE++))
    INSERT_SCORE=$($PSQL "INSERT INTO games(score) VALUES($SCORE)")
    echo -e "\nYou guessed it in $SCORE tries. The secret number was $RANDOM_NUMBER. Nice job!"
  fi
fi


  





