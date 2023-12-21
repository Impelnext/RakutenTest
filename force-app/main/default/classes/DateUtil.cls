public class DateUtil {
    /**
     * 
     * 日付文字空日付を取得する
     * フォーマット：20190101（数字8桁）
     */
    public static Date getDate1(String dateStr){
        try{
            return Date.parse(dateStr.substring(0, 4) +
                              '/' + dateStr.substring(4, 6) + 
                              '/' + dateStr.substring(6, 8));
        }catch(Exception ex){
            return null;
        }
    }
}