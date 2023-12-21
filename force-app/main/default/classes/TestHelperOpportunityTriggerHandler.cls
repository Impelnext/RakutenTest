public class TestHelperOpportunityTriggerHandler{
    
    public static user createUser(String ProfileName,String UserName){
        List<Profile> profileId = [SELECT Id FROM Profile WHERE Profile.Name =: ProfileName]; //System Administrator
        
        User userObj = new User (
        Username = UserName,//'testEmail@gmail.com', 
        LastName = 'test value', 
        Email = UserName,//'testEmail@gmail.com', 
        Alias = 'test', 
        CommunityNickname = 'test value', 
        TimeZoneSidKey ='Pacific/Kiritimati', 
        LocaleSidKey ='is_IS', 
        EmailEncodingKey ='UTF-8', 
        ProfileId = profileId[0].id, 
        LanguageLocaleKey ='en_US'
        
        );
        return userObj;
    }
    
    public static account createAccount(){
         Account accountObj = new Account (
            LastName='個人',
            FirstName='取引先',
            LastName__pc='個人',
            firstname__pc='取引先',
            furiganaLast__pc='こじん',
            furiganaForst__pc='とりひきさき',
            OperationType__c ='割当可',
           
            PersonMobilePhone  = '88-8888-8888',
            OpportunityStatus__c ='未対応'
        );
        return accountObj;
    }
    
    public static opportunity createOpportunity(Id RecordTypeId,String StageName,Id accountId,String OppName){
         Opportunity opportunityObj = new Opportunity (
            AccountId = accountId,//accountObj.id, 
            RecordTypeId = RecordTypeId,//oppHanyoRecordTypeId, 
            CampaignDateTime__c = System.now(), 
            InflowRoute__c ='ミニ保険', 
            Answer10__c = 'Test Value', 
            Answer1__c = 'Test Value', 
            Answer2_1__c = 'Test Value', 
            Answer2_2__c = 'Test Value', 
            Answer2__c = 'Test Value', 
            Answer3__c = 'Test Value', 
            Answer4__c = 'Test Value', 
            Answer5__c = 'Test Value', 
            Answer6__c = 'Test Value', 
            Answer7__c = 'Test Value', 
            Answer8__c = 'Test Value', 
            Answer9__c = 'Test Value', 
            DateSource__c = 'test value', 
            Date__c = Date.today(), 
            Item10__c = 'test value', 
            Item1__c = 'test value', 
            Item2__c = 'test value', 
            Item3__c = 'test value', 
            Item4__c = 'test value', 
            Item5__c = 'test value', 
            Item6__c = 'test value', 
            Item7__c = 'test value', 
            Item8__c = 'test value', 
            Item9__c = 'test value', 
            ItemLong10__c = 'Test Value', 
            ItemLong1__c = 'Test Value', 
            ItemLong2__c = 'Test Value', 
            ItemLong3__c = 'Test Value', 
            ItemLong4__c = 'Test Value', 
            ItemLong5__c = 'Test Value', 
            ItemLong6__c = 'Test Value', 
            ItemLong7__c = 'Test Value', 
            ItemLong8__c = 'Test Value', 
            ItemLong9__c = 'Test Value', 
            Question10__c = 'test value', 
            Question1__c = 'test value', 
            Question2__c = 'test value', 
            Question3__c = 'test value', 
            Question4__c = 'test value', 
            Question5__c = 'test value', 
            Question6__c = 'test value', 
            Question7__c = 'test value', 
            Question8__c = 'test value', 
            Question9__c = 'test value', 
            //ExLeadUpdateDate__c = System.now(), 
            //MiniUpdateDate__c = System.now(), 
            Name = OppName, 
            StageName = StageName,//'未割当', 
            CloseDate = Date.today()
        );
        return opportunityObj;
    }
}