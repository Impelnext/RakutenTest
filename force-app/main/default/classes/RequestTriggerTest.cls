@isTest
public class RequestTriggerTest{

    @isTest
    static void prepareData(){
    
        List<Request__c> reqList = new List<Request__c>(); 
         List<Reception__c> recpList = new List<Reception__c>(); 
         List<Request__c> reqRecordUpdateList = new List<Request__c>();
    
        Reception__c recpRecord1 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord1);
        
         Reception__c recpRecord2 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord2);
        
         Reception__c recpRecord3 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord3);
        
         Reception__c recpRecord4 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord4);
        
         Reception__c recpRecord5 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord5);
        
         Reception__c recpRecord6 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        recpList.add(recpRecord6);
    
        insert recpList;
    
    
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('共通ケース','住所変更',recpList[0].id));    
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('生命専用ケース','住所変更',recpList[0].id));
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','控除証明再発行',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','解約（火災）',recpList[0].id));     
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','解約（火災）',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','解約（ジャンプ・積立・その他）',recpList[0].id));
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','対象所在地変更（火災・満期戻）',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','全損失効',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','質権設定・削除',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','被保険者変更',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('損保専用ケース','被保険者変更',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','少短事故受付',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','少短事故受付(賠責）',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','保険金関連（事故受付以外）',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','更新変更',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','更新拒否_少短',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','解約_少短',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','振込用紙再送',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','住所変更',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','証券類・更新案内再送',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','申込内容変更・新規多頭対応',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','契約内容変更',recpList[0].id)); 
        reqList.add(RequestTriggerTestHandler.RequestTriggerTest('少短専用ケース','汎用（少短）',recpList[0].id)); 
        
        if(reqList.size()>0){
            insert reqList;
        }   

    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('共通ケース','住所変更',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('生命専用ケース','保険金・給付金・共済金請求',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','控除証明再発行',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','解約（火災）',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','解約（ジャンプ・積立・その他）',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','対象所在地変更（火災・満期戻）',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','全損失効',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('損保専用ケース','質権設定・削除',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','少短事故受付',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','少短事故受付(賠責）',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','保険金関連（事故受付以外）',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','更新変更',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','更新拒否_少短',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','解約_少短',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','振込用紙再送',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','証券類・更新案内再送',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','申込内容変更・新規多頭対応',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','契約内容変更',recpList[0].id)); 
    reqRecordUpdateList.add(RequestTriggerTestHandler.RequestTriggerUpdate('少短専用ケース','汎用（少短）',recpList[0].id)); 
    
    system.debug('----------boolean value----'+reqRecordUpdateList[0].ReflectMailingAddress__c);
        if(reqRecordUpdateList.size()>0){
            update reqRecordUpdateList;
        }
        }
    
 
 }