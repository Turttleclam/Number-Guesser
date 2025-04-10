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
# So many issues with this variable, but I think this should work
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name = '$USER_NAME'")
USER_ID=$(echo "$USER_ID" | xargs) #trims extra spaces
# If this is a new user
if [[ -z $USER_ID ]]
then
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME')")
  echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id = $USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(score) FROM games WHERE user_id = $USER_ID")
  echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Game Play: Random number generator
NUMBERS_GAME () {
  # Initialize random number between 1 - 1000
  # RANDOM_NUMBER=$(( (RANDOM % 1000) + 1 ))
  RANDOM_NUMBER=546
  # Initialize score variable
  SCORE=0
  # Game Play: Handle user input
  echo -e "\nGuess the secret number between 1 and 1000:"

  while true
  do
    read USER_GUESS
    # If user input is not a number
    if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      continue
    fi
    # Increment the score
    (( SCORE++ ))

    # If guess is lower
    if [[ $USER_GUESS -lt $RANDOM_NUMBER ]]
    then 
      echo -e "\nIt's higher than that, guess again:"
    # If guess is higher
    elif [[ $USER_GUESS -gt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
    # If guess is correct
    else 
      INSERT_SCORE=$($PSQL "INSERT INTO games(user_id, score) VALUES($USER_ID, $SCORE)")
      echo -e "\nYou guessed it in $SCORE tries. The secret number was $RANDOM_NUMBER. Nice job!"
      break
    fi
  done
}

NUMBERS_GAME
