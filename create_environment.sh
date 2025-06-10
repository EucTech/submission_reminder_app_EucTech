#!/bin/bash

# Ask the user for their name and create a directory with that name

read -p "Enter your Name: " name
mainDir=submission_reminder_$name

mkdir -p $mainDir

# Create subdirectories for the app, modules, assets, and config
appDir=$mainDir/app
modulesDir=$mainDir/modules
assetsDir=$mainDir/assets
configDir=$mainDir/config

mkdir -p $appDir $modulesDir $assetsDir $configDir

# Create files in the subdirectories

touch $appDir/reminder.sh $modulesDir/functions.sh $assetsDir/submissions.txt $configDir/config.env

# Write a script to the reminder.sh file
cat << 'EOF' > $appDir/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

chmod u+x $appDir/reminder.sh

# Write a sample config.env file

cat << 'EOF' > $configDir/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Write a script in functions.sh file
cat << 'EOF' > $modulesDir/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

chmod u+x $modulesDir/functions.sh

# Create a sample submissions.txt file
cat << 'EOF' > $assetsDir/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Uche, Shell Navigation, not submitted
Mary, Git, not submitted
Chidera, Shell Navigation, submitted
Chinonso, Shell Basics, not submitted
Uwem, Shell Navigation, not submitted
EOF

# Create a startup script that runs the reminder script
startupScript=$mainDir/startup.sh
echo "#!/bin/bash" > $startupScript
echo "./app/reminder.sh" >> $startupScript
chmod +x $startupScript
