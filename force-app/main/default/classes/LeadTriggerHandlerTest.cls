@isTest
public class LeadTriggerHandlerTest{

    @isTest
    static void testLeadWithKnownTerritory(){
        Lead lead =new Lead (
          FirstName = 'Test',
          LastName = 'CA Lead',
          Company = 'Test Company',
          State = 'CA',
          Title = 'VP of Operation',
        Marketing_Consent_c__c = true,
     Estimated_Deal_Value_c__c = 60000
        );

       Test.startTest();
       insert lead;
       Test.stopTest();

       Lead insertedLead= [
        SELECT Id, Lead_Score__c, OwnerId FROM Lead WHERE Id = :lead.Id

       ];
      System.assertEquals(60, insertedLead.Lead_Score__c);

      User expectedOwner = [
         SELECT Id FROM User
        WHERE Name = 'Sam Rivera'
        LIMIT 1
      ];

      System.assertEquals(expectedOwner.Id, insertedLead.OwnerId);
    }

    @isTest
static void testLeadWithUnknownTerritory(){

    Lead lead = new Lead(
        FirstName = 'Test',
        LastName = 'Unknown Territory',
        Company = 'Test Company',
        State = 'TX',
        Title = 'Sales Representative',
        Marketing_Consent_c__c = false,
        Estimated_Deal_Value_c__c = 10000
    );

    Test.startTest();

    insert lead;

    Test.stopTest();

    Lead insertedLead = [
        SELECT Id, OwnerId
        FROM Lead
        WHERE Id = :lead.Id
    ];

    System.assertNotEquals(null, insertedLead.OwnerId);
}
    
    @isTest 
    static void testLeadWithNoScoringConditions(){
        Lead lead= new Lead(
              FirstName = 'Test',
        LastName = 'No Score',
        Company = 'Test Company',
        State = 'TX',
        Title = 'Sales Representative',
        Marketing_Consent_c__c = false,
        Estimated_Deal_Value_c__c = 10000
        );

        Test.startTest();
        insert lead;
        Test.stopTest();

        Lead insertedLead=[
            SELECT Id,  Lead_Score__c FROM Lead WHERE Id = :lead.Id
        ];
         System.assertEquals(0, insertedLead.Lead_Score__c);

    }
}