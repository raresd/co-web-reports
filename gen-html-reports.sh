#!/bin/bash

echo "Copying directory structure from PVCs to web result server"

#
# This command will create the folder structure on the HTML/WEB report PVC to match the one created by the Complianc Operator report server. 
# Note: In the Web Server all PVCs are mounted in /var/opt/ directory. 
cd /var/opt
find . -type d -exec mkdir -p -- /web-results/{} \;

# 
# Looping over all Compliance Operator created PVCs. There is one for each Compliance Operator Profile. 
#
for dir in /var/opt/*/ ; do

  # Keeping only the folder name instead of the full path
  dir_name=${dir%*/}
  dir_name=${dir_name##*/}

  # Compliance Operator is keeping 'N' revisions (configurable on CO) of the openscap scans. Looping over them. 
  for subdir in ${dir}* ; do

    iter_name=${subdir%*/}
    iter_name=${iter_name##*/}

    if [ ${iter_name} != "lost+found" ] ; then
      
      # For each revision we are looking at reports. 
      for report in ${subdir}/* ; do

        web_report_name=${report##*/}
        web_report_name=${web_report_name%.*.*}

        # If the HTML/WEB report has not been created already, it will be created. 
        if ! [ -f $(echo "/web-results/${dir_name}/${iter_name}/${web_report_name}.html") ] ; then
          echo "Generating HTML report /web-results/${dir_name}/${iter_name}/${web_report_name}.html"
          oscap xccdf generate report $report > $(echo "/web-results/${dir_name}/${iter_name}/${web_report_name}.html")
        else 
          echo "HTML/Web report /web-results/${dir_name}/${iter_name}/${web_report_name}.html already exists"
        fi        

      done

    fi

  done

done
