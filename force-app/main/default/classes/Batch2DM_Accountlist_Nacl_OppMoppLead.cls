global class Batch2DM_Accountlist_Nacl_OppMoppLead implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    //Common variables accessible throughout the batch
    global String errorLog;
    global String warningLog;
    global Date DM2_runDate;
    global Integer monthFrom;
    global Integer monthTo;
    global Integer monthFromResetDoNotSend_BD2M;
    global Integer monthToResetDoNotSend_BD2M;
    global Datetime deadline;
    global Integer BirthdayDM_CL_From_Day;
    global Integer BirthdayDM_CL_To_Day;
    global Integer BirthdayDM_CL_From_Age;
    global Integer BirthdayDM_CL_To_Age;
    
    
    global void execute(SchedulableContext SC) 
    {
        try
        {
            String apexBatchName = 'Batch2DM_Accountlist_Nacl_OppMoppLead';
            
            Date DM2_RunDate = Date.today();
            Datetime dt = Datetime.now();
            
            Datetime deadline = dt.addMinutes(30);
            Integer chunkSize = Integer.valueOf(10);
            
            Database.executeBatch(new Batch2DM_Accountlist_Nacl_OppMoppLead(DM2_RunDate, deadline), chunkSize);
        }
        catch(Exception ex)
        {
            SendErrorMailClass.sendErrorMailAccountList(
                                                    '[Salesforce][Rakuten Life Insurance][Error] Schedule2DM_Accountlist_Nacl_OppMoppLead Failed', 
                                                    ex.getMessage() + ' at ' + ex.getLineNumber() ,'error');
        }
    }
    
    
    global Batch2DM_Accountlist_Nacl_OppMoppLead(){
    }
    
    
    global Batch2DM_Accountlist_Nacl_OppMoppLead(Date DM2_runDate,Datetime deadline)
    {
        this.DM2_runDate = DM2_runDate; //This is the batch running date to prepare AccountList BD2M data
        this.errorLog = '';
        this.warningLog = '';
        monthFrom = DM2_runDate.addMonths(2).month(); //'from' range to select 取引先 records
        monthTo = DM2_runDate.addMonths(3).month(); //'to' range to select 取引先 records
        monthFromResetDoNotSend_BD2M = DM2_runDate.addMonths(-4).month(); //'from' range to select 取引先 records to reset DoNotSend_BD2M flag
        monthToResetDoNotSend_BD2M = DM2_runDate.addMonths(-3).month(); //'to' range to select 取引先 records to reset DoNotSend_BD2M flag
        this.deadline = deadline;
        BirthdayDM_CL_From_Day = Integer.valueOf(System.Label.BirthdayDM_CL_From_Day); //Day to filter 取引先 from
        BirthdayDM_CL_To_Day = Integer.valueOf(System.Label.BirthdayDM_CL_To_Day);//Day to filter 取引先 to
        BirthdayDM_CL_From_Age = Integer.valueOf(System.Label.BirthdayDM_CL_From_Age);
        BirthdayDM_CL_To_Age = Integer.valueOf(System.Label.BirthdayDM_CL_To_Age);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        try
        {
            //This field is updated whenever related object's birthdate is updated and is different from this field. Related objects are (Opportunities, Leads and MiniOpportunities)
            //Query to fetch 取引先 with UpdatedBirthdate lies between (monthFrom and monthTo) also DM sent before two months is less than 2.
            // NOTE: Field removed from Query as not available are as below,
            // DoNotSend_BD2M__c, UpdatedBirthdate__c = PersonBirthdate
            // Calling__c.UpdatedBirthdate__c is same as Account.PersonBirthDate in NewCRM SFDC
            // 生命SFDCでは架電の生年月日は資料請求や申込によって更新されないので
            // バースデイDMバッチではUpdateBirthdate__cを使用している
            // 統合CRMで取引先は関連先がInsert/Updateされると
            // 生年月日が更新されるので生年月日を使います。
            // **************************************************//
            String query = 'Select Id, LastName_BD2M__c, FirstName_BD2M__c,PersonBirthDate,' +
                            'PostalCode_BD2M__c, State_BD2M__c, City_BD2M__c, Apart_BD2M__c, Gender_BD2M__c, Birthdate_BD2M__c, ' +
                            'DMShipmentDate_BD2M__c,DoNotSend_BD2M__c,SentCount_BD2M__c,HanshaJudgement__c, Path_BD2M__c, ' +
                            'BirthdayLateLastMonth_BD2M__c, AgeCalculationReferenceDate_BD2M__c from Account ' +
                            'where (CALENDAR_MONTH(PersonBirthdate) = ' + monthFrom + 
                            ' or CALENDAR_MONTH(PersonBirthdate) = ' + monthTo + 
                            ' or CALENDAR_MONTH(PersonBirthdate) = ' + monthFromResetDoNotSend_BD2M + 
                            ' or CALENDAR_MONTH(PersonBirthdate) = ' + monthToResetDoNotSend_BD2M + 
                            ' )' + 
                            ' and StopDMFlg__c = FALSE' + 
                            ' and SentCount_BD2M__c < 2';// + 
                            //' and HanshaJudgement__c NOT IN (\'反社確定\', \'疑いあり\')';
            return Database.getQueryLocator(query);
        }
        catch(Exception ex)
        {
            errorLog += ex.getMessage() + ' at ' + ex.getLineNumber() + '\n';
            String fallbackQuery = 'Select Id from Account limit 0'; //Fallback query in case main query fails. To avoid errors.
            return Database.getQueryLocator(fallbackQuery);
        }
    }
    
    
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        List<Account> accountlistsToBeUpdated = new List<Account>(); //List of 取引先 used to reduce SOQL operations
        for(sObject s : scope)
        {
            Account acc = (Account) s;
            try
            {
                Boolean accountlistUpdate = false;
                //Code to copy data from related objects to 取引先 
                Integer baseYear = null;
                Integer DM2_runDateYear = DM2_runDate.year();
                if(DM2_runDate.month() == 10)
                {
                    if(acc.PersonBirthdate.month() == 12)
                    {
                        baseYear = DM2_runDateYear;
                    }
                    else
                    {
                        baseYear = DM2_runDateYear + 1;
                    }
                }
                else if(DM2_runDate.month() < 10)
                {
                    baseYear = DM2_runDateYear;
                }
                else
                {
                    baseYear = DM2_runDateYear + 1;
                }
                
                Date ageCalculationBase = Date.newInstance(baseYear, acc.PersonBirthdate.month(), acc.PersonBirthdate.day());
                
                if (acc.PersonBirthdate.addYears(BirthdayDM_CL_From_Age) <= ageCalculationBase && 
                    acc.PersonBirthdate.addYears(BirthdayDM_CL_To_Age) > ageCalculationBase)
                {
                    if (acc.DoNotSend_BD2M__c && 
                        ((acc.PersonBirthdate.day() >= BirthdayDM_CL_From_Day && 
                          acc.PersonBirthdate.month() == monthFromResetDoNotSend_BD2M) || 
                         (acc.PersonBirthdate.day() <= BirthdayDM_CL_To_Day && 
                         acc.PersonBirthdate.month() == monthToResetDoNotSend_BD2M)))
                    {
                        //reset the DoNotSend_BD2M flag
                        acc.DoNotSend_BD2M__c = False;
                        accountlistUpdate = True;
                    }
                    else if(!acc.DoNotSend_BD2M__c && 
                            ((acc.PersonBirthdate.day() >= BirthdayDM_CL_From_Day && 
                              acc.PersonBirthdate.month() == monthFrom) || 
                             (acc.PersonBirthdate.day() <= BirthdayDM_CL_To_Day && 
                              acc.PersonBirthdate.month() == monthTo)))
                    {
                         //Read value of System label in order to avoid code changes if 発送日 changes
                        Integer BirthdayDM_Shipment_Day = Integer.valueOf(System.Label.BirthdayDM_Shipment_Day);
                        Date shipmentDate = Date.newInstance(DM2_runDate.year(), DM2_runDate.month(), BirthdayDM_Shipment_Day); //calculate 発送日
                        SObject latestModifiedObject = AccountListHelper.getLatestModifiedObject(shipmentDate, acc.Id, acc.PersonBirthdate);
                        if(latestModifiedObject != null) //Some valid object is linked with the 取引先 from which data has to be copied
                        {
                            Date AgeCalculationReferenceDate = shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(1);
                            Date BirthdayLateLastMonth = shipmentDate.addDays(-(shipmentDate.Day() - 1)).addMonths(2);
                            //Create a new entry of the data to be copied into DMHistory object
                            DMHistory__c dmh = new DMHistory__c();
                            dmh.DMClass__c = 'ＢＤ２Ｍ';
                            dmh.DMShipmentDate__c = shipmentDate;
                            dmh.AccountId__c = acc.Id;
                            dmh.AgeCalculationReferenceDate__c = AgeCalculationReferenceDate; //年齢計算基準日
                            dmh.BirthdayLateLastMonth__c = BirthdayLateLastMonth; //誕生日前月末日
                            
                            acc.SentCount_BD2M__c = acc.SentCount_BD2M__c + 1; //This field's value is checked in main query in order not to send DM2 more than 2 times
                            acc.DoNotSend_BD2M__c= True; //Once data is copied to the 取引先 it should not be considered by the batch for the predecided period
                            acc.DMShipmentDate_BD2M__c = shipmentDate; //発送日
                            acc.AgeCalculationReferenceDate_BD2M__c = AgeCalculationReferenceDate; //年齢計算基準日
                            acc.BirthdayLateLastMonth_BD2M__c = BirthdayLateLastMonth; //誕生日前月末日
                            
                            if(latestModifiedObject.getSObjectType() == MiniInsurance__c.sObjectType)
                            {
                                MiniInsurance__c mOps = (MiniInsurance__c)latestModifiedObject;
                                
                                //Select valid home number from 2 phone fields of mini opportunity
                                String phone1 = AccountListHelper.getPhoneNumber(mOps.phone_num__c);
                                String phone2 = AccountListHelper.getPhoneNumber(mOps.mobile_num__c);
                                String postalCode = AccountListHelper.convertPostalCode(mOps.postal_code__c);
                                
                                //Copy（ミニ保険）申込み fields to the 取引先
                                acc.LastName_BD2M__c = mOps.LastName__c;
                                acc.FirstName_BD2M__c = mOps.FirstName__c;
                                acc.PostalCode_BD2M__c = postalCode;
                                acc.State_BD2M__c = mOps.address1__c;
                                acc.City_BD2M__c = mOps.address2__c;
                                acc.Apart_BD2M__c = '';
                                acc.Gender_BD2M__c = mOps.gender__c;
                                acc.Birthdate_BD2M__c = mOps.Birthdate__c;
                                acc.Path_BD2M__c = '３';
                                acc.Phone_BD2M__c = phone1;
                                acc.Phone2_BD2M__c = phone2;
                                acc.MiniOpportunitiesID_BD2M__c = mOps.Id;
                                acc.OpportunityID_BD2M__c = null;
                                acc.LeadID_BD2M__c = null;
                                acc.InboundLeadID_BD2M__c = null;
                                
                                //Copy（ミニ保険）申込み fields to the DMHistory
                                dmh.LastName__c = mOps.LastName__c;
                                dmh.FirstName__c = mOps.FirstName__c;
                                dmh.PostalCode__c = postalCode;
                                dmh.State__c = mOps.address1__c;
                                dmh.City__c = mOps.address2__c;
                                dmh.Apart__c = '';
                                dmh.Gender__c = mOps.gender__c;
                                dmh.Birthdate__c = mOps.Birthdate__c;
                                dmh.Path__c = '３';
                                dmh.Phone__c = phone1;
                                dmh.Phone2__c = phone2;
                                dmh.MiniOpportunitiesID__c = mOps.Id;
                            } 
                            else if(latestModifiedObject.getSObjectType() == SeihoOpportunity__c.sObjectType)
                            {
                                SeihoOpportunity__c ops = (SeihoOpportunity__c)latestModifiedObject;
                                
                                //Select valid Phone number from 2 phone fields of SeihoOpportunity__c
                                String phone1 = AccountListHelper.getPhoneNumber(ops.Phone__c); 
                                String phone2 = AccountListHelper.getPhoneNumber(ops.MobilePhone__c);
                                String postalCode = AccountListHelper.convertPostalCode(ops.PostalCode__c);
                                if(String.isBlank(ops.State__c))
                                    ops.State__c = '';
                                if(String.isBlank(ops.address1__c))
                                    ops.address1__c = '';
                                
                                //Copy 申込み fields to the 取引先
                                acc.LastName_BD2M__c = ops.LastName__c;
                                acc.FirstName_BD2M__c = ops.FirstName__c;
                                acc.PostalCode_BD2M__c = postalCode;
                                acc.State_BD2M__c = ops.State__c + ops.address1__c;
                                acc.City_BD2M__c = ops.address2__c;
                                acc.Apart_BD2M__c = ops.address3__c;
                                acc.Gender_BD2M__c = ops.Gender__c;
                                acc.Birthdate_BD2M__c = ops.Birthdate__c;
                                acc.Path_BD2M__c = '１';
                                acc.Phone_BD2M__c = phone1;
                                acc.Phone2_BD2M__c = phone2;
                                acc.OpportunityID_BD2M__c = ops.Id;
                                acc.MiniOpportunitiesID_BD2M__c = null;
                                acc.LeadID_BD2M__c = null;
                                acc.InboundLeadID_BD2M__c = null;
                                
                                //Copy 申込み fields to the DMHistory
                                dmh.LastName__c = ops.LastName__c;
                                dmh.FirstName__c = ops.FirstName__c;
                                dmh.PostalCode__c = postalCode;
                                dmh.State__c = ops.State__c + ops.address1__c;
                                dmh.City__c = ops.address2__c;
                                dmh.Apart__c = ops.address3__c;
                                dmh.Gender__c = ops.Gender__c;
                                dmh.Birthdate__c = ops.Birthdate__c;
                                dmh.Path__c = '１';
                                dmh.Phone__c = phone1;
                                dmh.Phone2__c = phone2;
                                dmh.SeihoOpportunityID__c = ops.Id;
                            }
                            else if(latestModifiedObject.getSObjectType() == SeihoLead__c.sObjectType)
                            {
                                SeihoLead__c leads = (SeihoLead__c)latestModifiedObject;
                                
                                //Select valid Phone number from 2 phone fields of SeihoLead__c
                                String phone1 = AccountListHelper.getPhoneNumber(leads.Phone__c); 
                                String phone2 = AccountListHelper.getPhoneNumber(leads.MobilePhone__c);
                                String postalCode = AccountListHelper.convertPostalCode(leads.PostalCode__c);
                                
                                if(String.isBlank(leads.Street__c))
                                    leads.Street__c = '';
                                if(String.isBlank(leads.Apart__c))
                                    leads.Apart__c = '';
                                
                                //Copy Lead fields to the 取引先
                                acc.LastName_BD2M__c = leads.LastName__c;
                                acc.FirstName_BD2M__c = leads.FirstName__c;
                                acc.PostalCode_BD2M__c = postalCode;
                                acc.Apart_BD2M__c = leads.Street__c + leads.Apart__c;
                                acc.City_BD2M__c = leads.City__c;
                                acc.State_BD2M__c = leads.State__c;
                                acc.Gender_BD2M__c = leads.Gender__c;
                                acc.Birthdate_BD2M__c = leads.BirthDate__c;
                                acc.Path_BD2M__c = '２';
                                acc.Phone_BD2M__c = phone1;
                                acc.Phone2_BD2M__c = phone2;
                                acc.LeadID_BD2M__c = leads.Id;
                                acc.OpportunityID_BD2M__c = null;
                                acc.MiniOpportunitiesID_BD2M__c = null;
                                acc.InboundLeadID_BD2M__c = null;
                                
                                //Copy Lead fields to the DMHistory
                                dmh.LastName__c = leads.LastName__c;
                                dmh.FirstName__c = leads.FirstName__c;
                                dmh.PostalCode__c = postalCode;
                                dmh.State__c = leads.State__c;
                                dmh.City__c = leads.City__c;
                                dmh.Apart__c = leads.Street__c + leads.Apart__c;
                                dmh.Gender__c = leads.Gender__c;
                                dmh.Birthdate__c = leads.BirthDate__c;
                                dmh.Path__c = '２';
                                dmh.Phone__c = phone1;
                                dmh.Phone2__c = phone2;
                                dmh.SeihoLeadID__c = leads.Id;
                            }
                            else if(latestModifiedObject.getSObjectType() == SeihoInboundLead__c.sObjectType)
                            {
                                SeihoInboundLead__c inboundLeads = (SeihoInboundLead__c)latestModifiedObject;
                                
                                //Select valid Phone number from 2 phone fields of SeihoInboundLead__c
                                String phone1 = AccountListHelper.getPhoneNumber(inboundLeads.DestPhone__c);
                                String phone2 = AccountListHelper.getPhoneNumber(inboundLeads.DestMobilePhone__c);
                                String postalCode = AccountListHelper.convertPostalCode(inboundLeads.Account_PostalCode__c);
                                
                                Date account_BirthDate = null;
                                if(String.isNotBlank(inboundLeads.Account_BirthDate__c))
                                    account_BirthDate = Date.Parse(inboundLeads.Account_BirthDate__c.replaceAll('-','/'));
                                
                                //Copy (コール)資料請求) fields to the 取引先
                                acc.LastName_BD2M__c = inboundLeads.Account_LastName__c;
                                acc.FirstName_BD2M__c = inboundLeads.Account_FirstName__c;
                                acc.PostalCode_BD2M__c = postalCode;
                                acc.Apart_BD2M__c = inboundLeads.Account_Apart__c;
                                acc.City_BD2M__c = inboundLeads.Account_City__c;
                                acc.State_BD2M__c = inboundLeads.Account_State__c;
                                acc.Gender_BD2M__c = inboundLeads.Account_Gender__c;
                                acc.Birthdate_BD2M__c = account_BirthDate;
                                acc.Path_BD2M__c = '２';
                                acc.Phone_BD2M__c = phone1;
                                acc.Phone2_BD2M__c = phone2;
                                acc.InboundLeadID_BD2M__c = inboundLeads.Id;
                                acc.LeadID_BD2M__c = null;
                                acc.OpportunityID_BD2M__c = null;
                                acc.MiniOpportunitiesID_BD2M__c = null;
                                
                                //Copy (コール)資料請求) fields to the DMHistory
                                dmh.LastName__c = inboundLeads.Account_LastName__c;
                                dmh.FirstName__c = inboundLeads.Account_FirstName__c;
                                dmh.PostalCode__c = postalCode;
                                dmh.State__c = inboundLeads.Account_State__c;
                                dmh.City__c = inboundLeads.Account_City__c;
                                dmh.Apart__c = inboundLeads.Account_Apart__c;
                                dmh.Gender__c = inboundLeads.Account_Gender__c;
                                dmh.Birthdate__c = account_BirthDate;
                                dmh.Path__c = '２';
                                dmh.Phone__c = phone1;
                                dmh.Phone2__c = phone2;
                                dmh.SeihoInboundLeadID__c = inboundLeads.Id;
                            }
                            
                            insert dmh;
                            acc.DMHistoryID_BD2M__c = dmh.Id;
                            accountlistUpdate = True;
                        }
                    }
                }
                
                if(accountlistUpdate) //Add 取引先 to the List to reduce unnecessary SOQL update operations
                    accountlistsToBeUpdated.add(acc);
            }
            catch(Exception ex)
            {
                errorLog += acc.Id + ' | ' + ex.getMessage() + ' at ' + ex.getLineNumber() + '\n';
            }
        }
        
        if(!accountlistsToBeUpdated.isEmpty())
        {
            try
            {
                update accountlistsToBeUpdated; //Update list of 取引先
            }
            catch(Exception ex)
            {
                errorLog += ex.getMessage() + ' at ' + ex.getLineNumber() + '\n';
            }
        }
    }
    
    
    global void finish(Database.BatchableContext bc)
    {
        //Send warning mail in case apex job did not meed it's deadline
        // NOTE : TODO **************************//
        //SchedulingHelper.sendDidNotMeetDeadlineWarningMail('Batch2DM Accountlist Nacl OppMoppLead', deadline);
        
        //Error mail in case of exception occures in the batch
        if(String.isNotBlank(errorLog))
            SendErrorMailClass.sendErrorMailAccountList( '[Salesforce][Rakuten Life Insurance][Error] Batch2DM Accountlist Nacl OppMoppLead failed', 
                                                         '取引先 Name | Exception Details\n' + errorLog, 'error'); 
    }
}