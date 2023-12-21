public with sharing class URLPasswordUtility {

    static String charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_';

    // パスワード生成
    public static String generatePassword(Integer len) {

        Double rnd;
        Integer idx;
        String password = '';

        for (Integer i = 0; i < len; i++) {
            rnd = charList.length() * Math.random();
            idx = rnd.intValue();
            password += charList.substring(idx, idx + 1);
        }

        return password;
    }

    // ハッシュ値生成
    public static String generateHash(String password) {

        String input = Datetime.now().format('HH:mm:ss') + password;
        String hashValue = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(input)));
        
        return hashValue;

    }
}