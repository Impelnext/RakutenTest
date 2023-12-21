global class BatchFetchDataCleansingLifeContract implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from LifeContract
        String strQuery = 'SELECT AccountId__c, KANA_CONTROR_NAME__c, CONTROR_BIRTH_DATE__c, CONTROR_POST_CODE__c, CONTRANT_PHONE__c, CONTRANT_MOBILE_PHONE__c, WEB_USER_ID__c, CSID__c FROM LifeContract__c WHERE AccountId__c != null AND STATUS_DISPLAY__c = \'有効\'';
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Work1__c> workRecords = new List<Work1__c>();
        List<String> userIds = new List<String>();

        // Query SeihoMember records based on collected WEB_USER_ID values
        Map<String, Work1__c> userIdToWork1Map = new Map<String, Work1__c>();

        for (sObject obj : scope) {
            // Collect WEB_USER_ID values from LifeContract records
            LifeContract__c lifeContract = (LifeContract__c)obj;
            String webuserid = (String)lifeContract.get('WEB_USER_ID__c');
            userIds.add(webuserid);

            // Create a Work1 record and map fields
            Work1__c workRecord = new Work1__c();
            workRecord.AccountId__c = (Id)lifeContract.get('AccountId__c');
            workRecord.Data_Source__c = 'Life';
            workRecord.NameKana__c = lifeContract.KANA_CONTROR_NAME__c;
            workRecord.BirthDate__c = lifeContract.CONTROR_BIRTH_DATE__c;
            workRecord.PostalCode__c = lifeContract.CONTROR_POST_CODE__c;
            workRecord.Phone__c = lifeContract.CONTRANT_PHONE__c;
            workRecord.CSID__c = lifeContract.CSID__c;
            workRecord.MobilePhone__c = lifeContract.CONTRANT_MOBILE_PHONE__c;
            workRecords.add(workRecord);
            if(String.isNotBlank(webUserId)) {
                userIdToWork1Map.put(webUserId, workRecord);
            }
        }

        for(SeihoMember__c seihoMember : [SELECT Id, Name, EasyId__c FROM SeihoMember__c WHERE Name IN :userIds]) {
            // userIdToWork1Map.put((String)seihoMember.Name, seihoMember);
            if(userIdToWork1Map.containsKey(seihoMember.Name)) {
                // Check if EasyId exists in SeihoMember and map it to Work1
                if (String.isNotBlank(seihoMember.EasyId__c)) {
                    userIdToWork1Map.get(seihoMember.Name).EasyId__c = seihoMember.EasyId__c;
                }
            }
        }
        
        // Insert Work1 records
        insert workRecords;
    }

    global void finish(Database.BatchableContext BC) {
    }
}