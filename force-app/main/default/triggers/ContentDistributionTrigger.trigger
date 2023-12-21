trigger ContentDistributionTrigger on ContentDistribution (before insert, before update) {

    for (ContentDistribution cd: Trigger.new) {
        if (Trigger.isInsert) {
            cd.PreferencesPasswordRequired = true;
        }
        if (Trigger.isUpdate && cd.PreferencesPasswordRequired == false) {
            cd.addError('パスワードを有効にしてください。');
        }
    }
    
}