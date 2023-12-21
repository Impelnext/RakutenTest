@isTest(SeeAllData=true)
public class ExC_FormProcedureControllerTest {

    class Personal {
        String Address;
        String ConfBasicInfoBirthday;
        String ConfBasicInfoEmail;
        String ConfBasicInfoFuriganaFirstName;
        String ConfBasicInfoFuriganaLastName;
        String ConfBasicInfoKanjiFirstName;
        String ConfBasicInfoKanjiLastName;
        String ConfBasicInfoPolicyNum;
        String ConfCompanyName;
        String DaytimePhoneNumber;
        String ModAddHomePhoneNum;
        String ModAddMobilePhoneNum;
        String ModEmail;
        String ModFuriganaLastName;
        String ModLastName;
        String MoveDay;
        String OtherAddress;
        String PostCode;
        String Prefectures;
        String ProcedureType;
        String RegisteredPhoneNumber;
        Boolean isModAddHomephone;
        Boolean isModAddress;
        Boolean isModEmail;
        Boolean isModLastName;
    }

    class Payment {
        String Address;
        String CancelInsurance1;
        String CancelInsurance2;
        String CancelInsurance3;
        String CancelInsurance4;
        String CancelInsurance5;
        String CancelInsurance6;
        String CancelInsurance7;
        String CancelInsurance8;
        String CancelInsurance9;
        String CancelInsurance10;
        String CancelInsurance11;
        String CancelInsurance12;
        String CancelInsurance13;
        String CancelInsurance14;
        String CancelInsurance15;
        String CancelInsurance16;
        String CancelInsurance17;
        String CancelInsurance18;
        String CancelInsurance19;
        String CancelInsurance20;
        String ConfBasicInfoBirthday;
        String ConfBasicInfoEmail;
        String ConfBasicInfoFuriganaFirstName;
        String ConfBasicInfoFuriganaLastName;
        String ConfBasicInfoKanjiFirstName;
        String ConfBasicInfoKanjiLastName;
        String ConfCompanyName;
        String DaytimePhoneNumber;
        String ModAddHomePhoneNum;
        String ModAddMobilePhoneNum;
        String ModFuriganaLastName;
        String ModLastName;
        String ModPaymentMethod;
        String MoveDay;
        String OtherAddress;
        String PostCode;
        String Prefectures;
        String ProcedureType;
        String RegisteredPhoneNumber;
        Boolean isModAddHomephone;
        Boolean isModAddress;
        Boolean isModLastName;
    }

    class Reissue {
        String Address;
        String ConfBasicInfoBirthday;
        String ConfBasicInfoEmail;
        String ConfBasicInfoFuriganaFirstName;
        String ConfBasicInfoFuriganaLastName;
        String ConfBasicInfoKanjiFirstName;
        String ConfBasicInfoKanjiLastName;
        String ConfBasicInfoPolicyNum;
        String ConfCompanyName;
        String DaytimePhoneNumber;
        String InfoReissueYear1;
        String InfoReissueYear2;
        String InfoReissueYear3;
        String InfoReissueYear4;
        String InfoReissueYear5;
        String ModAddHomePhoneNum;
        String ModAddMobilePhoneNum;
        String ModFuriganaLastName;
        String ModLastName;
        String MoveDay;
        String OtherAddress;
        String PostCode;
        String Prefectures;
        String ProcedureType;
        String RegisteredPhoneNumber;
        Boolean isModAddHomephone;
        Boolean isModAddress;
        Boolean isModLastName;
    }

    class Cancellation {
        String Address;
        String CancelInsurance1;
        String CancelInsurance2;
        String CancelInsurance3;
        String CancelInsurance4;
        String CancelInsurance5;
        String CancelInsurance6;
        String CancelInsurance7;
        String CancelInsurance8;
        String CancelInsurance9;
        String CancelInsurance10;
        String CancelInsurance11;
        String CancelInsurance12;
        String CancelInsurance13;
        String CancelInsurance14;
        String CancelInsurance15;
        String CancelInsurance16;
        String CancelInsurance17;
        String CancelInsurance18;
        String CancelInsurance19;
        String CancelInsurance20;
        String CancelProduct1;
        String CancelProduct2;
        String CancelProduct3;
        String CancelProduct4;
        String CancelProduct5;
        String CancelReason1;
        String CancelReason2;
        String CancelReason3;
        String ConfBasicInfoBirthday;
        String ConfBasicInfoEmail;
        String ConfBasicInfoFuriganaFirstName;
        String ConfBasicInfoFuriganaLastName;
        String ConfBasicInfoKanjiFirstName;
        String ConfBasicInfoKanjiLastName;
        String ConfCompanyName;
        String ConfRefundAccInfoAccNum;
        String ConfRefundAccInfoBank;
        String ConfRefundAccInfoBranch;
        String ConfRefundAccInfoDepoType;
        String ConfRefundAccInfoPassbookNum;
        String ConfRefundAccInfoPassbookSymbol;
        String ConfRefundCard;
        String ConfRefundProductNote;
        String ConfRefundPtAccInfoAccNum;
        String ConfRefundPtAccInfoBank;
        String ConfRefundPtAccInfoBranch;
        String ConfRefundPtAccInfoDepoType;
        String ConfRefundPtAccInfoPassbookNum;
        String ConfRefundPtAccInfoPassbookSymbol;
        String DaytimePhoneNumber;
        String ModAddHomePhoneNum;
        String ModAddMobilePhoneNum;
        String ModFuriganaLastName;
        String ModLastName;
        String MoveDay;
        String OtherAddress;
        String PostCode;
        String Prefectures;
        String ProcedureType;
        String RegisteredPhoneNumber;
        Boolean isModAddHomephone;
        Boolean isModAddress;
        Boolean isModLastName;
    }
    
    @isTest
    static void testcase01() {
    
        Personal prc = new Personal();
        prc.Address = '金沢市松島１丁目';
        prc.ConfBasicInfoBirthday = '1996/05/13';
        prc.ConfBasicInfoEmail = 'test@rakuten.jp';
        prc.ConfBasicInfoFuriganaFirstName = 'タロウ';
        prc.ConfBasicInfoFuriganaLastName = 'ラクテン';
        prc.ConfBasicInfoKanjiFirstName = '太郎';
        prc.ConfBasicInfoKanjiLastName = '楽天';
        prc.ConfBasicInfoPolicyNum = '12345678';
        prc.ConfCompanyName = '楽天生命';
        prc.DaytimePhoneNumber = '';
        prc.ModAddHomePhoneNum = '0312345678';
        prc.ModAddMobilePhoneNum = '';
        prc.ModEmail = 'modify@rakuten.jp';
        prc.ModFuriganaLastName = 'ホケン';
        prc.ModLastName = '保険';
        prc.MoveDay = '';
        prc.OtherAddress = '３７番地';
        prc.PostCode = '9201234';
        prc.Prefectures = '石川県';
        prc.ProcedureType = 'ご住所・連絡先番号・お名前（改姓）・メールアドレス変更';
        prc.RegisteredPhoneNumber = '09012345678';
        prc.isModAddHomephone = true;
        prc.isModAddress = true;
        prc.isModEmail = true;
        prc.isModLastName = true;
                
        Test.startTest();
        
        ExC_FormProcedureController.publishPlatformEvent(JSON.serialize(prc));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormProcedureEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
    
    }

    @isTest
    static void testcase02() {

        Payment prc = new Payment();
        prc.Address = '金沢市松島1丁目';
        prc.CancelInsurance1 = '11111111';
        prc.CancelInsurance2 = '22222222';
        prc.CancelInsurance3 = '33333333';
        prc.CancelInsurance4 = '44444444';
        prc.CancelInsurance5 = '5555555555';
        prc.CancelInsurance6 = '6666666666';
        prc.CancelInsurance7 = '77777777';
        prc.CancelInsurance8 = '88888888';
        prc.CancelInsurance9 = '9999999999';
        prc.CancelInsurance10 = '';
        prc.CancelInsurance11 = '';
        prc.CancelInsurance12 = '';
        prc.CancelInsurance13 = '';
        prc.CancelInsurance14 = '';
        prc.CancelInsurance15 = '';
        prc.CancelInsurance16 = '';
        prc.CancelInsurance17 = '';
        prc.CancelInsurance18 = '';
        prc.CancelInsurance19 = '';
        prc.CancelInsurance20 = '';
        prc.ConfBasicInfoBirthday = '1996/05/13';
        prc.ConfBasicInfoEmail = 'test@rakuten.jp';
        prc.ConfBasicInfoFuriganaFirstName = 'タロウ';
        prc.ConfBasicInfoFuriganaLastName = 'ラクテン';
        prc.ConfBasicInfoKanjiFirstName = '太郎';
        prc.ConfBasicInfoKanjiLastName = '楽天';
        prc.ConfCompanyName = '楽天生命';
        prc.DaytimePhoneNumber = '08012345678';
        prc.ModAddHomePhoneNum = '';
        prc.ModAddMobilePhoneNum = '07012345678';
        prc.ModFuriganaLastName = '';
        prc.ModLastName = '';
        prc.ModPaymentMethod = '口座振替';
        prc.MoveDay = '2022/12/10';
        prc.OtherAddress = '３７番地';
        prc.PostCode = '9200364';
        prc.Prefectures = '石川県';
        prc.ProcedureType = 'お支払方法の変更';
        prc.RegisteredPhoneNumber = '09012345678';
        prc.isModAddHomephone = true;
        prc.isModAddress = true;
        prc.isModLastName = false;

        Test.startTest();
        
        ExC_FormProcedureController.publishPlatformEvent(JSON.serialize(prc));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormProcedureEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
    }

    @isTest
    static void testcase03() {

        Schema.DescribeFieldResult years = FormProcedureInformation__c.ReissueYears__c.getDescribe();
        List<Schema.PicklistEntry> yearlist = years.getPicklistValues();

        Reissue prc = new Reissue();
        prc.Address = '金沢市松島１丁目';
        prc.ConfBasicInfoBirthday = '1996/05/13';
        prc.ConfBasicInfoEmail = 'test@rakuten.jp';
        prc.ConfBasicInfoFuriganaFirstName = 'タロウ';
        prc.ConfBasicInfoFuriganaLastName = 'ラクテン';
        prc.ConfBasicInfoKanjiFirstName = '太郎';
        prc.ConfBasicInfoKanjiLastName = '楽天';
        prc.ConfBasicInfoPolicyNum = '12345678';
        prc.ConfCompanyName = '楽天生命';
        prc.DaytimePhoneNumber = '';
        prc.InfoReissueYear1 = yearlist[0].getValue().replace('年度', '');
        prc.InfoReissueYear2 = '';
        prc.InfoReissueYear3 = yearlist[2].getValue().replace('年度', '');
        prc.InfoReissueYear4 = '';
        prc.InfoReissueYear5 = '';
        prc.ModAddHomePhoneNum = '0312345678';
        prc.ModAddMobilePhoneNum = '';
        prc.ModFuriganaLastName = 'ホケン';
        prc.ModLastName = '保険';
        prc.MoveDay = '';
        prc.OtherAddress = '３７番地';
        prc.PostCode = '9201234';
        prc.Prefectures = '石川県';
        prc.ProcedureType = '控除証明書の再発行';
        prc.RegisteredPhoneNumber = '';
        prc.isModAddHomephone = true;
        prc.isModAddress = true;
        prc.isModLastName = true;
       
        Test.startTest();
        
        ExC_FormProcedureController.publishPlatformEvent(JSON.serialize(prc));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormProcedureEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
    
    }

    @isTest
    static void testcase04() {
        Cancellation prc = new Cancellation();
        prc.Address = '金沢市松島1丁目';
        prc.CancelInsurance1 = '11111111';
        prc.CancelInsurance2 = '22222222';
        prc.CancelInsurance3 = '33333333';
        prc.CancelInsurance4 = '44444444';
        prc.CancelInsurance5 = '55555555';
        prc.CancelInsurance6 = '66666666';
        prc.CancelInsurance7 = '77777777';
        prc.CancelInsurance8 = '88888888';
        prc.CancelInsurance9 = '99999999';
        prc.CancelInsurance10 = '';
        prc.CancelInsurance11 = '';
        prc.CancelInsurance12 = '';
        prc.CancelInsurance13 = '';
        prc.CancelInsurance14 = '';
        prc.CancelInsurance15 = '';
        prc.CancelInsurance16 = '';
        prc.CancelInsurance17 = '';
        prc.CancelInsurance18 = '';
        prc.CancelInsurance19 = '';
        prc.CancelInsurance20 = '';
        prc.CancelProduct1 = '終身・定期総合医療共済　／　メディエイド（旧メディ）';
        prc.CancelProduct2 = '';
        prc.CancelProduct3 = '重度障害共済　／　ライフエイド';
        prc.CancelProduct4 = '';
        prc.CancelProduct5 = '';
        prc.CancelReason1 = '現在の保険料が負担と感じるため';
        prc.CancelReason2 = '保障が過剰だと感じたため';
        prc.CancelReason3 = '楽天生命のサービスにご不安・不満足';
        prc.ConfBasicInfoBirthday = '1996/05/13';
        prc.ConfBasicInfoEmail = 'test@rakuten.jp';
        prc.ConfBasicInfoFuriganaFirstName = 'タロウ';
        prc.ConfBasicInfoFuriganaLastName = 'ラクテン';
        prc.ConfBasicInfoKanjiFirstName = '太郎';
        prc.ConfBasicInfoKanjiLastName = '楽天';
        prc.ConfCompanyName = '楽天生命';
        prc.ConfRefundAccInfoAccNum = '';
        prc.ConfRefundAccInfoBank = '';
        prc.ConfRefundAccInfoBranch = 'ゆうちょ銀行';
        prc.ConfRefundAccInfoDepoType = '';
        prc.ConfRefundAccInfoPassbookNum = '12345678';
        prc.ConfRefundAccInfoPassbookSymbol = '12345';
        prc.ConfRefundCard = 'true';
        prc.ConfRefundProductNote = 'false';
        prc.ConfRefundPtAccInfoAccNum = '';
        prc.ConfRefundPtAccInfoBank = '';
        prc.ConfRefundPtAccInfoBranch = '';
        prc.ConfRefundPtAccInfoDepoType = '';
        prc.ConfRefundPtAccInfoPassbookNum = '';
        prc.ConfRefundPtAccInfoPassbookSymbol = '';
        prc.DaytimePhoneNumber = '08012345678';
        prc.ModAddHomePhoneNum = '';
        prc.ModAddMobilePhoneNum = '07012345678';
        prc.ModFuriganaLastName = '';
        prc.ModLastName = '';
        prc.MoveDay = '2022/12/10';
        prc.OtherAddress = '３７番地';
        prc.PostCode = '9200364';
        prc.Prefectures = '石川県';
        prc.ProcedureType = 'ご契約の解約';
        prc.RegisteredPhoneNumber = '09012345678';
        prc.isModAddHomephone = true;
        prc.isModAddress = true;
        prc.isModLastName = false;

        Test.startTest();
        
        ExC_FormProcedureController.publishPlatformEvent(JSON.serialize(prc));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormProcedureEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
    
    }
}