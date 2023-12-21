@isTest
public class Test_AccountListHelper {
    static testmethod void convertPostalCode()
     {     
            
            Account cl1 = new Account();
            cl1.PostalCode_BD2M__c ='010-025';
            cl1.LastName = 'TestSRM10';    
        insert cl1;
         AccountListHelper.convertPostalCode(cl1.PostalCode_BD2M__c);
    
     }
    static testmethod void getPhoneNumber()
     {     
           
            Account cl1 = new Account();
            cl1.Phone = '080-0000-0000'; 
            cl1.LastName = 'TestSRM10';        
         insert cl1;
         AccountListHelper.getPhoneNumber(cl1.Phone);
    
     }
	
    static testmethod void getLatestModifiedObject()
    {
       Date ShipmentDate=Date.newInstance(2018, 01, 15);
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'ﾘﾘﾖﾘﾛ02';     
            cl1.firstname__pc = 'ｷｼｿｷｼｿ02';
            cl1.LastName__pc = 'ﾖｷﾖﾘ02';
            cl1.Gender__pc = '男性';  
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '0738110302';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
            cl1.Birthdate_BD2M__c =Date.newInstance(1965, 09, 09);       
        insert cl1;


        MiniInsurance__c mOpp = new MiniInsurance__c();
        String label  = 'b2dmexcludeminiopp';
            mOpp.last_name__c = 'ﾖｷﾖﾘ02';
            mOpp.first_name__c = 'ｷｼｿｷｼｿ02';
            mOpp.gender__c = '男性';
            mOpp.birthdate__c =  Date.newInstance(1965, 09, 09);
            mOpp.address1__c = 'Tokyo';
            mOpp.address2__c = 'Shibuya 3-4-5';
            mOpp.postal_code__c = '140-0004';
            mOpp.easy_id__c = '0738110302';
            //mOpp.expiry_date__c = Date.newInstance(2018, 10, 15); 
            mOpp.entry_status__c = '契約満了';
            //mOpp.entry_status__c = '';
            mOpp.AccountId__c=cl1.Id;
            mOpp.dm_flg__c=false;
        insert mOpp; 
        
         AccountListHelper.getLatestModifiedObject(ShipmentDate,cl1.Id,cl1.Birthdate_BD2M__c);
    
    }
     static testmethod void getLatestModifiedObject1()
    {  
        Date ShipmentDate=Date.newInstance(2018, 01, 15);
        Date OppSpecialUpdateTime=Date.newInstance(2016, 03,01);
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'ﾘﾘﾖﾘﾛ02';     
            cl1.firstname__pc = 'ｷｼｿｷｼｿ02';
            cl1.LastName__pc = 'ﾖｷﾖﾘ02';
            cl1.Gender__pc = '男性';  
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '0738110302';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
			cl1.Birthdate_BD2M__c =Date.newInstance(1965, 09, 09); 
                   
        insert cl1;

        SeihoOpportunity__c opp =new SeihoOpportunity__c();
            opp.Name='OpsTestAcntId';
            opp.CloseDate__c=Date.newInstance(2018, 10, 06);
            opp.StageName__c='評価';
            opp.EasyId__c='0738110303';
            opp.LastName__c='ﾖｷﾖﾘ03';
            opp.FirstName__c='ｷｼｿｷｼｿ03';
            opp.Phone__c='789654123';
            opp.MobilePhone__c='080789654';
            opp.Birthdate__c=Date.newInstance(1965, 09, 09); 
            opp.Gender__c='男性';
            opp.AgentCd__c='000001';
            opp.ApplySts__c='顧客情報入力済';
            opp.Ref_Account__c=cl1.Id;
            opp.WebLastSyncTime__c=Date.newInstance(2010, 09, 09); 
        insert opp;
        
         AccountListHelper.getLatestModifiedObject(ShipmentDate,cl1.Id,cl1.Birthdate_BD2M__c);
    }
    static testmethod void getLatestModifiedObject2()
    {
        Date ShipmentDate=Date.newInstance(2018, 01, 15);
       Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'ﾘﾘﾖﾘﾛ02';     
            cl1.firstname__pc = 'ｷｼｿｷｼｿ02';
            cl1.LastName__pc = 'ﾖｷﾖﾘ02';
            cl1.Gender__pc = '男性';  
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '0738110302';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
			cl1.Birthdate_BD2M__c =Date.newInstance(1965, 09, 09); 
                   
        insert cl1;

        SeihoInboundLead__c inboundLead1 = new SeihoInboundLead__c();
        inboundLead1.LastName__c = 'ﾖｷﾖﾘ03';
        inboundLead1.FirstName__c = 'ｷｼｿｷｼｿ03';
        inboundLead1.State__c = '山梨県';
        inboundLead1.Apart__c = '4343';
        inboundLead1.PostalCode__c = '140-4343';
        inboundLead1.City__c = 'Shibuya';
        inboundLead1.BirthDate__c =  Date.today().addYears(-50).addDays(63);
        inboundLead1.Gender__c = '男性';
        inboundLead1.AccountId__c = cl1.Id;
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
        
         AccountListHelper.getLatestModifiedObject(ShipmentDate,cl1.Id,cl1.Birthdate_BD2M__c);
    
    }
    static testmethod void getLatestModifiedObject3()
    {  
        Date ShipmentDate=Date.newInstance(2018, 01, 15);
        Date OppSpecialUpdateTime=Date.newInstance(2016, 03,01);
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'ﾘﾘﾖﾘﾛ02';     
            cl1.firstname__pc = 'ｷｼｿｷｼｿ02';
            cl1.LastName__pc = 'ﾖｷﾖﾘ02';
            cl1.Gender__pc = '男性';  
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '0738110302';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
            cl1.Birthdate_BD2M__c =Date.newInstance(1965, 09, 09); 
                   
        insert cl1;

        SeihoLead__c lead =new SeihoLead__c();
            lead.Name='OpsTestAcntId';
            lead.EasyId__c='0738110303';
            lead.LastName__c='ﾖｷﾖﾘ03';
            lead.FirstName__c='ｷｼｿｷｼｿ03';
            lead.Phone__c='789654123';
            lead.MobilePhone__c='080789654';
            lead.Birthdate__c=Date.newInstance(1965, 09, 09); 
            lead.Gender__c='男性';
            lead.AgentCd__c='000001';
            lead.Ref_Account__c=cl1.Id;
        insert lead;
        
         AccountListHelper.getLatestModifiedObject(ShipmentDate,cl1.Id,cl1.Birthdate_BD2M__c);
    }
    
    static testmethod void existValidFields1()
    {
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'TEST';     
            cl1.firstname__pc = '01';
            cl1.LastName__pc = 'SRM';
            cl1.Gender__pc = '男性'; 
            cl1.Phone='8909087890';
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
			
                   insert cl1;
        string homephone='';
        string Name='TEST';
        AccountListHelper.existValidFields(Name,cl1.FirstName,cl1.firstname__pc,cl1.LastName__pc, cl1.Phone,homephone,cl1.PersonBirthdate,cl1.EasyId__c,cl1.Gender__pc );
    }
    static testmethod void existValidFields3()
    {
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = 'SRM';     
            cl1.firstname__pc = '01';
            cl1.LastName__pc = '';
            cl1.Gender__pc = ''; 
            cl1.Phone='';
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '';
            cl1.PersonBirthdate = null; 
			
                   insert cl1;
        string homephone='';
        string Name='';
        AccountListHelper.existValidFields(Name,cl1.FirstName,cl1.firstname__pc,cl1.LastName__pc, cl1.Phone,homephone,cl1.PersonBirthdate,cl1.EasyId__c,cl1.Gender__pc );
    }
    static testmethod void existValidFields2()
    {
        Account cl1 = new Account();
            cl1.LastName = 'ﾖﾖｷｼｿ02';
            cl1.FirstName = '';     
            cl1.firstname__pc = '';
            cl1.LastName__pc = '';
            cl1.Gender__pc = ''; 
            cl1.Phone='';
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '';
            cl1.PersonBirthdate = null; 
			
                   insert cl1;
        string homephone='';
        string Name='';
        AccountListHelper.existValidFields(Name,cl1.FirstName,cl1.firstname__pc,cl1.LastName__pc, cl1.Phone,homephone,cl1.PersonBirthdate,cl1.EasyId__c,cl1.Gender__pc );
    }
    static testmethod void existNameAndPhone3()
    {
        Account cl1 = new Account();
            cl1.LastName = 'TEST';
            cl1.FirstName = 'SRM';     
            cl1.firstname__pc = 'TEST';
            cl1.LastName__pc = '01';
            cl1.Gender__pc = '男性'; 
            cl1.Phone='';
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
			
               insert cl1;
        string homephone='';
        string name='TEST';
        boolean bacc=AccountListHelper.existNameAndPhone(Name,cl1.FirstName,cl1.firstname__pc,cl1.LastName__pc, cl1.Phone,homephone);
        system.assertEquals(false, bacc);
       
    }
    static testmethod void existNameAndPhone4()
    {
        Account cl1 = new Account();
            cl1.LastName = 'TEST';
            cl1.FirstName = '';     
            cl1.firstname__pc = '';
            cl1.LastName__pc = '';
            cl1.Gender__pc = '男性'; 
            cl1.Phone='265315978';
            cl1.DoNotSend_BD2M__c = False;
            cl1.EasyId__c = '';
            cl1.PersonBirthdate =   Date.newInstance(1965, 09, 09); 
			
               insert cl1;
        string homephone='596482152';
        string name='';
        
        boolean bacc=AccountListHelper.existNameAndPhone(Name,cl1.FirstName,cl1.firstname__pc,cl1.LastName__pc, cl1.Phone,homephone);
    system.assertEquals(false, bacc);
    }
    }