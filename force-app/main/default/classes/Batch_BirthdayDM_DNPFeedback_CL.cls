global class Batch_BirthdayDM_DNPFeedback_CL implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    
    global String st;
    global String et;
    global String errorLog;
    global String warningLog;
    global String noRecordFound_warningLog;
    global String multipleRecordFound_warningLog;
    global String recordAlreadyExist_warningLog;
    global Set<String> Birthday2DM_Feedback_DMClass;
    global Datetime deadline;
    
    
    global void execute(SchedulableContext SC) 
    {
        try
        {
            String apexBatchName = 'Batch_BirthdayDM_DNPFeedback_CL';
            
            Datetime DatetimeNow = Datetime.now();
            String endDate = DatetimeNow.formatGmt('yyyy-MM-dd');
            String endHour = DatetimeNow.formatGmt('HH');
            String endMinute = DatetimeNow.formatGmt('mm');
            
            Datetime DatetimeBefore = DatetimeNow.addHours(-25);
            String startDate = DatetimeBefore.formatGmt('yyyy-MM-dd');
            String startHour = DatetimeBefore.formatGmt('HH');
            String startMinute = DatetimeBefore.formatGmt('mm');
            
            String st = startDate + 'T' + startHour + ':' + startMinute + ':00+00:00';
            String et = endDate + 'T' + endHour + ':' + endMinute + ':00+00:00';
            
            Datetime deadline = DatetimeNow.addMinutes(30);
            Integer chunkSize = Integer.valueOf(10);
            
            Database.executeBatch(new Batch_BirthdayDM_DNPFeedback_CL(st, et, deadline), chunkSize);
        }
        catch(Exception ex)
        {
            SendErrorMailClass.sendErrorMailAccountList(
                                                    '[Salesforce][Rakuten Life Insurance][Error] Schedule_BirthdayDM_DNPFeedback_CL Failed', 
                                                    ex.getMessage() + ' at ' + ex.getLineNumber() ,'error');
        }
    }
    
    
    global Batch_BirthdayDM_DNPFeedback_CL()
    {
    }
    
    
    global Batch_BirthdayDM_DNPFeedback_CL(String st, String et, Datetime deadline)
    {
        this.st = st;
        this.et = et;
        this.errorLog = '';
        this.warningLog = '';
        this.noRecordFound_warningLog = '';
        this.multipleRecordFound_warningLog = '';
        this.recordAlreadyExist_warningLog = '';
        this.Birthday2DM_Feedback_DMClass = new Set<String>(System.Label.Birthday2DM_Feedback_DMClass.split(','));
        this.deadline = deadline;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        try
        {
            String query = 'select Id, DMClass__c, ID__c, Call_Update_flag__c, ShippingDate__c, ReturnsProcessingDate__c, ReturnsProcessingReason__c from DnpDM__c ' +
                'where (DMClass__c in ' + new List<String>(Birthday2DM_Feedback_DMClass) +') and Call_Update_flag__c = False and LastModifiedDate > ' + st + ' and LastModifiedDate < ' + et;
            
            return Database.getQueryLocator(query);
        }
        catch(Exception e)
        {
            errorLog += e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            String fallbackQuery = 'select Id from DnpDM__c limit 0';
            return Database.getQueryLocator(fallbackQuery);
        }
    }
    
    
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        List<DMHistory__c> dmh = new List<DMHistory__c>(); 
        List<DMHistory__c> dmhsToBeUpdated = new List<DMHistory__c>();
        List<DnpDM__c> dnpdmsToBeUpdated = new List<DnpDM__c>();
        List<Account> callListToBeUpdated = new List<Account>();
        for(sObject s : scope)
        {
            DnpDM__c dnpdm = (DnpDM__c) s;
            try
            {
                Boolean CalllistUpdateFlag = False;
                List<Account> acc = [select Id, ShipmentActualDate_BD2M__c, ReturnProcessingDate_BD2M__c, ReasonForReturn_BD2M__c, DMHistoryID_BD2M__c from Account where CallingId_BD2M__c =: dnpdm.ID__c];
                if(!acc.isEmpty())
                {
                    if(Birthday2DM_Feedback_DMClass.contains('\'' + dnpdm.DMClass__c + '\''))
                    {
                        dmh = [select Id, ShipmentActualDate__c, ReturnProcessingDate__c, ReasonForReturn__c from DMHistory__c where Id =: acc[0].DMHistoryID_BD2M__c and DMClass__c =: 'ＢＤ２Ｍ' and AccountId__c =: acc[0].Id];
                        
                        acc[0].ShipmentActualDate_BD2M__c = dnpdm.ShippingDate__c;
                        acc[0].ReturnProcessingDate_BD2M__c = dnpdm.ReturnsProcessingDate__c;
                        acc[0].ReasonForReturn_BD2M__c = dnpdm.ReturnsProcessingReason__c;
                        callListToBeUpdated.add(acc[0]);
                        
                        dnpdm.Call_Update_flag__c = True;
                        dnpdmsToBeUpdated.add(dnpdm);
                    }
                    
                    if(!dmh.isEmpty() && dmh.size() == 1)
                    {
                        if(dmh[0].ShipmentActualDate__c == null && dnpdm.ShippingDate__c != null)
                        {
                            dmh[0].ShipmentActualDate__c = dnpdm.ShippingDate__c;
                        }
                        else if(dmh[0].ShipmentActualDate__c != null  && dnpdm.ShippingDate__c != null)
                        {
                            //Record already exist in DM History
                            recordAlreadyExist_warningLog += dnpdm.Id + ' : Record already exist in DM History \n';
                            continue;
                        }
                        
                        if(dmh[0].ReturnProcessingDate__c == null && dnpdm.ReturnsProcessingDate__c != null)
                        {
                            dmh[0].ReturnProcessingDate__c = dnpdm.ReturnsProcessingDate__c;
                        }
                        else if(dmh[0].ReturnProcessingDate__c !=null && dnpdm.ReturnsProcessingDate__c !=null)
                        {
                            //Record already exist in DM History
                            recordAlreadyExist_warningLog += dnpdm.Id + ' : Record already exist in DM History \n';
                            continue;
                        }
                        
                        if(dmh[0].ReasonForReturn__c == null && dnpdm.ReturnsProcessingReason__c != null)
                        {
                            dmh[0].ReasonForReturn__c = dnpdm.ReturnsProcessingReason__c;
                        }
                        else if(dmh[0].ReasonForReturn__c != null && dnpdm.ReturnsProcessingReason__c != null)
                        {
                            //Record already exist in DM History
                            recordAlreadyExist_warningLog += dnpdm.Id + ' : Record already exist in DM History \n';
                            continue;
                        }
                        
                        dmhsToBeUpdated.add(dmh[0]);
                    }
                    else
                    {
                        if(dmh.isEmpty())
                        {
                            //No record found in DM History
                            noRecordFound_warningLog += dnpdm.Id + ' : No record found in DM History \n';
                        }
                        else
                        {
                            //More than one record found in DM History
                            multipleRecordFound_warningLog += dnpdm.Id + ' : Multiple record found in DM History \n';
                        }
                    }
                }
            }
            catch(Exception e)
            {
                errorLog += dnpdm.Id + ' | ' + e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            }
        }
        
        if(!callListToBeUpdated.isEmpty())
        {
            try
            {
                update callListToBeUpdated;
            }
            catch(Exception e)
            {
                errorLog += e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            }
        }
        
        if(!dnpdmsToBeUpdated.isEmpty())
        {
            try
            {
                update dnpdmsToBeUpdated;
            }
            catch(Exception e)
            {
                errorLog += e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            }
        }
        
        if(!dmhsToBeUpdated.isEmpty())
        {
            try
            {
                update dmhsToBeUpdated;
            }
            catch(Exception e)
            {
                errorLog += e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            }
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        //Send warning mail in case apex job did not meed it's deadline
        // NOTE : TODO **************************************************//
        //SchedulingHelper.sendDidNotMeetDeadlineWarningMail('Batch BirthdayDM DNPFeedback CL', deadline);
        
        //Error mail in case of exception occures in the batch
        if(String.isNotBlank(errorLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Error] Batch BirthdayDM DNPFeedback CL failed', 
                                                        '【DNP専用】DM管理 Name | Exception Details\n' + errorLog, 'error'); 
        
        if(String.isNotBlank(noRecordFound_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch BirthdayDM DNPFeedback - No record found in DM History', 
                                                        '【DNP専用】DM管理 ID| Warning Details\n' + noRecordFound_warningLog, 'warning');
        
        if(String.isNotBlank(multipleRecordFound_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch BirthdayDM DNPFeedback - Multiple record found in DM History', 
                                                        '【DNP専用】DM管理 ID| Warning Details\n' + multipleRecordFound_warningLog, 'warning');
        
        if(String.isNotBlank(recordAlreadyExist_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch BirthdayDM DNPFeedback - Record Already Exist in DM History', 
                                                        '【DNP専用】DM管理 ID| Warning Details\n' + recordAlreadyExist_warningLog, 'warning');
    }
}