global class Batch_DNP_DM_Error_DMHistory_Update implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    global String st;
    global String et;
    global String errorLog;
    global String dmclassNotMatching_warningLog;
    global String noRecordFound_warningLog;
    global String multipleRecordFound_warningLog;
    global Set<String> Birthday2DM_Feedback_DMClass;
    global Datetime deadline;
    
    
    
    global void execute(SchedulableContext SC) 
    {
        try
        {
            String apexBatchName = 'Batch_DNP_DM_Error_DMHistory_Update';
            
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
            
            Datetime deadline = DatetimeNow.addMinutes(Integer.valueOf(30));
            Integer chunkSize = Integer.valueOf(10);
            
            Database.executeBatch(new Batch_DNP_DM_Error_DMHistory_Update(st, et, deadline), chunkSize);
        }
        catch(Exception ex)
        {
            SendErrorMailClass.sendErrorMailAccountList(
                                                    '[Salesforce][Rakuten Life Insurance][Error] Schedule_DNP_DM_Error_DMHistory_Update Failed', 
                                                    ex.getMessage() + ' at ' + ex.getLineNumber() ,'error');
        }
    }
    
    
    global Batch_DNP_DM_Error_DMHistory_Update ()
    {
    }
    
    
    global Batch_DNP_DM_Error_DMHistory_Update (String st, String et, Datetime deadline)
    {
        this.st = st;
        this.et = et;
        this.errorLog = '';
        this.dmclassNotMatching_warningLog = '';
        this.noRecordFound_warningLog = '';
        this.multipleRecordFound_warningLog = '';
        this.Birthday2DM_Feedback_DMClass = new Set<String>(System.Label.Birthday2DM_Feedback_DMClass.split(','));
        this.deadline = deadline;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        try
        {
            String query = 'select Id, DMClass__c, ID__c from DM_Error__c ' +
                ' where (DMClass__c in ' + new List<String>(Birthday2DM_Feedback_DMClass) + ' ) and LastModifiedDate > ' + st + ' and LastModifiedDate < ' + et;
            System.debug(query);
            return Database.getQueryLocator(query);
        }
        catch(Exception e)
        {
            errorLog += 'Error in Main Query | ' + e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            String fallbackQuery = 'select Id from DM_Error__c limit 0';
            return Database.getQueryLocator(fallbackQuery);
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        List<DM_Error__c> dmErrorToBeUpdated = new List<DM_Error__c>();
        for(sObject s : scope)
        {
            DM_Error__c dmerror = (DM_Error__c) s;
            
            try
            {   
                List<DMHistory__c> dmh = new List<DMHistory__c>();
                
                if(Birthday2DM_Feedback_DMClass.contains('\'' + dmerror.DMClass__c + '\'') )
                {
                    // Account.CallingId_BD2M__c is the Key to be mapped to DMError.ID__c
                    List<Account> acc = [select Id, DMHistoryID_BD2M__c from Account where CallingId_BD2M__c =: dmerror.ID__c];
                    
                    if(!acc.isEmpty())
                    {
                        if(Birthday2DM_Feedback_DMClass.contains('\'' + dmerror.DMClass__c + '\''))
                        {
                            dmh = [select Id from DMHistory__c where Id =: acc[0].DMHistoryID_BD2M__c and DMClass__c =: 'ＢＤ２Ｍ' and AccountId__c =: Acc[0].Id];
                        }
                    } 
                }
                else
                {
                    //DM_Error DMClass not match with ＢＤ２Ｍ
                    dmclassNotMatching_warningLog += dmerror.Id + '\n';
                    continue;
                }
                
                if(dmh.isEmpty())
                {  
                    //No record found in DM History
                    noRecordFound_warningLog += dmerror.Id + '\n';
                }
                else if(dmh.size() == 1)
                {
                    dmerror.DMHistoryID__c = dmh[0].Id;
                    dmErrorToBeUpdated.add(dmerror);
                }
                else
                {
                    //More than one record found in DM History
                    multipleRecordFound_warningLog += dmerror.Id + '\n';
                }
            }
            catch(Exception e)
            {
                errorLog += dmerror.Id + ' | ' + e.getMessage() + ' at ' + e.getLineNumber() + '\n';
            }
        }
        
        try
        {   
            //Update DM_Error__c list
            if(!dmErrorToBeUpdated.isEmpty())
            {
                update dmErrorToBeUpdated;
            }
        }
        catch(Exception e)
        {
            errorLog += 'List Update Operation Failed | ' + e.getMessage() + ' at ' + e.getLineNumber() + '\n';
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        //Send warning mail in case apex job did not meed it's deadline
        // NOTE : TODO **************************//
        //SchedulingHelper.sendDidNotMeetDeadlineWarningMail('Batch DNP DM Error DMHistory Update', deadline); 
        
        //Error mail in case of exception occures in the batch
        if(String.isNotBlank(errorLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Error] Batch DNP DM Error DMHistory Update failed', 
                                                        '【DNP】DMエラー情報 Name | Exception Details\n' + errorLog, 'error'); 
        
        if(String.isNotBlank(dmclassNotMatching_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch DNP DM Error DMHistory Update- DM_Error DMClass not match', 
                                                        'DNP】DMエラー情報 ID| Warning Details\n' + dmclassNotMatching_warningLog, 'warning');
        
        if(String.isNotBlank(noRecordFound_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch DNP DM Error DMHistory Update- No record found in DM History', 
                                                        '【DNP】DMエラー情報 ID | Warning Details\n' + noRecordFound_warningLog, 'warning');
        
        if(String.isNotBlank(multipleRecordFound_warningLog))
            SendErrorMailClass.sendErrorMailAccountList('[Salesforce][Rakuten Life Insurance][Warning] Batch DNP DM Error DMHistory Update- Multiple record found in DM History', 
                                                        '【DNP】DMエラー情報 ID | Warning Details\n' + multipleRecordFound_warningLog, 'warning');
    }
}