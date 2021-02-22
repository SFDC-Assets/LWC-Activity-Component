public inherited sharing class ActivityTimeComponentHelper {
    /* 
    * DEFAULT FIELDS
    * objectApiName: Task
    * createdDateTimeField: CreatedDate
    * completedDateTimeField: CompletedDateTime
    * GroupByField: Subject //This just adds the field to the query...
    * Example Query:  SELECT ActivityDate, Type, CreatedDate, CompletedDateTime, Productivity_Type__C, Duration__c, Status, Description from TASK WHERE Status = 'Completed' AND RecordType.DeveloperName = 'Case_Managers_TASK'
    */
    @AuraEnabled
    public static List<Object> getActivities(String recordId, String objectApiName, String groupByField, String createdDateTimeField, String completedDateTimeField, String whereClause){

        System.debug('Processing the following:');
        System.debug('recordId:' + recordId + ' objectApiName:' + objectApiName + ' groupByField:' + groupByField + ' createdDateTimeField:' + createdDateTimeField + ' completedDateTimeField:' + completedDateTimeField + ' whereClause:' + whereClause);
        
        String queryWhereClause = 'WHERE ';
        String queryObjectApiName = 'Task';
        String querySelect = 'SELECT ActivityDate, Type, Subject, CreatedDate, CompletedDateTime, Status, Description';

        if(null != objectApiName && '' != objectApiName){
            queryObjectApiName = objectApiName;
        }

        if(null != createdDateTimeField && '' != createdDateTimeField && createdDateTimeField != 'CreatedDate'){
            querySelect = querySelect + ', ' + createdDateTimeField;
        }

        if(null != groupByField && '' != groupByField && groupByField != 'Subject'){
            querySelect = querySelect + ', ' + groupByField;
        }

        if(null != completedDateTimeField && '' != completedDateTimeField && completedDateTimeField != 'CompletedDateTime'){
            querySelect = querySelect + ', ' + completedDateTimeField;
        }

        if(null != whereClause && '' != whereClause){
            queryWhereClause = queryWhereClause + ' AND ' + whereClause;
        }else if(queryObjectApiName == 'Task'){
            queryWhereClause = queryWhereClause + ' Status = \'Completed\' ';
        }

        if(null != recordId && '' != recordId){
            queryWhereClause = queryWhereClause + ' AND WhatId = \'' + recordId + '\'';
        }        

        string processQuery = querySelect + ' FROM ' + queryObjectApiName + ' ' + queryWhereClause;

        System.debug('Running the following Query:');
        System.debug(processQuery);

        return DataBase.query(processQuery);
    }

}
