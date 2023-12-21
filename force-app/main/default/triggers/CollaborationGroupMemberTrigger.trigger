trigger CollaborationGroupMemberTrigger on CollaborationGroupMember (before insert) {

    // カスタムメタデータからChatterグループ名の一覧を取得
    List<InsuranceCompanySet__mdt> companyList = [SELECT ChatterGroupName__c FROM InsuranceCompanySet__mdt];
    List<String> groupNameList = new List<String>();
    for (InsuranceCompanySet__mdt company: companyList) {
        groupNameList.add(company.ChatterGroupName__c);
    }
    
    // Chatterグループ名からグループIDを取得
    Map<Id, CollaborationGroup> groupMap = new Map<Id, CollaborationGroup>([SELECT Id FROM CollaborationGroup WHERE Name IN :groupNameList]);
    for (CollaborationGroupMember n: Trigger.new) {
		// 何れかのグループメンバーの場合
        if (groupMap.containsKey(n.CollaborationGroupId)) {
            n.NotificationFrequency = 'P';
        }
    }
}