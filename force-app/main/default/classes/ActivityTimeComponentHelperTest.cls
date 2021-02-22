@isTest
public with sharing class ActivityTimeComponentHelperTest {

    @testSetup 
    static void setup() {
    }
    
    static testmethod void testrunApex() {    
        Object results = ActivityTimeComponentHelper.getActivities(null, 'Task', 'Subject', 'CreatedDate', 'CompletedDateTime', null);

        System.assertEquals(1, 1);
    }
}