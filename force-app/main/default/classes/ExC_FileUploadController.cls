public class ExC_FileUploadController {

    public String key {get; set;}
    public String pass {get; set;}
    public String siteProcessId {get; set;}
    public String fileName {get; set;}
    public transient String fileBody {get; set;}
    public String  message  { get; set; }
    
    class LoginInfo {
        Boolean IsSuccess;
        String Message;
        String LoginKey;
        String LoginPassword;
        String GuidanceCustomerName;
        String GuidanceMessage;
    }

    class UpdateInfo {
        Boolean IsSuccess;
        String Message;
    }

    @AuraEnabled
    public static String checkURLPassword(String key, String pass){
        ExC_LimitedAccessUtility.LoginInfo login = ExC_LimitedAccessUtility.checkURLPassword(key, pass);
        return JSON.serialize(login);
    }

    @AuraEnabled    
    public static String updateURLWithLimited(String key, String pass, String jsonData){
        ExC_LimitedAccessUtility.UpdateInfo upd = ExC_LimitedAccessUtility.updateURLWithLimited(key, pass, jsonData);
        return JSON.serialize(upd);
    }

    @AuraEnabled
    public static String issueSiteProcessId(String key, String pass){
        return URLPasswordUtility.generatePassword(13);
    }
    

    public pagereference uploadFile(){
        try{
            if(this.fileBody!=null)this.message ='filesize: '+this.fileBody.length();
            this.fileBody = EncodingUtil.urlDecode(this.fileBody, 'UTF-8');
            String recordId = ExC_LimitedAccessUtility.checkURLPasswordForUpFile(this.key, this.pass);
            createContents(recordId, this.fileBody ,this.fileName , this.siteProcessId);
        }catch(Exception e){
            this.message = e.getMessage();
        }

        return null;
    }
    

    public static void createContents(string parentid, string fileData, string fileName, string processid){
        
        // コンテンツバージョンを保存する
        ContentVersion conVer = new ContentVersion();
        conVer.Title = fileName;// タイトル
        conVer.PathOnClient = fileName;// クライアントでのパス
        conVer.VersionData = EncodingUtil.Base64Decode(fileData);// バージョンデータ
        conVer.IsMajorVersion = false;// メジャーバージョン
        conVer.SiteProcessId__c = parentid;
        insert conVer;

        return ;
    }

}