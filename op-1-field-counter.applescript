-- Define the base directory
set baseDirectoryPath to POSIX path of (path to home folder) & "Library/Containers/engineering.teenage.fieldkit/Data/Documents"

-- Define the handler to display error messages
on displayError()
	display dialog "I can’t find your OP-1 field" & return & return & "Please check the following before trying again:" & return & return & "1) field kit is running on your Mac" & return & "2) OP-1 is plugged via USB" & return & "3) OP-1 is on MTP mode (shift + com, then T4)" buttons {"Close"} default button "Close" with icon stop
end displayError

-- Define the handler to count files
on countPatches(baseDirectoryPath)
	display dialog "⏳ Counting patches, please wait…" buttons {} giving up after 3
	
	-- Check if the base directory exists using AppleScript's native commands
	tell application "System Events"
		if not (exists folder baseDirectoryPath) then
			displayError()
			return
		end if
	end tell
	
	-- Find the OP-1 folder
	set op1Folder to do shell script "find " & quoted form of baseDirectoryPath & " -type d -name 'OP-1-*' -print -quit"
	
	-- Display error if no folder is found
	if op1Folder is "" then
		displayError()
		return
	end if
	
	-- Count files in drum and synth folders
	set drumFileCount to do shell script "find " & quoted form of (op1Folder & "/drum") & " -type f \\( -name '*.wav' -o -name '*.aif' -o -name '*.aiff' -o -name '*.aifc' \\) -not -path '*/slots/*' | wc -l"
	set synthFileCount to do shell script "find " & quoted form of (op1Folder & "/synth") & " -type f \\( -name '*.wav' -o -name '*.aif' -o -name '*.aiff' -o -name '*.aifc' \\) -not -path '*/slots/*' | wc -l"
	
	-- Convert counts and calculate totals
	set drumFileCount to drumFileCount as integer
	set synthFileCount to synthFileCount as integer
	set totalFileCount to drumFileCount + synthFileCount
	set slotsLeft to 500 - totalFileCount
	
	-- Display the result
	display dialog ("🎹 " & totalFileCount & " patches installed on your OP-1 field" & return & return & "🥁 " & drumFileCount & " drums" & return & "🎷 " & synthFileCount & " synths" & return & return & "📥 " & slotsLeft & " available") buttons {"Close"} default button "Close"
end countPatches

-- Run the patch counting process
countPatches(baseDirectoryPath)