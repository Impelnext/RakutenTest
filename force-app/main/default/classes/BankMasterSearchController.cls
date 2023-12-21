public with sharing class BankMasterSearchController {
   
    @AuraEnabled
    public static BankMasterWrapper searchBankMaster(String arg1, String arg2, String source){

        BankMasterWrapper wrapper = new BankMasterWrapper();
        String query = 'SELECT Id, BankCode__c, BankName__c, BranchCode__c, BranchName__c, BankName_Kana__c, BranchName_Kana__c FROM BankMaster__c WHERE ';
        String bankCode = '';
        String branchCode = '';
        String bankNameKana = '';
        String branchNameKana = '';

        if(source.equals('code')){

            //arg1は金融機関コード（bankCode) を指します。
            bankCode = arg1;
            //arg2は支店コード（branchCode) を指します。
            branchCode = arg2;

            if(!String.isEmpty(bankCode) && !String.isEmpty(branchCode)){
                bankCode = '%'+bankCode+'%';
                branchCode = '%'+branchCode+'%';
                query += 'BankCode__c like: bankCode AND BranchCode__c like: branchCode';
            }else if(String.isEmpty(branchCode)){
                bankCode = '%'+bankCode+'%';
                query += 'BankCode__c like: bankCode';
            }else{
                branchCode = '%'+branchCode+'%';
                query += 'BranchCode__c like: branchCode';
            }
        }else{
            //arg1は金融機関名（bankNameKana) を指します。
            bankNameKana = arg1;
            //arg2は支店コード（branchNameKana) を指します。
            branchNameKana = arg2;

            if(!String.isEmpty(bankNameKana)){
                bankNameKana = convertZenkakuToHankakuKana(bankNameKana);
                bankNameKana = replaceSuteganaToKatakana(bankNameKana);
            }

            System.debug('bankNameKana ' + bankNameKana);

            if(!String.isEmpty(branchNameKana)){
                branchNameKana = convertZenkakuToHankakuKana(branchNameKana);
                branchNameKana = replaceSuteganaToKatakana(branchNameKana);
            }

            System.debug('branchNameKana ' + branchNameKana);

            if(!String.isEmpty(bankNameKana) && !String.isEmpty(branchNameKana)){
                bankNameKana = '%'+bankNameKana+'%';
                branchNameKana = '%'+branchNameKana+'%';
                query += 'BankName_Kana__c like: bankNameKana AND BranchName_Kana__c like: branchNameKana';
            }else if(String.isEmpty(branchNameKana)){
                bankNameKana = '%'+bankNameKana+'%';
                query += 'BankName_Kana__c like: bankNameKana';
            }else{
                branchNameKana = '%'+branchNameKana+'%';
                query += 'BranchName_Kana__c like: branchNameKana';
            }
        }
        query += ' ORDER BY BankName__c ASC';

        System.debug('query ' + query);
        List<BankMaster__c> dbBankMasterList = Database.query(query);

        for(BankMaster__c dbMaster : dbBankMasterList){

            BankMasterTbl bankMasterTbl  = new BankMasterTbl();
            bankMasterTbl.Id = dbMaster.Id;
            bankMasterTbl.bankCode = dbMaster.BankCode__c;
            bankMasterTbl.bankName = dbMaster.BankName__c;
            bankMasterTbl.bankNameKana = dbMaster.BankName_Kana__c;
            bankMasterTbl.branchCode = dbMaster.BranchCode__c;
            bankMasterTbl.branchName = dbMaster.BranchName__c;
            bankMasterTbl.branchNameKana = dbMaster.BranchName_Kana__c;

            wrapper.bankMasterSearchResultList.add(bankMasterTbl);
        }
        wrapper.errorDisplayFlag = dbBankMasterList.size() > 100 ? 1 : dbBankMasterList.size() == 0 ? 2 : 3;

        System.debug('dbBankMasterList ' + dbBankMasterList.size());
        System.debug('wrapper.errorDisplayFlag ' + wrapper.errorDisplayFlag);

        return wrapper;
    }

    private static String convertZenkakuToHankakuKana(String name){

        Map<String,String> conversionTextMap = new Map<String,String>{
            'ア' => 'ｱ','イ' => 'ｲ','ウ' => 'ｳ','エ' => 'ｴ','オ' =>'ｵ',
            'カ' => 'ｶ','キ' => 'ｷ','ク' => 'ｸ','ケ' => 'ｹ','コ' =>'ｺ',
            'サ' => 'ｻ','シ' => 'ｼ','ス' => 'ｽ','セ' => 'ｾ','ソ' => 'ｿ',
            'タ' => 'ﾀ','チ' => 'ﾁ','ツ' => 'ﾂ','テ' => 'ﾃ','ト' => 'ﾄ',
            'ナ' => 'ﾅ','ニ' => 'ﾆ','ヌ' => 'ﾇ','ネ' => 'ﾈ','ノ' => 'ﾉ',
            'ハ' => 'ﾊ','ヒ' => 'ﾋ','フ' => 'ﾌ','ヘ' => 'ﾍ','ホ' => 'ﾎ',
            'マ' => 'ﾏ','ミ' => 'ﾐ','ム' => 'ﾑ','メ' => 'ﾒ','モ' => 'ﾓ',
            'ヤ' => 'ﾔ','ユ' => 'ﾕ','ヨ' => 'ﾖ', 
            'ラ' => 'ﾗ','リ' => 'ﾘ','ル' => 'ﾙ','レ' => 'ﾚ','ロ' => 'ﾛ', 
            'ワ' => 'ﾜ','ン' => 'ﾝ',
            
            'ガ' => 'ｶﾞ','ギ' => 'ｷﾞ','グ' => 'ｸﾞ','ゲ' => 'ｹﾞ','ゴ' => 'ｺﾞ',
            'ザ' => 'ｻﾞ','ジ' => 'ｼﾞ','ズ' => 'ｽﾞ','ゼ' => 'ｾﾞ','ゾ' => 'ｿﾞ',
            'ダ' => 'ﾀﾞ','ヂ' => 'ﾁﾞ','ヅ' => 'ﾂﾞ','デ' => 'ﾃﾞ','ド' => 'ﾄﾞ',
            'バ' => 'ﾊﾞ','ビ' => 'ﾋﾞ','ブ' => 'ﾌﾞ','ベ' => 'ﾍﾞ','ボ' => 'ﾎﾞ',
            'パ' => 'ﾊﾟ','ピ' => 'ﾋﾟ','プ' => 'ﾌﾟ','ペ' => 'ﾍﾟ','ポ' => 'ﾎﾟ',
            'ヴ' => 'ｳﾞ',

            'ァ' => 'ｧ','ィ' => 'ｨ','ゥ' => 'ｩ','ェ' => 'ｪ','ォ' => 'ｫ' ,
            'ャ' => 'ｬ','ュ' => 'ｭ','ョ' => 'ｮ',
            'ッ' => 'ｯ','ー' => 'ｰ'
        };

        for(Integer i = 0;i<name.length(); i++){
            String charValue = name.substring(i, i+1);
            if(conversionTextMap.containsKey(charValue)){
                name = name.replace(charValue, conversionTextMap.get(charValue));
            }
        }
        return name;
    }

    private static String replaceSuteganaToKatakana(String name){

        Map<String,String> conversionTextMap = new Map<String,String>();
        conversionTextMap.put('ｯ','ﾂ');
        conversionTextMap.put('ｬ','ﾔ');
        conversionTextMap.put('ｭ','ﾕ');
        conversionTextMap.put('ｮ','ﾖ');
        conversionTextMap.put('ｧ','ｱ');
        conversionTextMap.put('ｧ','ｱ');
        conversionTextMap.put('ｨ','ｲ');
        conversionTextMap.put('ｩ','ｳ');
        conversionTextMap.put('ｪ','ｴ');
        conversionTextMap.put('ｫ','ｵ');

        for(Integer i = 0;i<name.length();i++){
            String character = name.substring(i,i+1);
            if(conversionTextMap.containsKey(character)){
                name = name.replace(character, conversionTextMap.get(character));
            }
        }
        return name;
    }

    public class BankMasterWrapper{

        //1:検索結果が100件過ぎた場合
        //2:条件に一致するレコードがありません。
        //3:成功
        @AuraEnabled
        public Integer errorDisplayFlag{get;set;}

        //金融機関の検索結果リスト
        @AuraEnabled
        public List<BankMasterTbl> bankMasterSearchResultList = new List<BankMasterTbl>();
    }

    public class BankMasterTbl {

        @AuraEnabled
        public String Id{get;set;}

        //金融機関コード
        @AuraEnabled
        public String bankCode{get;set;}

        //金融機関名
        @AuraEnabled
        public String bankName{get;set;}

        //金融機関名（カナ）
        @AuraEnabled
        public String bankNameKana{get;set;}

        //支店コード
        @AuraEnabled
        public String branchCode{get;set;}

        //支店名
        @AuraEnabled
        public String branchName{get;set;}

        //支店名（カナ）
        @AuraEnabled
        public String branchNameKana{get;set;}
    }   
}