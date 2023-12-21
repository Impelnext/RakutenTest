global class BatchMaskPersonalData implements Database.Batchable<sObject> {

    private String strQuery { get; set; }
    private String strObjName { get; set; }
    private Map<String, String> maskFieldtypes;

    private static final String strKanaSrc = 'ア,イ,ウ,エ,オ,カ,キ,ク,ケ,コ,サ,シ,ス,セ,ソ,タ,チ,ツ,テ,ト,ナ,ニ,ヌ,ネ,ノ,ハ,ヒ,フ,ヘ,ホ,マ,ミ,ム,メ,モ,ヤ,ユ,ヨ,ラ,リ,ル,レ,ロ,ワ,ヲ,ン,ヴ,ガ,ギ,グ,ゲ,ゴ,ダ,ヂ,ヅ,デ,ド,バ,ビ,ブ,ベ,ボ,パ,ピ,プ,ペ,ポ,　';
    private static final String strKanaCon = 'ス,ホ,ク,ツ,ン,マ,レ,シ,ソ,ヤ,ニ,ヲ,ネ,イ,ヨ,ファ,ヲ,メ,カ,チ,ヘ,サ,ツ,オ,コ,セ,ケ,タ,ラ,ア,モ,ウ,ヲ,ク,ヒ,ン,ミ,ソ,ユ,ケ,サ,オ,キ,ヌ,モ,テ,ポ,ペ,プ,ピ,パ,ボ,ベ,ブ,ビ,バ,ヴ,ガ,ギ,グ,ゲ,ゴ,ダ,ヂ,ヅ,デ,ド, ';
    private Map<String, String> KanaMap;
    private Map<String, String> NumberMap;

    public BatchMaskPersonalData(Map<String, String> maskType, String query, String strobjname) {
        this.strQuery = query;
        this.strObjName = strobjname;
        System.debug(' BatchMaskPersonalData strObjName ' + strObjName);
        this.maskFieldtypes = maskType;
        System.debug(' BatchMaskPersonalData maskFieldtypes ' + maskFieldtypes);
        List<String> listKanaSrc = strKanaSrc.split(',');
        List<String> listKanaconv = strKanaCon.split(',');
        // Using Map constructor and List comprehension to create a map
        KanaMap = new Map<String, String>();
        for (Integer i = 0; i < listKanaSrc.size(); i++){
            KanaMap.put( listKanaSrc[i], listKanaconv[i]);
        }
        NumberMap = new Map<String, String>();
        NumberMap.put('0', '0');
        NumberMap.put('1', '6');
        NumberMap.put('2', '4');
        NumberMap.put('3', '9');
        NumberMap.put('4', '1');
        NumberMap.put('5', '3');
        NumberMap.put('6', '8');
        NumberMap.put('7', '7');
        NumberMap.put('8', '2');
        NumberMap.put('9', '5');
        NumberMap.put('-', '-');
        NumberMap.put('(', '(');
        NumberMap.put(')', ')');
        NumberMap.put('+', '+');
        NumberMap.put(' ', ' ');
        NumberMap.put('　', '　');
        NumberMap.put('ー', 'ー');
        NumberMap.put('‐', '‐');
        NumberMap.put('―', '―');
        NumberMap.put('－', '－');
        
        // {FirstName=K, LastName=H, PersonEmail=E, PersonHomePhone=N, PersonMobilePhone=N, furiganaForst__pc=K, furiganaLast__pc=K}
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query fields from Object
        System.debug(' BatchMaskPersonalData strQuery ' + strQuery);
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<SObject> recUpdate = new List<SObject>();
        Cleansing cleans = new Cleansing();
        try {
            for(sObject obj : scope) {
                
                // Get the SObject reference dynamically
                SObjectType objectType = Schema.getGlobalDescribe().get(strObjName);
                if (objectType != null) {
                    SObject objInstance = objectType.newSObject();
                    objInstance.Id = obj.Id;
                    String maskedValue = '';
                    // set field values:
                    for(String key : maskFieldtypes.keySet()) {
                        String maskType = maskFieldtypes.get(key);
                        String fieldValue = String.valueOf(obj.get(key));

                        if(null == fieldValue || String.isBlank(fieldValue)) {
                            continue;
                        }
                        
                        switch on maskType {
                            when  'H' {
                                maskedValue = getHashString(fieldValue);
                            }
                            when  'N' {
                                fieldValue = Cleansing.convert(fieldValue, Cleansing.NUMBER_MAP);
                                maskedValue = getNumberMasked(fieldValue);
                            }
                            when  'K' {
                                fieldValue = Cleansing.convert(fieldValue, Cleansing.KANA_MAP);
                                maskedValue = getKanaMasked(fieldValue);
                            }
                            when  'E' {
                                maskedValue = getEmailMasked(fieldValue);
                            }
                            when else {
                                fieldValue = Cleansing.convert(fieldValue, Cleansing.KANA_MAP);
                                fieldValue = Cleansing.convert(fieldValue, Cleansing.NUMBER_MAP);
                                maskedValue = getHashString(fieldValue);
                            }
                        }
                        if(null != maskedValue && '' != maskedValue) {
                            objInstance.put(key, maskedValue);
                        }
                    }
                    recUpdate.add(objInstance);
                    // System.debug('**** objInstance *' + objInstance);
                }
            }
        } finally {
            System.debug('**** recUpdate *' + recUpdate);
            if(recUpdate.size() != 0) {
                // Update the records in bulk
                Database.SaveResult[] updateResults = Database.update(recUpdate, false);

                // Process the results if needed
                for (Database.SaveResult result : updateResults) {
                    if (!result.isSuccess()) {
                        // Handle errors if necessary
                        for (Database.Error err : result.getErrors()) {
                            System.debug('Error updating record: ' + err.getMessage());
                        }
                    }
                }
                //Update recUpdate;
                recUpdate.clear();
                recUpdate = null;
            }
        }
    }

    global void finish(Database.BatchableContext BC) {

        try{ 
            // Create a new SingleEmailMessage
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            // Set the recipient email address
            email.setToAddresses(new String[]{'iyappan@impelnext.com'});

            // Set the email subject
            email.setSubject('Batch Process Completed: ' + strObjName);

            // Set the email body
            email.setPlainTextBody('The batch process has completed successfully.');

            // Send the email
            // Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            
        } finally {
            strQuery='';
            strObjName ='';
            maskFieldtypes.clear();
            maskFieldtypes = null;
        }
    }

    private String getHashString(String strVal) {
        if(null != strVal && '' != strVal) {
            return EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(strVal)));
        } else {
            return '';
        }
    }

    private String getNumberMasked(String numVal) {
        String maskVal ='';
        if(null != numVal && '' != numVal) {
            List<String> charList = numVal.split('');

            for(String zchar : charList) {
                maskVal += (zchar != null && zchar != '') ? NumberMap.get(zchar) : '';
            }
        }
        return maskVal;
    }
    
    private String getKanaMasked(String kanaVal) {
        String kanaMaskVal ='';
        if(null != kanaVal && '' != kanaVal) {
            List<String> charList = kanaVal.split('');
            for(String zchar : charList) {
             kanaMaskVal += (zchar != null && zchar != '') ? KanaMap.get(zchar) : '';
            }
        }
        return kanaMaskVal;
    }
    
    private String getEmailMasked(String email) {
        // Split the email address into two parts: before and after the "@" symbol
        if(null == email || '' == email) {
            return '';
        }
        List<String> parts = email.split('@');

        if (parts.size() == 2) {
            // Concatenate the SHA-256 hash of both parts
            String hashBeforeAt = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(parts[0])));
            String hashAfterAt = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(parts[1])));

            return hashBeforeAt.substring(0,32) + '@' + hashAfterAt.substring(0,32) + '.com';
        } else {
            // Handle the case where the email does not contain the "@" symbol
            return '';
        }
    }
}