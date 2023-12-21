@isTest
  public class Patch_Onyx_UpdateAccountTest {
      @isTest
      private static void testUpdateAccount1(){
          List<Account> acclst1 = batchTestData(null);
          test.startTest();
          //バーチ起動
          Patch_Onyx_UpdateAccount batchAcc = new  Patch_Onyx_UpdateAccount();
          database.executeBatch(batchAcc);
          test.stopTest();
          //確認
          System.assertEquals('生保契約者',[Select seihoAccoutType__c from Account where Id=:acclst1[0].Id][0].seihoAccoutType__c);
          System.assertEquals('生保契約者',[Select seihoAccoutType__c from Account where Id=:acclst1[0].Id][0].seihoAccoutType__c);
         
      }
      @isTest
      private static void testUpdateAccount2(){
          List<Account>acclst2 = batchTestData('生保代理店');
          test.startTest();
          //バーチ起動
          Patch_Onyx_UpdateAccount batchAcc = new  Patch_Onyx_UpdateAccount();
          database.executeBatch(batchAcc);
          test.stopTest();
          //確認
          System.assertEquals('生保契約者',[Select seihoAccoutType__c from Account where Id=:acclst2[0].Id][0].seihoAccoutType__c);
          System.assertEquals('生保契約者',[Select seihoAccoutType__c from Account where Id=:acclst2[0].Id][0].seihoAccoutType__c);
         
      }
    
      static List<Account> batchTestData(String accTyp){
       //return list def
       List<Account> accLst = new List<Account>(); 
           Account acc1 = new Account(
                LastName = 'Account 00',
                FirstName = 'Test',
                 csid__pc='REC001',
                 seihoAccoutType__c=accTyp
                
            );
          insert acc1;
          
          Account acc2 = new Account(
                LastName = 'Account 00',
                FirstName = 'Test',
                csid__pc='REC002',
                seihoAccoutType__c=accTyp
                
            );
          insert acc2;
          
          Account h=[select id from account where id=:acc1.id];
           LifeContract__c LifeContract1 = new LifeContract__c(
                Name = 'TEST ID 002',
               AccountId__c=h.id
                
             );
          insert LifeContract1;
          
          LifeContract__c LifeContract2 = new LifeContract__c(
                Name = 'TEST ID 002',
               AccountId__c=acc2.id
                
             );
          insert LifeContract2;
          //更新ー＞トリガー操業で変更した項目再編集
          acc1.seihoAccoutType__c=null;
          update acc1;
          acc2.seihoAccoutType__c='生保代理店';
          update acc2;
          accLst.add(acc1);accLst.add(acc2);
          return accLst;
       }
}