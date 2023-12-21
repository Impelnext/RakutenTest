/**
     * @File Name          : OpportunityTriggerTest.cls
     * @Description        : 
     * @Author             : SRM
     * @Group              : 
     * @Last Modified By   : SRM
     * @Last Modified On   : 1/17/2020, 5:47:28 PM
     * @Modification Log   : 
     * Ver       Date            Author                 Modification
     * 1.0    1/17/2020   SRM     Initial Version
    **/
    @isTest
    private class OpportunityTriggerTest{
        
        @isTest static void ProcessTest_With_Exist_Opp() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
            OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //System.runAs(userObj) {
                //create Opportunity
                Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName1');
                //OPP.OwnerId = userObj.Id;
                insert opp;
            //}
            Test.startTest();
           
             //create Opportunity
            Opportunity opp1 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSyotonRecordTypeId,'対応中',acc.id,'OppName2');
            insert opp1;
            
            Test.stopTest();
            List<Opportunity> OppList = [Select id,StageName from Opportunity];
            System.assertEquals('未割当', OppList[0].StageName);
            Opportunity oppt = triggerTest.getOpportunityById(OppList[1].id);
            System.assertEquals(Oppt.OwnerId, Oppt.OwnerForBulkChange__c);
             Map<Id, Schema.RecordTypeInfo> oppRecordTypeMapById = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosById();
            
            System.assertEquals(Oppt.RecordTypeForBulkChange__c, oppRecordTypeMapById.get(oppt.RecordTypeId).getName());
        }

        @isTest static void ProcessTest_With_New_Opp() {
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;

            //create Opportunity
            Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.Id,'OppName1');
            insert opp; 
            
             Map<Id, Schema.RecordTypeInfo> oppRecordTypeMapById = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosById();
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            System.assertEquals(Oppt.OwnerId, Oppt.OwnerForBulkChange__c);      
            System.assertEquals(Oppt.RecordTypeForBulkChange__c, oppRecordTypeMapById.get(oppt.RecordTypeId).getName());
        }
        @isTest static void ProcessTest_With_Opp_Update() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            update opp;
            
            Test.stopTest();
            Account acct = triggerTest.getAccountById(acc.Id);
            List<Opportunity> OppList = [Select id,StageName from Opportunity];
            System.assertEquals('未割当', OppList[0].StageName);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            Opportunity destOpp = triggerTest.getOpportunityById(oppSonpo.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');   
            System.assertEquals(Oppt.CloseReason__c, '他商談にて対応');    
            System.assertEquals(Oppt.RecordTypeId, oppHanyoRecordTypeId);   
            System.assertEquals(Oppt.RecentProbability__c,'申込なし');  
            System.assertEquals(Oppt.DestinationOpportunity__c, oppSonpo.id);
            System.assertEquals(Oppt.CampaignDateTime__c, destOpp.CampaignDateTime__c);
            
            System.assertEquals(destOpp.MiniUpdateDate__c , oppt.MiniUpdateDate__c);
            // 移行先商談．質問 = （作成または更新）商談．質問
            System.assertEquals(destOpp.Question1__c ,oppt.Question1__c);
            System.assertEquals(destOpp.Question2__c ,oppt.Question2__c);
            System.assertEquals(destOpp.Question3__c ,oppt.Question3__c);
            System.assertEquals(destOpp.Question4__c ,oppt.Question4__c);
            System.assertEquals(destOpp.Question5__c ,oppt.Question5__c);
            System.assertEquals(destOpp.Question6__c ,oppt.Question6__c);
            System.assertEquals(destOpp.Question7__c ,oppt.Question7__c);
            System.assertEquals(destOpp.Question8__c ,oppt.Question8__c);
            System.assertEquals(destOpp.Question9__c ,oppt.Question9__c);
            System.assertEquals(destOpp.Question10__c ,oppt.Question10__c);
            // 移行先商談．回答 = （作成または更新）商談．回答
            System.assertEquals(destOpp.Answer1__c ,oppt.Answer1__c);
            System.assertEquals(destOpp.Answer2__c ,oppt.Answer2__c);
            System.assertEquals(destOpp.Answer2_1__c ,oppt.Answer2_1__c);
            System.assertEquals(destOpp.Answer2_2__c ,oppt.Answer2_2__c);
            System.assertEquals(destOpp.Answer3__c ,oppt.Answer3__c);
            System.assertEquals(destOpp.Answer4__c ,oppt.Answer4__c);
            System.assertEquals(destOpp.Answer5__c ,oppt.Answer5__c);
            System.assertEquals(destOpp.Answer6__c ,oppt.Answer6__c);
            System.assertEquals(destOpp.Answer7__c ,oppt.Answer7__c);
            System.assertEquals(destOpp.Answer8__c ,oppt.Answer8__c);
            System.assertEquals(destOpp.Answer9__c ,oppt.Answer9__c);
            System.assertEquals(destOpp.Answer10__c ,oppt.Answer10__c);
            
            System.assertEquals(destOpp.DateSource__c,oppt.DateSource__c);
                    // 移行先商談．外部データソース更新日時 = （作成または更新）商談．外部データソース更新日時
            System.assertEquals(destOpp.ExLeadUpdateDate__c,oppt.ExLeadUpdateDate__c);
            // 移行先商談．項目 = （作成または更新）商談．項目
            System.assertEquals(destOpp.Item1__c,oppt.Item1__c);
            System.assertEquals(destOpp.Item2__c,oppt.Item2__c);
            System.assertEquals(destOpp.Item3__c,oppt.Item3__c);
            System.assertEquals(destOpp.Item4__c,oppt.Item4__c);
            System.assertEquals(destOpp.Item5__c,oppt.Item5__c);
            System.assertEquals(destOpp.Item6__c,oppt.Item6__c);
            System.assertEquals(destOpp.Item7__c,oppt.Item7__c);
            System.assertEquals(destOpp.Item8__c,oppt.Item8__c);
            System.assertEquals(destOpp.Item9__c,oppt.Item9__c);
            System.assertEquals(destOpp.Item10__c,oppt.Item10__c);
             // 移行先商談．項目ロング = （作成または更新）商談．項目ロング
            System.assertEquals(destOpp.ItemLong1__c,oppt.ItemLong1__c);
            System.assertEquals(destOpp.ItemLong2__c,oppt.ItemLong2__c);
            System.assertEquals(destOpp.ItemLong3__c,oppt.ItemLong3__c);
            System.assertEquals(destOpp.ItemLong4__c,oppt.ItemLong4__c);
            System.assertEquals(destOpp.ItemLong5__c,oppt.ItemLong5__c);
            System.assertEquals(destOpp.ItemLong6__c,oppt.ItemLong6__c);
            System.assertEquals(destOpp.ItemLong7__c,oppt.ItemLong7__c);
            System.assertEquals(destOpp.ItemLong8__c,oppt.ItemLong8__c);
            System.assertEquals(destOpp.ItemLong9__c,oppt.ItemLong9__c);
            System.assertEquals(destOpp.ItemLong10__c,oppt.ItemLong10__c);
             // 移行先商談．日付 = （作成または更新）商談．日付
            System.assertEquals(destOpp.Date__c,oppt.Date__c);
            
            System.assertEquals(acct.OperationType__c,'割当可');
            System.assertEquals(acct.OpportunityStatus__c,'対応継続可');
        }
         @isTest static void ProcessTest_With_Opp_UpdateNg() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            acc.OperationType__c = '架電禁止';
            acc.OpportunityStatus__c='全商談終了'; 
            acc.MeetingSalesflg__c = false;
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            opp = triggerTest.getOpportunityById(opp.id);
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            opp.RecentResultType_Middle__c = '対面誘導';
            opp.RecentResultType_Small__c = '了承';
            opp.StopCallingList__c = '進行中商談の全終了';
            update opp;
            
            Test.stopTest();
            Account acct = triggerTest.getAccountById(acc.Id);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');   
            System.assertEquals(Oppt.CloseReason__c, '取引先架電禁止');    
            System.assertEquals(Oppt.RecentProbability__c, '申込なし'); 
            System.assertEquals(Oppt.StopCallingList__c, '進行中商談の全終了');
            
            System.assertEquals(acct.OperationType__c,'架電禁止');
            System.assertEquals(acct.OpportunityStatus__c,'全商談終了');

        }
        @isTest static void ProcessTest_With_Opp_Update_OpType() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            acc.OperationType__c = '有効商談なし';            
            acc.OpportunityStatus__c = '全商談終了';
            acc.MeetingSalesflg__c = false;
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            opp.RecentResultType_Middle__c = '対面誘導';
            opp.RecentResultType_Small__c = '了承';
            opp.StopCallingList__c = '永続的な架電禁止';
            update opp;
            
            Test.stopTest();
            Account acct = triggerTest.getAccountById(acc.Id);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            Opportunity destOpp = triggerTest.getOpportunityById(oppSonpo.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');   
            System.assertEquals(Oppt.CloseReason__c, '他商談にて対応');    
            System.assertEquals(Oppt.RecordTypeId, oppHanyoRecordTypeId);   
            System.assertEquals(Oppt.RecentProbability__c,'申込なし');  
            System.assertEquals(Oppt.DestinationOpportunity__c, oppSonpo.id);
            System.assertEquals(Oppt.CampaignDateTime__c, destOpp.CampaignDateTime__c);
            
            System.assertEquals(destOpp.MiniUpdateDate__c , oppt.MiniUpdateDate__c);
            // 移行先商談．質問 = （作成または更新）商談．質問
            System.assertEquals(destOpp.Question1__c ,oppt.Question1__c);
            System.assertEquals(destOpp.Question2__c ,oppt.Question2__c);
            System.assertEquals(destOpp.Question3__c ,oppt.Question3__c);
            System.assertEquals(destOpp.Question4__c ,oppt.Question4__c);
            System.assertEquals(destOpp.Question5__c ,oppt.Question5__c);
            System.assertEquals(destOpp.Question6__c ,oppt.Question6__c);
            System.assertEquals(destOpp.Question7__c ,oppt.Question7__c);
            System.assertEquals(destOpp.Question8__c ,oppt.Question8__c);
            System.assertEquals(destOpp.Question9__c ,oppt.Question9__c);
            System.assertEquals(destOpp.Question10__c ,oppt.Question10__c);
            // 移行先商談．回答 = （作成または更新）商談．回答
            System.assertEquals(destOpp.Answer1__c ,oppt.Answer1__c);
            System.assertEquals(destOpp.Answer2__c ,oppt.Answer2__c);
            System.assertEquals(destOpp.Answer2_1__c ,oppt.Answer2_1__c);
            System.assertEquals(destOpp.Answer2_2__c ,oppt.Answer2_2__c);
            System.assertEquals(destOpp.Answer3__c ,oppt.Answer3__c);
            System.assertEquals(destOpp.Answer4__c ,oppt.Answer4__c);
            System.assertEquals(destOpp.Answer5__c ,oppt.Answer5__c);
            System.assertEquals(destOpp.Answer6__c ,oppt.Answer6__c);
            System.assertEquals(destOpp.Answer7__c ,oppt.Answer7__c);
            System.assertEquals(destOpp.Answer8__c ,oppt.Answer8__c);
            System.assertEquals(destOpp.Answer9__c ,oppt.Answer9__c);
            System.assertEquals(destOpp.Answer10__c ,oppt.Answer10__c);
            
            System.assertEquals(destOpp.DateSource__c,oppt.DateSource__c);
            // 移行先商談．外部データソース更新日時 = （作成または更新）商談．外部データソース更新日時
            System.assertEquals(destOpp.ExLeadUpdateDate__c,oppt.ExLeadUpdateDate__c);
            // 移行先商談．項目 = （作成または更新）商談．項目
            System.assertEquals(destOpp.Item1__c,oppt.Item1__c);
            System.assertEquals(destOpp.Item2__c,oppt.Item2__c);
            System.assertEquals(destOpp.Item3__c,oppt.Item3__c);
            System.assertEquals(destOpp.Item4__c,oppt.Item4__c);
            System.assertEquals(destOpp.Item5__c,oppt.Item5__c);
            System.assertEquals(destOpp.Item6__c,oppt.Item6__c);
            System.assertEquals(destOpp.Item7__c,oppt.Item7__c);
            System.assertEquals(destOpp.Item8__c,oppt.Item8__c);
            System.assertEquals(destOpp.Item9__c,oppt.Item9__c);
            System.assertEquals(destOpp.Item10__c,oppt.Item10__c);
             // 移行先商談．項目ロング = （作成または更新）商談．項目ロング
            System.assertEquals(destOpp.ItemLong1__c,oppt.ItemLong1__c);
            System.assertEquals(destOpp.ItemLong2__c,oppt.ItemLong2__c);
            System.assertEquals(destOpp.ItemLong3__c,oppt.ItemLong3__c);
            System.assertEquals(destOpp.ItemLong4__c,oppt.ItemLong4__c);
            System.assertEquals(destOpp.ItemLong5__c,oppt.ItemLong5__c);
            System.assertEquals(destOpp.ItemLong6__c,oppt.ItemLong6__c);
            System.assertEquals(destOpp.ItemLong7__c,oppt.ItemLong7__c);
            System.assertEquals(destOpp.ItemLong8__c,oppt.ItemLong8__c);
            System.assertEquals(destOpp.ItemLong9__c,oppt.ItemLong9__c);
            System.assertEquals(destOpp.ItemLong10__c,oppt.ItemLong10__c);
             // 移行先商談．日付 = （作成または更新）商談．日付
            System.assertEquals(destOpp.Date__c,oppt.Date__c);
            
            System.assertEquals(acct.MeetingSalesflg__c,true);
            System.assertEquals(acct.OperationType__c,'架電禁止');
            System.assertEquals(acct.OpportunityStatus__c,'全商談終了');
        }
        @isTest static void ProcessTest_With_Opp_Update_OpType_PermCall() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            acc.OperationType__c = '有効商談なし';
            acc.OpportunityStatus__c = '全商談終了';
            acc.MeetingSalesflg__c = false;
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            Externaldatasource__c ex = new Externaldatasource__c();
            ex.OpportunityId__c = oppSonpo.id;
            insert ex;
            
            MiniInsurance__c mini = new MiniInsurance__c();
            mini.OpportunityId__c = oppSonpo.id;
            insert mini;
            
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            opp.RecentResultType_Middle__c = '対面誘導';
            opp.RecentResultType_Small__c = '了承';
            opp.StopCallingList__c = '永続的な架電禁止';
            update opp;
            
            
            Test.stopTest();
           Account acct = triggerTest.getAccountById(acc.Id);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            Opportunity destOpp = triggerTest.getOpportunityById(oppSonpo.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');   
            System.assertEquals(Oppt.CloseReason__c, '他商談にて対応');    
            System.assertEquals(Oppt.RecordTypeId, oppHanyoRecordTypeId);   
            System.assertEquals(Oppt.RecentProbability__c,'申込なし');  
            System.assertEquals(Oppt.DestinationOpportunity__c, oppSonpo.id);
            System.assertEquals(Oppt.CampaignDateTime__c, destOpp.CampaignDateTime__c);
            
            System.assertEquals(destOpp.MiniUpdateDate__c , oppt.MiniUpdateDate__c);
            // 移行先商談．質問 = （作成または更新）商談．質問
            System.assertEquals(destOpp.Question1__c ,oppt.Question1__c);
            System.assertEquals(destOpp.Question2__c ,oppt.Question2__c);
            System.assertEquals(destOpp.Question3__c ,oppt.Question3__c);
            System.assertEquals(destOpp.Question4__c ,oppt.Question4__c);
            System.assertEquals(destOpp.Question5__c ,oppt.Question5__c);
            System.assertEquals(destOpp.Question6__c ,oppt.Question6__c);
            System.assertEquals(destOpp.Question7__c ,oppt.Question7__c);
            System.assertEquals(destOpp.Question8__c ,oppt.Question8__c);
            System.assertEquals(destOpp.Question9__c ,oppt.Question9__c);
            System.assertEquals(destOpp.Question10__c ,oppt.Question10__c);
            // 移行先商談．回答 = （作成または更新）商談．回答
            System.assertEquals(destOpp.Answer1__c ,oppt.Answer1__c);
            System.assertEquals(destOpp.Answer2__c ,oppt.Answer2__c);
            System.assertEquals(destOpp.Answer2_1__c ,oppt.Answer2_1__c);
            System.assertEquals(destOpp.Answer2_2__c ,oppt.Answer2_2__c);
            System.assertEquals(destOpp.Answer3__c ,oppt.Answer3__c);
            System.assertEquals(destOpp.Answer4__c ,oppt.Answer4__c);
            System.assertEquals(destOpp.Answer5__c ,oppt.Answer5__c);
            System.assertEquals(destOpp.Answer6__c ,oppt.Answer6__c);
            System.assertEquals(destOpp.Answer7__c ,oppt.Answer7__c);
            System.assertEquals(destOpp.Answer8__c ,oppt.Answer8__c);
            System.assertEquals(destOpp.Answer9__c ,oppt.Answer9__c);
            System.assertEquals(destOpp.Answer10__c ,oppt.Answer10__c);
            
            System.assertEquals(destOpp.DateSource__c,oppt.DateSource__c);
            // 移行先商談．外部データソース更新日時 = （作成または更新）商談．外部データソース更新日時
            System.assertEquals(destOpp.ExLeadUpdateDate__c,oppt.ExLeadUpdateDate__c);
            // 移行先商談．項目 = （作成または更新）商談．項目
            System.assertEquals(destOpp.Item1__c,oppt.Item1__c);
            System.assertEquals(destOpp.Item2__c,oppt.Item2__c);
            System.assertEquals(destOpp.Item3__c,oppt.Item3__c);
            System.assertEquals(destOpp.Item4__c,oppt.Item4__c);
            System.assertEquals(destOpp.Item5__c,oppt.Item5__c);
            System.assertEquals(destOpp.Item6__c,oppt.Item6__c);
            System.assertEquals(destOpp.Item7__c,oppt.Item7__c);
            System.assertEquals(destOpp.Item8__c,oppt.Item8__c);
            System.assertEquals(destOpp.Item9__c,oppt.Item9__c);
            System.assertEquals(destOpp.Item10__c,oppt.Item10__c);
             // 移行先商談．項目ロング = （作成または更新）商談．項目ロング
            System.assertEquals(destOpp.ItemLong1__c,oppt.ItemLong1__c);
            System.assertEquals(destOpp.ItemLong2__c,oppt.ItemLong2__c);
            System.assertEquals(destOpp.ItemLong3__c,oppt.ItemLong3__c);
            System.assertEquals(destOpp.ItemLong4__c,oppt.ItemLong4__c);
            System.assertEquals(destOpp.ItemLong5__c,oppt.ItemLong5__c);
            System.assertEquals(destOpp.ItemLong6__c,oppt.ItemLong6__c);
            System.assertEquals(destOpp.ItemLong7__c,oppt.ItemLong7__c);
            System.assertEquals(destOpp.ItemLong8__c,oppt.ItemLong8__c);
            System.assertEquals(destOpp.ItemLong9__c,oppt.ItemLong9__c);
            System.assertEquals(destOpp.ItemLong10__c,oppt.ItemLong10__c);
             // 移行先商談．日付 = （作成または更新）商談．日付
            System.assertEquals(destOpp.Date__c,oppt.Date__c);
            
            System.assertEquals(acct.MeetingSalesflg__c,true);
            System.assertEquals(acct.OperationType__c,'架電禁止');
            System.assertEquals(acct.OpportunityStatus__c,'全商談終了');
        }
        @isTest static void ProcessTest_With_Opp_Update_OpType_Corres() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            acc.OperationType__c = '対応中';
            acc.OpportunityStatus__c = '生保フォロー中';
            acc.MeetingSalesflg__c = false;
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'対応中',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            Externaldatasource__c ex = new Externaldatasource__c();
            ex.OpportunityId__c = oppSonpo.id;
            insert ex;
            
            MiniInsurance__c mini = new MiniInsurance__c();
            mini.OpportunityId__c = oppSonpo.id;
            insert mini;
            
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            opp.RecentResultType_Middle__c = '対面誘導';
            opp.RecentResultType_Small__c = '了承';
            opp.StopCallingList__c = '永続的な架電禁止';
            update opp;
            
            
            Test.stopTest();
            Account acct = triggerTest.getAccountById(acc.Id);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            Opportunity destOpp = triggerTest.getOpportunityById(oppSonpo.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');   
            System.assertEquals(Oppt.CloseReason__c, '他商談にて対応');    
            System.assertEquals(Oppt.RecordTypeId, oppHanyoRecordTypeId);   
            System.assertEquals(Oppt.RecentProbability__c,'申込なし');  
            System.assertEquals(Oppt.DestinationOpportunity__c, oppSonpo.id);
            System.assertEquals(Oppt.CampaignDateTime__c, destOpp.CampaignDateTime__c);
            
            System.assertEquals(destOpp.MiniUpdateDate__c , oppt.MiniUpdateDate__c);
            // 移行先商談．質問 = （作成または更新）商談．質問
            System.assertEquals(destOpp.Question1__c ,oppt.Question1__c);
            System.assertEquals(destOpp.Question2__c ,oppt.Question2__c);
            System.assertEquals(destOpp.Question3__c ,oppt.Question3__c);
            System.assertEquals(destOpp.Question4__c ,oppt.Question4__c);
            System.assertEquals(destOpp.Question5__c ,oppt.Question5__c);
            System.assertEquals(destOpp.Question6__c ,oppt.Question6__c);
            System.assertEquals(destOpp.Question7__c ,oppt.Question7__c);
            System.assertEquals(destOpp.Question8__c ,oppt.Question8__c);
            System.assertEquals(destOpp.Question9__c ,oppt.Question9__c);
            System.assertEquals(destOpp.Question10__c ,oppt.Question10__c);
            // 移行先商談．回答 = （作成または更新）商談．回答
            System.assertEquals(destOpp.Answer1__c ,oppt.Answer1__c);
            System.assertEquals(destOpp.Answer2__c ,oppt.Answer2__c);
            System.assertEquals(destOpp.Answer2_1__c ,oppt.Answer2_1__c);
            System.assertEquals(destOpp.Answer2_2__c ,oppt.Answer2_2__c);
            System.assertEquals(destOpp.Answer3__c ,oppt.Answer3__c);
            System.assertEquals(destOpp.Answer4__c ,oppt.Answer4__c);
            System.assertEquals(destOpp.Answer5__c ,oppt.Answer5__c);
            System.assertEquals(destOpp.Answer6__c ,oppt.Answer6__c);
            System.assertEquals(destOpp.Answer7__c ,oppt.Answer7__c);
            System.assertEquals(destOpp.Answer8__c ,oppt.Answer8__c);
            System.assertEquals(destOpp.Answer9__c ,oppt.Answer9__c);
            System.assertEquals(destOpp.Answer10__c ,oppt.Answer10__c);
            
            System.assertEquals(destOpp.DateSource__c,oppt.DateSource__c);
            // 移行先商談．外部データソース更新日時 = （作成または更新）商談．外部データソース更新日時
            System.assertEquals(destOpp.ExLeadUpdateDate__c,oppt.ExLeadUpdateDate__c);
            // 移行先商談．項目 = （作成または更新）商談．項目
            System.assertEquals(destOpp.Item1__c,oppt.Item1__c);
            System.assertEquals(destOpp.Item2__c,oppt.Item2__c);
            System.assertEquals(destOpp.Item3__c,oppt.Item3__c);
            System.assertEquals(destOpp.Item4__c,oppt.Item4__c);
            System.assertEquals(destOpp.Item5__c,oppt.Item5__c);
            System.assertEquals(destOpp.Item6__c,oppt.Item6__c);
            System.assertEquals(destOpp.Item7__c,oppt.Item7__c);
            System.assertEquals(destOpp.Item8__c,oppt.Item8__c);
            System.assertEquals(destOpp.Item9__c,oppt.Item9__c);
            System.assertEquals(destOpp.Item10__c,oppt.Item10__c);
             // 移行先商談．項目ロング = （作成または更新）商談．項目ロング
            System.assertEquals(destOpp.ItemLong1__c,oppt.ItemLong1__c);
            System.assertEquals(destOpp.ItemLong2__c,oppt.ItemLong2__c);
            System.assertEquals(destOpp.ItemLong3__c,oppt.ItemLong3__c);
            System.assertEquals(destOpp.ItemLong4__c,oppt.ItemLong4__c);
            System.assertEquals(destOpp.ItemLong5__c,oppt.ItemLong5__c);
            System.assertEquals(destOpp.ItemLong6__c,oppt.ItemLong6__c);
            System.assertEquals(destOpp.ItemLong7__c,oppt.ItemLong7__c);
            System.assertEquals(destOpp.ItemLong8__c,oppt.ItemLong8__c);
            System.assertEquals(destOpp.ItemLong9__c,oppt.ItemLong9__c);
            System.assertEquals(destOpp.ItemLong10__c,oppt.ItemLong10__c);
             // 移行先商談．日付 = （作成または更新）商談．日付
            System.assertEquals(destOpp.Date__c,oppt.Date__c);
            
            System.assertEquals(acct.MeetingSalesflg__c,true);
            System.assertEquals(acct.OperationType__c,'架電禁止');
            System.assertEquals(acct.OpportunityStatus__c,'全商談終了');
        }
        @isTest static void ProcessTest_With_Opp_Update_OpType_No_Acc() {
             Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
             Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
             Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();   
             OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            acc.OperationType__c = '有効商談なし';
            acc.OpportunityStatus__c = '全商談終了';
            acc.MeetingSalesflg__c = false;
            insert acc;
            
             //Create User
            /*User userObj = TestHelperOpportunityTriggerHandler.createUser('Standard User','testEmail@gmail.com');
            insert userObj;*/
            
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',null,'OppName2');
            insert oppSonpo; 
            
            Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.id,'OppName3');
            //opp.OwnerId = userObj.Id;
            insert opp;
            
            Test.startTest();
            
            opp.RecordTypeId = oppSonpoRecordTypeId;
            opp.Name='個人';
            opp.RecordTypeForBulkChange__c = '損保';
            opp.CampaignDateTime__c = System.Now().addHours(-1);
            opp.MiniUpdateDate__c = System.now();
            opp.ExLeadUpdateDate__c = System.now();
            opp.RecentResultType_Middle__c = '対面誘導';
            opp.RecentResultType_Small__c = '了承';
            opp.StopCallingList__c = '永続的な架電禁止';
            update opp;
            
            Test.stopTest();
            Account acct = triggerTest.getAccountById(acc.Id);
            Opportunity oppt = triggerTest.getOpportunityById(opp.id);
            System.assertEquals(Oppt.StageName, '対応終了');
            System.assertEquals(Oppt.CloseType__c, '対応打ち切り');           
            System.assertEquals(oppt.StopCallingList__c,'永続的な架電禁止');
            
            System.assertEquals(acct.StopCallingFlg__c,TRUE);         
            System.assertEquals(acct.OperationType__c,'架電禁止');
            System.assertEquals(acct.OpportunityStatus__c,'全商談終了');
        }
         @isTest static void ProcessTest_With_Delete() {
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;

            Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
            Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
            Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();  
            OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'対応中',acc.Id,'OppName1');
            insert oppSonpo;  
            
            Opportunity opp1 = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'対応中',acc.Id,'OppName2');
            insert opp1;
            
            delete oppSonpo;
            
            Account acct = triggerTest.getAccountById(acc.Id);
            System.assertEquals(acct.OperationType__c,'対応中'); 
            System.assertEquals(acct.OpportunityStatus__c,'損保フォロー中'); 
            
        }
        @isTest static void ProcessTest_With_Delete2() {
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;

            Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
            Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
            Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();  
            OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'対応中',acc.Id,'OppName1');
            insert oppSonpo;  
            
            Opportunity opp1 = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.Id,'OppName2');
            insert opp1;
            
            delete oppSonpo;
            
            Account acct = triggerTest.getAccountById(acc.Id);
            System.assertEquals(acct.OperationType__c,'割当可'); 
            System.assertEquals(acct.OpportunityStatus__c,'対応継続可'); 
        }
        @isTest static void ProcessTest_With_Delete3() {
             
            //create Account
            Account acc = TestHelperOpportunityTriggerHandler.createAccount();
            insert acc;

            Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
            Id oppSyotonRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
            Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();  
            OpportunityTriggerTest triggerTest = new OpportunityTriggerTest();
            //create Opportunity
            Opportunity oppSonpo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'対応中',acc.Id,'OppName1');
            insert oppSonpo;  
            
            Opportunity opp1 = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'対応中',acc.Id,'OppName2');
            insert opp1;
            
            delete opp1;
            
            Account acct = triggerTest.getAccountById(acc.Id);
            System.assertEquals(acct.OperationType__c,'対応中'); 
            System.assertEquals(acct.OpportunityStatus__c,'損保フォロー中'); 
            
        }
        private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaForst__pc, furiganaLast__pc, Phone,easyId__pc,openId__pc,
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc,HanshaUserUpdateDate__c,  
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, MeetingSalesflg__c,StopCallingFlg__c,
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,division__pc,
                       OperationType__c,OpportunityStatus__c
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
        }
        private Opportunity getOpportunityById( Id oppId ) {
            return [SELECT id,name,OwnerId,OwnerForBulkChange__c,RecordTypeForBulkChange__c,StopCallingList__c,
            RecordTypeId,DestinationOpportunity__c,telReason__c,CloseType__c,InflowRoute__c,Question1__c,Question2__c,Question3__c,
            Question4__c,Question5__c,Question6__c,Question7__c,Question8__c,Question9__c,Question10__c,Answer1__c,Answer2__c,
            Answer3__c,Answer4__c,Answer5__c,Answer6__c,Answer7__c,Answer8__c,Answer9__c,Answer10__c,Answer2_1__c,Answer2_2__c,
            CloseDate,StageName,RecentProbability__c,Item1__c,Item2__c,Item3__c,Item4__c,Item5__c,Item6__c,Item7__c,Item8__c,Item9__c,Item10__c,
            CloseReason__c,ItemLong1__c,ItemLong2__c,ItemLong3__c,ItemLong4__c,ItemLong5__c,ItemLong6__c,ItemLong7__c,ItemLong8__c,
            ItemLong9__c,ItemLong10__c,MiniUpdateDate__c,CampaignDateTime__c,DateSource__c,ExLeadUpdateDate__c,Date__c
            FROM Opportunity WHERE  Id =: oppId LIMIT 1];
        }
    }