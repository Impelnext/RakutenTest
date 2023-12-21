@isTest
public class Test_BatchBCP_PetFree {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_PetFree                               */
    /* Description:    Test Method for BatchBCP_PetFree                    */
    /***********************************************************************/
    @isTest static void main(){
        //ペットフリー保険
        PetFreeInsurance__c petFree1 = new PetFreeInsurance__c (name = '引受承諾', InsuredStatus__c = '引受承諾',Email__c = 'test1@rakuten.com');
        insert petFree1;
        PetFreeInsurance__c petFree2 = new PetFreeInsurance__c (name = '有効中', InsuredStatus__c = '有効中',Email__c = 'test2@rakuten.com');
        insert petFree2;
        PetFreeInsurance__c petFree3 = new PetFreeInsurance__c (name = '解除', InsuredStatus__c = '解除',Email__c = 'test3@rakuten.com');
        insert petFree3;
        PetFreeInsurance__c petFree4 = new PetFreeInsurance__c (name = '失効', InsuredStatus__c = '失効',Email__c = 'test4@rakuten.com');
        insert petFree4;
        PetFreeInsurance__c petFree5 = new PetFreeInsurance__c (name = '満期', InsuredStatus__c = '満期',Email__c = 'test5@rakuten.com');
        insert petFree5;
        PetFreeInsurance__c petFree6 = new PetFreeInsurance__c (name = '取消', InsuredStatus__c = '取消',Email__c = 'test6@rakuten.com');
        insert petFree6;
        //被保険者ステータスが増えたら追記してください。    
        
        Test.startTest();
        BatchBCP_PetFreeConsentCSV batch = new BatchBCP_PetFreeConsentCSV();
        batch.executeBatchBCP_PetFreeConsentCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description:    Test Method  for Schedule Execute                         */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        //ペットフリー保険
        PetFreeInsurance__c petFree1 = new PetFreeInsurance__c (name = '引受承諾', InsuredStatus__c = '引受承諾',Email__c = 'test1@rakuten.com');
        insert petFree1;
        PetFreeInsurance__c petFree2 = new PetFreeInsurance__c (name = '有効中', InsuredStatus__c = '有効中',Email__c = 'test2@rakuten.com');
        insert petFree2;
        PetFreeInsurance__c petFree3 = new PetFreeInsurance__c (name = '解除', InsuredStatus__c = '解除',Email__c = 'test3@rakuten.com');
        insert petFree3;
        PetFreeInsurance__c petFree4 = new PetFreeInsurance__c (name = '失効', InsuredStatus__c = '失効',Email__c = 'test4@rakuten.com');
        insert petFree4;
        PetFreeInsurance__c petFree5 = new PetFreeInsurance__c (name = '満期', InsuredStatus__c = '満期',Email__c = 'test5@rakuten.com');
        insert petFree5;
        PetFreeInsurance__c petFree6 = new PetFreeInsurance__c (name = '取消', InsuredStatus__c = '取消',Email__c = 'test6@rakuten.com');
        insert petFree6;
        //被保険者ステータスが増えたら追記してください。

        Test.startTest();
        BatchBCP_PetFreeConsentCSV batch = new BatchBCP_PetFreeConsentCSV();
        batch.executeBatchBCP_PetFreeConsentCSV();
        DateTime currentTime = System.now().addSeconds(5);
        String CRON_EXP = currentTime.second() + ' '
                    + currentTime.minute() + ' '
                    + currentTime.hour() + ' '
                    + currentTime.day() + ' '
                    + currentTime.month() + ' '
                    + '? '
                    + currentTime.year();
        String jobId = System.schedule('main', CRON_EXP, batch );
        Test.stopTest();
    }
}