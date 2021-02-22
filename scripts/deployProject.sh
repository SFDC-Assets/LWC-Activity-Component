
echo "*** Run Test Cases W\Coverage ..."
sfdx force:apex:test:run -c -u activityTrackerScratch -r human

#No Longer Needed
#echo "*** Creating Managed Package ..."
#sfdx force:package:create -n "Activity Tracker Demo Component" -t Unlocked --nonamespace -r force-app --targetdevhubusername CDOPackageManager

echo "*** Creating Managed Package Version..."
sfdx force:package:version:create --package "Activity Tracker Demo Component" -x --wait 10 --codecoverage  --definitionfile config/project-scratch-def.json

echo "*** Promoting Latest Managed Package ..."
sfdx force:package:version:promote -p $(sfdx force:package:version:list -p 'Activity Tracker Demo Component' -o CreatedDate --concise | tail -1 | awk '{print $3}')