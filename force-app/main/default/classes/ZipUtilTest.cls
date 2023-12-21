@isTest
public class ZipUtilTest
{
    @isTest
    static void ZipUtilTest_getAreaInfo()
    {
        //WebServiceを疑似コールアウト
        Test.setMock(HttpCalloutMock.class, new ZipUtilTest_HttpCalloutMock());
        Test.startTest();
        Map<String, String> area = ZipUtil.getAreaInfo('1630216');
        System.assertEquals('東京都', area.get(ZipUtil.PREFECTURE));
        System.assertEquals('北区', area.get(ZipUtil.MUNICIPALITY));
        System.assertEquals('豊島', area.get(ZipUtil.CHOME));
        Test.stopTest();
    }
}