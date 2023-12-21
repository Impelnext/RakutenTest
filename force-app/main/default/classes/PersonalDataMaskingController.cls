public with sharing class PersonalDataMaskingController {
    public List<String> customLabelNames { get; set; }
    public List<String> customLabelValues { get; set; }
    public List<String> selectedValues { get; set; }
    private Map<String, String> mapObjFields; 
    private Map<String, String> mapFieldMaskType; 
    private String strPerfectObjName;

    public class QueryResult {
        public List<CustomLabelss> records;
    }

    public PersonalDataMaskingController() {
        customLabelNames = new List<String>();
        customLabelValues = new List<String>();
        selectedValues = new List<String>();
    }
    public class CustomLabelss {
        public String Id;
        public String Name;
        public String Value;
        public String Category;
    }

    public String queryCustomLabel() {
        
        mapObjFields = new Map<String, String>();
        String categoryFilter = 'Masking Target';
        String queryString = 'SELECT Id, Name, Value, Category FROM CustomLabel WHERE Category = \'' + categoryFilter + '\'';

        // Use Tooling API to execute the query
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v54.0/tooling/query/?q=' + EncodingUtil.urlEncode(queryString, 'UTF-8'));
        request.setMethod('GET');
        
        // Set your OAuth token (replace 'YOUR_ACCESS_TOKEN' with the actual access token)
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());

        // Make the HTTP request
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Process the response
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON response into QueryResult
            QueryResult result = (QueryResult)JSON.deserialize(response.getBody(), QueryResult.class);

            // Process the records
            for (CustomLabelss label : result.records) {
                customLabelNames.add(label.Name);
                customLabelValues.add(label.Value);
                mapObjFields.put(label.Name, label.Value);
            }

            return 'Query executed successfully.';
        } else {
            return 'Error executing query. Status code: ' + response.getStatusCode() + ', Response: ' + response.getBody();
        }
    }
    public List<SelectOption> getSelectedValuesOptions() {
        queryCustomLabel();
        List<SelectOption> options = new List<SelectOption>();
        for (String value : customLabelNames) {
            options.add(new SelectOption(value, value));
        }
        return options;
    }

    public PageReference runSelectedMaskingBatch() {
        System.debug('*********** Selected Object Name = '+selectedValues );
        PageReference currentPage;
        try {
            //Invoke data masking batch class
            
            for (String strObjectName : selectedValues) {
                String strQ = constructQuery(strObjectName);
                if(null != strQ && '' != strQ) {
                    Database.executeBatch(new BatchMaskPersonalData(mapFieldMaskType, strQ, strPerfectObjName), 200);
                    mapFieldMaskType.clear();
                    mapFieldMaskType = null;
                    strPerfectObjName = '';
                    strQ = '';
                } else {
                    System.debug('**** Nothing to execute');
                }
            }

            // Get the current page reference
            currentPage = ApexPages.currentPage();

            // Set redirect to true for an immediate redirect, or false for a delayed redirect
            currentPage.setRedirect(false);
            String message = 'Batch executed successfully.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
        } catch (Exception err) {
            String strErr = err.getCause() + '::' + err.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErr));
        }
        // Return the current page reference
        return currentPage;
    }

    public String constructQuery(String strObjName) {
        
        mapFieldMaskType = new Map<String, String>();
        String strFields = mapObjFields.get(strObjName);
        // System.debug('**** strFields ' + strFields);
        if(null == strFields || '' == strFields) {
            System.debug('**** strFields is null' + strFields);
            return null;
        }
        List<String> fields = strFields.split(',');
        if(fields.size() ==0) {
            System.debug('**** fields.size()  is 0' + fields);
            return null;
        }
        // System.debug(fields);
        String strQueryTemplate = 'SELECT ID, % FROM &';
        String strFieldnames = '';
        for(String strTemp : fields) {
            if(strTemp.indexOf('@@') == -1)
                continue;

            List<String> ss = strTemp.split('@@');
            if(ss.size() < 2) {
                System.debug('**** ss.size() < 2 ' + ss);
                return null;
            }
            strFieldnames += ss.get(0) + ',';
            mapFieldMaskType.put(ss.get(0), ss.get(1));
        }
        strQueryTemplate = strQueryTemplate.replaceAll('%', strFieldnames);
        strPerfectObjName = fields.get(0);
        strQueryTemplate = strQueryTemplate.replace('&', strPerfectObjName);

        Integer lastCommaIndex = strQueryTemplate.lastIndexOf(',');
        // Replace the last comma with an empty string
        if (lastCommaIndex != -1) {
            strQueryTemplate = strQueryTemplate.substring(0, lastCommaIndex) + strQueryTemplate.substring(lastCommaIndex + 1);
        }
        // System.debug('**** QUERY **** ' + strQueryTemplate);
        // System.debug(' *** Map *** ' + mapFieldMaskType);
        return strQueryTemplate;
    }
}