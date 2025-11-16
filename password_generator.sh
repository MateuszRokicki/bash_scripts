#!/bin/bash

finished=0

echo -e "***Welcome to password generator***\n"

options_menu(){
    re="^[0-9]+$"
    pwd_chars="a-z"

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
                pwd_chars+="A-Z"
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done

    # Include/exclude numbers
    while true
    do
        echo "Include numbers (y/n): "
        read numbers;

        case $numbers in
            y|Y) 
                pwd_chars+="0-9"
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
    
    # Include/exclude options
    while true
    do
        echo "Include special characters (y/n): "
        read spec_char;

        case $spec_char in
            y|Y) 
                pwd_chars+='#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~'
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
}

generate_passwords(){
    echo -e "\nGenerating passwords"
    passwords=()
    for ((i=0; i<$pass_num; i++)); do
        passwords+=$(tr -dc $pwd_chars </dev/urandom | head -c $len)
    done

    while true
    do
        echo "Print passwords (y/n):"
        read prt_pwd;

        case $prt_pwd in
            y|Y) 
                echo "${passwords[@]}"
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
    
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
            generate_passwords;;
        2) finished=1;;
        *) echo -e "Inappropriate option. Choose again\n"
    esac
done
