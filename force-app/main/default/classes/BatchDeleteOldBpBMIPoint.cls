/*************************************************************************************************************
 *   Class               :       BatchDeleteOldBpBMIPoint                                                    *
 *   Description         :       血圧BMI-２年過去データの削除バッチクラス                                       *
 *   Created Date        :       Takumi Nagaya                                                               *
 *   Created By          :       2023/02/06                                                                  *
 *   Modified Date       :                                                                                   *
 *   Modified By         :                                                                                   *
 *************************************************************************************************************/
global class BatchDeleteOldBpBMIPoint implements 
                                                Database.Stateful, 
                                                Database.Batchable<sObject>, 
                                                Schedulable {
    
    private String errMessage;
    private Integer recordCount;
    private Integer successCount;
    
    /*****************************************************************************/
    /* Method Name:    BatchDeleteOldBpBMIPoint                                  */
    /* Description:    Constructor of Batch Class                                */
    /*****************************************************************************/
    public BatchDeleteOldBpBMIPoint() {
    }
    
    
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batch Interface                           */
    /*****************************************************************************/
    global Iterable<SObject> start(Database.BatchableContext BC) {
        // Initialize
        errMessage = '';
        recordCount = 0;
        successCount = 0;
        
        // Get the 1st Date of the Month, 2 Years before Today
        Date chkDate = Date.Today().addYears(-2);
        String sChkDate = DateTime.newInstance(
                            chkDate.year(),
                            chkDate.month(), 
                            chkDate.day())
                            .format('yyyy/MM');
        
        // Get the Records that is 2 Years Older then Current Month
        return Database.GetQueryLocator('SELECT ID FROM BpBMIPoint__c WHERE TARGET_MONTH__c < :sChkDate ');
    }
    
    
    /*****************************************************************************/
    /* Method Name:    execute                                                   */
    /* Description:    execute method of Schedulable Interface,                  */
    /*                 which executes this batch                                 */
    /*****************************************************************************/
    global void execute(SchedulableContext sc){
        Database.Executebatch(this, 2000);
    }
    
    
    /*****************************************************************************/
    /* Method Name:    execute                                                   */
    /* Description:    execute method of Batchable Interface                     */
    /*                 Delete operation is performed in this method              */
    /*****************************************************************************/
    global void execute(Database.BatchableContext BC, SObject[]  records) {
        
        try {
            // Get the Total Record Counts
            recordCount += records.size();
            
            // Delete the Old Records
            Delete records;
            
            // Get the Success Record Counts
            successCount += records.size();
        }
        catch(Exception ex) {
            
            // Get the Error Message from Delete
            errMessage += ex.getMessage();
            errMessage += '\n';
        }
    }
    
    
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*                 Send Batch Details through mail                           */
    /*****************************************************************************/
    global void finish(Database.BatchableContext BC) {
        
        // Save Batch Result in BatchRunControl__c Object
        
        // Status = 1, for OK
        // Status = 2, for Error
        // Status = 0, DO NOT SET this VALUE
        // (Status = 0, Is to Run the Batch Again)
        String status = recordCount != successCount ? '2' : '1';
        String jobName = 'BatchDeleteOldBpBMIPoint';
        BatchRunControl__c bRunControl = new BatchRunControl__c(
            JobName__c = jobName,
            Status__c = status,
            //RecordCount__c = recordCount,
            //SuccessCount__c = successCount,
            ErrorMessage__c = errMessage
        );
        Insert bRunControl;
    }
}