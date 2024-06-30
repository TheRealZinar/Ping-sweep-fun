#!/bin/bash

while true; do
  echo "Main Menu:"
  echo "1. Scan for live IP addresses"
  echo "2. Play a game"
  echo "3. Exit"
  read -p "Enter your choice (1/2/3): " main_choice

  if [[ "$main_choice" = "1" ]]; then
    read -p "Enter the IP address to scan: " ip_address

    if [[ "$ip_address" = "" ]]; then
      echo "Please enter a valid IP address."
    else
      live_count=0  # Initialize a counter for live IP addresses

      for ip in $(seq 1 254); do
        color_code=$((31 + RANDOM % 7))  # Generate a random color code (31-37 for text colors)

        # Ping each IP with a shorter timeout (e.g., 0.01 seconds) and capture the exit status
        ping -c 1 -W 0.01 "$ip_address.$ip" > /dev/null 2>&1
        status=$?

        # Display only if the ping was successful (exit status 0)
        if [[ $status -eq 0 ]]; then
          echo -e "\e[${color_code}m$ip_address.$ip is alive\e[0m"  # Set the text color and reset it after printing
          ((live_count++))  # Increment the live count
        fi
      done

      echo "Total live IP addresses: $live_count"  # Display the total count of live IP addresses
    fi
  elif [[ "$main_choice" = "2" ]]; then
    while true; do
      echo "Choose a game to play:"
      echo "1. Guess the Secret Number"
      echo "2. Rock, Paper, Scissors"
      echo "3. Stop Playing"
      echo "4. Back to Main Menu"
      read -p "Enter your choice (1/2/3/4): " game_choice
      
      if [[ "$game_choice" = "3" ]]; then
        break  # Exit the game loop and return to the game menu
      elif [[ "$game_choice" = "4" ]]; then
        break  # Exit the game loop and return to the main menu
      elif [[ "$game_choice" = "1" ]]; then
        # Simple guessing game
        echo "Welcome to the guessing game!"
        secret_number=$((RANDOM % 100 + 1))
        attempts=0

        while true; do
          read -p "Guess the secret number (between 1 and 100): " guess
          ((attempts++))

          if [[ $guess -lt $secret_number ]]; then
            echo "Try a higher number."
          elif [[ $guess -gt $secret_number ]]; then
            echo "Try a lower number."
          else
            echo "Congratulations! You guessed the secret number ($secret_number) in $attempts attempts."
            break
          fi
        done
      elif [[ "$game_choice" = "2" ]]; then
        # Rock, Paper, Scissors game
        echo "Welcome to Rock, Paper, Scissors!"
        echo "Choose your move:"
        echo "1. Rock"
        echo "2. Paper"
        echo "3. Scissors"
        echo "4. Back to Game Menu"
        read -p "Enter your choice (1/2/3/4): " player_choice

        if [[ "$player_choice" = "4" ]]; then
          break  # Exit the game loop and return to the game menu
        fi

        case "$player_choice" in
          1)
            player_move="Rock"
            ;;
          2)
            player_move="Paper"
            ;;
          3)
            player_move="Scissors"
            ;;
          *)
            echo "Invalid choice."
            continue  # Continue the game loop
            ;;
        esac

        computer_choice=$((RANDOM % 3 + 1))

        case "$computer_choice" in
          1)
            computer_move="Rock"
            ;;
          2)
            computer_move="Paper"
            ;;
          3)
            computer_move="Scissors"
            ;;
        esac

        echo "You chose $player_move."
        echo "Computer chose $computer_move."

        if [[ "$player_choice" -eq "$computer_choice" ]]; then
          echo "It's a tie!"
        elif [[ ("$player_choice" -eq 1 && "$computer_choice" -eq 3) || ("$player_choice" -eq 2 && "$computer_choice" -eq 1) || ("$player_choice" -eq 3 && "$computer_choice" -eq 2) ]]; then
          echo "You win!"
        else
          echo "Computer wins!"
        fi
      else
        echo "Invalid choice."
      fi
    done
  elif [[ "$main_choice" = "3" ]]; then
    echo "Exiting."
    break  # Exit the main loop and end the script
  else
    echo "Invalid choice. Please enter '1' to scan for live IP addresses, '2' to play a game, or '3' to exit."
  fi
done
