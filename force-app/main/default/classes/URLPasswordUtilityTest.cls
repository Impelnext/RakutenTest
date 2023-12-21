@isTest
public class URLPasswordUtilityTest {

    @isTest
    static void testGeneratePassword() {
        URLPasswordUtility.generatePassword(13);
    }
    
    @isTest
    static void testGenerateHash() {
        URLPasswordUtility.generateHash('aaaaaa');

    }
}