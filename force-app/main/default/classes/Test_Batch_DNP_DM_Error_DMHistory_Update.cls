@isTest
public class Test_Batch_DNP_DM_Error_DMHistory_Update 
{
    static Datetime deadline =  Datetime.now().addMinutes(25);

    static testMethod void DMClass_BD2M()
    {
        test.startTest();
        
        Account acc = new Account();
        acc.EasyId__c = '120014';
        acc.PERSONBIRTHDATE = Date.today().addYears(-50).addDays(60);        
        acc.LastName = 'TestSRM1';
        insert acc;
        system.debug('ACCID='+ acc.id);
        
        DMHistory__c dmh1 = new DMHistory__c();
        //string Birthday2DM_Feedback_DMClass  = 'ＢＤ２Ｍ';
        dmh1.AccountId__c = acc.Id;
        dmh1.DMClass__c = 'ＢＤ２Ｍ';
        dmh1.ShipmentActualDate__c = null;
        dmh1.ReturnProcessingDate__c = null;
        dmh1.ReasonForReturn__c = null;
        insert dmh1;
        
        Account acc1 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc.id];
        acc1.DMHistoryID_BD2M__c = dmh1.Id;
         update acc1;
        string id=string.valueof(acc1.CallingId_BD2M__c);
        system.debug('DMHistoryID_BD2M__IDCheck='+ dmh1.Id);
        
        //DMClass__c ='ＢＤ２Ｍ' 
        //string Birthday2DM_Feedback_DMClass  = 'ＢＤ２Ｍ'; 
        DM_Error__c dmerror1 = new DM_Error__c();
        dmerror1.DMClass__c ='ＢＤ２Ｍ';
        dmerror1.ID__c =id;  
        insert dmerror1;                
       
        
        
        /*DMHistory__c dmh2 = new DMHistory__c();
        string Birthday2DM_Feedback_DMClass  = 'ＢＤ２Ｍ'; 
        dmh2.DMClass__c = 'ＢＤ２Ｍ';
        dmh2.AccountId__c = acc1.id;
        dmh2.id = acc1.DMHistoryID_BD2M__c;
        update dmh2;*/
         
        //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_DNP_DM_Error_DMHistory_Update   dnpDMError = new Batch_DNP_DM_Error_DMHistory_Update  (datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00', deadline);
        ID bPId = Database.executeBatch(dnpDMError);      
         //system.schedule('Batch_DNP_DM_Error_DMHistory_Update',cronExp ,dnpDMError );                                                                   
       
        
        test.stopTest();
        
        dmerror1 = [Select id, DMHistoryID__c from DM_Error__c where id =:dmerror1.id];
        system.assertEquals(dmerror1.DMHistoryID__c, dmh1.id);    
    }
    static testMethod void DMClass_NoRecord()
    {
        test.startTest();
        
        Account acc = new Account();
        acc.EasyId__c = '120014';
        acc.PERSONBIRTHDATE = Date.today().addYears(-50).addDays(60);        
        acc.LastName = 'TestSRM1';
        insert acc;
        system.debug('ACCID='+ acc.id);
        
        DMHistory__c dmh1 = new DMHistory__c();
        //string Birthday2DM_Feedback_DMClass  = 'ＢＤ２Ｍ';
        dmh1.AccountId__c = acc.Id;
        dmh1.DMClass__c = 'ＢＤ２Ｔ';
        dmh1.ShipmentActualDate__c = null;
        dmh1.ReturnProcessingDate__c = null;
        dmh1.ReasonForReturn__c = null;
        insert dmh1;
        
        Account acc1 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc.id];
        acc1.DMHistoryID_BD2M__c = dmh1.Id;
         update acc1;
        string id=string.valueof(acc1.CallingId_BD2M__c);
        system.debug('DMHistoryID_BD2M__IDCheck='+ dmh1.Id);
        
        //DMClass__c ='ＢＤ２Ｍ' 
        
        DM_Error__c dmerror1 = new DM_Error__c();
        dmerror1.DMClass__c ='ＢＤ２Ｔ';
        dmerror1.ID__c =id;  
        insert dmerror1;                

        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_DNP_DM_Error_DMHistory_Update batch = new Batch_DNP_DM_Error_DMHistory_Update();
        Batch_DNP_DM_Error_DMHistory_Update   dnpDMError = new Batch_DNP_DM_Error_DMHistory_Update  (datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00', deadline);
        dnpDMError.errorLog = 'Exception';
        dnpDMError.dmclassNotMatching_warningLog = 'DM class not match';
        dnpDMError.multipleRecordFound_warningLog = 'Multiple Record Found';
        ID bPId = Database.executeBatch(dnpDMError);      
         
        
        test.stopTest();
        
        dmerror1 = [Select id, DMHistoryID__c from DM_Error__c where id =:dmerror1.id];
        system.assertNotEquals(dmerror1.DMHistoryID__c, dmh1.id);    
    }
    static testMethod void scheduler()
    {
        test.startTest();
        
        Integer batchRunDay = 15 -integer.valueOf(10);
        
        Datetime datetimeNow = datetime.newInstance(date.newInstance(date.today().year(), date.today().month(), batchRunDay), time.newInstance(07, 30, 00, 00));
        Datetime datetimeAfter = datetimeNow.addMonths(1);
        String schMinute = datetimeNow.format('mm');
        
        String sch = '00 30 07 ' + batchRunDay + ' * ?';
        //String sch = '0 ' + schMinute + ' * * * ?';
        String jobId = System.schedule('Test_Batch_DNP_DM_Error_DMHistory_Update', sch, new Batch_DNP_DM_Error_DMHistory_Update(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00', deadline));
              
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(sch, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        if(date.today().day() >= batchRunDay)
            System.assertEquals(datetimeAfter.format('yyyy-MM-dd HH:mm:') + '00', String.valueOf(ct.NextFireTime));
        else
            System.assertEquals(datetimeNow.format('yyyy-MM-dd HH:mm:') + '00', String.valueOf(ct.NextFireTime));
        test.stopTest();
    }
    
}