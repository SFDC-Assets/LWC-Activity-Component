@isTest
public with sharing class ActivityTimeComponentHelperTest {

    @testSetup 
    static void setup() {

        Account newAccount = new Account(Name = 'Test Account');
        insert newAccount;  

        Contact newContact = new Contact(FirstName='Joe',LastName='Smith',Phone='415.555.1212',AccountId=newAccount.Id);
        insert newContact;          

        Case newCase = new Case(ContactId = newContact.Id, AccountId = newAccount.Id, Status = 'Working', Origin = 'Phone');
        insert newCase;

        List<Task> taskList = new List<Task>();

        Task newTask = new Task(Subject = 'Web', Status = 'Completed',Priority = 'Normal', WhatId = newCase.Id, OwnerId = UserInfo.getUserId());
        taskList.add(newTask);

        newTask = new Task(Subject = 'Email', Status = 'Completed',Priority = 'Normal', WhatId = newCase.Id, OwnerId = UserInfo.getUserId());
        taskList.add(newTask);
 
        Insert taskList;

    }
    
    static testmethod void testRunNoId() { 
        
        List<Task> results = (List<Task>) ActivityTimeComponentHelper.getActivities(null, 'Task', 'Subject', 'CreatedDate', 'CompletedDateTime', null);

        System.assertEquals(2, results.size());
    }

    static testmethod void testRunWithId() { 
        
        Case thisCase = [SELECT Id FROM Case];

        List<Task> results = (List<Task>) ActivityTimeComponentHelper.getActivities(thisCase.Id, null, null, null, null, null);

        System.assertEquals(2, results.size());
    }

    static testmethod void testRunWithWhereClause() { 
        
        Case thisCase = [SELECT Id FROM Case];

        List<Task> results = (List<Task>) ActivityTimeComponentHelper.getActivities(null, null, null, null, null, 'Subject = \'Web\'');

        System.assertEquals(1, results.size());
    }
    
    static testmethod void testRunBadQuery() { 
        
        Case thisCase = [SELECT Id FROM Case];

        List<Task> results = (List<Task>) ActivityTimeComponentHelper.getActivities(null, 'Contact', null, null, null, null);

        System.assertEquals(null, results);
    }   
}