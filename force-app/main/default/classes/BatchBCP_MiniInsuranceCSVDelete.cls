/****************************************************************************************/
/* Class Name:     BatchBCP_MiniInsuranceCSVDelete                                      */
/* Description:                                                                         */
/****************************************************************************************/
global class BatchBCP_MiniInsuranceCSVDelete implements Schedulable,
                                        Database.Batchable<sObject>,
                                        Database.Stateful{

    /*****************************************************************************/
    /* Method Name:    execute                                                   */
    /* Description:    execute method of Schedulable Interface                   */
    /*****************************************************************************/
    global void execute(SchedulableContext sc) {
        database.executebatch(this);
    }
                                            
    /*****************************************************************************/
    /* Method Name:    BatchBCP_MiniInsuranceCSVDelete                           */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchBCP_MiniInsuranceCSVDelete() {
    }
    
    public String csvColumnHeader;
    public List<String> csvRowValues = new List<String>();
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //前日分のファイル削除
        Date beforeDay = system.today().addDays(-1);
        Datetime newDay = Datetime.newInstance(beforeDay.year(), beforeDay.month(), beforeDay.day());
        String dayStr = newDay.format('yyyy-MM-dd');
        String name ='ミニ保険_'+ dayStr;

        // For Running Test Class
        if (Test.isRunningTest()) {
            List<Folder> folders = [SELECT Id, Name FROM Folder WHERE Name = 'BCP_送信メール一覧'];
            Document doc = new Document(Name = name, Body = Blob.valueOf('TEST用'), FolderId = folders.get(0).Id, Type = 'csv', ContentType='application/vnd.ms-excel');
            insert doc;
        }        
        
        String strSql  = 'SELECT ID';
               strSql += ' FROM  Document WHERE ';
               strSql += ' Name LIKE \'%'+ name + '%\' ';

        return Database.getQueryLocator(strSql);
    }

    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Change details corresponding mini Data                         */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc,SObject[] miniList) {
        if(miniList.size() >0){
            delete miniList;   
        }
     }
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
    }
}