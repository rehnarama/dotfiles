if status is-interactive
    # if test -z "$ZELLIJ"; and test "$DESKTOP_SESSION" != "niri"
    #     exec zellij
    # end

    function run-env
        # Check if the .env file exists in the current directory
        if test -f .env
            # Read the .env file and set environment variables for the command
            for line in (cat .env)
                # Skip empty lines and comments
                if not echo $line | grep -q "^\s*#" ; and test -n "$line"
                    set -l var (string split --max 1 '=' "$line")[1]
                    set -l value (string split --max 1 '=' "$line")[2]
                    set -x $var $value
                end
            end
        end

        # Run the command with the environment variables set
        eval $argv
    end

    fzf --fish | source

    pyenv init - fish | source

    # Commands to run in interactive sessions can go here
    starship init fish | source
end

