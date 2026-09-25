public class LeadTriggerHandler {

    public static void handleBeforeInsert(List<Lead> newLeads) {

        // 1. Calculate Lead Score
        for (Lead lead : newLeads) {

            Integer score = 0;

            if (lead.Marketing_Consent_c__c == true) {
                score += 30;
            }

            if (lead.Estimated_Deal_Value_c__c > 50000) {
                score += 20;
            }

            if (lead.Title != null &&
                (lead.Title.contains('VP') ||
                 lead.Title.contains('Director') ||
                 lead.Title.contains('Chief'))) {
                score += 10;
            }

           lead.Lead_Score__c = score;
        }


        // 2. Get Territory Rules
        Map<String, String> territoryOwners = new Map<String, String>();

        for (Territory_Assignment_Rule__mdt rule : [
    SELECT State_Code_c__c, Assigned_Owner_c__c
    FROM Territory_Assignment_Rule__mdt
]) {
    territoryOwners.put(
        rule.State_Code_c__c,
        rule.Assigned_Owner_c__c
    );
}


        // 3. Find Salesforce Users
        Map<String, Id> userIds = new Map<String, Id>();

        for (User user : [
            SELECT Id, Name
            FROM User
            WHERE Name IN :territoryOwners.values()
        ]) {
            userIds.put(user.Name, user.Id);
        }


        // 4. Assign Lead Owner
        for (Lead lead : newLeads) {

            if (territoryOwners.containsKey(lead.State)) {

                String ownerName = territoryOwners.get(lead.State);

                if (userIds.containsKey(ownerName)) {
                    lead.OwnerId = userIds.get(ownerName);
                }
            }
        }
    }
}