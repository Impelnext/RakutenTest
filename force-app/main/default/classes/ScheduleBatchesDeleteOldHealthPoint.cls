/************************************************************************************************************
*   Class               :       ScheduleBatchesDeleteOldHealthPoint                                         *
*   Description         :       健康ポイント-２年過去データの削除バッチのスケジューラクラス                      *
*   Created Date        :       2023/02/06                                                                  *
*   Created By          :       Takumi Nagaya                                                               *
*   Modified Date       :                                                                                   *
*   Modified By         :                                                                                   *
*************************************************************************************************************/
global class ScheduleBatchesDeleteOldHealthPoint implements Schedulable{
    
    global ScheduleBatchesDeleteOldHealthPoint(){
    }
    
    global void execute(SchedulableContext ctx) {
        
        BatchDeleteOldHealthRefundPoint bdohp = new BatchDeleteOldHealthRefundPoint();
        Database.executeBatch(bdohp, 2000);
        
        BatchDeleteOldHealthCertificatePoint bdohcp = new BatchDeleteOldHealthCertificatePoint();
        Database.executeBatch(bdohcp, 2000);
        
        BatchDeleteOldBpBMIPoint bdobp = new BatchDeleteOldBpBMIPoint();
        Database.executeBatch(bdobp, 2000);
        
        BatchDeleteOldActivePoint bdoap = new BatchDeleteOldActivePoint();
        Database.executeBatch(bdoap, 2000);
        
    }
}