#!/bin/bash

finished=0

echo -e "***Welcome to password generator***\n"

options_menu(){
    re="^[0-9]+$"

    # Password length
    while true
    do
        echo -e "\nProvide password length:"
        read len;
        if ! [[ $len =~ $re ]]; then
            echo "Error: Wrong value"
        else
            break
        fi
    done
    
    # Number of passwords
    while true
    do
        echo -e "\nProvide number of passwords:"
        read pass_num;
        if ! [[ $pass_num =~ $re ]]; then
            echo "Error: Wrong value"
        else
            break
        fi
    done

    # Include/exclude options
    while true
    do
        echo "Include uppercase letters (y/n): "
        read uppercase;

        case $uppercase in
            y|Y) 
                uppercase=true
                break;;
            n|N) 
                uppercase=false
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done

    # Include/exclude numbers
    while true
    do
        echo "Include numbers letters (y/n): "
        read numbers;

        case $numbers in
            y|Y) 
                numbers=true
                break;;
            n|N) 
                numbers=false
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
    
    # Include/exclude options
    while true
    do
        echo "Include spec_char letters (y/n): "
        read spec_char;

        case $spec_char in
            y|Y) 
                spec_char=true
                break;;
            n|N) 
                spec_char=false
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
}

generate_password(){
    echo "Generating password"
}

while [ $finished -ne 1 ]
do
    echo "Choose an option:"
    echo "1 - Generate password"
    echo "2 - Exit"

    read option;

    case $option in
        1) 
            options_menu
            generate_password;;
        2) finished=1;;
        *) echo -e "Inappropriate option. Choose again\n"
    esac
done
