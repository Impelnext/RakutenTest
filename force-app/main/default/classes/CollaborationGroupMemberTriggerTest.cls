@isTest(SeeAllData=true)
public with sharing class CollaborationGroupMemberTriggerTest {

    @isTest
    static void testcase01() {
        List<InsuranceCompanySet__mdt> companyList = [SELECT ChatterGroupName__c FROM InsuranceCompanySet__mdt];
        List<String> groupNameList = new List<String>();
        for (InsuranceCompanySet__mdt company: companyList) {
            groupNameList.add(company.ChatterGroupName__c);
        }
        String grpnm = companyList[0].ChatterGroupName__c;
        CollaborationGroup[] grp_s = [SELECT Id FROM CollaborationGroup WHERE Name = :grpnm];
        CollaborationGroup grp = (grp_s.size()==1)? grp_s[0] : new CollaborationGroup(Name=grpnm,CollaborationType = 'Public');
        if(grp.id==null)   insert grp;

        Profile p = [SELECT Id FROM Profile WHERE Name = '新会社業務委託ロール'];
        User u = [SELECT Id FROM User WHERE IsActive = true AND DefaultGroupNotificationFrequency != 'P' AND ProfileId =: p.Id LIMIT 1];

        Test.startTest();

        CollaborationGroupMember mb = new CollaborationGroupMember();
        mb.CollaborationGroupId = grp.Id;
        mb.CollaborationRole = 'Standard';
        mb.MemberId = u.Id;
        mb.NotificationFrequency = 'N';
        insert mb;

        CollaborationGroupMember newmb = [SELECT Id, NotificationFrequency FROM CollaborationGroupMember WHERE Id = : mb.Id];
        System.assertEquals('P', newmb.NotificationFrequency);
        Test.stopTest();
    
    }
}