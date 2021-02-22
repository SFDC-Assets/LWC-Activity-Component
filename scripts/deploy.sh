echo "*** Pushing metadata to scratch org ..."
sfdx force:source:push

echo "*** Deploying metadata to target org ..."
sfdx force:source:deploy --targetusername VAMSDevHub --sourcepath force-app

echo "*** Re-Importing Data ..."
sfdx sfdmu:run --sourceusername csvfile --targetusername eWRTS -p data

echo "*** Setting up Remote Site Settings ..."
sfdx force:apex:execute -f scripts/apex/createRemoteSiteSettings.apex -u eWRTS