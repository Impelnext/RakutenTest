/*************************************************************************************************************
 *   Class               :       BatchDeleteOldSeihoPolicyDepHistTest                                        *
 *   Description         :       生保契約入金履歴-２年過去データの削除バッチクラスのテストクラス             *
 *   Created Date        :       Valsala Kumar                                                               *
 *   Created By          :       2022/04/20                                                                  *
 *   Modified Date       :                                                                                   *
 *   Modified By         :                                                                                   *
 *************************************************************************************************************/
@isTest
public class BatchDeleteOldSeihoPolicyDepHistTest {
    
    @IsTest
    static void deleteOldSeihoPolicyDepHist(){
        
        // Create the Test Data
        List<SeihoPolicyDepHist__c> recList = createOldSeihoPolicyDepHistTestData();
        
        Test.startTest();
        // Run the Delete Batch
        Database.ExecuteBatch(new BatchDeleteOldSeihoPolicyDepHist());
        Test.stopTest();
        
        // Test 2 Year Old record is Deleted
        List<SeihoPolicyDepHist__c> deletedRecList = [SELECT ID FROM SeihoPolicyDepHist__c WHERE Id = :recList[0].Id];
        System.assertEquals(deletedRecList.size(), 0);
        
        // Test Not 2 Year Old record is NOT Deleted
        List<SeihoPolicyDepHist__c> notdeletedRecList = [SELECT ID FROM SeihoPolicyDepHist__c WHERE Id = :recList[1].Id];
        System.assertEquals(notdeletedRecList.size(), 1);
    }
    
    
    static List<SeihoPolicyDepHist__c> createOldSeihoPolicyDepHistTestData(){
        
        List<SeihoPolicyDepHist__c> recList =  new List<SeihoPolicyDepHist__c>();
        
        // Test Data that is 2 Year Old
        SeihoPolicyDepHist__c twoYrOldRec = new SeihoPolicyDepHist__c(
            TARGET_MONTH__c = System.Now()
                                .addYears(-2)
                                .addMonths(-1)
                                .format('yyyy/MM') 
                                + '/01'
        );
        recList.add(twoYrOldRec);
        
        // Test Data that is Not Yet 2 Year Old
        SeihoPolicyDepHist__c nottwoYrOldRec = new SeihoPolicyDepHist__c(
            TARGET_MONTH__c = System.Now()
                                .addYears(-2)
                                .format('yyyy/MM')
                                + '/01'
        );
        recList.add(nottwoYrOldRec);
        
        Insert recList;
        
        return recList;
    }
}