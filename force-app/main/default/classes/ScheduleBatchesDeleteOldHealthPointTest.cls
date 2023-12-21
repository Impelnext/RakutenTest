/*************************************************************************************************************
 *   Class               :       ScheduleBatchesDeleteOldHealthPointTest                                     *
 *   Description         :       健康ポイント-２年過去データの削除バッチのスケジューラクラスのテストクラス   *
 *   Created Date        :       2023/02/06                                                              　　*
 *   Created By          :       Takumi Nagaya                                                               *
 *   Modified Date       :                                                                                   *
 *   Modified By         :                                                                                   *
 *************************************************************************************************************/
@isTest
public class ScheduleBatchesDeleteOldHealthPointTest {
    
    @IsTest
    static void testScheduleBatches(){
        
        Test.startTest();
        
        SchedulableContext ctx;
        ScheduleBatchesDeleteOldHealthPoint sbd = new ScheduleBatchesDeleteOldHealthPoint();
        sbd.execute(ctx);
        
        Test.stopTest();
    }
}