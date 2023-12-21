public without sharing class ExC_LimitedAccessUtility {

    public class LoginInfo {
        Boolean IsSuccess;
        String Message;
        String LoginKey;
        String LoginPassword;
        String GuidanceCustomerName;
        String GuidanceMessage;
        String InsuranceCompany;
    }
    public class UpdateInfo {
        Boolean IsSuccess;
        String Message;
    }

    public static LoginInfo checkURLPassword(String key, String pass){

        LoginInfo login = new LoginInfo();
        login.IsSuccess = false;
        login.LoginKey = key;
        login.LoginPassword = pass;

        // ハッシュ値が一致する期限付きURL取得
		URLWithLimit__c[] uwl_s = [
            SELECT
            Id,
            HashValue__c,
            Status__c,
            Password__c,
            LastName__c,
            FirstName__c,
            LimitTime__c,
            TryCount__c,
            InsuranceCompany__c,
            ContactCenterInputArea__c,
            CustomerInputArea__c
            FROM URLWithLimit__c
            WHERE HashValue__c = :key
        ];
        if (uwl_s.size() != 1) {
        	login.Message = 'URLが無効です';
            return login;
        }

        URLWithLimit__c uwl = uwl_s[0];
        ExC_URLWithLimitEvent__e evt = new ExC_URLWithLimitEvent__e();
        evt.HashValue__c = uwl.HashValue__c;
        evt.TryCount__c = uwl.TryCount__c;
        evt.CustomerInputArea__c = uwl.CustomerInputArea__c;

        String InsuranceCompany = uwl.InsuranceCompany__c;

        Datetime current = Datetime.now();
        if (current.getTime() > uwl.LimitTime__c.getTime()) {
        	// 有効期限が過去日付の場合
        	login.Message = 'URLが無効です';
        } else if (uwl.TryCount__c >= 5) {
        	// 試行回数が5回以上の場合
        	login.Message = 'URLが無効です';
            evt.Status__c = '試行回数上限';
        } else if (!pass.equals(uwl.Password__c)) {
            // パスワード不一致の場合
            evt.TryCount__c++;
            if (evt.TryCount__c >= 5) {
        		// 試行回数が5回以上になった場合
                if (InsuranceCompany == '楽天生命'){
                    evt.Status__c = '試行回数上限';
                    login.Message = 'ログイン試行の回数が上限を超えました。\r\n'+
                                    'お手数ですが以下にご連絡ください。\r\n\r\n'+
                                    '　保険金・給付金のご請求に関するお問合せ\r\n'+
                                    '　0120-949-132\r\n'+
                                    '　保険金・給付金のご請求以外に関するお問合せ\r\n'+
                                    '　0120‐479‐142\r\n'+
                                    '　受付時間：9:00～18:00（年末年始を除く）';
                }
                else if (InsuranceCompany == '楽天損保') {
                    evt.Status__c = '試行回数上限';
                    login.Message = 'ログイン試行の回数が上限を超えました。\r\n'+
                                    'お手数ですが以下にご連絡ください。\r\n\r\n'+
                                    '　自動車保険に関するお問合せ\r\n'+
                                    '　0120-479-164\r\n'+
                                    '　自動車保険以外その他に関するお問合せ\r\n'+
                                    '　0120‐479‐179\r\n'+
                                    '　受付時間：9:00～18:00（年末年始を除く）';
                }
                else {
                    evt.Status__c = '試行回数上限';
                    login.Message = 'ログイン試行の回数が上限を超えました。\r\n'+
                                    'お手数ですが以下にご連絡ください。\r\n\r\n'+
                                    '　0120-987-014\r\n'+
                                    '　受付時間：9:00～18:00（年末年始を除く）';
                }
            } else {
            	login.Message = 'パスワードが違います';
            }
        } else {
        	// パスワード一致
        	evt.TryCount__c = 0;
        	login.IsSuccess = true;
            login.Message = '';
        	login.GuidanceCustomerName = uwl.LastName__c + '　' + uwl.FirstName__c;
            login.GuidanceMessage = uwl.ContactCenterInputArea__c;
            login.InsuranceCompany = uwl.InsuranceCompany__c;
        }

        Database.SaveResult res = EventBus.publish(evt);
        if (!res.isSuccess()) {
            login.IsSuccess = false;
            login.Message = 'エラーが発生しました、再度試して同じ事象が発生するようであれば窓口までお問い合わせください。';
            login.Message += ' エラー内容：' + res.getErrors()[0].getMessage();
        }

        return login;
    }

    public static UpdateInfo updateURLWithLimited(String key, String pass, String jsonData){

        UpdateInfo upd = new UpdateInfo();
        upd.IsSuccess = false;

        // ハッシュ値が一致する期限付きURL取得
		URLWithLimit__c[] uwl_s = getURLWithLimit(key);
        if (uwl_s.size() != 1) {
        	upd.message = 'URLが無効です';
            return upd;
        }

        URLWithLimit__c uwl = uwl_s[0];
        ExC_URLWithLimitEvent__e evt = new ExC_URLWithLimitEvent__e();
        evt.HashValue__c = uwl.HashValue__c;
        evt.TryCount__c = uwl.TryCount__c;

        Datetime current = Datetime.now();
        if (current.getTime() > uwl.LimitTime__c.getTime()) {
        	// 有効期限が過去日付の場合
        	upd.message = 'URLが無効です';
        } else if (uwl.TryCount__c >= 5) {
        	// 試行回数が5回以上の場合
        	upd.message = 'URLが無効です';
            evt.Status__c = '試行回数上限';
        } else if (!pass.equals(uwl.Password__c)) {
            // パスワード不一致の場合
        	upd.message = 'URLが無効です';
            evt.TryCount__c++;
        } else {
        	// パスワード一致
        	upd.IsSuccess = true;
            upd.message = '';
            Map<String, Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(jsonData);
            evt.CustomerInputArea__c = (String)dataMap.get('CustomerQuestion');
            evt.Status__c = '顧客回答済み';
        }

        Database.SaveResult res = EventBus.publish(evt);
        if (!res.isSuccess()) {
            upd.IsSuccess = false;
            upd.message = 'エラーが発生しました、再度試して同じ事象が発生するようであればシステム管理者にお問い合わせください。';
            upd.message += ' エラー内容：' + res.getErrors()[0].getMessage();
        }
        return upd;
    }

    static URLWithLimit__c[] getURLWithLimit(string key){
         URLWithLimit__c[] uwl_s = [
            SELECT
            Id,
            HashValue__c,
            Status__c,
            Password__c,
            LimitTime__c,
            TryCount__c
            FROM URLWithLimit__c
            WHERE HashValue__c = :key
        ];
        return uwl_s;
    }

    public static string checkURLPasswordForUpFile(String key, String pass){

        // ハッシュ値が一致する期限付きURL取得
		URLWithLimit__c[] uwl_s = [
            SELECT
            Id,
            HashValue__c,
            Status__c,
            Password__c,
            LastName__c,
            FirstName__c,
            LimitTime__c,
            TryCount__c,
            ContactCenterInputArea__c,
            Case__c
            FROM URLWithLimit__c
            WHERE HashValue__c = :key
        ];
        if (uwl_s.size() != 1) {
            return null;
        }
        return uwl_s[0].Case__c;
    }

    // プロセスID生成
    static String charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_';
    static Integer ProcessIdLen = 13;

    public static String issueSiteProcessId() {

        Double rnd;
        Integer idx;
        String processid = '';

        for (Integer i = 0; i < ProcessIdLen; i++) {
            rnd = charList.length() * Math.random();
            idx = rnd.intValue();
            processid += charList.substring(idx, idx + 1);
        }

        return processid;
    }

    public static String getInquiryNoByProcessId(String processId) {
		String inquiryNo;

        system.debug('processId: '+ processId);
        FormInquiryInformation__c[] lst = [select Name from FormInquiryInformation__c where SiteProcessId__c = :processId];

		if(lst.size()==1 && lst[0].Name !=null ) inquiryNo = lst[0].Name;
        return inquiryNo;
    }
}