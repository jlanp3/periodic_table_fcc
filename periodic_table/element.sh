#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
fi

STR=$(echo -n "$1" | wc -m)

if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number='$1';")
elif [[ $1 =~ ^[A-Z][a-z]{2,}$ ]]
then
  QUERY=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1';")
elif [[ $1 =~ (^[A-Z]$|^[A-Z][a-z]{1}$) ]]
then
  QUERY=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$1';")
fi

if [[ $STR > 0 ]]
then
  if [[ -z $QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$QUERY" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do 
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi