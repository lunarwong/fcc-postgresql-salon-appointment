#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nWelcome to the salon!\nHow can I help you :)\n"
echo "~~~~~~~~~~~~~~~~~~~~"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "$1"
  fi

  echo -e "1) cut\n2) color\n3) perm\n4) style\n"

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU ;;
    2) APPOINTMENT_MENU ;;
    3) APPOINTMENT_MENU ;;
    4) APPOINTMENT_MENU ;;
    *) MAIN_MENU "\nI could not find that service. Which services would you like?" ;;
  esac

}

APPOINTMENT_MENU() {
  echo -e "\nLet's make an appointment"

  #get customer phone number
  echo "What is your phone number?"
  read CUSTOMER_PHONE
  
  #get customer name from phone
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'" | xargs)

  #no customer info in the customers table
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, What's your name?"
    read CUSTOMER_NAME

    #insert new customer info
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  #the customer info is already in the customers table
  #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED" | xargs)

  #ask for time 
  echo -e "What time would you like for $SERVICE_NAME, $CUSTOMER_NAME"
  read SERVICE_TIME

  #get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #insert time appointment
  INSERT_TIME_APP=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")


  #display appointment info
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\nThank you!"

}

#run main menu at start
MAIN_MENU