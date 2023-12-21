@IsTest
public class DamageContractAccountAlertControllerTest {

    @IsTest
    public static void m1(){
        
        DamageContract__c dc = new DamageContract__c();
        insert dc;
        
        Account account = new Account();
        account.Name = 'test';
        insert account;
        
        Account c1 = DamageContractAccountAlertController.getAccountInfo(null);
        Account c2 = DamageContractAccountAlertController.getAccountInfo(account.Id);
    }
    
}