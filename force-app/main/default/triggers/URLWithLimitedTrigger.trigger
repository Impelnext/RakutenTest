trigger URLWithLimitedTrigger on URLWithLimit__c (Before Insert) {

    String password;
    String msg = 'エラーが発生しました、再度試して同じ事象が発生するようであればシステム管理者にお問い合わせください。';

    for (URLWithLimit__c uwl: trigger.new) {

        try {
            // 13桁のパスワードを生成
            password = URLPasswordUtility.generatePassword(13);

            // パスワードとハッシュ値を設定
            uwl.Password__c = password;
            uwl.HashValue__c = URLPasswordUtility.generateHash(password);

        } catch (Exception e) {
            System.debug(e.getMessage());
            uwl.addError(msg + ' エラー内容：' + e.getMessage());
        }
    }
}