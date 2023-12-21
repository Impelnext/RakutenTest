public class StringUtil {
    /*
     * 先頭と末尾のスペースを抜きます（全角含む）
     */
    public static String trim(String v){
        if(v == null){
            return '';
        }
        return v.replaceAll('^[ |　]+', '').replaceAll('[ |　]+$', '');
    }
}