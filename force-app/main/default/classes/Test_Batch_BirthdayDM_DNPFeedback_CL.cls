@isTest
public class Test_Batch_BirthdayDM_DNPFeedback_CL 
{
    static Datetime deadline =  Datetime.now().addMinutes(25);
    static testMethod void DMClass_BD2M() 
    {
        test.startTest();
        
        Account acc1 = new Account();
        acc1.EasyId__c = '128714';
        acc1.PersonBirthDate = Date.today().addYears(-50).addDays(60);        
        acc1.LastName = 'Test.SRM';
        insert acc1;
        
        DMHistory__c dmh = new DMHistory__c();
        dmh.AccountId__c = acc1.Id;
        dmh.DMClass__c = 'ＢＤ２Ｍ';
        dmh.ShipmentActualDate__c = null;
       dmh.ReturnProcessingDate__c = null;
       dmh.ReasonForReturn__c = null;
        insert dmh;
        
        Account acc2 = [select id, CRMID__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where Id =: acc1.Id];
        acc2.DMHistoryID_BD2M__c = dmh.Id;
        update acc2;
        string id=string.valueof(acc2.CallingId_BD2M__c);
        DnpDM__c dnpdm = new DnpDM__c();
        dnpdm.ID__c = id;
        dnpdm.DMClass__c = 'ＢＤ２Ｍ';
        dnpdm.ShippingDate__c = Date.today();
        dnpdm.ReturnsProcessingDate__c = Date.today();
        dnpdm.ReturnsProcessingReason__c = '転送期間経過';        
        insert dnpdm;
      //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_BirthdayDM_DNPFeedback_CL  bbdmf = new Batch_BirthdayDM_DNPFeedback_CL (datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                      datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00', deadline);
        ID bPId = Database.executeBatch(bbdmf);
        //system.schedule('Batch_BirthdayDM_DNPFeedback_CL',cronExp ,bbdmf );
        test.stopTest();
        
        acc1 = [select ShipmentActualDate_BD2M__c, ReturnProcessingDate_BD2M__c, ReasonForReturn_BD2M__c,DMHistoryID_BD2M__c from Account where CallingId_BD2M__c = :dnpdm.ID__c];
        system.assertEquals(dnpdm.ReturnsProcessingDate__c, acc1.ReturnProcessingDate_BD2M__c);
        system.assertEquals(dnpdm.ReturnsProcessingReason__c, acc1.ReasonForReturn_BD2M__c);
        system.assertEquals(dnpdm.ShippingDate__c, acc1.ShipmentActualDate_BD2M__c);

        dmh = [select ShipmentActualDate__c, ReturnProcessingDate__c, ReasonForReturn__c  from DMHistory__c where Id =: dmh.Id];
        system.assertEquals(dnpdm.ReturnsProcessingDate__c, dmh.ReturnProcessingDate__c);
        system.assertEquals(dnpdm.ReturnsProcessingReason__c, dmh.ReasonForReturn__c);
        system.assertEquals(dnpdm.ShippingDate__c, dmh.ShipmentActualDate__c);        
        
        dnpdm = [select Call_Update_flag__c from DnpDM__c where Id =:  dnpdm.Id];
        system.assertEquals(True, dnpdm.Call_Update_flag__c);
    }
    
    /*static testMethod void DMClass_BD2T() 
    {
        test.startTest();
        Account cl = new Account();        
        insert cl;
        
        DMHistory__c dmh = new DMHistory__c();
        dmh.CallingID__c = cl.Id;
        dmh.DMClass__c = 'ＢＤ２Ｍ';
        insert dmh;
        
        Account cl2 = [select Name, DMHistoryID_BD2M__c from Account where Id =: cl.Id];
        cl2.DMHistoryID_BD2M__c = dmh.Id;
        
        DnpDM__c dnpdm = new DnpDM__c();
        dnpdm.ID__c = cl2.Name;
        dnpdm.DMClass__c = 'ＢＤ２Ｔ';
        dnpdm.ShippingDate__c = Date.today();
        dnpdm.ReturnsProcessingDate__c = Date.today();
        dnpdm.ReturnsProcessingReason__c = '転送期間経過';        
        insert dnpdm;
        update cl2;
        
        Account cl3 = new Account();
        insert cl3;        
        
        DMHistory__c dmh1 = new DMHistory__c();
        dmh1.CallingID__c = cl3.Id;
        dmh1.DMClass__c = 'ＢＤ２Ｍ';
        dmh1.ReturnProcessingDate__c = Date.today();
        insert dmh1;
        
        Account cl4 = [select Name, DMHistoryID_BD2M__c from Account where Id =: cl3.Id];
        cl4.DMHistoryID_BD2M__c = dmh1.Id;
        
        DnpDM__c dnpdm1 = new DnpDM__c();
        dnpdm1.ID__c = cl4.Name;
        dnpdm1.DMClass__c = 'ＢＤ２Ｔ';
        dnpdm1.ShippingDate__c = Date.today();
        dnpdm1.ReturnsProcessingDate__c = Date.today();
        dnpdm1.ReturnsProcessingReason__c = '転送期間経過';        
        insert dnpdm1;
        update cl4;
        
        Account cl5 = new Account();
        insert cl5;        
        
        DMHistory__c dmh2 = new DMHistory__c();
        dmh2.CallingID__c = cl5.Id;
        dmh2.DMClass__c = 'ＢＤ２Ｍ';
        dmh2.ShipmentActualDate__c = Date.today();
        insert dmh2;
        
        Account cl6 = [select Name, DMHistoryID_BD2M__c from Account where Id =: cl5.Id];
        cl6.DMHistoryID_BD2M__c = dmh2.Id;
        
        DnpDM__c dnpdm2 = new DnpDM__c();
        dnpdm2.ID__c = cl6.Name;
        dnpdm2.DMClass__c = 'ＢＤ２Ｔ';
        dnpdm2.ShippingDate__c = Date.today();
        dnpdm2.ReturnsProcessingDate__c = Date.today();
        dnpdm2.ReturnsProcessingReason__c = '転送期間経過';    
        insert dnpdm2;
        update cl6;
        //for ReturnsProcessingReason__c is not null && ReasonForReturn__c is not null
        Account cl7 = new Account();
        insert cl7;        
        
        DMHistory__c dmh3 = new DMHistory__c();
        dmh3.CallingID__c = cl7.Id;
        dmh3.DMClass__c = 'ＢＤ２Ｍ';
        dmh3.ReasonForReturn__c = '転送期間経過';
        insert dmh3;
        
        Account cl8 = [select Name, DMHistoryID_BD2M__c from Account where Id =: cl7.Id];
        cl8.DMHistoryID_BD2M__c = dmh3.Id;
        
        DnpDM__c dnpdm3 = new DnpDM__c();
        dnpdm3.ID__c = cl8.Name;
        dnpdm3.DMClass__c = 'ＢＤ２Ｔ';
        dnpdm3.ShippingDate__c = Date.today();
        dnpdm3.ReturnsProcessingDate__c = Date.today();
        dnpdm3.ReturnsProcessingReason__c = '転送期間経過';        
        insert dnpdm3;
        update cl8;
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(5);
        Batch_BirthdayDM_DNPFeedback_CL  bbdmf = new Batch_BirthdayDM_DNPFeedback_CL (datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                      datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00', deadline);
        ID bPId = Database.executeBatch(bbdmf);
        
        test.stopTest();
        
        cl = [select ShipmentActualDate_BD2M__c, ShipmentActualDate_BD4M__c, ReturnProcessingDate_BD2M__c, ReturnProcessingDate_BD4M__c, ReasonForReturn_BD2M__c, ReasonForReturn_BD4M__c from Account where Id =: cl.Id];
        system.assertEquals(dnpdm.ReturnsProcessingDate__c, cl.ReturnProcessingDate_BD2M__c);
        system.assertEquals(dnpdm.ReturnsProcessingReason__c, cl.ReasonForReturn_BD2M__c);
        system.assertEquals(dnpdm.ShippingDate__c, cl.ShipmentActualDate_BD2M__c);
        system.assertEquals(null, cl.ReturnProcessingDate_BD4M__c);
        system.assertEquals(null, cl.ReasonForReturn_BD4M__c);
        system.assertEquals(null, cl.ShipmentActualDate_BD4M__c);
        
        dmh = [select ShipmentActualDate__c, ReturnProcessingDate__c, ReasonForReturn__c  from DMHistory__c where Id =: dmh.Id];
        system.assertEquals(dnpdm.ReturnsProcessingDate__c, dmh.ReturnProcessingDate__c);
        system.assertEquals(dnpdm.ReturnsProcessingReason__c, dmh.ReasonForReturn__c);
        system.assertEquals(dnpdm.ShippingDate__c, dmh.ShipmentActualDate__c);        
        
        dnpdm = [select Call_Update_flag__c from DnpDM__c where Id =:  dnpdm.Id];
        system.assertEquals(True, dnpdm.Call_Update_flag__c);
        
        cl3 = [select ShipmentActualDate_BD2M__c, ShipmentActualDate_BD4M__c, ReturnProcessingDate_BD2M__c, ReturnProcessingDate_BD4M__c, ReasonForReturn_BD2M__c, ReasonForReturn_BD4M__c from Account where Id =: cl3.Id];
        system.assertEquals(dnpdm1.ReturnsProcessingDate__c, cl3.ReturnProcessingDate_BD2M__c);
        system.assertEquals(dnpdm1.ReturnsProcessingReason__c, cl3.ReasonForReturn_BD2M__c);
        system.assertEquals(dnpdm1.ShippingDate__c, cl3.ShipmentActualDate_BD2M__c);
        system.assertEquals(null, cl3.ReturnProcessingDate_BD4M__c);
        system.assertEquals(null, cl3.ReasonForReturn_BD4M__c);
        system.assertEquals(null, cl3.ShipmentActualDate_BD4M__c);
        
        dmh1 = [select ShipmentActualDate__c, ReturnProcessingDate__c, ReasonForReturn__c from DMHistory__c where Id =: dmh1.Id];        
        system.assertNotEquals(dnpdm1.ReturnsProcessingReason__c, dmh1.ReasonForReturn__c);
        system.assertNotEquals(dnpdm1.ShippingDate__c, dmh1.ShipmentActualDate__c);
        
        dnpdm1 = [select Call_Update_flag__c from DnpDM__c where Id =:  dnpdm1.Id];
        system.assertEquals(True, dnpdm1.Call_Update_flag__c);
        
        cl5 = [select ShipmentActualDate_BD2M__c, ShipmentActualDate_BD4M__c, ReturnProcessingDate_BD2M__c, ReturnProcessingDate_BD4M__c, ReasonForReturn_BD2M__c, ReasonForReturn_BD4M__c from Account where Id =: cl5.Id];
        system.assertEquals(dnpdm2.ReturnsProcessingDate__c, cl5.ReturnProcessingDate_BD2M__c);
        system.assertEquals(dnpdm2.ReturnsProcessingReason__c, cl5.ReasonForReturn_BD2M__c);
        system.assertEquals(dnpdm2.ShippingDate__c, cl5.ShipmentActualDate_BD2M__c);
        system.assertEquals(null, cl5.ReturnProcessingDate_BD4M__c);
        system.assertEquals(null, cl5.ReasonForReturn_BD4M__c);
        system.assertEquals(null, cl5.ShipmentActualDate_BD4M__c);
        
        dmh2 = [select ReturnProcessingDate__c, ReasonForReturn__c from DMHistory__c where Id =: dmh2.Id];
        system.assertNotEquals(dnpdm2.ReturnsProcessingDate__c, dmh2.ReturnProcessingDate__c);
        system.assertNotEquals(dnpdm2.ReturnsProcessingReason__c, dmh2.ReasonForReturn__c);               
        
        dnpdm2 = [select Call_Update_flag__c from DnpDM__c where Id =:  dnpdm2.Id];
        system.assertEquals(True, dnpdm2.Call_Update_flag__c);
        
        dnpdm3 = [select Call_Update_flag__c from DnpDM__c where Id =:  dnpdm3.Id];
        system.assertEquals(True, dnpdm3.Call_Update_flag__c);
    }*/
    static testMethod void AlreadyExists_DMHistory() 
    {
        test.startTest();
         Account acc1 = new Account();
        acc1.EasyId__c = '128914';
        acc1.PersonBirthDate = Date.today().addYears(-50).addDays(60);        
        acc1.LastName = 'Test.SRM7';
        insert acc1;
        DMHistory__c dmh = new DMHistory__c();
        dmh.LastName__c = 'Last_1';
        dmh.FirstName__c = 'First_1';
        dmh.AccountId__c=acc1.id;
        dmh.PostalCode__c = '12345670';
        dmh.State__c = 'tokyo';
        dmh.City__c = 'Japan';
        dmh.Phone__c = '0801457812';
        dmh.Phone2__c = '0804745588';
        dmh.Path__c ='1';
        dmh.DMClass__c = 'BD2M';
        dmh.CatalogOrderId__c = '565765765';
        dmh.DMShipmentDate__c  = Date.today();
        dmh.ShipmentActualDate__c = Date.newInstance(2016,11,15);
        dmh.ReasonForReturn__c='転居先不明   ';
        dmh.ReturnProcessingDate__c=Date.newInstance(2018,11,16);
        Date shipDate = Date.newInstance(2016,11,15);
        dmh.DMShipmentDate__c = shipDate;
        insert dmh;
        Account acc2 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc1.id];
        acc2.DMHistoryID_BD2M__c = dmh.Id;
         update acc2;
        string id2=string.valueof(acc2.CallingId_BD2M__c);
         DnpDM__c DnpDM = new DnpDM__c();
        DnpDM.ID__c = id2;  
        DnpDM.DMClass__c ='BD2M'; 
        dnpdm.ShippingDate__c=Date.newInstance(2018,11,15);
        dnpdm.ReturnsProcessingReason__c='転居先不明';
        dnpdm.ReturnsProcessingDate__c=Date.newInstance(2018,11,16);
         insert dnpdm;
        //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_BirthdayDM_DNPFeedback_CL  dnpDMC = new Batch_BirthdayDM_DNPFeedback_CL(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00',Datetime.now().addMinutes(25));
        ID bPId = Database.executeBatch(dnpDMC);
//system.schedule('Batch_BirthdayDM_DNPFeedback_CL',cronExp ,dnpDMC); 
        test.stopTest();
        
      
    }
    static testMethod void AlreadyExists_DMHistory1() 
    {
        test.startTest();
         Account acc1 = new Account();
        acc1.EasyId__c = '128914';
        acc1.PersonBirthDate = Date.today().addYears(-50).addDays(60);        
        acc1.LastName = 'Test.SRM7';
        insert acc1;
        DMHistory__c dmh = new DMHistory__c();
        dmh.LastName__c = 'Last_1';
        dmh.FirstName__c = 'First_1';
        dmh.AccountId__c=acc1.id;
        dmh.PostalCode__c = '12345670';
        dmh.State__c = 'tokyo';
        dmh.City__c = 'Japan';
        dmh.Phone__c = '0801457812';
        dmh.Phone2__c = '0804745588';
        dmh.Path__c ='1';
        dmh.DMClass__c = 'BD2M';
        dmh.CatalogOrderId__c = '565765765';
        dmh.DMShipmentDate__c  = Date.today();
        dmh.ReasonForReturn__c='転居先不明   ';
        Date shipDate = Date.newInstance(2016,11,15);
        dmh.DMShipmentDate__c = shipDate;
        insert dmh;
        Account acc2 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc1.id];
        acc2.DMHistoryID_BD2M__c = dmh.Id;
         update acc2;
        string id2=string.valueof(acc2.CallingId_BD2M__c);
         DnpDM__c DnpDM = new DnpDM__c();
        DnpDM.ID__c = id2;  
        DnpDM.DMClass__c ='BD2M'; 
        dnpdm.ReturnsProcessingReason__c='転居先不明';
         insert dnpdm;
        //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_BirthdayDM_DNPFeedback_CL  dnpDMC = new Batch_BirthdayDM_DNPFeedback_CL(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00',Datetime.now().addMinutes(25));
        ID bPId = Database.executeBatch(dnpDMC);
//system.schedule('Batch_BirthdayDM_DNPFeedback_CL',cronExp ,dnpDMC); 
        test.stopTest();
        
      
    }
    static testMethod void AlreadyExists_DMHistory2() 
    {
        test.startTest();
         Account acc1 = new Account();
        acc1.EasyId__c = '128914';
        acc1.PersonBirthDate = Date.today().addYears(-50).addDays(60);        
        acc1.LastName = 'Test.SRM7';
        insert acc1;
        DMHistory__c dmh = new DMHistory__c();
        dmh.LastName__c = 'Last_1';
        dmh.FirstName__c = 'First_1';
        dmh.AccountId__c=acc1.id;
        dmh.PostalCode__c = '12345670';
        dmh.State__c = 'tokyo';
        dmh.City__c = 'Japan';
        dmh.Phone__c = '0801457812';
        dmh.Phone2__c = '0804745588';
        dmh.Path__c ='1';
        dmh.DMClass__c = 'BD2M';
        dmh.CatalogOrderId__c = '565765765';
        dmh.DMShipmentDate__c  = Date.today();
        dmh.ReturnProcessingDate__c=Date.newInstance(2018,11,16);
        Date shipDate = Date.newInstance(2016,11,15);
        dmh.DMShipmentDate__c = shipDate;
        insert dmh;
        Account acc2 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc1.id];
        acc2.DMHistoryID_BD2M__c = dmh.Id;
         update acc2;
        string id2=string.valueof(acc2.CallingId_BD2M__c);
         DnpDM__c DnpDM = new DnpDM__c();
        DnpDM.ID__c = id2;  
        DnpDM.DMClass__c ='BD2M'; 
        dnpdm.ReturnsProcessingDate__c=Date.newInstance(2018,11,16);
         insert dnpdm;
        //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_BirthdayDM_DNPFeedback_CL  dnpDMC = new Batch_BirthdayDM_DNPFeedback_CL(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00',Datetime.now().addMinutes(25));
        ID bPId = Database.executeBatch(dnpDMC);
//system.schedule('Batch_BirthdayDM_DNPFeedback_CL',cronExp ,dnpDMC); 
        test.stopTest();
        
      
    }
    
    static testMethod void NO_DMHistory() 
    {
        test.startTest();
         Account acc1 = new Account();
        acc1.EasyId__c = '128914';
        acc1.PersonBirthDate = Date.today().addYears(-50).addDays(60);        
        acc1.LastName = 'Test.SRM7';
        insert acc1;
        Account acc2 = [select ID,CRMID__c,Birthdate_BD2M__c,DMHistoryID_BD2M__c,CallingId_BD2M__c from Account where id =: acc1.id];
  
        string id2=string.valueof(acc2.CallingId_BD2M__c);
         DnpDM__c DnpDM = new DnpDM__c();
        DnpDM.ID__c = id2;  
        DnpDM.DMClass__c ='BD2M'; 
        dnpdm.ShippingDate__c=Date.newInstance(2018,11,15);
         insert dnpdm;
        //string cronExp='0 0 7 ? * 5';
        
        Datetime datetimeNow = datetime.now();
        Datetime datetimeAfter = datetimeNow.addMinutes(15);
        Batch_BirthdayDM_DNPFeedback_CL  dnpDMC = new Batch_BirthdayDM_DNPFeedback_CL(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
                                                                                                     datetimeAfter.formatGMT('yyyy-MM-dd') + 'T' + datetimeAfter.formatGMT('HH') + ':' + datetimeAfter.formatGMT('mm') + ':00+00:00',Datetime.now().addMinutes(25));
        ID bPId = Database.executeBatch(dnpDMC);
//system.schedule('Batch_BirthdayDM_DNPFeedback_CL',cronExp ,dnpDMC); 
        test.stopTest();
        
      
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
        String jobId = System.schedule('Test_Batch_BirthdayDM_DNPFeedback_CL', sch, new Batch_BirthdayDM_DNPFeedback_CL(datetimeNow.formatGMT('yyyy-MM-dd') + 'T' + datetimeNow.formatGMT('HH') + ':' + datetimeNow.formatGMT('mm') + ':00+00:00',
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