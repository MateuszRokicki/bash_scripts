#!/bin/bash

SCRIPT_ARGS_LEN="$#"
FILE="tasks.txt"

# Initialize file if doesn't exist
[[ ! -f "$FILE" ]] && touch "$FILE"

add(){
    local task=$1
    local priority=$2
    local list="low medium high" 
    if ! [[ $list =~ (^|[[:space:]])$priority($|[[:space:]]) ]]; then
        echo "Wrong priority"
        echo "Usage: ToDo.sh add <task> low|medium|high"
        exit 2
    fi
    
    local last_id=$(tail -n 1 "$FILE" | cut -d'|' -f1)
        local next_id=$(( ${last_id:-0} + 1))

    if [[ $next_id == 1 ]]; then
        printf "id|task|priority|status|created|updated\n" >> "$FILE"

    printf "%s|\"%s\"|%s|%s\|%s|%s\n" "$next_id" "$task" "$priority" "backlog" "$(date '+%Y-%m-%d %H:%M:%S')" "$(date '+%Y-%m-%d %H:%M:%S')" >> "$FILE";

    echo "Task $task added with id $next_id"
}

list(){
    local fun=$1
    local param=$2
    
    if [[ -z $fun ]]; then
        awk -F '|' -v w="removed" '$4 != w' "$FILE"
    elif [[ $fun = "status" ]]; then
        if ! [[ "backlog pending completed" =~ (^|[[:space:]])$param($|[[:space:]]) ]]; then
            echo "Wrong status"
            echo "Usage: ToDo.sh list status backlog|pending|completed"
            exit 2
        else
            awk -F '|' -v w="$param" '$4 == w' "$FILE"
        fi
    else
        if ! [[ "low medium high" =~ (^|[[:space:]])$param($|[[:space:]]) ]]; then
            echo "Wrong priority"
            echo "Usage: ToDo.sh list priority low|medium|high"
            exit 2
        else
            awk -F '|' -v w="$param" -v s="removed" '$3 == w && $4 != s' "$FILE"
        fi
    fi
}

status(){
    local id="$1"
    local status="$2"

    if awk -F '|' -v w="$id" '$1 == w { found=1; exit } END { exit !found }' "$FILE"; then
        if ! [[ "backlog pending completed" =~ (^|[[:space:]])$status($|[[:space:]]) ]]; then
            echo "Wrong status"
            echo "Usage: ToDo.sh status <id> backlog|pending|completed"
            exit 2
        else
            awk -F '|' -v w="$id" -v s="$status" -v t="$(date '+%Y-%m-%d %H:%M:%S')" 'BEGIN {OFS="|"} $1 == w {$4=s; $6=t} {print}'  "$FILE" > temp.txt && mv temp.txt "$FILE"
            echo "Task with ID $id updated to status $status"
        fi
    else
        echo "Task with ID $id doesn't exist"
    fi
}

priority(){
    local id="$1"
    local priority="$2"

    if awk -F '|' -v w="$id" '$1 == w { found=1; exit } END { exit !found }' "$FILE"; then
        if ! [[ "low medium high" =~ (^|[[:space:]])$priority($|[[:space:]]) ]]; then
            echo "Wrong priority"
            echo "Usage: ToDo.sh priority <id> high|medium|low"
            exit 2
        else
            awk -F '|' -v w="$id" -v p="$priority" -v t="$(date '+%Y-%m-%d %H:%M:%S')" 'BEGIN {OFS="|"} $1 == w {$3=p; $6=t} {print}'  "$FILE" > temp.txt && mv temp.txt "$FILE"
            echo "Task with ID $id updated to priority $priority"
        fi
    else
        echo "Task with ID $id doesn't exist"
    fi
}

remove(){
    local id="$1"

    if awk -F '|' -v w="$id" '$1 == w { found=1; exit } END { exit !found }' "$FILE"; then
        awk -F '|' -v w="$id" -v t="$(date '+%Y-%m-%d %H:%M:%S')" 'BEGIN {OFS="|"} $1 == w {$4="removed"; $6=t} {print}'  "$FILE" > temp.txt && mv temp.txt "$FILE"
        echo "Task with ID $id marked as removed"
    else
        echo "Task with ID $id doesn't exist"
    fi

}


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
                echo "Usage: ToDo.sh list or ToDo.sh list status backlog|pending|completed or ToDo.sh list priority low|medium|high"
                ;;
            status)
                echo "Option status takes 3 argument"
                echo "Usage: ToDo.sh status <task_id> <status>"
                ;;
            priority)
                echo "Option priority takes 3 argument"
                echo "Usage: ToDo.sh priority <task_id> <priority>"
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
        check_arguments "list" 3 1
        list "$2" "$3"
        ;;
    status)
        check_arguments "status" 3
        status "$2" "$3"
        ;;
    priority)
        check_arguments "priority" 3
        priority "$2" "$3"
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
# id|task|priority|status|created|updated