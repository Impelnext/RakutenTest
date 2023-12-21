/*
* @Class Name     : TaskTrigger 
* @Description    : ToDoトリガー
* @Created Date   : 2019.04.29
* @Created By     : 
* @Modified Date  : 2020.01.07
* @Modified By    : Valsala Kumar
*/
trigger TaskTrigger on Task (before insert, before update, after insert, after update, after delete) {
    //トリガを停止させたい場合はカスタム表示ラベル「IsTastTriggerFlg」を0に設定
    if(Label.IsTaskTriggerFlg != '0') {
        TaskTriggerHandler handler = new TaskTriggerHandler();
        if (Trigger.isBefore){
            if(Trigger.isInsert){
                // ToDo更新
                handler.onBeforeProcess(Trigger.new, 'insert');
            }
            else if(Trigger.isUpdate){
                // ToDo更新
                handler.onBeforeProcess(Trigger.new, 'update');
            }
        }
        else if (Trigger.isAfter){
            if(Trigger.isInsert){
                // 商談更新
                handler.onAfterProcess(Trigger.new, Trigger.oldMap, 'insert');
            }else if(Trigger.isUpdate){
                // 商談更新
                handler.onAfterProcess(Trigger.new, Trigger.oldMap,'update');
            }else if(Trigger.isDelete){
                //商談更新
                handler.onAfterDeleteProcess(Trigger.old, Trigger.oldMap,'delete');
            }
        }
    }
}