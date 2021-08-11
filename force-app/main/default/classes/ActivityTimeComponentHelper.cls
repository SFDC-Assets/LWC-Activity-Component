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
        
        Boolean badquery = false;

        String queryWhereClause = 'WHERE ';
        String queryObjectApiName = 'Task';
        String querySelect = 'SELECT Id ';

        if(null != objectApiName && '' != objectApiName){
            queryObjectApiName = objectApiName;
        }

        //createdDateTimeField
        querySelect += ', ' + ((null != createdDateTimeField && '' != createdDateTimeField) ? createdDateTimeField : 'CreatedDate');

        //completedDateTimeField
        querySelect += ', ' + ((null != completedDateTimeField && '' != completedDateTimeField) ? completedDateTimeField : 'CompletedDateTime');

        //groupByField
        querySelect += ', ' + ((null != groupByField && '' != groupByField) ? groupByField : 'Subject');

        //whereClause
        queryWhereClause += ((null != whereClause && '' != whereClause) ? whereClause : ' Status = \'Completed\' ');

        //recordId
        if(null != recordId && '' != recordId){
            queryWhereClause += ' AND WhatId = \'' + recordId + '\'';
        }        

        string processQuery = querySelect + ' FROM ' + queryObjectApiName + ' ' + queryWhereClause;

        System.debug('Running the following Query:');
        System.debug(processQuery);
        
        try {
            return DataBase.query(processQuery);
        } catch(QueryException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }

        System.debug('Returning Null');
        return null;
    }

}
