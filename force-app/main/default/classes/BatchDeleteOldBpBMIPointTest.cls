/************************************************************************************************************
*   Class               :       BatchDeleteOldBpBMIPointTest                                                *
*   Description         :       血圧BMI-２年過去データの削除バッチクラスのテストクラス                          *
*   Created Date        :       Takumi Nagaya                                                               *
*   Created By          :       2023/02/06                                                                  *
*   Modified Date       :                                                                                   *
*   Modified By         :                                                                                   *
*************************************************************************************************************/
@isTest
public class BatchDeleteOldBpBMIPointTest {
    
    @IsTest
    static void deleteOldBpBMIPoint(){
        
        // Create the Test Data
        List<BpBMIPoint__c> recList = createOldBpBMIPointTestData();
        
        Test.startTest();
        // Run the Delete Batch
        Database.ExecuteBatch(new BatchDeleteOldBpBMIPoint());
        Test.stopTest();
        
        // Test 2 Year Old record is Deleted
        List<BpBMIPoint__c> deletedRecList = [SELECT ID FROM BpBMIPoint__c WHERE Id = :recList[0].Id];
        System.assertEquals(deletedRecList.size(), 0);
        
        // Test Not 2 Year Old record is NOT Deleted
        List<BpBMIPoint__c> notdeletedRecList = [SELECT ID FROM BpBMIPoint__c WHERE Id = :recList[1].Id];
        System.assertEquals(notdeletedRecList.size(), 1);
    }
    
    
    static List<BpBMIPoint__c> createOldBpBMIPointTestData(){
        
        Account acc = new Account();
        acc.LastName = 'test1';
        acc.FirstName = 'Test2';
        insert acc;
        
        LifeContract__c Life = new LifeContract__c();
        Life.Name = 'test name';
        Life.POL_NUM__c = '1234567';
        Life.PRODUCT_NAME__c = 'test product name';
        Life.AccountId__c = acc.Id;
        insert Life;
        
        
        List<BpBMIPoint__c> recList =  new List<BpBMIPoint__c>();
        
        // Test Data that is 2 Year Old
        BpBMIPoint__c twoYrOldRec = new BpBMIPoint__c();
        twoYrOldRec.TARGET_MONTH__c = System.Now().addYears(-2).addMonths(-1).format('yyyy/MM');
        twoYrOldRec.LifeContract__c = life.Id;
        recList.add(twoYrOldRec);
        
        // Test Data that is Not Yet 2 Year Old
        BpBMIPoint__c nottwoYrOldRec = new BpBMIPoint__c();
        nottwoYrOldRec.TARGET_MONTH__c = System.Now().addYears(-2).format('yyyy/MM');
        nottwoYrOldRec.LifeContract__c = life.Id;
        recList.add(nottwoYrOldRec);
        
        Insert recList;
        
        return recList;
    }
}