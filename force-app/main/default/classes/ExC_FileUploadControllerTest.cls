@isTest
public class ExC_FileUploadControllerTest {

    class message {
        String CustomerQuestion;
        String pass;
        String key;
    }

    class login {
        Boolean IsSuccess;
        String Message;
        String LoginKey;
        String LoginPassword;
        String GuidanceCustomerName;
        String GuidanceMessage;
    }

    class updated {
        Boolean IsSuccess;
        String Message;
    }

    @isTest
    static void testcase01() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        String pid = ExC_FileUploadController.issueSiteProcessId(saveUwl.HashValue__c, saveUwl.Password__c);
        System.assertEquals(13, pid.length());

        String res = ExC_FileUploadController.checkURLPassword(saveUwl.HashValue__c, saveUwl.Password__c);
        login resobj = (login)JSON.deserialize(res, login.class);
        System.assert(resobj.IsSuccess);

        ExC_FileUploadController ctrl = new ExC_FileUploadController();
        ctrl.key = saveUwl.HashValue__c;
        ctrl.pass = saveUwl.Password__c;
        ctrl.fileName = 'testfile.png';
        ctrl.fileBody = EncodingUtil.urlEncode(EncodingUtil.base64Encode(Blob.valueOf('テストデータ')), 'UTF-8');
        ctrl.uploadFile();
        System.assert(ctrl.message.startsWith('filesize:'));

        message msg = new message();
        msg.CustomerQuestion = 'テスト';
        msg.key = saveUwl.HashValue__c;
        msg.pass = saveUwl.Password__c;
        String upd = ExC_FileUploadController.updateURLWithLimited(saveUwl.HashValue__c, saveUwl.Password__c, JSON.serialize(msg));
        updated updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(updobj.IsSuccess);

        Test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, Status__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.Status__c, '顧客回答済み');
    }

    @isTest
    static void testcase02() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(-1);
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        String res = ExC_FileUploadController.checkURLPassword('dummykey', saveUwl.Password__c);
        login resobj = (login)JSON.deserialize(res, login.class);
        System.assert(!resobj.IsSuccess);
        System.assertEquals('URLが無効です', resobj.Message);

        message msg = new message();
        msg.CustomerQuestion = 'テスト';
        msg.key = 'dummykey';
        msg.pass = saveUwl.Password__c;
        String upd = ExC_FileUploadController.updateURLWithLimited('dummykey', saveUwl.Password__c, JSON.serialize(msg));
        updated updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(!updobj.IsSuccess);
        System.assertEquals('URLが無効です', updobj.Message);

        res = ExC_FileUploadController.checkURLPassword(saveUwl.HashValue__c, saveUwl.Password__c);
        resobj = (login)JSON.deserialize(res, login.class);
        System.assert(!resobj.IsSuccess);
        System.assertEquals('URLが無効です', resobj.Message);

        msg.key = saveUwl.HashValue__c;
        upd = ExC_FileUploadController.updateURLWithLimited(saveUwl.HashValue__c, saveUwl.Password__c, JSON.serialize(msg));
        updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(!updobj.IsSuccess);
        System.assertEquals('URLが無効です', updobj.Message);

        test.stopTest();

    }

    @isTest
    static void testcase03() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 1;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        String res = ExC_FileUploadController.checkURLPassword(saveUwl.HashValue__c, 'dummypass');
        login resobj = (login)JSON.deserialize(res, login.class);
        System.assert(!resobj.IsSuccess);
        System.assertEquals('パスワードが違います', resobj.Message);
      
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 2);

    }

    @isTest
    static void testcase04() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 1;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        message msg = new message();
        msg.CustomerQuestion = 'テスト';
        msg.key = saveUwl.HashValue__c;
        msg.pass = 'dummypass';
        String upd = ExC_FileUploadController.updateURLWithLimited(saveUwl.HashValue__c, 'dummypass', JSON.serialize(msg));
        updated updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(!updobj.IsSuccess);
        System.assertEquals('URLが無効です', updobj.Message);
        
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 2);

    }

    @isTest
    static void testcase05() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 4;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        String res = ExC_FileUploadController.checkURLPassword(saveUwl.HashValue__c, 'dummypass');
        login resobj = (login)JSON.deserialize(res, login.class);
        System.assert(!resobj.IsSuccess);
        string expect_msg = 'ログイン試行の回数が上限を超えました。\r\n'+
                                    'お手数ですが以下にご連絡ください。\r\n\r\n'+
                                    '　0120-987-014\r\n'+
                                    '　受付時間：9:00～18:00（年末年始を除く）';
        System.assertEquals(expect_msg, resobj.Message);
      
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 5);

    }

    @isTest
    static void testcase06() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 2;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        message msg = new message();
        msg.CustomerQuestion = 'テスト';
        msg.key = saveUwl.HashValue__c;
        msg.pass = 'dummypass';
        String upd = ExC_FileUploadController.updateURLWithLimited(saveUwl.HashValue__c, 'dummypass', JSON.serialize(msg));
        updated updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(!updobj.IsSuccess);
        System.assertEquals('URLが無効です', updobj.Message);
        
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 3);

    }

    @isTest
    static void testcase07() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 5;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        String res = ExC_FileUploadController.checkURLPassword(saveUwl.HashValue__c, 'dummypass');
        login resobj = (login)JSON.deserialize(res, login.class);
        System.assert(!resobj.IsSuccess);
        System.assertEquals('URLが無効です', resobj.Message);
      
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 5);

    }

    @isTest
    static void testcase08() {

        RecordType recType = [
            SELECT Id
            FROM RecordType
            WHERE SobjectType = 'Case' AND DeveloperName = 'InquiryCase'
        ];

        Case cs = new Case();
        cs.RecordTypeId = recType.Id;
        insert cs;

        URLWithLimit__c uwl = new URLWithLimit__c();
        uwl.FuriganaLast__c = 'ラクテン';
        uwl.FuriganaFirst__c = 'タロウ';
        uwl.LastName__c = '楽天';
        uwl.FirstName__c = '太郎';
        uwl.CustomerInputArea__c = 'お客様ご入力欄';
        uwl.ContactCenterInputArea__c = '総合窓口入力欄';
        uwl.LimitTime__c = Datetime.now().addDays(1);
        uwl.TryCount__c = 5;
        uwl.Case__c = cs.Id;
        insert uwl;

        URLWithLimit__c saveUwl = [
            SELECT Id, Password__c, HashValue__c
            FROM URLWithLimit__c
            WHERE Id =: uwl.Id
        ];

        Test.startTest();

        message msg = new message();
        msg.CustomerQuestion = 'テスト';
        msg.key = saveUwl.HashValue__c;
        msg.pass = 'dummypass';
        String upd = ExC_FileUploadController.updateURLWithLimited(saveUwl.HashValue__c, 'dummypass', JSON.serialize(msg));
        updated updobj = (updated)JSON.deserialize(upd, updated.class);
        System.assert(!updobj.IsSuccess);
        System.assertEquals('URLが無効です', updobj.Message);
        
        test.stopTest();

        URLWithLimit__c resUwl = [
            SELECT Id, TryCount__c
            FROM URLWithLimit__c
            WHERE Id =: saveUwl.Id
        ];
        System.assertEquals(resUwl.TryCount__c, 5);

    }

}