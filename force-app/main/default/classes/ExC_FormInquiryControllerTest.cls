@isTest(SeeAllData=true)
public with sharing class ExC_FormInquiryControllerTest {

    class Inquiry {
        String CompanyName;
        String ContentsOfInquiry;
        String InquiryType;
        String RelationshipWithContractor;
        String FuriganaLast;
        String FuriganaFirst;
        String LastName;
        String FirstName;
        String DaytimePhoneNumberRegistered;
        String DaytimePhoneNumber;
        String Birthday;
        String Email;
    }
    
    @isTest
    static void testcase01() {
    
        Inquiry inq = new Inquiry();
        inq.CompanyName = '楽天生命';
        inq.ContentsOfInquiry = 'テスト';
        inq.InquiryType = 'お申し込みのご相談';
		inq.RelationshipWithContractor = '契約者ご本人さま';
        inq.FuriganaLast = 'ラクテン';
        inq.FuriganaFirst = 'タロウ';
        inq.LastName = '楽天';
        inq.FirstName = '太郎';
        inq.DaytimePhoneNumberRegistered = 'On';
        inq.DaytimePhoneNumber = '08087654321';
        inq.Birthday = '1992/10/22';
        inq.Email = 'test@rakuten.jp';        
        
        Test.startTest();
        
        String procId = ExC_FormInquiryController.publishPlatformEvent(JSON.serialize(inq));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormInquiryEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
        
        FormInquiryInformation__c dat = [
            SELECT Id, Name
            FROM FormInquiryInformation__c 
            WHERE SiteProcessId__c =: procId
        ];
        String InqId = ExC_FormInquiryController.checkProcess(procId);
        System.assertEquals(dat.Name, InqId);

    }
    

    @isTest
    static void testcase01_error() {

        String errorText300Char = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
        String cmpnm = '楽天生命';
        String grpnm = '生命保全';
        CollaborationGroup[] grp_s = [SELECT Id FROM CollaborationGroup WHERE Name = :grpnm];
        if(grp_s.size()==0){
            insert new CollaborationGroup(Name=grpnm,CollaborationType = 'Public');
        }
        
        Inquiry inq = new Inquiry();
        inq.CompanyName = cmpnm;
        inq.ContentsOfInquiry = 'テスト';
        inq.InquiryType = errorText300Char;
		inq.RelationshipWithContractor = '契約者ご本人さま';
        inq.FuriganaLast = 'ラクテン';
        inq.FuriganaFirst = 'タロウ';
        inq.LastName = '楽天';
        inq.FirstName = '太郎';
        inq.DaytimePhoneNumberRegistered = 'On';
        inq.DaytimePhoneNumber = '08087654321';
        inq.Birthday = '1992/10/22';
        inq.Email = 'test@rakuten.jp';        
        
        Test.startTest();
        
        String procId = ExC_FormInquiryController.publishPlatformEvent(JSON.serialize(inq));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormInquiryEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();


    }

    @isTest
    static void testcase02() {
    
        Inquiry inq = new Inquiry();
        inq.CompanyName = '楽天生命';
        inq.ContentsOfInquiry = 'テスト';
        inq.InquiryType = '保険金・給付金のご請求';
		inq.RelationshipWithContractor = '契約者ご本人さま以外';
        inq.FuriganaLast = 'ラクテン';
        inq.FuriganaFirst = 'タロウ';
        inq.LastName = '楽天';
        inq.FirstName = '太郎';
        inq.DaytimePhoneNumberRegistered = '';
        inq.DaytimePhoneNumber = '08087654321';
        inq.Birthday = '1992/10/22';
        inq.Email = 'test@rakuten.jp';        
        
        Test.startTest();
        
        String procId = ExC_FormInquiryController.publishPlatformEvent(JSON.serialize(inq));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormInquiryEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
        
        FormInquiryInformation__c dat = [
            SELECT Id, Name
            FROM FormInquiryInformation__c 
            WHERE SiteProcessId__c =: procId
        ];
        String InqId = ExC_FormInquiryController.checkProcess(procId);
        System.assertEquals(dat.Name, InqId);
    
    }

    @isTest
    static void testcase03() {
    
        Inquiry inq = new Inquiry();
        inq.CompanyName = '楽天損保';
        inq.ContentsOfInquiry = 'テスト';
        inq.InquiryType = '自動車保険';
		inq.RelationshipWithContractor = '契約者ご本人さま以外';
        inq.FuriganaLast = 'ラクテン';
        inq.FuriganaFirst = 'タロウ';
        inq.LastName = '楽天';
        inq.FirstName = '太郎';
        inq.DaytimePhoneNumberRegistered = '';
        inq.DaytimePhoneNumber = '09087654321';
        inq.Birthday = '1992/10/22';
        inq.Email = 'test@rakuten.jp';        
        
        Test.startTest();
        
        String procId = ExC_FormInquiryController.publishPlatformEvent(JSON.serialize(inq));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormInquiryEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
        
        FormInquiryInformation__c dat = [
            SELECT Id, Name
            FROM FormInquiryInformation__c 
            WHERE SiteProcessId__c =: procId
        ];
        String InqId = ExC_FormInquiryController.checkProcess(procId);
        System.assertEquals(dat.Name, InqId);
    
    }

    @isTest
    static void testcase04() {
    
        Inquiry inq = new Inquiry();
        inq.CompanyName = '楽天ペット保険';
        inq.ContentsOfInquiry = 'テスト';
        inq.InquiryType = '保険金・給付金のご請求';
		inq.RelationshipWithContractor = '契約者ご本人さま';
        inq.FuriganaLast = 'ラクテン';
        inq.FuriganaFirst = 'タロウ';
        inq.LastName = '楽天';
        inq.FirstName = '太郎';
        inq.DaytimePhoneNumberRegistered = 'On';
        inq.DaytimePhoneNumber = '08087654321';
        inq.Birthday = '1992/10/22';
        inq.Email = 'test@rakuten.jp';        
        
        Test.startTest();
        
        String procId = ExC_FormInquiryController.publishPlatformEvent(JSON.serialize(inq));

		List<EventBusSubscriber> evt = [
            SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber 
			WHERE Topic='ExC_FormInquiryEvent__e' AND Type='ApexTrigger'
        ];
        System.assertEquals(evt.size(), 1);

        Test.stopTest();
        
        FormInquiryInformation__c dat = [
            SELECT Id, Name
            FROM FormInquiryInformation__c 
            WHERE SiteProcessId__c =: procId
        ];
        String InqId = ExC_FormInquiryController.checkProcess(procId);
        System.assertEquals(dat.Name, InqId);
   
    }
}