#!/bin/bash

SCRIPT_ARGS_LEN="$#"
FILE="tasks.txt"

# Initialize file if doesn't exist
[[ ! -f "$FILE" ]] && touch "$FILE"

add(){
    echo "ADD"
    local task=$1
    local priority=$2
    local list="low medium high" 
    if ! [[ $list =~ (^|[[:space:]])$priority($|[[:space:]]) ]]; then
        echo "Wrong priority"
        echo "Usage: ToDo.sh add <task> low|medium|high"
        exit 2
    fi
    
    local last_id=$(tail -n 1 "$FILE" | cut -d'|' -f1)
        local next_id=$((last_id + 1))
    
    printf "%s|\"%s\"|%s|\"%s\"|%s|\n" "$next_id" "$task" "$priority" "backlog" "$(date '+%Y-%m-%d %H:%M:%S')" >> "$FILE";

    echo "Task $task added with id $next_id"
}

list(){
    echo "LIST"
    local fun=$1
    local param=$2
    echo $fun
    echo $param
    if [[ $fun = "all" ]]; then
        awk -F '|' -v w="removed" '$4 != w' "$FILE"
    elif [[ $fun = "status" ]]; then
        if ! [[ "all backlog pending completed" =~ (^|[[:space:]])$param($|[[:space:]]) ]]; then
            echo "Wrong status"
            echo "Usage: ToDo.sh list status backlog|pending|completed"
            exit 2
        # elif [[ $param = "all" ]]; then
        #     awk -F '|' -v w="$param" '$4 != w' "$FILE"
        else
            awk -F '|' -v w="$param" '$4 == w' "$FILE"
        fi
    else
        if ! [[ "low medium high" =~ (^|[[:space:]])$param($|[[:space:]]) ]]; then
            echo "Wrong priority"
            echo "Usage: ToDo.sh list priority low|medium|high"
            exit 2
        else
            awk -F '|' -v w="$param" '$3 == w' "$FILE"
        fi
    fi


    # case $fun in
    #     status)
    #         echo 
    #     priority)
    #         echo;;

    # awk -F '|' '$4 != "removed"' tasks.txt
}

status(){
    echo "status"
}

remove(){
    echo "REMOVE"
}

# while getopts "p:s:h" opt; do
#     case $opt in
#         p) priority="$OPTARG" ;;
#         s) status="$OPTARG" ;;
#         h) show_help; exit 0 ;;
#     esac
# done

check_arguments(){
    local fun="$1"
    local num="$2"
    local num2="$3"

    if [[ $SCRIPT_ARGS_LEN -ne $num && $SCRIPT_ARGS_LEN -ne $num2 ]]; then
        case "$fun" in
            add)
                echo "Option add takes 2 arguments"
                echo "Usage: ToDo.sh add <task> <priority>"
                ;;
            list)
                echo "Option list takes 0 or 2 arguments"
                echo "Usage: ToDo.sh list or ToDo.sh list status all|backlog|pending|completed or ToDo.sh list priority low|medium|high"
                ;;
            status)
                echo "Option status takes 3 argument"
                echo "Usage: ToDo.sh status <task_id> <status?"
                ;;
            remove)
                echo "Option remove takes 1 argument"
                echo "Usage: ToDo.sh remove <task_id>"
                ;;
        esac
        exit 1
    fi

}


case "$1" in
    add)
        check_arguments "add" 3 
        add "$2" "$3"
        ;;
    list)
        check_arguments "list" 3 0
        list "$2" "$3"
        ;;
    status)
        check_arguments "status" 3
        status "$2"
        ;;
    remove)
        check_arguments "remove" 2
        remove "$2"
        ;;
    *)
        echo "Wrong option used"
        echo "Usage: ToDo.sh add|list|status|remove"
esac


# file format
# id|task|priority|status|created