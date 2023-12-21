public with sharing class ReceptionTriggerTestHandler {


        public void insertAccountRecord(){
            Account acc = new Account();
            insert acc;
        }

     public void insertRecptRecord(){
        Reception__c rec = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        rec.LF_Inquiry__c = true;
        insert rec;
        
        Reception__c rec1 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        rec1.LT_Inquiry__c = true;
        insert rec1;
        
        Reception__c rec2 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        rec2.DM_Inquiry__c = true;
       insert rec2;
       
       //negative when DM_Inquiry__c false
       Reception__c rec3 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        rec3.DM_Inquiry__c = false;
        insert rec3;
        
        Reception__c rec4 = new Reception__c(AdderssInputMethod__c='リクエストで指定');
        rec4.LT_Inquiry__c = false;
        insert rec4;
    }
    
    public void updateRecpRecord(){
        Reception__c recp = new Reception__c();
        recp = [select id,AdderssInputMethod__c  from Reception__c limit 1];
        system.debug('-----recp----'+recp);
        Account acc = new Account(firstName='太郎',lastName='楽天');
        insert acc;
        recp.AdderssInputMethod__c = '取引先から引用';
        recp.Account__c = acc.Id;
        recp.LF_Inquiry__c = true;
        update recp;
        }
    
    
    



}