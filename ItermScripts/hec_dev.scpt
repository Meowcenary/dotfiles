(* This is an incredibly jive script, but it works and I don't really want to spend more time on this. It is *)
(* probably self explanatory, but all it does is open four tabs with a profile that opens to a desired directory *)
tell application "iTerm2"
  tell current window
    create tab with profile "hec_dev"
    create tab with profile "hec_dev"
    create tab with profile "hec_dev"
    create tab with profile "hec_dev"
  end tell
end tell
