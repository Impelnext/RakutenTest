public with sharing class Patch_CommonDmlOperation {
    //コンストラクタ
    public Patch_CommonDmlOperation() {}
    public final static String CRLF = '\r\n';

    //新規登録
    public void dmlOperation(List<SObject> sobjList, String operationMode,  String programName){
        List<Database.SaveResult> res_lists = new List<Database.SaveResult>();
        List<ErrorLog__c> errorList = new List<ErrorLog__c>();

        if(operationMode == 'insert'){
            res_lists = Database.insert(sobjList, false);
        }else if (operationMode == 'update'){
            res_lists = Database.update(sobjList, false);
        }else{
            //何もしない
        }
        
        for (Database.SaveResult res : res_lists) {
            if(res.isSuccess()){
                //成功時（何も無し）
            }else{
                //失敗時
                for(Database.Error err : res.getErrors()) {
                    ErrorLog__c error = new ErrorLog__c();
                    error.ProgramName__c = programName;
                    error.ErrorMessage__c = '◆StatusCode : ' + err.getStatusCode() + CRLF;
                    error.ErrorMessage__c += '◆Message : ' + err.getMessage() + CRLF + CRLF;
                    error.ErrorMessage__c += '========================' + CRLF;
                    error.ErrorMessage__c += err;

                    errorList.add(error);
                }
            }
        }
        insert errorList;
    }
}