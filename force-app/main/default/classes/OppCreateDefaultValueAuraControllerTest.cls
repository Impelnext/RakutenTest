@isTest
public class OppCreateDefaultValueAuraControllerTest {
    
    @isTest
    static void execut1(){
        
        //取引先カナ名取得
        Account acc1 = createAccount();
        Insert acc1;
        List<Account> acclist =  [SELECT Id FROM Account WHERE furiganaLast__pc != null AND
                                  furiganaForst__pc != null LIMIT 1];
        Account acc = acclist[0];
        OppCreateDefaultValueAuraController.getAccFurigana((String)acc.get('Id'));   
        OppCreateDefaultValueAuraController.getAccFurigana('nulltest');
        
        //プロファイル取得テスト
        OppCreateDefaultValueAuraController.getRType();
    }
    
    private static Account createAccount(){
        return new Account(
            LastName='個人',
            FirstName='取引先',
            LastName__pc='個人',
            firstname__pc='取引先',
            furiganaLast__pc='こじん',
            furiganaForst__pc='とりひきさき');
    }
}