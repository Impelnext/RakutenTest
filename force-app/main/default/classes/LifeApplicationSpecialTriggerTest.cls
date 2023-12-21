@isTest
public class LifeApplicationSpecialTriggerTest
{
    @isTest
    static void LifeApplicationSpecialTriggerTest_insert()
    {
        LifeApplicationSpecialTriggerTest triggerTest = new LifeApplicationSpecialTriggerTest();

        Test.startTest();
        insert triggerTest.createSeihoOpportunity();
        insert triggerTest.createLifeApplicationSpecial();

        Test.stopTest();
    }
    
    @isTest
    static void LifeApplicationSpecialTriggerTest_update()
    {
        LifeApplicationSpecialTriggerTest triggerTest = new LifeApplicationSpecialTriggerTest();

        insert triggerTest.createSeihoOpportunity();
        insert triggerTest.createLifeApplicationSpecial();
        LifeApplicationSpecial__c la = [SELECT Id, Name FROM LifeApplicationSpecial__c LIMIT 1];
        la.Name = '333333';
        Test.startTest();
        
        update la;
        
        Test.stopTest();
    }


    private LifeApplicationSpecial__c createLifeApplicationSpecial(){
        return new LifeApplicationSpecial__c(
            Name = '111111',
            ForeignKey_LifeApplicationSpecial__c = '2222222'
        );
    }

    private SeihoOpportunity__c createSeihoOpportunity(){
        return new SeihoOpportunity__c(
            Name = '楽天',
            AppliNo__c = '111111',
            AppliReceptionChannel__c = 'WEB'
        );
    }

}