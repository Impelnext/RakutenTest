@isTest
global class ZipUtilTest_HttpCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        
        // JSONデータとしてBodyにセット
        String jsonStr = '';
        jsonStr += '{';
        jsonStr += '    "allcount": 1, ';
        jsonStr += '    "allpagecount": 1, ';
        jsonStr += '    "count": 1, ';
        jsonStr += '    "lists": [';
        jsonStr += '        {';
        jsonStr += '            "commonkana": "トウキョウト キタク", ';
        jsonStr += '            "commonkanji": "東京都 北区", ';
        jsonStr += '            "detaillists": [';
        jsonStr += '                {';
        jsonStr += '                    "child": 0, ';
        jsonStr += '                    "jiscode": "13117", ';
        jsonStr += '                    "kanachoiki": "トシマ", ';
        jsonStr += '                    "kanahosoku": "", ';
        jsonStr += '                    "kanajigyosho": "", ';
        jsonStr += '                    "kanashikucho": "キタク", ';
        jsonStr += '                    "kanatodo": "トウキョウト", ';
        jsonStr += '                    "kanjichoiki": "豊島", ';
        jsonStr += '                    "kanjihosoku": "", ';
        jsonStr += '                    "kanjijigyosho": "", ';
        jsonStr += '                    "kanjishikucho": "北区", ';
        jsonStr += '                    "kanjitodo": "東京都", ';
        jsonStr += '                    "parent": 718, ';
        jsonStr += '                    "postcode": "114-0003", ';
        jsonStr += '                    "type": 0';
        jsonStr += '                }';
        jsonStr += '            ]';
        jsonStr += '        }';
        jsonStr += '    ], ';
        jsonStr += '    "message": "", ';
        jsonStr += '    "pageno": 1, ';
        jsonStr += '    "seastr": "1140003", ';
        jsonStr += '    "status": 200';
        jsonStr += '}';
                
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonStr);
        res.setStatusCode(200);
        return res;
    }
}