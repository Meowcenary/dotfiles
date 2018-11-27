(* Example of a function, 'logit', that can be used to debug runtime errors on applescripts. *)
(* In this instance, it outputs to a file TestDrive.log under ~/Library/Logs/ *)

tell application "TextEdit"
    try
        set a to text 0 of its name
    on error e number n
        my logit("OOPs: " & e & " " & n, "TestDrive")
    end try
end tell

to logit(log_string, log_file)
    do shell script ¬
        "echo `date '+%Y-%m-%d %T: '`\"" & log_string & ¬
        "\" >> $HOME/Library/Logs/" & log_file & ".log"
end logit
