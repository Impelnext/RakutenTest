/**
 * Class containing tests for SMSInfoCmpController
 */
@IsTest public with sharing class SMSInfoCmpControllerTest {


    // @IsTest(SeeAllData=true) static void testRegistration() {
    @IsTest 
    static void testRegistration() {
        SMSInfoCmpControllerTest controllertest = new SMSInfoCmpControllerTest();
        Account ac =  controllertest.createAccount();
        insert ac;
        Account ac2 =  controllertest.createAccount2();
        insert ac2;
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        SMSInfo__c info2 = controllertest.createSMSInfo2();
        insert info2;
        SMSInfo__c info3 = controllertest.createSMSInfo3();
        insert info3;
        SMSInfo__c info4 = controllertest.createSMSInfo3();
        insert info4;
        SMSInfo__c info5 = controllertest.createSMSInfo3();
        insert info5;

        User us = controllertest.createUser();
        insert us;
        User us2 = controllertest.createUser2();
        insert us2;

        // 作成したユーザで処理を実行
        System.runAs(us){
            SMSInfo__c info6 = controllertest.createSMSInfo6(us2);
//            insert info6;
        }
        SMSInfo__c info7 = controllertest.createSMSInfo7(us2);
//        insert info7;
        
        
        Test.startTest();   
        SMSInfoCmpController aa = new SMSInfoCmpController();  
        Account nonAct;
        
        string str = SMSInfoCmpController.hasEditAuthor();     // 編集権限チェック
        Account testAct = SMSInfoCmpController.getAccount(ac.Id); // 取引先情報取得
        SMSInfo__c testInfo = SMSInfoCmpController.getSMSInfo(info.Id); // SMS送信情報取得
        
        string rtnstr1;
        rtnstr1 = SMSInfoCmpController.checkSave(ac, info, '承認済み');    // 保存処理前チェック
        rtnstr1 = SMSInfoCmpController.checkSave(ac, info4, '下書き');    // 保存処理前チェック
        info5.DestinationPhoneNumber__c = '000-0000-00000';
        info5.Status__c = '下書き';
        rtnstr1 = SMSInfoCmpController.checkSave(ac, info5, '下書き');    // 保存処理前チェック
        info5.DestinationPhoneNumber__c = null;
        rtnstr1 = SMSInfoCmpController.checkSave(ac, info5, '下書き');    // 保存処理前チェック
        
        rtnstr1 = SMSInfoCmpController.checkSave(nonAct, info3, '');
        rtnstr1 = SMSInfoCmpController.checkSave(ac2, info, '承認済み');    // 保存処理前チェック
        rtnstr1 = SMSInfoCmpController.checkSave(ac, info, '送信済み(成功)');    // 保存処理前チェック
        info.ApprovalUser__c = us.Id;
        info.Status__c = '承認済み';
        rtnstr1 = SMSInfoCmpController.checkSave(ac2, info, '承認済み');    // 保存処理前チェック
        info.ApprovalUser__c = UserInfo.getUserId();
        rtnstr1 = SMSInfoCmpController.checkSave(ac2, info, '承認済み');    // 保存処理前チェック
        
        List<String> rtnList;
        rtnList = SMSInfoCmpController.doSaveSMSInfo(info, ac); // 保存処理
        rtnList = SMSInfoCmpController.doSaveSMSInfo(info, nonAct); // 保存処理
        info.Branch_smsid__c = null;
        rtnList = SMSInfoCmpController.doSaveSMSInfo(info, null); // 保存処理

        string rtnstr7;
        rtnstr7 = SMSInfoCmpController.checkSave(ac, info7, '下書き');    // 保存処理前チェック
        rtnstr7 = SMSInfoCmpController.checkSave(ac2, info7, '下書き');    // 保存処理前チェック
        rtnstr7 = SMSInfoCmpController.checkSave(null, info7, '下書き');    // 保存処理前チェック
        rtnstr7 = SMSInfoCmpController.checkSave(ac, info7, '承認済み');    // 保存処理前チェック
        rtnstr7 = SMSInfoCmpController.checkSave(ac, info7, 'リトライ中');    // 保存処理前チェック
        info5.Status__c = 'リトライ中';
        rtnstr7 = SMSInfoCmpController.checkSave(ac, info5, '承認済み');    // 保存処理前チェック
        rtnstr7 = SMSInfoCmpController.checkSave(ac, info5, 'リトライ中');    // 保存処理前チェック

        Test.stopTest();        
    }
  
    
     private account createAccount(){
        return new Account(
            Name='TEST',
            SMSPermissionFlgLife__c=TRUE,
            SMSPermissionFlgSonpo__c=TRUE,
            SMSPermissionFlgLittle__c=TRUE
            //PersonMobilePhone='00000000000'
            //furigana__c=0
        );
    }
    
    private account createAccount2(){
        return new Account(
            Name='TEST',
            SMSPermissionFlgLife__c=FALSE,
            SMSPermissionFlgSonpo__c=FALSE,
            SMSPermissionFlgLittle__c=FALSE
            //PersonMobilePhone='00000000000'
            //furigana__c=0
        );
    }
    
    private SMSInfo__c createSMSInfo(){
        return new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000'
        );
    }
    
    private SMSInfo__c createSMSInfo2(){
        return new SMSInfo__c(
            Name='TEST',
            Branch_smsid__c=null,
            //SMSpermissionFlg__c=TRUE,
            DestinationPhoneNumber__c='00000000000'
        );
    }
    
    private SMSInfo__c createSMSInfo3(){
        return new SMSInfo__c(
            Name='TEST',
            //SMSPermissionFlg__c=FALSE,
            DestinationPhoneNumber__c='00000000000'
        );
    }
    
    private SMSInfo__c createSMSInfo4(){
        return new SMSInfo__c(
            Name='TEST',
            Status__c='承認済み',
            DestinationPhoneNumber__c='00000000000'
        );
    }
    
    private SMSInfo__c createSMSInfo5(){
        return new SMSInfo__c(
            Name='TEST',
            Status__c='リトライ中中',
            DestinationPhoneNumber__c='00000000000'
        );
    }

    private SMSInfo__c createSMSInfo6(User us){
        return new SMSInfo__c(
            Name='TEST',
            ApprovalUser__c = us.Id,
            DestinationPhoneNumber__c='00000000000'
        );
    }

    private SMSInfo__c createSMSInfo7(User us){
        return new SMSInfo__c(
            Name='TEST',
            Status__c='下書き',
            ApprovalUser__c = us.Id,
            DestinationPhoneNumber__c='00000000000',
            Branch_smsid__c = null
        );
    }

    private User createUser(){

        // get profile
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard User', '標準ユーザ')];
        System.assert(profiles.size() > 0);

        return new User(
             LastName = 'LastName'
            ,Alias = 'Alias'
            ,Email = 'user@example.com'
            ,Username = 'ChatTest3@rakuten.com.test'
            ,CommunityNickname = 'TestUser'
            ,EmailEncodingKey = 'ISO-2022-JP'
            ,TimeZoneSidKey = 'Asia/Tokyo'
            ,LocaleSidKey = 'ja_JP'
            ,LanguageLocaleKey = 'ja'
            ,ProfileId = profiles.get(0).Id
        );
    }

    private User createUser2(){

        // get profile
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard User', '標準ユーザ')];
        System.assert(profiles.size() > 0);

        return new User(
             LastName = 'LastName2'
            ,Alias = 'Alias2'
            ,Email = 'user2@example.com'
            ,Username = 'ChatTest4@rakuten.com.test'
            ,CommunityNickname = 'TestUser2'
            ,EmailEncodingKey = 'ISO-2022-JP'
            ,TimeZoneSidKey = 'Asia/Tokyo'
            ,LocaleSidKey = 'ja_JP'
            ,LanguageLocaleKey = 'ja'
            ,ProfileId = profiles.get(0).Id
        );
    }


    /*
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
        */
}