@isTest
public class Test_Batch2DM_Acclist_Nacl_OppMoppLead 
{ 
    
    static Integer DM_PreparationDays =10;
    static Integer BirthdayDM_Shipment_Day = Integer.valueOf(System.Label.BirthdayDM_Shipment_Day);
    static Datetime deadline =  Datetime.now().addMinutes(30);
    
    static testMethod void Accountlist_DoNotSend_BD2M_Flag_True() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.DoNotSend_BD2M__c = True;
        cl.PersonBirthDate = Date.Newinstance(1998,12,01);
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
         insert cl;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM';
        ld.FirstName__c = 'Test';
        ld.Company__c = 'Rakuraku';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.Newinstance(1998,12,01);
        ld.Street__c = '3-4-5';
        ld.City__c = 'Shibuya';
        ld.State__c = 'Tokyo';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.newInstance(2018,02,05);
        ld.AgentCd__c = '000001';
        insert ld;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.newInstance(2019,03,05);
        Date DM2_RunDateManual =Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
           cl = [select DoNotSend_BD2M__c from Account where Id =: cl.Id];
        System.assertEquals(False, cl.DoNotSend_BD2M__c);

    }
    static testMethod void Accountlist_PersonBirthdate_Month_Twelve() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.DoNotSend_BD2M__c = False;
        cl.PersonBirthDate = Date.Newinstance(1998,12,03);
        cl.SentCount_BD2M__c=0;
        cl.LastName='TEST';
         insert cl;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM';
        ld.FirstName__c = 'Test';
        ld.Company__c = 'Rakuraku';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.Newinstance(1998,12,03);
        ld.Street__c = '3-4-5';
        ld.City__c = 'Shibuya';
        ld.State__c = 'Tokyo';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.newInstance(2018,02,05);
        ld.AgentCd__c = '000001';
        insert ld;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.newInstance(2019,10,05);
        Date DM2_RunDateManual =Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
           cl = [select DoNotSend_BD2M__c from Account where Id =: cl.Id];
        System.assertEquals(True, cl.DoNotSend_BD2M__c);

    }
    
    static testMethod void Accountlist_DoNotSendDM_Flag_False_NoValidObject_Connected() 
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        //cl.Birthdate_BD2M__c = Date.today().addYears(-50).addDays(60);
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl.SentCount_BD2M__c=1;
        cl.DoNotSend_BD2M__c=False;
        cl.LastName='TEST';
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addMonths(-5);
        insert mOpp;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(60);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM2';
        ld.FirstName__c = 'Test2';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld.Street__c = '3-4-6';
        ld.City__c = 'Shibuyi';
        ld.State__c = 'Tokya';
        ld.PostalCode__c = '140-4346';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addMonths(-9).addDays(15);
        ld.AgentCd__c = '000001';
        insert ld;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today();
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        Account acc = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, 
                        Gender_BD2M__c, Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c,PersonBirthDate, BirthdayLateLastMonth_BD2M__c, 
                        AgeCalculationReferenceDate_BD2M__c, MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                        from Account where Id =: cl.Id];
        System.assertEquals(null, acc.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, acc.OpportunityID_BD2M__c);
        System.assertEquals(null, acc.LeadID_BD2M__c);
        System.assertEquals(null, acc.LastName_BD2M__c);
        System.assertEquals(null, acc.FirstName_BD2M__c);
        System.assertEquals(null, acc.State_BD2M__c);
        System.assertEquals(null, acc.City_BD2M__c);
        System.assertEquals(null, acc.Apart_BD2M__c);
        System.assertEquals(null, acc.PostalCode_BD2M__c);
        System.assertEquals(null, acc.Gender_BD2M__c);
        System.assertEquals(null, acc.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, acc.DMShipmentDate_BD2M__c);
        System.assertEquals(null, acc.Path_BD2M__c);
        System.assertEquals(null, acc.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, acc.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Multiple_ValidInvalidObject_Connected() 
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        //cl.Birthdate_BD2M__c = Date.today().addYears(-50).addDays(60);
        cl.PersonBirthdate=Date.today().addYears(-50).addDays(60);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test1';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuyo 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addMonths(-5);
        insert mOpp;
        
        MiniInsurance__c mOpp2 = new MiniInsurance__c();
        mOpp2.last_name__c = 'BDM';
        mOpp2.first_name__c = 'Test2';
        mOpp2.gender__c = '男性';
        mOpp2.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp2.address1__c = 'Tokyo';
        mOpp2.address2__c = 'Shibuyo 3-4-5';
        mOpp2.postal_code__c = '140-0004';
        mOpp2.easy_id__c = '123414';
        mOpp2.AccountId__c = cl.Id;
        mOpp2.expiry_date__c = Date.today().addMonths(1);
        insert mOpp2;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest3';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(60);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM2';
        ld.FirstName__c = 'Test4';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld.Street__c = '3-4-6';
        ld.City__c = 'Shibuyi';
        ld.State__c = 'Tokya';
        ld.PostalCode__c = '140-4346';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addMonths(-4);
        ld.AgentCd__c = '000001';
        insert ld;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM2';
        ld2.FirstName__c = 'Test5';
        ld2.Company__c = 'Rakuraku1';
        ld2.Gender__c = '男性';
        ld2.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld2.Street__c = '3-4-6';
        ld2.City__c = 'Shibuyi';
        ld2.State__c = 'Tokya';
        ld2.PostalCode__c = '140-4346';
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl.Id;
        ld2.CatalogOrderDate__c = Date.today().addMonths(1);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addMonths(8);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(null, cl.State_BD2M__c);
        System.assertEquals(null, cl.City_BD2M__c);
        System.assertEquals(null, cl.Apart_BD2M__c);
        System.assertEquals(null, cl.PostalCode_BD2M__c);
        System.assertEquals(null, cl.Gender_BD2M__c);
        System.assertEquals(null, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl.Path_BD2M__c);
        System.assertEquals(null, cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Only_Lead_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';     
        cl.LastName = 'ﾖﾖｷｼｿ02';
        cl.FirstName = 'ﾘﾘﾖﾘﾛ02';     
        cl.firstname__pc = 'ｷｼｿｷｼｿ02';
        cl.LastName__pc = 'ﾖｷﾖﾘ02';
        cl.Gender__pc = '男性';
        cl.SentCount_BD2M__c=1;
        //cl.Birthdate_BD2M__c =Date.today().addYears(-50).addDays(61);
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl.DoNotSend_BD2M__c=False;
        cl.LastName='TEST';
        insert cl;
        system.debug(cl.id);
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM';
        ld.FirstName__c = 'Test';
        ld.Company__c = 'Rakuraku';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld.Street__c = '3-4-5';
        ld.Apart__c = '606';
        ld.City__c = 'Shibuya';
        ld.State__c = 'Tokyo';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today();
        ld.AgentCd__c = '000001';
        insert ld;
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123411';
        //cl2.Birthdate_BD2M__c = Date.today().addYears(-50).addDays(61);
        cl2.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl2.DoNotSend_BD2M__c=False;
        cl2.SentCount_BD2M__c=1;
        cl2.LastName='TEST';
        insert cl2;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM';
        ld2.FirstName__c = 'Test';
        ld2.Company__c = 'Rakuraku';
        ld2.PostalCode__c = '1404343';
        ld2.EasyId__c = '123411';
        ld2.Ref_Account__c = cl2.Id;
        ld2.CatalogOrderDate__c = Date.today();
        ld2.BirthDate__c =Date.today().addYears(-50).addDays(61);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Account cl3 = new Account();
        cl3.EasyId__c = '123410';
        //cl3.Birthdate_BD2M__c =Date.today().addYears(-50).addDays(61);
        cl3.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl3.DoNotSend_BD2M__c=False;
        cl3.SentCount_BD2M__c=1;
        cl3.LastName='TEST';
        insert cl3;
        
        SeihoLead__c ld3 = new SeihoLead__c();
        ld3.LastName__c = 'BDM';
        ld3.FirstName__c = 'Test';
        ld3.Company__c = 'Rakuraku';
        ld3.PostalCode__c = '';
        ld3.EasyId__c = '123410';
        ld3.Ref_Account__c = cl3.Id;
        ld3.CatalogOrderDate__c = Date.today();
        ld3.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld3.AgentCd__c = '000001';
        insert ld3;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(ld.Id, cl.LeadID_BD2M__c);
        System.assertEquals(ld.LastName__c, cl.LastName_BD2M__c);
        System.assertEquals(ld.FirstName__c, cl.FirstName_BD2M__c);
        System.assertEquals('1404343', cl.PostalCode_BD2M__c);
        System.assertEquals(ld.Street__c+ld.Apart__c, cl.Apart_BD2M__c);
        System.assertEquals(ld.City__c, cl.City_BD2M__c);
        System.assertEquals(ld.State__c, cl.State_BD2M__c);
        System.assertEquals(ld.Gender__c, cl.Gender_BD2M__c);
        System.assertEquals(ld.BirthDate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('２', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
        
        cl2 = [select PostalCode_BD2M__c from Account where Id =: cl2.Id];
        System.assertEquals(null, cl2.PostalCode_BD2M__c);
        
        cl3 = [select PostalCode_BD2M__c from Account where Id =: cl3.Id];
        System.assertEquals(null, cl3.PostalCode_BD2M__c); 

    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Only_Opp_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        //cl.Birthdate_BD2M__c = Date.today().addYears(-50).addDays(63);
        cl.PersonBirthdate = Date.today().addYears(-50).addDays(63);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op.State__c = 'Toky';
        op.address1__c = 'Shinagawa';
        op.address2__c = 'Yashio';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        op.AgentCd__c = '000001';
        op.ApplySts__c = '顧客情報入力済';
        insert op;
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123414';
        cl2.personBirthDate = Date.today().addYears(-50).addDays(63);
        cl2.DoNotSend_BD2M__c=false;
        cl2.SentCount_BD2M__c=1;
        cl2.LastName='TEST';
        insert cl2;
        
        SeihoOpportunity__c op2 = new SeihoOpportunity__c();
        op2.Name = 'BDMTest';
        op2.StageName__c = '評価';
        op2.CloseDate__c = Date.today();
        op2.LastName__c = 'BDM';
        op2.FirstName__c = 'Test';
        op2.Gender__c = '男性';
        op2.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op2.address1__c = 'Tokyo';
        op2.address2__c = 'Shibuya';
        op2.address3__c = '3-4-5';
        op2.PostalCode__c = '140-0004';
        op2.Ref_Account__c = cl2.id;
        op2.AgentCd__c = '000001';
        op2.ApplySts__c = '申込完了';
        insert op2;
        
        Account cl3 = new Account();
        cl3.EasyId__c = '123414';
        cl3.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl3.DoNotSend_BD2M__c=false;
        cl3.SentCount_BD2M__c=1;
        cl3.LastName='TEST';
        insert cl3;
        
        SeihoOpportunity__c op3 = new SeihoOpportunity__c();
        op3.Name = 'BDMTest';
        op3.StageName__c = '評価';
        op3.CloseDate__c = Date.today();
        op3.LastName__c = 'BDM';
        op3.FirstName__c = 'Test';
        op3.Gender__c = '男性';
        op3.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op3.address1__c = 'Tokyo';
        op3.address2__c = 'Shibuya';
        op3.address3__c = '3-4-5';
        op3.PostalCode__c = '140-0004';
        op3.Ref_Account__c = cl3.id;
        op3.AgentCd__c = '000001';
        op3.ApplySts__c = '申込完了';
        insert op3;
        
        Account cl4 = new Account();
        cl4.EasyId__c = '123419';
        cl4.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl4.DoNotSend_BD2M__c=false;
        cl4.SentCount_BD2M__c=1;
        cl4.LastName='TEST';
        insert cl4;
        
        SeihoOpportunity__c op4 = new SeihoOpportunity__c();
        op4.Name = 'OPSTest';
        op4.StageName__c = '評価';
        op4.CloseDate__c = Date.today();
        op4.LastName__c = 'BDM';
        op4.FirstName__c = 'Test';
        op4.Gender__c = '男性';
        op4.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op4.address1__c = 'Tokyo';
        op4.address2__c = 'Shibuya';
        op4.address3__c = '3-4-5';
        op4.PostalCode__c = '1400004';
        op4.Ref_Account__c = cl4.id;
        op4.AgentCd__c = '000001';
        op4.ApplySts__c = '職業入力済';
        insert op4;
        
        Account cl5 = new Account();
        cl5.EasyId__c = '123414';
        cl5.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl5.DoNotSend_BD2M__c=false;
        cl5.SentCount_BD2M__c=1;
        cl5.LastName='TEST';
        insert cl5;
        
        SeihoOpportunity__c op5 = new SeihoOpportunity__c();
        op5.Name = 'PackTest';
        op5.StageName__c = '評価';
        op5.CloseDate__c = Date.today();
        op5.LastName__c = 'BDM';
        op5.FirstName__c = 'Test';
        op5.Gender__c = '男性';
        op5.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op5.State__c = 'Toky';
        op5.address2__c = 'Shibuya';
        op5.address3__c = '3-4-5';
        op5.PostalCode__c = '';
        op5.Ref_Account__c = cl5.id;
        op5.AgentCd__c = '000001';
        op5.ApplySts__c = '職業入力済';
        insert op5;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
       
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(op.Id, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(op.LastName__c, cl.LastName_BD2M__c);
        System.assertEquals(op.FirstName__c, cl.FirstName_BD2M__c);
        System.assertEquals('1400004', cl.PostalCode_BD2M__c);
        System.assertEquals(op.State__c + op.address1__c, cl.State_BD2M__c);
        System.assertEquals(op.address2__c, cl.City_BD2M__c);
        System.assertEquals(op.address3__c, cl.Apart_BD2M__c);
        System.assertEquals(op.Gender__c, cl.Gender_BD2M__c);
        System.assertEquals(op.Birthdate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('１', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
        
        DMHistory__c dmh = [select SeihoOpportunityID__c from DMHistory__c where AccountId__c =: cl.Id];
        System.assertEquals(op.Id, dmh.SeihoOpportunityID__c);
        
        cl2 = [select OpportunityID_BD2M__c from Account where Id =: cl2.Id];
        System.assertEquals(null, cl2.OpportunityID_BD2M__c);
        
        cl3 = [select OpportunityID_BD2M__c from Account where Id =: cl3.Id];
        System.assertEquals(null, cl3.OpportunityID_BD2M__c);
        
        cl4 = [select OpportunityID_BD2M__c, State_BD2M__c, PostalCode_BD2M__c from Account where Id =: cl4.Id];
        System.assertEquals(op4.Id, cl4.OpportunityID_BD2M__c);
        System.assertEquals(op4.address1__c, cl4.State_BD2M__c);
        System.assertEquals('1400004', cl4.PostalCode_BD2M__c);
        
        cl5 = [select OpportunityID_BD2M__c, State_BD2M__c, PostalCode_BD2M__c from Account where Id =: cl5.Id];
        System.assertEquals(op5.Id, cl5.OpportunityID_BD2M__c);
        System.assertEquals(op5.State__c, cl5.State_BD2M__c);
        System.assertEquals(null, cl5.PostalCode_BD2M__c);

    }
    static testMethod void Accountlist_ConnectedTo_OpsWithDiffDetailsUsingEasyId() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-40).addMonths(2);
        cl.LastName='TEST';
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        insert cl;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'OPSTest1';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'Rakuten';
        op.FirstName__c = 'Tarou';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addMonths(-2);
        op.State__c = 'Tok';
        op.address1__c = 'Shinagawa';
        op.address2__c = 'Yashio';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        op.AgentCd__c = '000001';
        op.ApplySts__c = '意向確認済';
        insert op;
        
        SeihoOpportunity__c op2 = new SeihoOpportunity__c();
        op2.Name = 'OPSTest2';
        op2.StageName__c = '評価';
        op2.CloseDate__c = Date.today();
        op2.LastName__c = 'Rakuten';
        op2.FirstName__c = 'Miller';
        op2.Gender__c = '女性';
        op2.Birthdate__c = Date.today().addYears(-40).addMonths(2);
        op2.address1__c = 'Tokyo';
        op2.address2__c = 'Shibuya';
        op2.address3__c = '3-4-5';
        op2.PostalCode__c = '140-0004';
        op2.Ref_Account__c = cl.id;
        op2.AgentCd__c = '123456';
        op2.ApplySts__c = '支払い方法入力済';
        insert op2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select DMShipmentDate_BD2M__c from Account where Id =: cl.Id];
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
    }
    static testMethod void OldOps_GKOps_ConnectedToCallList() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-40).addMonths(8);
        cl.LastName='TEST';
        //cl.UpdatedBirthdate will become same as cl.Birthdate
        insert cl;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'OPSTest1';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'Rakuten';
        op.FirstName__c = 'Tarou';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-40).addMonths(8);
        op.State__c = 'Tok';
        op.address1__c = 'Shinagawa';
        op.address2__c = 'Yashio';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        op.AgentCd__c = '000001';
        op.ApplySts__c = '意向確認済';
        insert op;
        
        SeihoOpportunity__c op2 = new SeihoOpportunity__c();
        op2.Name = 'Test2';
        op2.StageName__c = '評価';
        op2.CloseDate__c = Date.today();
        op2.LastName__c = 'Rakuten';
        op2.FirstName__c = 'Tarou';
        op2.Gender__c = '男性';
        op2.Birthdate__c = Date.today().addYears(-40).addMonths(8);
        op2.State__c = 'Tok';
        op2.address1__c = 'Shinagawa';
        op2.address2__c = 'Yashio';
        op2.address3__c = '3-4-5';
        op2.PostalCode__c = '140-0004';
        op2.Ref_Account__c = cl.id;
        op2.AgentCd__c = '000001';
        op2.ApplySts__c = '支払い方法入力済';
        insert op2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addMonths(6);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select DMShipmentDate_BD2M__c from Account where Id =: cl.Id];
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Only_Mopp_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl.LastName='TEST';
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(63);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '1400004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today();
        mOpp.entry_status__c = '契約満了';
        insert mOpp;
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123414';
        cl2.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl2.DoNotSend_BD2M__c=false;
        cl2.SentCount_BD2M__c=1;
        cl2.LastName='TEST';
        insert cl2;
        
        MiniInsurance__c mOpp2 = new MiniInsurance__c();
        mOpp2.last_name__c = 'BDM';
        mOpp2.first_name__c = 'Test2';
        mOpp2.gender__c = '男性';
        mOpp2.birthdate__c = Date.today().addYears(-50).addDays(63);
        mOpp2.address1__c = 'Tokyo';
        mOpp2.address2__c = 'Shibuyo 3-4-5';
        mOpp2.postal_code__c = '140-0004';
        mOpp2.easy_id__c = '123414';
        mOpp2.AccountId__c = cl2.Id;
        mOpp2.expiry_date__c = Date.today().addMonths(11);
        mOpp2.entry_status__c = 'お引受けできません';
        insert mOpp2;
        
        Account cl3 = new Account();
        cl3.EasyId__c = '1234144';
        cl3.PersonBirthDate = Date.today().addYears(-40).addDays(63);
        cl3.DoNotSend_BD2M__c=false;
        cl3.SentCount_BD2M__c=1;
        cl3.LastName='TEST';
        insert cl3;
        
        MiniInsurance__c mOpp3 = new MiniInsurance__c();
        mOpp3.last_name__c = 'BDM';
        mOpp3.first_name__c = 'Test3';
        mOpp3.gender__c = '男性';
        mOpp3.birthdate__c = Date.today().addYears(-40).addDays(63);
        mOpp3.address1__c = 'Tokyo';
        mOpp3.address2__c = 'Shibuyo 3-4-5';
        mOpp3.postal_code__c = '140-0004';
        mOpp3.easy_id__c = '1234144';
        mOpp3.AccountId__c = cl3.Id;
        mOpp3.expiry_date__c = Date.today().addMonths(12);
        mOpp3.entry_status__c = null;
        insert mOpp3;
        
        Account cl4 = new Account();
        cl4.EasyId__c = '1234114';
        cl4.PersonBirthDate = Date.today().addYears(-40).addDays(63);
        cl4.LastName='TEST';
        cl4.DoNotSend_BD2M__c=false;
        cl4.SentCount_BD2M__c=1;
        insert cl4;
        
        MiniInsurance__c mOpp4 = new MiniInsurance__c();
        mOpp4.last_name__c = 'BDM';
        mOpp4.first_name__c = '＿Test3';
        mOpp4.gender__c = '男性';
        mOpp4.birthdate__c = Date.today().addYears(-40).addDays(63);
        mOpp4.address1__c = 'Tokyo';
        mOpp4.address2__c = 'Shibuyo 3-4-5';
        mOpp4.postal_code__c = '140-0004';
        mOpp4.easy_id__c = '1234114';
        mOpp4.AccountId__c = cl4.Id;
        mOpp4.expiry_date__c = Date.today().addMonths(12);
        mOpp4.entry_status__c = '契約満了';
        insert mOpp4;
        
        Account cl5 = new Account();
        cl5.EasyId__c = '1234104';
        cl5.PersonBirthDate = Date.today().addYears(-40).addDays(63);
        cl5.DoNotSend_BD2M__c=false;
        cl5.SentCount_BD2M__c=1;
        cl5.LastName='TEST';
        insert cl5;
        
        MiniInsurance__c mOpp5 = new MiniInsurance__c();
        mOpp5.last_name__c = 'BDM＿';
        mOpp5.first_name__c = 'Test3';
        mOpp5.gender__c = '男性';
        mOpp5.birthdate__c = Date.today().addYears(-40).addDays(63);
        mOpp5.address1__c = 'Tokyo';
        mOpp5.address2__c = 'Shibuyo 3-4-5';
        mOpp5.postal_code__c = '140-0004';
        mOpp5.easy_id__c = '1234104';
        mOpp5.AccountId__c = cl5.Id;
        mOpp5.expiry_date__c = Date.today().addMonths(12);
        mOpp5.entry_status__c = '契約満了';
        insert mOpp5;    
        
        Account cl6 = new Account();
        cl6.EasyId__c = '1234104';
        cl6.PersonBirthDate = Date.today().addYears(-40).addDays(63);
        cl6.DoNotSend_BD2M__c=false;
        cl6.SentCount_BD2M__c=1;
        cl6.LastName='TEST';
        insert cl6;
        
        MiniInsurance__c mOpp6 = new MiniInsurance__c();
        mOpp6.last_name__c = 'BDM＿';
        mOpp6.first_name__c = 'Test3';
        mOpp6.gender__c = '男性';
        mOpp6.birthdate__c = Date.today().addYears(-40).addDays(63);
        mOpp6.address1__c = 'Tokyo';
        mOpp6.address2__c = 'Shibuyo 3-4-5';
        mOpp6.postal_code__c = '140-0004';
        mOpp6.easy_id__c = '1234104';
        mOpp6.AccountId__c = cl6.Id;
        mOpp6.expiry_date__c = Date.today().addMonths(12);
        mOpp6.entry_status__c = '契約満了';
        insert mOpp6;  
        
        MiniInsurance__c mOpp7 = new MiniInsurance__c();
        mOpp7.last_name__c = 'BDM';
        mOpp7.first_name__c = 'Test3';
        mOpp7.gender__c = '男性';
        mOpp7.birthdate__c = Date.today().addYears(-40).addDays(63);
        mOpp7.address1__c = 'Tokyo';
        mOpp7.address2__c = 'Shibuyo 3-4-5';
        mOpp7.postal_code__c = '140-0004';
        mOpp7.easy_id__c = '1234104';
        mOpp7.AccountId__c = cl6.Id;
        mOpp7.expiry_date__c = Date.today().addMonths(-12);
        mOpp7.entry_status__c = '契約満了';
        insert mOpp7;  
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(cl.LastName_BD2M__c, null);
        System.assertEquals(cl.FirstName_BD2M__c,null);
        System.assertEquals(cl.FirstName_BD2M__c,null);
        System.assertEquals(cl.City_BD2M__c,null);
        System.assertEquals(cl.PostalCode_BD2M__c,null);
        System.assertEquals(cl.Gender_BD2M__c,null);
        System.assertEquals(cl.Birthdate_BD2M__c,null);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(cl.DMShipmentDate_BD2M__c,null);
        System.assertEquals(cl.Path_BD2M__c,null);
        System.assertEquals(cl.BirthdayLateLastMonth_BD2M__c,null);
        System.assertEquals(cl.AgeCalculationReferenceDate_BD2M__c,null);                    
        
        cl2 = [select MiniOpportunitiesID_BD2M__c from Account where Id =: cl2.Id];
        System.assertEquals(null, cl2.MiniOpportunitiesID_BD2M__c);
        
        cl3 = [select MiniOpportunitiesID_BD2M__c from Account where Id =: cl3.Id];
        System.assertEquals(null, cl3.MiniOpportunitiesID_BD2M__c);
        
        cl4 = [select MiniOpportunitiesID_BD2M__c from Account where Id =: cl4.Id];
        System.assertEquals(null, cl4.MiniOpportunitiesID_BD2M__c);
        
        cl5 = [select MiniOpportunitiesID_BD2M__c from Account where Id =: cl5.Id];
        System.assertEquals(null, cl5.MiniOpportunitiesID_BD2M__c);
        
        cl6 = [select MiniOpportunitiesID_BD2M__c from Account where Id =: cl6.Id];
        System.assertEquals(null, cl6.MiniOpportunitiesID_BD2M__c);
    }
  
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Opp_Mopp_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(63);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(63);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(63);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addDays(2);
        mOpp.entry_status__c = '契約満了';
        insert mOpp;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(null, cl.State_BD2M__c);
        System.assertEquals(null, cl.City_BD2M__c);
        System.assertEquals(null, cl.PostalCode_BD2M__c);
        System.assertEquals(null, cl.Gender_BD2M__c);
        System.assertEquals(null, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl.Path_BD2M__c);
        System.assertEquals(null, cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Opp_Lead_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '12314';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(61);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(61);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM2';
        ld.FirstName__c = 'Test2';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld.Street__c = '3-4-6';
        ld.City__c = 'Shibuyi';
        ld.State__c = 'Tokya';
        ld.PostalCode__c = '140-4346';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addDays(3);
        ld.AgentCd__c = '000001';
        insert ld;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(ld.Id, cl.LeadID_BD2M__c);
        System.assertEquals(ld.LastName__c, cl.LastName_BD2M__c);
        System.assertEquals(ld.FirstName__c, cl.FirstName_BD2M__c);
        System.assertEquals(ld.State__c, cl.State_BD2M__c);
        System.assertEquals(ld.City__c, cl.City_BD2M__c);
        System.assertEquals(ld.Street__c, cl.Apart_BD2M__c);
        System.assertEquals('1404346', cl.PostalCode_BD2M__c);
        System.assertEquals(ld.Gender__c, cl.Gender_BD2M__c);
        System.assertEquals(ld.BirthDate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('２', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSendDM_Flag_False_Mopp_Lead_Connected() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '12341449';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(61);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        Account newcl = [select id,EasyId__c,Birthdate_BD2M__c,PersonBirthdate from  Account where id=:cl.id];
        system.debug('-->'+newcl);
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(61);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '12341449';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addDays(2);
        mOpp.entry_status__c = '契約満了';
        insert mOpp;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM';
        ld.FirstName__c = 'Test';
        ld.Company__c = 'Rakuraku';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld.Street__c = '3-4-5';
        ld.City__c = 'Shibuya';
        ld.State__c = 'Tokyo';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '12341449';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today();
        ld.AgentCd__c = '000001';
        insert ld;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        system.debug(ld.Id+'--testing '+DM2_RunDateManual);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
         system.debug(ld.Id+'After check testing '+cl.LeadID_BD2M__c);
        //System.assertEquals(mOpp.Id, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(ld.Id, cl.LeadID_BD2M__c);
        System.assertEquals(mOpp.last_name__c, cl.LastName_BD2M__c);
        System.assertEquals(mOpp.first_name__c, cl.FirstName_BD2M__c);
        System.assertEquals(mOpp.address1__c, cl.State_BD2M__c);
        System.assertEquals(ld.City__c, cl.City_BD2M__c);
        System.assertEquals('1404343', cl.PostalCode_BD2M__c);
        System.assertEquals(mOpp.gender__c, cl.Gender_BD2M__c);
        System.assertEquals(mOpp.birthdate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('２', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_DoNotSend_BD2M_Flag_False_Opp_Mopp_LeadConnected() 
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(61);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(61);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addDays(2);
        mOpp.entry_status__c = '契約満了';
        insert mOpp;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(61);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM2';
        ld.FirstName__c = 'Test2';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld.Street__c = '3-4-6';
        ld.City__c = 'Shibuyi';
        ld.State__c = 'Tokya';
        ld.PostalCode__c = '140-4346';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addDays(3);
        ld.AgentCd__c = '000001';
        insert ld;
        
        SeihoInboundLead__c inboundLead1 = new SeihoInboundLead__c();
        inboundLead1.LastName__c = 'BDM';
        inboundLead1.FirstName__c = '郎';
        inboundLead1.State__c = '山梨県';
        inboundLead1.Apart__c = '4343';
        inboundLead1.PostalCode__c = '140-4343';
        inboundLead1.City__c = 'Shibuya';
        inboundLead1.BirthDate__c =  Date.today().addYears(-50).addDays(61);
        inboundLead1.Gender__c = '男性';
        inboundLead1.AccountId__c = cl.Id;
        inboundLead1.DestState__c = '山梨県';
        inboundLead1.DestPhone__c = '12341234122';
        inboundLead1.Phone__c = '12341234123';
        inboundLead1.DestPostalCode__c = '0909090';
        inboundLead1.DestCity__c = 'Shibuya';
        inboundLead1.DestApart__c = '4343';
        inboundLead1.InterestedProds01__c = True;
        inboundLead1.IsShippingExcluded__c = False;
        inboundLead1.CatalogOrderDate__c = Date.today().addYears(-1);
        inboundLead1.AgentCd__c = '000001';
        inboundLead1.Path1__c = 'ＴＶ';
        inboundLead1.DestFirstName__c = 'TestDestFirstName';
        inboundLead1.DestLastName__c = 'TestDestLastName';        
        insert inboundLead1;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();

        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(ld.Id, cl.LeadID_BD2M__c);
        System.assertEquals(ld.LastName__c, cl.LastName_BD2M__c);
        System.assertEquals(ld.FirstName__c, cl.FirstName_BD2M__c);
        System.assertEquals(ld.State__c, cl.State_BD2M__c);
        System.assertEquals(ld.City__c, cl.City_BD2M__c);
        System.assertEquals(ld.Street__c, cl.Apart_BD2M__c);
        System.assertEquals('1404346', cl.PostalCode_BD2M__c);
        System.assertEquals(ld.Gender__c, cl.Gender_BD2M__c);
        System.assertEquals(ld.BirthDate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('２', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void multiple_samekind_objects_linked_to_Accountlist_val()
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(61);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM1';
        ld.FirstName__c = 'Test1';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld.Street__c = '3-4-3';
        ld.City__c = 'Shibuyo';
        ld.State__c = 'Tokyr';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addDays(3);
        ld.AgentCd__c = '000001';
        insert ld;
        
        SeihoLead__c  ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM2';
        ld2.FirstName__c = 'Test2';
        ld2.Company__c = 'Rakuraku1';
        ld2.Gender__c = '男性';
        ld2.BirthDate__c = Date.today().addYears(-50).addDays(61);
        ld2.Street__c = '3-4-6';
        ld2.City__c = 'Shibuyi';
        ld2.State__c = 'Tokya';
        ld2.PostalCode__c = '140-4346';
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl.Id;
        ld2.CatalogOrderDate__c = Date.today().addDays(1);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(ld.Id, cl.LeadID_BD2M__c);
        System.assertEquals(ld.LastName__c, cl.LastName_BD2M__c);
        System.assertEquals(ld.FirstName__c, cl.FirstName_BD2M__c);
        System.assertEquals(ld.State__c, cl.State_BD2M__c);
        System.assertEquals(ld.City__c, cl.City_BD2M__c);
        System.assertEquals(ld.Street__c, cl.Apart_BD2M__c);
        System.assertEquals('1404343', cl.PostalCode_BD2M__c);
        System.assertEquals(ld.Gender__c, cl.Gender_BD2M__c);
        System.assertEquals(ld.BirthDate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(shipmentDate, cl.DMShipmentDate_BD2M__c);
        System.assertEquals('２', cl.Path_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2), cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1), cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void multiple_samekind_objects_linked_to_Accountlist_val_inval()
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName='TEST';
        insert cl;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM1';
        ld.FirstName__c = 'Test1';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld.Street__c = '3-4-3';
        ld.City__c = 'Shibuyo';
        ld.State__c = 'Tokyr';
        ld.PostalCode__c = '140-4343';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addMonths(5);
        ld.AgentCd__c = '000001';
        insert ld;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM2';
        ld2.FirstName__c = 'Test2';
        ld2.Company__c = 'Rakuraku1';
        ld2.Gender__c = '男性';
        ld2.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld2.Street__c = '3-4-6';
        ld2.City__c = 'Shibuyi';
        ld2.State__c = 'Tokya';
        ld2.PostalCode__c = '140-4346';
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl.Id;
        ld2.CatalogOrderDate__c = Date.today().addDays(5);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(null, cl.State_BD2M__c);
        System.assertEquals(null, cl.City_BD2M__c);
        System.assertEquals(null, cl.Apart_BD2M__c);
        System.assertEquals(null, cl.PostalCode_BD2M__c);
        System.assertEquals(null, cl.Gender_BD2M__c);
        System.assertEquals(null, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl.Path_BD2M__c);
        System.assertEquals(null, cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl.AgeCalculationReferenceDate_BD2M__c);
    }
    static testMethod void Accountlist_SentCount_BD2M_check() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.SentCount_BD2M__c = 3;
        cl.DoNotSend_BD2M__c=false;
        cl.personBirthDate = Date.today().addYears(-50).addDays(60);
        cl.LastName='TEST';
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today();
        insert mOpp;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(null, cl.State_BD2M__c);
        System.assertEquals(null, cl.City_BD2M__c);
        System.assertEquals(null, cl.PostalCode_BD2M__c);
        System.assertEquals(null, cl.Gender_BD2M__c);
        System.assertEquals(null, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl.Path_BD2M__c);
        System.assertEquals(null, cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl.AgeCalculationReferenceDate_BD2M__c);
    }
    
    static testMethod void Accountlist_MiniInsurance_check() 
    {
        test.startTest();
        
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.SentCount_BD2M__c = 0;
        cl.DoNotSend_BD2M__c=false;
        cl.PersonBirthdate =Date.newInstance(1979,07,07);
        cl.LastName='TEST';
        cl.age__Pc =40;
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.newInstance(1979,07,07);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuya 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.newInstance(2020,06,18);
        mopp.entry_status__c='契約満了';
        mopp.dm_flg__c = False;
        insert mOpp;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.newInstance(2021,05,15);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
       miniInsurance__c mocc= [select id,address1__c,address2__c,postal_code__c,gender__c,birthdate__c from miniInsurance__c where id=:mopp.id];
        System.assertEquals(mocc.id, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(mocc.address1__c, cl.State_BD2M__c);
        System.assertEquals(mocc.address2__c, cl.City_BD2M__c);
        System.assertEquals(mocc.gender__c, cl.Gender_BD2M__c);
        System.assertEquals(mocc.birthdate__c, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        }

    static testMethod void Accountlists_collection_filter_check() 
    {
        test.startTest();
        Account cl1 = new Account();
        cl1.EasyId__c = '123414';
        cl1.PersonBirthDate = Date.newInstance(1977, 05, 01);
        cl1.SentCount_BD2M__c = 3;
        cl1.DoNotSend_BD2M__c=false;
        cl1.LastName='TEST';
        insert cl1;
        
        SeihoLead__c ld1 = new SeihoLead__c();
        ld1.BirthDate__c =  cl1.PersonBirthDate;
        ld1.LastName__c = 'BDM2Test1';
        ld1.Company__c = 'Rakuraku1';
        ld1.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld1.EasyId__c = '123414';
        ld1.Ref_Account__c = cl1.Id;
        ld1.CatalogOrderDate__c = Date.today().addYears(-3);
        ld1.AgentCd__c = '000001';
        insert ld1;
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123415';
        cl2.PersonBirthDate = Date.newInstance(1977, 05, 02);
        cl2.SentCount_BD2M__c = 1;
        cl2.DoNotSend_BD2M__c=false;
        cl2.LastName='TEST';
        insert cl2;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.BirthDate__c =  cl2.PersonBirthDate;
        ld2.LastName__c = 'BDM2Test2';
        ld2.Company__c = 'Rakuraku1';
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl2.Id;
        ld2.CatalogOrderDate__c = Date.today().addYears(-2);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Account cl3 = new Account();
        cl3.EasyId__c = '123414';
        cl3.PersonBirthDate = Date.newInstance(1977, 05, 15);
        cl3.SentCount_BD2M__c = 1;
        cl3.DoNotSend_BD2M__c=false;
        cl3.LastName='TEST';
        insert cl3;
        
        SeihoLead__c ld3 = new SeihoLead__c();
        ld3.BirthDate__c =  cl3.PersonBirthDate;
        ld3.LastName__c = 'BDM2Test3';
        ld3.Company__c = 'Rakuraku1';
        ld3.EasyId__c = '123414';
        ld3.Ref_Account__c = cl3.Id;
        ld3.CatalogOrderDate__c = Date.today().addYears(-3);
        ld3.AgentCd__c = '000001';
        insert ld3;
        
        Account cl4 = new Account();
        cl4.EasyId__c = '6823414';
        cl4.PersonBirthDate = Date.newInstance(1977, 05, 02);
        cl4.SentCount_BD2M__c = 1;
        cl4.DoNotSend_BD2M__c=false;
        cl4.LastName='TEST';
        insert cl4;
        
        SeihoLead__c ld4 = new SeihoLead__c();
        ld4.EasyId__c = '6823414';
        ld4.BirthDate__c =  cl4.PersonBirthDate;
        ld4.LastName__c = 'BDM2Test42';
        ld4.Company__c = 'Rakuraku12';        
        ld4.Ref_Account__c = cl4.Id;
        ld4.CatalogOrderDate__c = Date.today().addYears(-2);
        ld4.AgentCd__c = '000001';
        insert ld4;
        
        Account cl5 = new Account();
        cl5.EasyId__c = '123414';
        cl5.PersonBirthDate = Date.newInstance(1967, 06, 02);
        cl5.SentCount_BD2M__c = 1;
        cl5.DoNotSend_BD2M__c=false;
        cl5.LastName='TEST';
        insert cl5;
        
        SeihoLead__c ld5 = new SeihoLead__c();
        ld5.BirthDate__c =  cl5.PersonBirthDate;
        ld5.LastName__c = 'BDM2Test5';
        ld5.Company__c = 'Rakuraku1';
        ld5.EasyId__c = '123414';
        ld5.Ref_Account__c = cl5.Id;
        ld5.CatalogOrderDate__c = Date.today().addYears(-3);
        ld5.AgentCd__c = '000001';
        insert ld5;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = Date.newInstance(Date.today().Year(), 03, batchRunDay);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Date ShipmentDate = Date.newInstance(dt.year(), dt.month(), BirthdayDM_Shipment_Day);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl1 = [Select DMShipmentDate_BD2M__c from Account where Id =: cl1.Id];
        System.assertEquals(null, cl1.DMShipmentDate_BD2M__c);
        
        cl2 = [Select DMShipmentDate_BD2M__c from Account where Id =: cl2.Id];
        System.assertEquals(ShipmentDate, cl2.DMShipmentDate_BD2M__c);
        
        cl3 = [Select DMShipmentDate_BD2M__c from Account where Id =: cl3.Id];
        System.assertEquals(ShipmentDate, cl3.DMShipmentDate_BD2M__c);
        
        cl4 = [Select DMShipmentDate_BD2M__c from Account where Id =: cl4.Id];
        System.assertEquals(ShipmentDate, cl4.DMShipmentDate_BD2M__c);
        
        cl5 = [Select DMShipmentDate_BD2M__c from Account where Id =: cl5.Id];
        System.assertEquals(null, cl5.DMShipmentDate_BD2M__c); 
    }
    static testMethod void Accountlists_Age_Range_check() 
    {
        test.startTest();
        
        Account cl1 = new Account();
        cl1.EasyId__c = '123414';       
        cl1.personBirthDate = Date.newInstance(1932, 02, 02);//Age = 85
        cl1.LastName='TEST';
        cl1.DoNotSend_BD2M__c=false;
        cl1.SentCount_BD2M__c=1;
        insert cl1;
        
        SeihoLead__c ld1 = new SeihoLead__c();
        ld1.BirthDate__c =  cl1.personBirthDate;
        ld1.LastName__c = 'BDM2Test1';
        ld1.Company__c = 'Rakuraku1';
        ld1.BirthDate__c = Date.newInstance(1932, 02, 02);//Age = 85         
        ld1.EasyId__c = '123414';
        ld1.Ref_Account__c = cl1.Id;
        ld1.CatalogOrderDate__c = Date.newInstance(2012, 07, 02);
        ld1.AgentCd__c = '000001';
        insert ld1;
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123414';
        cl2.personBirthDate =   Date.newInstance(1933, 02, 02);//Age = 84 
        cl2.LastName='TEST';    
        cl2.DoNotSend_BD2M__c=false;
        cl2.SentCount_BD2M__c=1;
        insert cl2;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.BirthDate__c =  cl2.Birthdate_BD2M__c;
        ld2.LastName__c = 'BDM2Test2';
        ld2.Company__c = 'Rakuraku1';
        ld2.BirthDate__c =  Date.newInstance(1933, 02, 02);//Age = 84        
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl2.Id;
        ld2.CatalogOrderDate__c = Date.newInstance(1990, 02, 02);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Account cl3 = new Account();
        cl3.EasyId__c = '123414';
        cl3.personBirthDate =Date.newInstance(1931, 07, 02);//Age = 86       
        cl3.LastName='TEST';
        cl1.DoNotSend_BD2M__c=false;
        cl1.SentCount_BD2M__c=1;
        insert cl3;
        
        SeihoLead__c ld3 = new SeihoLead__c();
        ld3.BirthDate__c =  cl3.Birthdate_BD2M__c;
        ld3.LastName__c = 'BDM2Test3';
        ld3.Company__c = 'Rakuraku1';
        ld3.BirthDate__c =Date.newInstance(1931, 07, 02);//Age = 86        
        ld3.EasyId__c = '123414';
        ld3.Ref_Account__c = cl3.Id;
        ld3.CatalogOrderDate__c = Date.newInstance(2013, 07, 02);
        ld3.AgentCd__c = '000001';
        insert ld3;
        
        Account cl4 = new Account();
        cl4.EasyId__c = '123414';
        cl4.PersonBirthdate = Date.newInstance(1997, 02, 02);//Age = 20        
        cl4.LastName='TEST';
        cl4.DoNotSend_BD2M__c=false;
        cl4.SentCount_BD2M__c=1;
        insert cl4;
        
        SeihoLead__c ld4 = new SeihoLead__c();
        ld4.BirthDate__c =  cl4.PersonBirthDate;
        ld4.LastName__c = 'BDM2Test4';
        ld4.Company__c = 'Rakuraku1';
        ld4.BirthDate__c = Date.newInstance(1997, 02, 02);//Age = 20        
        ld4.EasyId__c = '123414';
        ld4.Ref_Account__c = cl4.Id;
        ld4.CatalogOrderDate__c = Date.newInstance(2015, 02, 02);
        ld4.AgentCd__c = '000001';
        insert ld4;
        
        Account cl5 = new Account();
        cl5.EasyId__c = '123414';
        cl5.PersonBirthDate = Date.newInstance(1996, 02, 02);//Age = 21        
        cl5.LastName='TEST';
        cl5.DoNotSend_BD2M__c=false;
        cl5.SentCount_BD2M__c=1;
        insert cl5;
        
        SeihoLead__c ld5 = new SeihoLead__c();
        ld5.BirthDate__c =  cl5.PersonBirthDate;
        ld5.LastName__c = 'BDM2Test5';
        ld5.Company__c = 'Rakuraku1';
        ld5.BirthDate__c = Date.newInstance(1996, 02, 02);//Age = 21        
        ld5.EasyId__c = '123414';
        ld5.Ref_Account__c = cl5.Id;
        ld5.CatalogOrderDate__c = Date.newInstance(2014, 02, 02);
        ld5.AgentCd__c = '000001';
        insert ld5;
        
        Account cl6 = new Account();
        cl6.EasyId__c = '123414';
        cl6.Birthdate_BD2M__c = Date.newInstance(1998, 02, 02);//Age = 19  
        cl6.LastName='TEST';      
        cl6.DoNotSend_BD2M__c=false;
        cl6.SentCount_BD2M__c=1;
        insert cl6;
        
        SeihoLead__c ld6 = new SeihoLead__c();
        ld6.BirthDate__c =  cl6.PersonBirthDate;
        ld6.LastName__c = 'BDM2Test5';
        ld6.Company__c = 'Rakuraku1';
        ld6.BirthDate__c = Date.newInstance(1998, 02, 02);//Age = 19        
        ld6.EasyId__c = '123414';
        ld6.Ref_Account__c = cl6.Id;
        ld6.CatalogOrderDate__c =  Date.newInstance(2015, 02, 02);
        ld6.AgentCd__c = '000001';
        insert ld6;
        
        Account cl7 = new Account();
        cl7.EasyId__c = '12341465';
        cl7.PersonBirthDate = Date.newInstance(1942, 02, 02);//Age = 75        
        cl7.LastName='TEST';
        cl7.DoNotSend_BD2M__c=false;
        cl7.SentCount_BD2M__c=1;
        insert cl7;
        
        SeihoLead__c ld7 = new SeihoLead__c();
        ld7.EasyId__c = '12341465';
        ld7.BirthDate__c =  cl7.PersonBirthDate;
        ld7.LastName__c = 'BDM2Test512';
        ld7.Company__c = 'Rakuraku112';
        ld7.BirthDate__c = Date.newInstance(1942, 02, 02);//Age = 75                
        ld7.Ref_Account__c = cl7.Id;
        ld7.CatalogOrderDate__c = Date.newInstance(2014, 02, 02);
        ld7.AgentCd__c = '000001';
        insert ld7;
        
        Account cl8 = new Account();
        cl8.EasyId__c = '123414';
        cl8.PersonBirthDate = Date.newInstance(2016, 07, 02);//Age = 1       
        cl8.LastName='TEST'; 
        cl8.DoNotSend_BD2M__c=false;
        cl8.SentCount_BD2M__c=1;
        insert cl8;
        
        SeihoLead__c ld8 = new SeihoLead__c();
        ld8.BirthDate__c =  cl8.PersonBirthDate;
        ld8.LastName__c = 'BDM2Test5';
        ld8.Company__c = 'Rakuraku1';
        ld8.BirthDate__c = Date.newInstance(2016, 07, 02);//Age = 1        
        ld8.EasyId__c = '123414';
        ld8.Ref_Account__c = cl8.Id;
        ld8.CatalogOrderDate__c = Date.newInstance(2016, 07, 02);
        ld8.AgentCd__c = '000001';
        insert ld8;
        
        Account cl9 = new Account();
        cl9.EasyId__c = '123414';
        cl9.PersonBirthDate = Date.newInstance(1987, 05, 05);//Age = 30    
        cl9.LastName='TEST';  
        cl9.DoNotSend_BD2M__c=false;
        cl9.SentCount_BD2M__c=1;
        insert cl9;
        
        SeihoLead__c ld9 = new SeihoLead__c();
        ld9.BirthDate__c =  cl9.PersonBirthDate;
        ld9.LastName__c = 'BDM2Test4';
        ld9.Company__c = 'Rakuraku1';
        ld9.BirthDate__c = Date.newInstance(1987, 05, 05);//Age = 30       
        ld9.EasyId__c = '123414';
        ld9.Ref_Account__c = cl9.Id;
        ld9.CatalogOrderDate__c = Date.newInstance(2014, 05, 05);
        ld9.AgentCd__c = '000001';
        insert ld9;
        
        // Birthday range - 2017-02-02 to 2017-03-01
        // Run date - 2016/12/15        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt =  Date.newInstance(2016, 12, 15);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Date ShipmentDate = Date.newInstance(dt.year(), dt.month(), BirthdayDM_Shipment_Day);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m);
        
        test.stopTest();
        
        cl1 = [Select Birthdate_BD2M__c from Account where Id =: cl1.Id];        
        System.assertEquals(null, cl1.Birthdate_BD2M__c);//Age- 85  1932/feb/02
        
        cl2 = [Select Birthdate_BD2M__c from Account where Id =: cl2.Id];       
        System.assertEquals(ld2.BirthDate__c,cl2.Birthdate_BD2M__c);//Age- 84  1933/Feb/02
        
        cl3 = [Select Birthdate_BD2M__c from Account where Id =: cl3.Id];          
        System.assertEquals(null, cl3.Birthdate_BD2M__c);//Age- 86  1931/july/02
        
        cl4 = [Select Birthdate_BD2M__c from Account where Id =: cl4.Id];//Age- 20   1997/Feb/02
        System.assertEquals(ld4.BirthDate__c, cl4.Birthdate_BD2M__c);
        
        cl5 = [Select Birthdate_BD2M__c from Account where Id =: cl5.Id];//Age- 21   1996/Feb/02
        System.assertEquals(ld5.BirthDate__c, cl5.Birthdate_BD2M__c);
        
        cl6 = [Select Birthdate_BD2M__c from Account where Id =: cl6.Id];//Age- 19   1998/Feb/02 
        System.assertEquals(ld6.BirthDate__c, cl6.Birthdate_BD2M__c);
        
        cl7 = [Select Birthdate_BD2M__c from Account where Id =: cl7.Id];//Age- 75   1942/Feb/02
        System.assertEquals(ld7.BirthDate__c, cl7.Birthdate_BD2M__c);
        
        cl8 = [Select Birthdate_BD2M__c from Account where Id =: cl8.Id];//Age- 1    2016/july/02
        System.assertEquals(null, cl8.Birthdate_BD2M__c); 
        
        cl9 = [Select Birthdate_BD2M__c from Account where Id =: cl9.Id];//Age- 30   1987/May/05 (Day out of range)
        System.assertEquals(null, cl9.Birthdate_BD2M__c);
    }

    static testMethod void DMHistory()
    {
        test.startTest();
        
        Account c3 = new Account();
        c3.EasyId__c = '121416';
        c3.LastName = 'BDM';
        c3.FirstName = '郎';
        c3.State_BD2M__c = '山梨県';
        c3.Apart_BD2M__c = '4343';
        c3.PostalCode_BD2M__c = '140-4343';
        c3.City_BD2M__c = 'Shibuya';
        c3.Gender_BD2M__c = '男性';
        c3.PersonBirthdate = Date.today().addYears(-50).addDays(63);
        c3.SentCount_BD2M__c=1;
        c3.DoNotSend_BD2M__c=false;
        insert c3;
        
        SeihoInboundLead__c inboundLead1 = new SeihoInboundLead__c();
        inboundLead1.AccountId__c = c3.Id;
        inboundLead1.DestState__c = '山梨県';
        inboundLead1.DestPhone__c = '12341234122';
        inboundLead1.Phone__c = '12341234123';
        inboundLead1.DestPostalCode__c = '0909090';
        inboundLead1.DestCity__c = 'Shibuya';
        inboundLead1.DestApart__c = '4343';
        inboundLead1.InterestedProds01__c = True;
        inboundLead1.IsShippingExcluded__c = False;
        inboundLead1.CatalogOrderDate__c = Date.today().addYears(-1);
        inboundLead1.AgentCd__c = '000001';
        inboundLead1.Path1__c = 'ＴＶ';
        inboundLead1.DestFirstName__c = 'TestDestFirstName';
        inboundLead1.DestLastName__c = 'TestDestLastName';        
        insert inboundLead1;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(),batchRunDay);
        Date ShipmentDate = Date.newInstance(dt.year(), dt.month(), BirthdayDM_Shipment_Day);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m); 
        
        test.stopTest();
      
        inboundLead1 = [select  Account_LastName__c, Account_FirstName__c, Account_State__c, Account_City__c, 
                        Account_Apart__c, Account_Gender__c, Account_BirthDate__c 
                        from SeihoInboundLead__c where Id =: inboundLead1.Id];
        DMHistory__c dmh1 = [select Id, DMClass__c,DMShipmentDate__c, LastName__c, FirstName__c, State__c, City__c, Apart__c, 
                                Gender__c, Birthdate__c, Path__c, BirthdayLateLastMonth__c, AgeCalculationReferenceDate__c,
                                MiniOpportunitiesID__c,SeihoOpportunityID__c,SeihoLeadID__c,SeihoInboundLeadID__c 
                                from DMHistory__c where AccountId__c =: c3.Id];
        system.assertEquals('ＢＤ２Ｍ', dmh1.DMClass__c);
        system.assertEquals(ShipmentDate, dmh1.DMShipmentDate__c);
        system.assertEquals(inboundLead1.Account_LastName__c, dmh1.LastName__c);
        system.assertEquals(inboundLead1.Account_FirstName__c, dmh1.FirstName__c);        
        system.assertEquals(inboundLead1.Account_State__c, dmh1.State__c);
        system.assertEquals(inboundLead1.Account_City__c, dmh1.City__c);
        system.assertEquals(inboundLead1.Account_Apart__c, dmh1.Apart__c);
        system.assertEquals(inboundLead1.Account_Gender__c, dmh1.Gender__c);
        Date Account_BirthDate = null;
        if(String.isNotBlank(inboundLead1.Account_BirthDate__c))
            Account_BirthDate = Date.Parse(inboundLead1.Account_BirthDate__c.replaceAll('-','/'));
        system.assertEquals(Account_BirthDate, dmh1.Birthdate__c);
        System.assertEquals('２', dmh1.Path__c);        
        System.assertEquals(inboundLead1.Id, dmh1.SeihoInboundLeadID__c);
        System.assertEquals(null, dmh1.SeihoLeadID__c);

    }

    static testMethod void active_object_linked_to_the_Accountlist() 
    {
        test.startTest();
        Account cl = new Account();
        cl.EasyId__c = '123414';
        cl.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl.DoNotSend_BD2M__c=false;
        cl.SentCount_BD2M__c=1;
        cl.LastName = 'BDM';
        insert cl;
        
        MiniInsurance__c mOpp = new MiniInsurance__c();
        mOpp.last_name__c = 'BDM';
        mOpp.first_name__c = 'Test1';
        mOpp.gender__c = '男性';
        mOpp.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp.address1__c = 'Tokyo';
        mOpp.address2__c = 'Shibuyo 3-4-5';
        mOpp.postal_code__c = '140-0004';
        mOpp.easy_id__c = '123414';
        mOpp.AccountId__c = cl.Id;
        mOpp.expiry_date__c = Date.today().addMonths(-5);
        insert mOpp;
        
        MiniInsurance__c mOpp2 = new MiniInsurance__c();
        mOpp2.last_name__c = 'BDM';
        mOpp2.first_name__c = 'Test2';
        mOpp2.gender__c = '男性';
        mOpp2.birthdate__c = Date.today().addYears(-50).addDays(60);
        mOpp2.address1__c = 'Tokyo';
        mOpp2.address2__c = 'Shibuyo 3-4-5';
        mOpp2.postal_code__c = '140-0004';
        mOpp2.easy_id__c = '123414';
        mOpp2.AccountId__c = cl.Id;
        mOpp2.expiry_date__c = Date.today().addMonths(1);
        insert mOpp2;
        
        SeihoOpportunity__c op = new SeihoOpportunity__c();
        op.Name = 'BDMTest3';
        op.StageName__c = '評価';
        op.CloseDate__c = Date.today();
        op.LastName__c = 'BDM';
        op.FirstName__c = 'Test';
        op.Gender__c = '男性';
        op.Birthdate__c = Date.today().addYears(-50).addDays(60);
        op.address1__c = 'Tokyo';
        op.address2__c = 'Shibuya';
        op.address3__c = '3-4-5';
        op.PostalCode__c = '140-0004';
        op.Ref_Account__c = cl.id;
        insert op;
        
        SeihoLead__c ld = new SeihoLead__c();
        ld.LastName__c = 'BDM2';
        ld.FirstName__c = 'Test4';
        ld.Company__c = 'Rakuraku1';
        ld.Gender__c = '男性';
        ld.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld.Street__c = '3-4-6';
        ld.City__c = 'Shibuyi';
        ld.State__c = 'Tokya';
        ld.PostalCode__c = '140-4346';
        ld.EasyId__c = '123414';
        ld.Ref_Account__c = cl.Id;
        ld.CatalogOrderDate__c = Date.today().addMonths(2);
        ld.AgentCd__c = '000001';
        insert ld;
        
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM2';
        ld2.FirstName__c = 'Test5';
        ld2.Company__c = 'Rakuraku1';
        ld2.Gender__c = '男性';
        ld2.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld2.Street__c = '3-4-6';
        ld2.City__c = 'Shibuyi';
        ld2.State__c = 'Tokya';
        ld2.PostalCode__c = '140-4346';
        ld2.EasyId__c = '123414';
        ld2.Ref_Account__c = cl.Id;
        ld2.CatalogOrderDate__c = Date.today().addMonths(1);
        ld2.AgentCd__c = '000001';
        insert ld2;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today();
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m,1);
        
        test.stopTest();
        
        cl = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl.Id];
        System.assertEquals(null, cl.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl.OpportunityID_BD2M__c);
        System.assertEquals(null, cl.LeadID_BD2M__c);
        System.assertEquals(null, cl.LastName_BD2M__c);
        System.assertEquals(null, cl.FirstName_BD2M__c);
        System.assertEquals(null, cl.State_BD2M__c);
        System.assertEquals(null, cl.City_BD2M__c);
        System.assertEquals(null, cl.Apart_BD2M__c);
        System.assertEquals(null, cl.PostalCode_BD2M__c);
        System.assertEquals(null, cl.Gender_BD2M__c);
        System.assertEquals(null, cl.Birthdate_BD2M__c);
        Date shipmentDate = Date.newInstance(DM2_RunDateManual.year(), DM2_RunDateManual.month(), BirthdayDM_Shipment_Day);
        System.assertEquals(null, cl.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl.Path_BD2M__c);
        System.assertEquals(null, cl.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl.AgeCalculationReferenceDate_BD2M__c);
    }
    

    static testMethod void scheduler()
    {
        test.startTest();
        
        Integer batchRunDay = 15 - DM_PreparationDays;
        
        Datetime datetimeNow = datetime.newInstance(date.newInstance(date.today().year(), date.today().month(), batchRunDay), time.newInstance(07, 30, 00, 00));
        Datetime datetimeAfter = datetimeNow.addMonths(1);
        String schMinute = datetimeNow.format('mm');
        
        String sch = '00 30 07 ' + batchRunDay + ' * ?';
        //String sch = '0 ' + schMinute + ' * * * ?';
        String jobId = System.schedule('Test_Batch2DM_Accountlist_Nacl_OppMoppLead', sch, new Batch2DM_Accountlist_Nacl_OppMoppLead(date.newInstance(2020,05,15), deadline));
        
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
     
    static testMethod void Skip_Invalid_Lead()
    {
        test.startTest();
        
        Account cl1 = new Account();
        cl1.EasyId__c = '123414';
        cl1.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl1.DoNotSend_BD2M__c=false;
        cl1.SentCount_BD2M__c=1;
        cl1.LastName = 'BDM';
        insert cl1;
        
        //Invalid CatalogOrderDate__c less than 9 months 
        SeihoLead__c ld1 = new SeihoLead__c();
        ld1.LastName__c = 'BDM';
        ld1.FirstName__c = 'Test';
        ld1.Company__c = 'Rakuraku';
        ld1.Gender__c = '男性';
        ld1.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld1.Street__c = '3-4-5';
        ld1.Apart__c = '4343';
        ld1.City__c = 'Shibuya';
        ld1.State__c = 'Tokyo';
        ld1.PostalCode__c = '140-4343';
        ld1.EasyId__c = '123414';
        ld1.Ref_Account__c = cl1.Id;
        ld1.CatalogOrderDate__c = Date.today().addMonths(6); 
        ld1.AgentCd__c = '000001';       
        insert ld1;         
        
        Account cl2 = new Account();
        cl2.EasyId__c = '123415';
        cl2.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl2.DoNotSend_BD2M__c=false;
        cl2.SentCount_BD2M__c=1;
        cl2.LastName = 'BDM';
        insert cl2;
        
        //Invalid birthday Jan/1
        SeihoLead__c ld2 = new SeihoLead__c();
        ld2.LastName__c = 'BDM';
        ld2.FirstName__c = 'Test';
        ld2.Company__c = 'Rakuraku';
        ld2.Gender__c = '男性';
        ld2.BirthDate__c = date.newinstance(Date.today().addYears(-50).year(), 1, 1);
        ld2.Street__c = '3-4-5';
        ld2.Apart__c = '4343';
        ld2.City__c = 'Shibuya';
        ld2.State__c = 'Tokyo';
        ld2.PostalCode__c = '140-4343';
        ld2.EasyId__c = '123415';
        ld2.Ref_Account__c = cl2.Id;
        ld2.CatalogOrderDate__c = Date.today().addYears(-1); 
        ld2.AgentCd__c = '000001';       
        insert ld2;     
        
        Account cl3 = new Account();
        cl3.EasyId__c = '123416';
        cl3.PersonBirthDate = Date.today().addYears(-50).addDays(60);
        cl3.DoNotSend_BD2M__c=false;
        cl3.SentCount_BD2M__c=1;
        cl3.LastName = 'BDM';
        insert cl3;
        
        //Invalid Agent code
        SeihoLead__c ld3 = new SeihoLead__c();
        ld3.LastName__c = 'BDM';
        ld3.FirstName__c = 'Test';
        ld3.Company__c = 'Rakuraku';
        ld3.Gender__c = '男性';
        ld3.BirthDate__c = Date.today().addYears(-50).addDays(60);
        ld3.Street__c = '3-4-5';
        ld3.Apart__c = '4343';
        ld3.City__c = 'Shibuya';
        ld3.State__c = 'Tokyo';
        ld3.PostalCode__c = '140-4343';
        ld3.EasyId__c = '123416';
        ld3.Ref_Account__c = cl3.Id;
        ld3.CatalogOrderDate__c = Date.today();
        ld3.AgentCd__c = '000002';
        insert ld3;
        
        Integer batchRunDay = BirthdayDM_Shipment_Day - DM_PreparationDays;
        Date dt = date.today().addYears(1);
        Date DM2_RunDateManual = Date.newInstance(dt.year(), dt.month(), batchRunDay);
        Date ShipmentDate = Date.newInstance(dt.year(), dt.month(), BirthdayDM_Shipment_Day);
        Batch2DM_Accountlist_Nacl_OppMoppLead bd2m = new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDateManual, deadline);
        ID bPId = Database.executeBatch(bd2m); 
        
        test.stopTest();
        
        cl1 = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl1.Id];
        System.assertEquals(null, cl1.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl1.OpportunityID_BD2M__c);
        System.assertEquals(null, cl1.LeadID_BD2M__c);
        System.assertEquals(null, cl1.LastName_BD2M__c);
        System.assertEquals(null, cl1.FirstName_BD2M__c);
        System.assertEquals(null, cl1.State_BD2M__c);
        System.assertEquals(null, cl1.City_BD2M__c);
        System.assertEquals(null, cl1.Apart_BD2M__c);
        System.assertEquals(null, cl1.PostalCode_BD2M__c);
        System.assertEquals(null, cl1.Gender_BD2M__c);
        System.assertEquals(null, cl1.Birthdate_BD2M__c);        
        System.assertEquals(null, cl1.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl1.Path_BD2M__c);
        System.assertEquals(null, cl1.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl1.AgeCalculationReferenceDate_BD2M__c);
        
        cl2 = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl2.Id];
        System.assertEquals(null, cl2.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl2.OpportunityID_BD2M__c);
        System.assertEquals(null, cl2.LeadID_BD2M__c);
        System.assertEquals(null, cl2.LastName_BD2M__c);
        System.assertEquals(null, cl2.FirstName_BD2M__c);
        System.assertEquals(null, cl2.State_BD2M__c);
        System.assertEquals(null, cl2.City_BD2M__c);
        System.assertEquals(null, cl2.Apart_BD2M__c);
        System.assertEquals(null, cl2.PostalCode_BD2M__c);
        System.assertEquals(null, cl2.Gender_BD2M__c);
        System.assertEquals(null, cl2.Birthdate_BD2M__c);        
        System.assertEquals(null, cl2.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl2.Path_BD2M__c);
        System.assertEquals(null, cl2.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl2.AgeCalculationReferenceDate_BD2M__c);
        
        cl3 = [select LastName_BD2M__c, FirstName_BD2M__c, PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, 
                Birthdate_BD2M__c, DMShipmentDate_BD2M__c, Path_BD2M__c, BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c, 
                MiniOpportunitiesID_BD2M__c, OpportunityID_BD2M__c, LeadID_BD2M__c 
                from Account where Id =: cl3.Id];
        System.assertEquals(null, cl3.MiniOpportunitiesID_BD2M__c);
        System.assertEquals(null, cl3.OpportunityID_BD2M__c);
        System.assertEquals(null, cl3.LeadID_BD2M__c);
        System.assertEquals(null, cl3.LastName_BD2M__c);
        System.assertEquals(null, cl3.FirstName_BD2M__c);
        System.assertEquals(null, cl3.State_BD2M__c);
        System.assertEquals(null, cl3.City_BD2M__c);
        System.assertEquals(null, cl3.Apart_BD2M__c);
        System.assertEquals(null, cl3.PostalCode_BD2M__c);
        System.assertEquals(null, cl3.Gender_BD2M__c);
        System.assertEquals(null, cl3.Birthdate_BD2M__c);        
        System.assertEquals(null, cl3.DMShipmentDate_BD2M__c);
        System.assertEquals(null, cl3.Path_BD2M__c);
        System.assertEquals(null, cl3.BirthdayLateLastMonth_BD2M__c);
        System.assertEquals(null, cl3.AgeCalculationReferenceDate_BD2M__c);     
    } 
}