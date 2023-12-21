@isTest
public class LeadTriggerTest
{
    @isTest
    static void LeadTriggerTest()
    {
        LeadTriggerTest triggerTest = new LeadTriggerTest();

        Test.startTest();

        insert triggerTest.createLead();

        Test.stopTest();
        
        List<Lead> leadList = [Select id,LastName FROM Lead ];
        System.assertEquals(leadList[0].LastName,'楽天');
        
        List<MiniInsurance__c> miniList = [Select   id,
                                                    LastName__c,
                                                    ShortAnswer1__c, 
                                                    ShortAnswer2__c, 
                                                    ShortAnswer3__c, 
                                                    ShortAnswer4__c, 
                                                    ShortAnswer5__c, 
                                                    ShortAnswer6__c, 
                                                    ShortAnswer7__c, 
                                                    ShortAnswer8__c, 
                                                    ShortAnswer9__c, 
                                                    ShortAnswer10__c 
                                            FROM MiniInsurance__c 
                                            WHERE mini_apply_id__c = '11111'];
        System.assertEquals(miniList[0].LastName__c,'楽天');
        System.assertEquals(miniList[0].ShortAnswer1__c ,'Answer1');
        System.assertEquals(miniList[0].ShortAnswer2__c ,'Answer2');
        System.assertEquals(miniList[0].ShortAnswer3__c ,'Answer3');
        System.assertEquals(miniList[0].ShortAnswer4__c ,'Answer4');
        System.assertEquals(miniList[0].ShortAnswer5__c ,'Answer5');
        System.assertEquals(miniList[0].ShortAnswer6__c ,'Answer6');
        System.assertEquals(miniList[0].ShortAnswer7__c ,'Answer7');
        System.assertEquals(miniList[0].ShortAnswer8__c ,'Answer8');
        System.assertEquals(miniList[0].ShortAnswer9__c ,'Answer9');
        System.assertEquals(miniList[0].ShortAnswer10__c,'Answer10');
    }
    
    
    private Lead createLead(){
        return new Lead(
            Suffix = '1111111',
            MiddleName = '楽天',
            FirstName = 'ﾗｸﾃﾝ',
            LastName = '楽天',
            mini_apply_id__c = '11111',
            dm_flg__c = true,
            Answer1__c = 'Answer1',
            Answer2__c = 'Answer2',
            Answer3__c = 'Answer3',
            Answer4__c = 'Answer4',
            Answer5__c = 'Answer5',
            Answer6__c = 'Answer6',
            Answer7__c = 'Answer7',
            Answer8__c = 'Answer8',
            Answer9__c = 'Answer9',
            Answer10__c = 'Answer10'
        );
    }
}