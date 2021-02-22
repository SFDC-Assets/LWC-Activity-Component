#!/bin/bash

echo "*** Creating scratch org ..."
sfdx force:org:create -f config/project-scratch-def.json --setdefaultusername --setalias activityTrackerScratch -d 30

echo "*** Pushing metadata to scratch org ..."
sfdx force:source:push

echo "*** Assigning permission set to your users ..."
#sfdx force:user:permset:assign -n activityTrackerScratch -u scratch

echo "*** Generating password for your users ..."
sfdx force:user:password:generate --targetusername activityTrackerScratch

echo "*** Creating data"
sfdx sfdmu:run --sourceusername csvfile --targetusername activityTrackerScratch -p data

echo "*** Setting up debug mode..."
sfdx force:apex:execute -f scripts/apex/setDebugMode.apex

echo "*** Opening Org"
sfdx force:org:open
