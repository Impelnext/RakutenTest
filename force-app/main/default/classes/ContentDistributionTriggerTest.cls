@isTest
public with sharing class ContentDistributionTriggerTest {

    @isTest
    static void testcase01() {

        ContentVersion ver = new ContentVersion();
        ver.Title = 'test';
        ver.PathOnClient = 'test.png';
        ver.VersionData = Blob.valueOf('テストデータ');
        ver.IsMajorVersion = false;
        insert ver;

        Test.startTest();
        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'テスト';
        cd.ContentVersionId = ver.Id;
        cd.PreferencesExpires = true;
        cd.PreferencesPasswordRequired = false;
        cd.ExpiryDate = Datetime.now().addDays(5);
        insert cd;
        ContentDistribution insCd = [SELECT Id, PreferencesPasswordRequired FROM ContentDistribution WHERE Id = :cd.Id];
        System.assertEquals(true, insCd.PreferencesPasswordRequired);

        insCd.PreferencesPasswordRequired = false;
        try {
            update insCd;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('パスワードを有効にしてください。'));
        }

        insCd.PreferencesPasswordRequired = true;
        update insCd;
        Test.stopTest();
    }
}