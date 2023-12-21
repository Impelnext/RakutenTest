/*
 * 郵便番号ユーティリティ
 */
public class ZipUtil
{
    public ZipUtil(){}

    // 都道府県コード
    public static final String PREFECTURE = 'prefecture';
    // 市区町村
    public static final String MUNICIPALITY = 'municipality';
    // 町域
    public static final String CHOME = 'chome';

    /**
     * 郵便番号からAPIでエリア情報を検索し、必要情報をMap化して返却する
     * @param zipCode 郵便番号
     * @return areaInfoMap エリア情報
    **/
    public static Map<String, String> getAreaInfo(String zipCode) {
        Map<String, String> areaInfoMap = new Map<String, String>();
    
        // 郵便番号APIをCALL
        String jsonData = callZipApi(zipCode);
        
        // JOSN文字列を、参照しやすいようにクラスに設定
        AreaInfo areaInfo = parse(jsonData);
    
        if(areaInfo != null) {
            if(areaInfo.lists != null) {
                if(areaInfo.lists[0].detaillists != null) {
                    Detaillists detail = areaInfo.lists[0].detaillists[0];
                    areaInfoMap.put(PREFECTURE, detail.kanjitodo);
                    areaInfoMap.put(MUNICIPALITY, detail.kanjishikucho);
                    areaInfoMap.put(CHOME, detail.kanjichoiki);
                }
            }
        }
    
        return areaInfoMap;
    }
    
    /**
     * 郵便番号APIをCALLしてJSONデータを返却する
     * @param zipCode 郵便番号
     * @return result JSON文字列
    **/
    private static String callZipApi(String zipCode) {
        String result = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        String url = Label.INS_JAPANPOST_API_URL;
        url = url.replace('@appId', Label.INS_JAPANPOST_API_ID);
        url = url.replace('@zipCode', zipCode);	
    
        request.setEndpoint(url);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-type', 'application/json');
    
        HttpResponse response = http.send(request);
        Integer status = response.getStatusCode();
        if (status == 200){
            result = response.getBody();
        }
        
        return result;
    }
    
    /**
     * JSONデータをクラスインスタンス化して返却する
     * @param json JSON文字列
     * @return AreaInfo JSONデータ設定済みクラスインスタンス
    **/
    private static AreaInfo parse(String json) {
        return new AreaInfo(System.JSON.createParser(json));
    }
    /**
     * 郵便番号APIから返却されるJSONデータ保持用クラス
     * 項目が「lists」の場合は、下位リストクラスを生成して保持
    **/
    public class AreaInfo {
        public Integer allcount {get;set;} 
        public Integer allpagecount {get;set;} 
        public Integer count {get;set;} 
        public List<Lists> lists {get;set;} 
        public String message {get;set;} 
        public Integer pageno {get;set;} 
        public String seastr {get;set;} 
        public Integer status {get;set;} 
    
        public AreaInfo(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'allcount') {
                            allcount = parser.getIntegerValue();
                        } else if (text == 'allpagecount') {
                            allpagecount = parser.getIntegerValue();
                        } else if (text == 'count') {
                            count = parser.getIntegerValue();
                        } else if (text == 'lists') {
                            lists = new List<Lists>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                lists.add(new Lists(parser));
                            }
                        } else if (text == 'message') {
                            message = parser.getText();
                        } else if (text == 'pageno') {
                            pageno = parser.getIntegerValue();
                        } else if (text == 'seastr') {
                            seastr = parser.getText();
                        } else if (text == 'status') {
                            status = parser.getIntegerValue();
                        }
                    }
                }
            }
        }
    }
    /**
     * 郵便番号APIから返却されるJSONデータ保持用クラス
     * 項目が「detaillists」の場合は、下位リストクラスを生成して保持
    **/
    public class Lists {
        public String commonkana {get;set;} 
        public String commonkanji {get;set;} 
        public List<Detaillists> detaillists {get;set;} 
    
        public Lists(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'commonkana') {
                            commonkana = parser.getText();
                        } else if (text == 'commonkanji') {
                            commonkanji = parser.getText();
                        } else if (text == 'detaillists') {
                            detaillists = new List<Detaillists>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                detaillists.add(new Detaillists(parser));
                            }
                        }
                    }
                }
            }
        }
    }
    /**
     * 郵便番号APIから返却されるJSONデータ保持用クラス
    **/
    public class Detaillists {
        public Integer child {get;set;} 
        public String jiscode {get;set;} 
        public String kanachoiki {get;set;} 
        public String kanahosoku {get;set;} 
        public String kanajigyosho {get;set;} 
        public String kanashikucho {get;set;} 
        public String kanatodo {get;set;} 
        public String kanjichoiki {get;set;} 
        public String kanjihosoku {get;set;} 
        public String kanjijigyosho {get;set;} 
        public String kanjishikucho {get;set;} 
        public String kanjitodo {get;set;} 
        public Integer parent {get;set;} 
        public String postcode {get;set;} 
        public Integer type_Z {get;set;} // in json: type
    
        public Detaillists(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'child') {
                            child = parser.getIntegerValue();
                        } else if (text == 'jiscode') {
                            jiscode = parser.getText();
                        } else if (text == 'kanachoiki') {
                            kanachoiki = parser.getText();
                        } else if (text == 'kanahosoku') {
                            kanahosoku = parser.getText();
                        } else if (text == 'kanajigyosho') {
                            kanajigyosho = parser.getText();
                        } else if (text == 'kanashikucho') {
                            kanashikucho = parser.getText();
                        } else if (text == 'kanatodo') {
                            kanatodo = parser.getText();
                        } else if (text == 'kanjichoiki') {
                            kanjichoiki = parser.getText();
                        } else if (text == 'kanjihosoku') {
                            kanjihosoku = parser.getText();
                        } else if (text == 'kanjijigyosho') {
                            kanjijigyosho = parser.getText();
                        } else if (text == 'kanjishikucho') {
                            kanjishikucho = parser.getText();
                        } else if (text == 'kanjitodo') {
                            kanjitodo = parser.getText();
                        } else if (text == 'parent') {
                            parent = parser.getIntegerValue();
                        } else if (text == 'postcode') {
                            postcode = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getIntegerValue();
                        }
                    }
                }
            }
        }
    }
}