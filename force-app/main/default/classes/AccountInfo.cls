/*
* @Class Name      : AccountInfo 
* @Description     : AccountInfo Wrapper
* @Created Date    : 2020.05.08
* @Created By      : Valsala Kumar J
* @Modified Date   : 
* @Modified        : 
*/
public class AccountInfo {
    // Account ID
    public Id accountid {get; set;}
    // SystemNameInfo
    // Do Not Add NULL as String to the Value
    // Do NULL Check for All Name String fields
    // that are added to the nameInfo key
    // SystemNameInfo
    public String nameInfo {get; set;}
    // last name
    public String lastname {get; set;}
    // first name
    public String firstname {get; set;}
    // last name kana
    public String lastnamekana {get; set;}
    // first name kana
    public String firstnamekana {get; set;}
    // Home Phone
    public String homephone {get; set;}
    // Mobile Phone
    public String mobilephone {get; set;}
    // Internal Phone
    public String internalphone {get; set;}
    // gender
    public String gender {get; set;}
    // birthdate
    public Date birthdate {get; set;}
    // EasyId
    public String easyId {get; set;}
    // Email Id
    public String email {get; set;}
    // PostalCode
    public String postalcode {get; set;}
    // State
    public String state {get; set;}
    // City
    public String city {get; set;}
    // Street
    public String street {get; set;}
    // Other String Params
    public Map<String, String> params {get; set;}
    // toUpdate flag - Update is required
    public Boolean toUpdate {get; set;}
    
    public AccountInfo() {
        toUpdate = false;
    }
}