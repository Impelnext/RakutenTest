/*************************************************************************************************************
*   Class               :       BatchDeleteOldHealthRefundPointTest                                         *
*   Description         :       健康還付ポイント-２年過去データの削除バッチクラスのテストクラス                   *
*   Created Date        :       Takumi Nagaya                                                               *
*   Created By          :       2023/02/06                                                                  *
*   Modified Date       :                                                                                   *
*   Modified By         :                                                                                   *
*************************************************************************************************************/
@isTest
public class BatchDeleteOldHealthRefundPointTest {
    
    @IsTest
    static void deleteOldHealthRefundPoint(){
        
        // Create the Test Data
        List<HealthRefundPoint__c> recList = createOldHealthRefundPointTestData();
        
        Test.startTest();
        // Run the Delete Batch
        Database.ExecuteBatch(new BatchDeleteOldHealthRefundPoint());
        Test.stopTest();
        
        // Test 2 Year Old record is Deleted
        List<HealthRefundPoint__c> deletedRecList = [SELECT ID FROM HealthRefundPoint__c WHERE Id = :recList[0].Id];
        System.assertEquals(deletedRecList.size(), 0);
        
        // Test Not 2 Year Old record is NOT Deleted
        List<HealthRefundPoint__c> notdeletedRecList = [SELECT ID FROM HealthRefundPoint__c WHERE Id = :recList[1].Id];
        System.assertEquals(notdeletedRecList.size(), 1);
    }
    
    
    static List<HealthRefundPoint__c> createOldHealthRefundPointTestData(){
        
        Account acc = new Account();
        acc.LastName = 'test3';
        acc.FirstName = 'Test4';
        insert acc;
        
        LifeContract__c Life = new LifeContract__c();
        Life.Name = 'test name1';
        Life.POL_NUM__c = '12345647';
        Life.PRODUCT_NAME__c = 'test product name1';
        Life.AccountId__c = acc.Id;
        insert Life;
        
        List<HealthRefundPoint__c> recList =  new List<HealthRefundPoint__c>();
        
        // Test Data that is 2 Year Old
        HealthRefundPoint__c twoYrOldRec = new HealthRefundPoint__c();
        twoYrOldRec.INSURANCE_YEAR_TO__c = System.Now().addYears(-2).addMonths(-1).format('yyyy/MM');
        twoYrOldRec.LifeContract__c = life.Id;
        twoYrOldRec.LifeContract1__c = life.Id;
        recList.add(twoYrOldRec);
        
        // Test Data that is Not Yet 2 Year Old
        HealthRefundPoint__c nottwoYrOldRec = new HealthRefundPoint__c();
        nottwoYrOldRec.INSURANCE_YEAR_TO__c = System.Now().addYears(-2).format('yyyy/MM');
        nottwoYrOldRec.LifeContract__c = life.Id;
        nottwoYrOldRec.LifeContract1__c = life.Id;
        recList.add(nottwoYrOldRec);
        
        Insert recList;
        
        return recList;
    }
}