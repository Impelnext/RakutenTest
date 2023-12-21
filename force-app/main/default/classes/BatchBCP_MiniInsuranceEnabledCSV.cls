/****************************************************************************************/
/* Class Name:     BatchBCP_MiniInsuranceEnabledCSV                                     */
/* Description:                                                                         */
/****************************************************************************************/
global class BatchBCP_MiniInsuranceEnabledCSV implements Schedulable,
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
    /* Method Name:    BatchBCP_MiniInsuranceEnabledCSV                          */
    /* Description:                                                              */
    /*****************************************************************************/
    public BatchBCP_MiniInsuranceEnabledCSV() {
    }
    
    public String csvColumnHeader;
    public Set<String> csvRowValues = new Set<String>();
    /*****************************************************************************/
    /* Method Name:    start                                                     */
    /* Description:    start method of Batchable Interface                       */
    /*                 Forms SQL Query for Batch processing                      */
    /*****************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String strSql  = 'SELECT email__c';
               strSql += ' FROM  MiniInsurance__c WHERE ';
               strSql += ' entry_status__c = \'有効中\'';
               strSql += ' AND email__c != null ORDER BY email__c ASC';       

        return Database.getQueryLocator(strSql);
    }

    /**********************************************************************************/
    /* Method Name:    execute                                                        */
    /* Description:    execute method of Batchable Interface,                         */
    /*                 Change details corresponding mini Data                         */
    /**********************************************************************************/
    global void execute(Database.BatchableContext bc,SObject[] miniList) {
        //200件ずつループしている。
        for(MiniInsurance__c mini : (List<MiniInsurance__c>)miniList){
            //セットにすることで重複メールを削除する。
            csvRowValues.add(mini.email__c);
        }
    }
                                            
    /*****************************************************************************/
    /* Method Name:    finish                                                    */
    /* Description:    finish method of Batchable Interface                      */
    /*****************************************************************************/
    global void finish(Database.BatchableContext bc) {
		Integer splitNum = 100000;//10万件単位で分割
        Integer startNum =0;
        Integer endNum =0;
        
        Integer csvGroup = csvRowValues.size() / splitNum;                 //切り捨て
        Integer fractionNum = math.mod(csvRowValues.size(),splitNum);      //端数
        List<Folder> folders = [SELECT Id, Name FROM Folder WHERE Name = 'BCP_送信メール一覧'];
        List<SObject> insertDocList = new List<SObject>();
    	if(!folders.isEmpty()){
            List<String> csvRowSplitValues = new List<String>();
            for(Integer i= 0;i <= csvGroup; i++){
                startNum = (i * splitNum);
                if(i != csvGroup){
                    endNum = splitNum + (i * splitNum);
                }else{
                    endNum = fractionNum + (i * splitNum);
                }
                csvRowSplitValues = splitList(startNum,endNum,csvRowValues);
            	String documentName = null;
                if(i != csvGroup){
                	documentName = 'ミニ保険_'+ Datetime.now().format('yyyy-MM-dd HH:mm', 'JST') + '_有効中_' + ((i + 1) * splitNum) + '件';
                }else{
                    documentName = 'ミニ保険_'+ Datetime.now().format('yyyy-MM-dd HH:mm', 'JST') + '_有効中_' + fractionNum + '件';
                }

                String csvFile = String.join(csvRowSplitValues,'\n');
                Document doc = new Document(Name = documentName, Body = Blob.valueOf(csvFile), FolderId = folders[0].Id, Type = 'csv', ContentType='application/vnd.ms-excel');
                insertDocList.add(doc);
                csvRowSplitValues.clear();
            }
        }
        insert insertDocList;
        if('0'.equals(System.Label.BCP_Recovery_F)){
        	Database.executeBatch(new BatchBCP_MiniInsuranceDisclaimerCSV());
        }
    }
                                            
    /*****************************************************************************/
    /* Method Name:    splitList                                                 */
    /* Description:    startNumからendNumまでListを分割する                      */
    /*****************************************************************************/
    public static List<String> splitList(Integer startNum,Integer endNum,Set<String> targertSet){
    	List<String> csvRowWorkValues = new List<String>();

        List<String> targetList = new List<String>();
        //開始位置、終了位置を意識するため、値を詰めなおす。
        targetList.addAll(targertSet);
        
        for(Integer j = startNum; j < endNum; j++){
        	csvRowWorkValues.add(targetList.get(j));
        }
       return csvRowWorkValues;                        
    }
}