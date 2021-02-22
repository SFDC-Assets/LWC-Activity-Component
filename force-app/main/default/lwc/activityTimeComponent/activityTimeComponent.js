import { LightningElement, api, track } from 'lwc';

import getActivities from "@salesforce/apex/ActivityTimeComponentHelper.getActivities";
import SystemModstamp from '@salesforce/schema/AcceptedEventRelation.SystemModstamp';

const columns = [
    { label: 'Activity Type', fieldName: 'Type', hideDefaultActions:true},
    { label: 'Hours', fieldName: 'TotalHours', hideDefaultActions:true, fixedWidth:75},
];

export default class ActivityTimeComponent extends LightningElement {
    @api recordId;
    @api Title = 'Activity Tracker';
    @api AlternateObjectApiName = 'Task';
    @api CreatedDateTimeField = 'CreatedDate';
    @api CompletedDateTimeField = 'CompletedDateTime';
    @api WhereClause = '';
    @api GroupByField = 'Subject';

    @track activityData = [];
    @track totalHours = 0;
    
    @track apiCallCompletedFlag = false;
    @track apiResultsFlag = false; 

    tableData = [];
    
    columns = columns;

    connectedCallback() {
      console.log(`Component Config: Title:${this.Title},  AlternateObjectApiName:${this.AlternateObjectApiName},  CreatedDateTimeField:${this.CreatedDateTimeField},  CompletedDateTimeField:${this.CompletedDateTimeField},  WhereClause:${this.WhereClause},  GroupByField:${this.GroupByField}}, `)
      console.log("Running doRefreshComponent");
      this.doRefreshComponent(false);
    }


    doRefreshComponent(forcedRefreshFlag) {
      getActivities({recordId: this.recordId, objectApiName: this.AlternateObjectApiName, groupByField: this.GroupByField, createdDateTimeField: this.CreatedDateTimeField, completedDateTimeField: this.CompletedDateTimeField, whereClause: this.WhereClause})
        .then((data) => {
          console.log(`getActivities Success! Response: ${JSON.stringify(data)}`);

          this.apiCallCompletedFlag = true;
          if(data.length > 0){
              this.apiResultsFlag = true; 
              this.activityData = data;
              this.getTotalHours();
              this.getTableData();
          }

          this.error = undefined;
        })
        .catch((error) => {
          console.log(`getActivities Fail! Response: ${JSON.stringify(error)}`);
          this.error = error;
        });
    }
  

  getTableData(){
    console.log(`Running getTableData...GroupByField = ${this.GroupByField}`);
    let tableData = [];

    //Loop to get Types
    console.log(`Running Type Loop`);
    for(let i = 0; i < this.activityData.length; i ++){
      //We automatically create a record if its the first one...
      console.log(`Running Type Outer Loop ${i} -> ${this.activityData[i][this.GroupByField]}`);

      let newRecordFlag = true;
        if(i > 0){
          for(let j = 0; j < tableData.length; j ++){
            if(tableData[j].Type === this.activityData[i][this.GroupByField]){
              console.log(`${this.activityData[i][this.GroupByField]} is an existing Type, do not add!`);
              newRecordFlag = false;
            }
          }
        }
        if(newRecordFlag){
          console.log(`New Type ${this.activityData[i][this.GroupByField]} found, adding...`);
          let tableRecord = {};
          tableRecord.id = this.activityData[i].Id;
          tableRecord.Type = this.activityData[i][this.GroupByField];
          tableRecord.TotalHours = 0;
          tableData.push(tableRecord);
        }
    }



    //Data Loop!!!!
    console.log(`Running Main Calculation Loop`);
    for(let i = 0; i < tableData.length; i ++){
      for(let j = 0; j < this.activityData.length; j ++){
        if(tableData[i].Type === this.activityData[j][this.GroupByField]){
          console.log(`Type ${tableData[i].Type} is a Match...Calculating difference `);
          let difference = (Date.parse(this.activityData[j][this.CompletedDateTimeField]) - Date.parse(this.activityData[j][this.CreatedDateTimeField])) / (60*60*1000);
          console.log(`Adding ${difference} to ${tableData[i].TotalHours}`);
          tableData[i].TotalHours += difference;
        }
      }
    }


    //Loop to Round and make whole number
    console.log(`Running Average Loop`);
    for(let i = 0; i < this.activityData.length; i ++){
        tableData[i].TotalHours = Math.abs(Math.round(tableData[i].TotalHours));
    }

    console.log(`tableData: ${JSON.stringify(tableData)}`);
    this.tableData = tableData;
  }

  getTotalHours(){
    let totalHours = 0;
    if(this.activityData.length > 0){
      for(let i = 0; i < this.activityData.length; i ++){
        console.log(`Activity ${this.activityData[i].Id} CreatedDateTime: ${this.activityData[i][this.CreatedDateTimeField]}, CompletedDateTimeField: ${this.activityData[i][this.CompletedDateTimeField]}`);
        let difference = (Date.parse(this.activityData[i][this.CompletedDateTimeField]) - Date.parse(this.activityData[i][this.CreatedDateTimeField])) / (60*60*1000);
        console.log(`Difference = ${difference}`);       
        totalHours += difference;
      }
      if(totalHours < 1){
        this.totalHours =  '<1';
      }else{
        this.totalHours = Math.abs(Math.round(totalHours));
      }
    }else{
      this.totalHours = 0;
    }
  }
      


    // List = Productivity_Type__C
    // Time Calculation= Duration__c
    // ClosedDate__c

}