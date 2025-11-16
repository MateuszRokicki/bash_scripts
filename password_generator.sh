#!/bin/bash


menu_num(){
    local name="$1"
    re="^[0-9]+$"

    while true
    do
        echo -e "\nProvide $name:" >&2
        read -r param;
        if ! [[ $param =~ $re ]]; then
            echo "Error: Wrong value" >&2
        else
            if [[ $name == "password length" && $param -lt 8 ]]; then
                echo -e "Password to short. Minimal length is 8\n" >&2
            else
                break
            fi
        fi
    done
    echo "$param"
}

menu_bool(){
    local name=$1
    local val=$2
    
    while true
    do
        echo -e "\nInclude $name (y/n): "
        read param;

        case $param in
            y|Y) 
                pwd_chars+="$val"
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again"
        esac
    done

}


options_menu(){
    pwd_chars="a-z"

    # Password length
    len=$(menu_num "password length")

    # Number of passwords
    pass_num=$(menu_num "number of passwords")

    # Include/exclude options
    menu_bool "uppercase letters" "A-Z"

    # Include/exclude numbers
    menu_bool "numbers" "0-9"

    # Include/exclude options
    menu_bool "special characters" '#$%&()*+,-./:;<=>?@[\]^_`{|}~'
}

print_passwords(){
    echo
    while true
    do
        echo -e "Print passwords (y/n):"
        read -r prt_pwd;
        echo
        case $prt_pwd in
            y|Y) 
                for pwd in "${passwords[@]}"; do
                    echo "$pwd"
                done
                break;;
            n|N) 
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
}

passwords_to_file(){
    echo
    while true
    do
        echo "Save passwords to file (y/n):"
        read -r save
        case $save in
            y|Y) 
                echo -e "\nProvide file:"
                read -r file
                if ! printf "%s\n" "${passwords[@]}" > "$file" 2>/dev/null; then
                    echo "Error: Could not write to $file" >&2
                else
                    echo "Passwords saved to file $file"
                    break
                fi
                ;;
            n|N)
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
}

password_to_clipboard(){
    echo
    while true
    do
        echo -e "Copy password to clipboard (y/n):"
        read -r clip;
        case $clip in
            y|Y) 
                if command -v xclip &> /dev/null; then
                    echo "${passwords[0]}" | xclip -selection clipboard
                    echo "Password copied to clipboard"
                elif command -v pbcopy &> /dev/null; then
                    echo "${passwords[0]}" | pbcopy
                    echo "Password copied to clipboard"
                else
                    echo "Error: No clipboard tool found (install xclip or pbcopy)" >&2
                fi
                break;;
            n|N) 
                echo
                break;;
            *) echo -e "Inappropriate option. Choose again\n"
        esac
    done
}

output_passwords(){
    print_passwords
    passwords_to_file
    if [[ $pass_num == 1 ]]; then
        password_to_clipboard
    fi
}

generate_passwords(){
    echo -e "\nGenerating passwords"
    passwords=()
    for ((i=0; i<$pass_num; i++)); do
        passwords+=("$(tr -dc $pwd_chars </dev/urandom | head -c $len)")
    done
}

finished=0

echo "***Welcome to password generator***"

while [ $finished -ne 1 ]
do
    echo -e "\nChoose an option:"
    echo "1 - Generate password"
    echo "2 - Exit"

    read option;

    case $option in
        1) 
            options_menu
            generate_passwords
            output_passwords;;
        2) finished=1;;
        *) echo -e "Inappropriate option. Choose again\n"
    esac
done
