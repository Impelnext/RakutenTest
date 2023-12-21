@isTest
public class TaskTriggerTest
{

    @isTest
    static void AccountTaskTriggerTest_Insert()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();
        Account acc = triggerTest.createAccount();
        insert acc;
        
        Test.startTest();
        Task t = triggerTest.createTask(acc.Id);
        // 活動．架電禁止依頼 = 永続的な架電禁止
        t.StopCallingList__c = '永続的な架電禁止';
        insert t;
        
        Task resTask = triggerTest.getTaskId(t.id);
        acc = [SELECT Id,OperationType__c,OpportunityStatus__c,StopCallingFlg__c FROM Account where Id = :resTask.WhatId];
        
        System.assertEquals('架電禁止',acc.OperationType__c );
        System.assertEquals(TRUE,acc.StopCallingFlg__c );
    }
    
    @isTest
    static void AccountTaskTriggerTest_Update()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();
        Account acc = triggerTest.createAccount();
        insert acc;
        
        Test.startTest();
        Task t = triggerTest.createTask(acc.Id);
        insert t;
        
        Task resTask = triggerTest.getTaskId(t.id);
        acc = [SELECT Id,OperationType__c,OpportunityStatus__c,StopCallingFlg__c FROM Account where Id = :resTask.WhatId];
        
        System.assertNotEquals('架電禁止',acc.OperationType__c );
        System.assertNotEquals(TRUE,acc.StopCallingFlg__c );
        
        // Update
        // 活動．架電禁止依頼 = 永続的な架電禁止
        t.StopCallingList__c = '永続的な架電禁止';
        update t;
        
        acc = [SELECT Id,OperationType__c,OpportunityStatus__c,StopCallingFlg__c FROM Account where Id = :resTask.WhatId];
        
        System.assertEquals('架電禁止',acc.OperationType__c );
        System.assertEquals(TRUE,acc.StopCallingFlg__c );
    }
    
    @isTest
    static void TaskTriggerTest_Insert()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();

        insert  triggerTest.createOpportunity();
        Opportunity op = [SELECT Id,StageName,prodtype_multilist__c,ProdctName__c,Field1__c FROM Opportunity LIMIT 1];

        Test.startTest();

        Task t = triggerTest.createTask(op.Id);
        insert t;
        
        Task resTask =  triggerTest.getTaskId(t.id);  
        Opportunity resOpp = triggerTest.getOppId(resTask.WhatId);
        System.assertEquals(True,resTask.FirstCall__c );
        System.assertEquals(True,resTask.ImprovingProbability__c );
        
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.FirstResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.FirstResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.FirstCallDateTime__c);
        System.assertEquals(resTask.Probability__c,resOpp.FirstProbability__c);
        System.assertEquals('申込なし',resOpp.RecentProbability__c);
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.RecentResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.RecentResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.RecentCallDateTime__c);
        System.assertEquals(resTask.NextCallDateTime__c,resOpp.RecentNextCallDateTime__c);
        System.assertEquals(resTask.Promise__c,resOpp.RecentPromise__c);
        System.assertEquals(resTask.Check_AcceptReparation__c,resOpp.Check_AcceptReparation__c);
        System.assertEquals(resTask.Check_AcceptPremire__c,resOpp.Check_AcceptPremire__c);
        System.assertEquals(resTask.Check_ApproveDate__c,resOpp.Check_ApproveDate__c);
        System.assertEquals(resTask.StopCallingList__c,resOpp.StopCallingList__c);
        System.assertEquals('失注',resOpp.CloseType__c);
        System.assertEquals(resTask.CloseReason__c,resOpp.CloseReason__c);
        System.assertEquals(System.today(),resOpp.CloseDate);
        System.assertEquals(resTask.VOC__c,resOpp.VOC__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.ClaimDate__c);
        System.assertEquals(op.Field1__c != null ? op.Field1__c + 1 : 1,resOpp.Field1__c );
        System.assertEquals(op.prodtype_multilist__c + ';' +resTask.prodtype_multilist__c,resOpp.prodtype_multilist__c);
        String taskCallDateTime = t.CallDateTime__c.format('yyyy/MM/dd hh:mm');
        System.assertEquals(op.ProdctName__c + '\n' + resTask.ProdctName__c+ '(' + taskCallDateTime + ')',resOpp.ProdctName__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void TaskTriggerTest_Insert_Else()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();

        Opportunity op = triggerTest.createOpportunity();
        op.FirstResultType_Middle__c = '不通';
        op.RecentProbability__c = '';
        op.prodtype_multilist__c = '';
        op.ProdctName__c = '';
        insert op;

        Test.startTest();

        Task t = triggerTest.createTask(op.Id);
        t.Probability__c = '';
        t.VOC__c = '感謝';
        t.ResultType_Small__c = '了承';
        t.ResultType_Middle__c = '対面誘導';
        insert t;
        t.VOC__c = '要望';
        update t;       
        
        Task resTask =  triggerTest.getTaskId(t.id);  
        Opportunity resOpp = triggerTest.getOppId(resTask.WhatId);
        System.assertEquals(True,resTask.FirstCall__c );
        System.assertEquals(False,resTask.ImprovingProbability__c );
        
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.FirstResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.FirstResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.FirstCallDateTime__c);
        System.assertEquals(resTask.Probability__c,resOpp.FirstProbability__c);
        System.assertEquals('申込なし',resOpp.RecentProbability__c);
        System.assertEquals('対応打ち切り',resOpp.CloseType__c);
        System.assertEquals('対面誘導',resOpp.CloseReason__c);
        System.assertEquals(System.today(),resOpp.CloseDate);
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.RecentResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.RecentResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.RecentCallDateTime__c);
        System.assertEquals(resTask.NextCallDateTime__c,resOpp.RecentNextCallDateTime__c);
        System.assertEquals(resTask.Promise__c,resOpp.RecentPromise__c);
        System.assertEquals(resTask.Check_AcceptReparation__c,resOpp.Check_AcceptReparation__c);
        System.assertEquals(resTask.Check_AcceptPremire__c,resOpp.Check_AcceptPremire__c);
        System.assertEquals(resTask.Check_ApproveDate__c,resOpp.Check_ApproveDate__c);
        System.assertEquals(resTask.StopCallingList__c,resOpp.StopCallingList__c);
        System.assertEquals(resTask.VOC__c,resOpp.VOC__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.ThankDate__c);
        System.assertEquals(op.Field1__c != null ? op.Field1__c + 1 : 1,resOpp.Field1__c );
        System.assertEquals(resTask.prodtype_multilist__c,resOpp.prodtype_multilist__c);
        String taskCallDateTime = t.CallDateTime__c.format('yyyy/MM/dd hh:mm');
        System.assertEquals(resTask.ProdctName__c+ '(' + taskCallDateTime + ')',resOpp.ProdctName__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void TaskTriggerTest_Update()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();

        Opportunity op = triggerTest.createOpportunity();
        op.FirstResultType_Middle__c = '不通';
        op.RecentProbability__c = '';
        op.prodtype_multilist__c = '';
        op.ProdctName__c = '';
        insert op;

        Test.startTest();

        Task t = triggerTest.createTask(op.Id);
        t.Probability__c = '';
        t.VOC__c = '要望';
        t.ResultType_Small__c = '申込完了';
        t.ResultType_Middle__c = 'Web誘導';
        insert t;
        t.VOC__c = '感謝';
        update t;    
        
        Task resTask =  triggerTest.getTaskId(t.id);  
        Opportunity resOpp = triggerTest.getOppId(resTask.WhatId);
        System.assertEquals(True,resTask.FirstCall__c );
        System.assertEquals(False,resTask.ImprovingProbability__c );
        
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.FirstResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.FirstResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.FirstCallDateTime__c);
        System.assertEquals(resTask.Probability__c,resOpp.FirstProbability__c);
        System.assertEquals(resTask.Probability__c,resOpp.RecentProbability__c);
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.RecentResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.RecentResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.RecentCallDateTime__c);
        System.assertEquals(resTask.NextCallDateTime__c,resOpp.RecentNextCallDateTime__c);
        System.assertEquals(resTask.Promise__c,resOpp.RecentPromise__c);
        System.assertEquals(resTask.Check_AcceptReparation__c,resOpp.Check_AcceptReparation__c);
        System.assertEquals(resTask.Check_AcceptPremire__c,resOpp.Check_AcceptPremire__c);
        System.assertEquals(resTask.Check_ApproveDate__c,resOpp.Check_ApproveDate__c);
        System.assertEquals(resTask.StopCallingList__c,resOpp.StopCallingList__c);
        System.assertEquals(resTask.CloseReason__c,resOpp.CloseReason__c);
        System.assertEquals(resTask.VOC__c,resOpp.VOC__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.ThankDate__c);
        System.assertEquals(op.Field1__c != null ? op.Field1__c + 1 : 1,resOpp.Field1__c );
        System.assertEquals(resTask.prodtype_multilist__c,resOpp.prodtype_multilist__c);
        String taskCallDateTime = t.CallDateTime__c.format('yyyy/MM/dd hh:mm');
        System.assertEquals(resTask.ProdctName__c+ '(' + taskCallDateTime + ')',resOpp.ProdctName__c);
        
        Test.stopTest();
    }
    
    @isTest
    static void TaskTriggerTest_Delete()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();

        insert  triggerTest.createOpportunity();
        Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();

        Task t = triggerTest.createTask(op.Id);
        insert t;
        
        delete [SELECT Id FROM Task LIMIT 1];
        
        Opportunity resOpp = triggerTest.getOppId(op.id);
        System.assertEquals(null,resOpp.FirstResultType_Middle__c);
        System.assertEquals(null,resOpp.FirstResultType_Small__c);
        System.assertEquals(null,resOpp.FirstCallDateTime__c);
        System.assertEquals(null,resOpp.RecentResultType_Middle__c);
        System.assertEquals(null,resOpp.RecentResultType_Small__c);
        System.assertEquals(null,resOpp.RecentCallDateTime__c);
        System.assertEquals(null,resOpp.RecentNextCallDateTime__c);
        System.assertEquals('無',resOpp.RecentPromise__c);
        System.assertEquals(False,resOpp.Check_AcceptReparation__c);
        System.assertEquals(False,resOpp.Check_AcceptPremire__c);
        System.assertEquals(False,resOpp.Check_ApproveDate__c);
        System.assertEquals(null,resOpp.StopCallingList__c);
        System.assertEquals(null,resOpp.FirstProbability__c);
        System.assertEquals(null,resOpp.RecentProbability__c);
        System.assertEquals(null,resOpp.prodtype_multilist__c);
        System.assertEquals(null,resOpp.ProdctName__c);
        System.assertEquals(null,resOpp.VOC__c);
        System.assertEquals(null,resOpp.ClaimDate__c);
        System.assertEquals(null,resOpp.RequestDate__c);
        System.assertEquals(null,resOpp.ThankDate__c);
        System.assertEquals(null,resOpp.Field1__c);
        
        Test.stopTest();
    }
    @isTest
    static void TaskTriggerTest_Delete_And_Added_Another_Task()
    {
        TaskTriggerTest triggerTest = new TaskTriggerTest();

        insert  triggerTest.createOpportunity();
        Opportunity op = [SELECT Id,prodtype_multilist__c,ProdctName__c FROM Opportunity LIMIT 1];
       
        insert triggerTest.createTask(op.Id);
        insert triggerTest.createTask(op.Id);

        Test.startTest();

        delete [SELECT Id FROM Task LIMIT 1];
        
        Task t = [SELECT Id,CallDateTime__c FROM Task LIMIT 1];
        Task resTask =  triggerTest.getTaskId(t.id);  
        Opportunity resOpp = triggerTest.getOppId(resTask.WhatId);
        
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.FirstResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.FirstResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.FirstCallDateTime__c);
        System.assertEquals(resTask.Probability__c,resOpp.FirstProbability__c);
        System.assertEquals(resTask.prodtype_multilist__c,resOpp.prodtype_multilist__c);
        String taskCallDateTime = t.CallDateTime__c.format('yyyy/MM/dd hh:mm');
        System.assertEquals(resTask.ProdctName__c+ '(' + taskCallDateTime + ')',resOpp.ProdctName__c);
        System.assertEquals(resTask.ResultType_Middle__c,resOpp.RecentResultType_Middle__c);
        System.assertEquals(resTask.ResultType_Small__c,resOpp.RecentResultType_Small__c);
        System.assertEquals(resTask.CallDateTime__c,resOpp.RecentCallDateTime__c);
        System.assertEquals(resTask.NextCallDateTime__c,resOpp.RecentNextCallDateTime__c);
        System.assertEquals(resTask.Promise__c,resOpp.RecentPromise__c);
        System.assertEquals(resTask.Check_AcceptReparation__c,resOpp.Check_AcceptReparation__c);
        System.assertEquals(resTask.Check_AcceptPremire__c,resOpp.Check_AcceptPremire__c);
        System.assertEquals(resTask.Check_ApproveDate__c,resOpp.Check_ApproveDate__c);
        System.assertEquals(resTask.StopCallingList__c,resOpp.StopCallingList__c);
        System.assertEquals(resTask.VOC__c,resOpp.VOC__c);

        Test.stopTest();
    }
    
    private Task createTask(Id WhatId){
        return new Task(
            WhatId = WhatId,
            ResultType_Large__c = '発信',
            ResultType_Middle__c = '資料送付',
            ResultType_Small__c = '拒否',
            Probability__c = 's',
            VOC__c = '苦情',
            prodtype_multilist__c = '住宅',
            ProdctName__c = 'ProdctName',
            CallDateTime__c = System.today()
        );
    }
    
    private Opportunity createOpportunity() {
        return new Opportunity(
            Name = '1111111',
            StageName = '未対応',
            FirstResultType_Middle__c = '',
            FirstCallDateTime__c = System.today(),
            //FirstProbability__c = 'test',
            RecentCallDateTime__c = System.today().addDays(-1),
            RecentProbability__c = 'A',
            ProdctName__c = 'TestProdName',
            prodtype_multilist__c ='医療',
            CloseDate = System.today()
        );
    }
    
    private Account createAccount() {
        return new Account(
            LastName = 'TEST1111111',
            PersonHomePhone = '09999999999'
        );
    }
    
    private Task getTaskId(Id id){
        return [Select id,WhatId,FirstCall__c,ImprovingProbability__c,ResultType_Middle__c,ResultType_Small__c,
                CallDateTime__c,Probability__c,NextCallDateTime__c,Promise__c,Check_AcceptReparation__c,ProdctName__c,
                Check_AcceptPremire__c,Check_ApproveDate__c,StopCallingList__c,CloseReason__c,VOC__c,prodtype_multilist__c
                from Task where id =: id];
    }
    
    private Opportunity getOppId(Id id){
        return [Select id,FirstProbability__c,RecentProbability__c,Field1__c,FirstResultType_Middle__c,
                FirstResultType_Small__c,FirstCallDateTime__c,RecentResultType_Middle__c,RecentResultType_Small__c,
                RecentCallDateTime__c,RecentNextCallDateTime__c,RecentPromise__c,Check_AcceptReparation__c,
                Check_AcceptPremire__c,Check_ApproveDate__c,StopCallingList__c,VOC__c,ClaimDate__c,RequestDate__c,
                ThankDate__c,CloseReason__c,CloseDate,prodtype_multilist__c,ProdctName__c ,CloseType__c                                             
                from Opportunity where id =: id];
    }
}