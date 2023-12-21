/*************************************************************************************************************
 *   Class               :       BatchDeleteOldActivePointTest                                               *
 *   Description         :       活動ポイント-２年過去データの削除バッチクラスのテストクラス                      *
 *   Created Date        :       Takumi Nagaya                                                               *
 *   Created By          :       2023/02/06                                                                  *
 *   Modified Date       :                                                                                   *
 *   Modified By         :                                                                                   *
 *************************************************************************************************************/
@isTest
public class BatchDeleteOldActivePointTest {
    
    @IsTest
    static void deleteOldActivePoint(){
        
        // Create the Test Data
        List<ActivePoint__c> recList = createOldActivePointTestData();
        
        Test.startTest();
        // Run the Delete Batch
        Database.ExecuteBatch(new BatchDeleteOldActivePoint());
        Test.stopTest();
        
        // Test 2 Year Old record is Deleted
        List<ActivePoint__c> deletedRecList = [SELECT ID FROM ActivePoint__c WHERE Id = :recList[0].Id];
        System.assertEquals(deletedRecList.size(), 0);
        
        // Test Not 2 Year Old record is NOT Deleted
        List<ActivePoint__c> notdeletedRecList = [SELECT ID FROM ActivePoint__c WHERE Id = :recList[1].Id];
        System.assertEquals(notdeletedRecList.size(), 1);
    }
    
    
    static List<ActivePoint__c> createOldActivePointTestData(){
        
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
        
        List<ActivePoint__c> recList =  new List<ActivePoint__c>();
        
        // Test Data that is 2 Year Old
        ActivePoint__c twoYrOldRec = new ActivePoint__c();
        twoYrOldRec.TARGET_MONTH__c = System.Now().addYears(-2).addMonths(-1).format('yyyy/MM');
        twoYrOldRec.LifeContract__c = life.Id;
        twoYrOldRec.LifeContract1__c = life.Id;
        twoYrOldRec.LifeContract2__c = life.Id;
        recList.add(twoYrOldRec);
        
        // Test Data that is Not Yet 2 Year Old
        ActivePoint__c nottwoYrOldRec = new ActivePoint__c();
        nottwoYrOldRec.TARGET_MONTH__c = System.Now().addYears(-2).format('yyyy/MM');
        nottwoYrOldRec.LifeContract__c = life.Id;
        nottwoYrOldRec.LifeContract1__c = life.Id;
        nottwoYrOldRec.LifeContract2__c = life.Id;
        recList.add(nottwoYrOldRec);
        
        Insert recList;
        
        return recList;
    }
}