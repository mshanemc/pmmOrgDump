public with sharing class org62LeadCreate {

    // public static final string endpoint = 'https://shane-request-bin.herokuapp.com/v5jg2rv5';
    public static final string endpoint = 'https://www.salesforce.com/leadcapture/ForwardingLeadCaptureServlet';

    public static final string requestPage = '/form.html';
    public static final string resultPage = '/conf.html';
    public static final string requestHost = 'www.salesforce.com';

    @InvocableMethod(label='Create Lead in Org62')
    public static void createLeadInOrg62(list<leadCreateRequest> LCRs){

        for (leadCreateRequest LCR:LCRs){
            calloutLater(bodyMaker(LCR));
        }
    }

    @future(callout=true)
    public static void calloutLater(string reqbody){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse resp = new HttpResponse();

        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody(reqbody);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');

        System.HttpResponse response = new System.Http().send(req);
        system.debug(response.getStatus());
        system.debug(response.getBody());
        system.debug(response.getStatusCode());
        System.debug(response.getHeaderKeys());
    }

    public static string bodyMaker(leadCreateRequest LCR){
        string requestBody = 'UserFirstName=' + EncodingUtil.urlEncode(LCR.UserFirstName, 'UTF-8');
        requestBody = requestBody + '&UserLastName=' + EncodingUtil.urlEncode(LCR.UserLastName, 'UTF-8');
        requestBody = requestBody + '&FormCampaignId=' + EncodingUtil.urlEncode(LCR.FormCampaignId, 'UTF-8');
        requestBody = requestBody + '&UserEmail=' + EncodingUtil.urlEncode(LCR.UserEmail, 'UTF-8');
        requestBody = requestBody + '&requestPage=' + EncodingUtil.urlEncode(requestPage, 'UTF-8');
        requestBody = requestBody + '&resultPage=' + EncodingUtil.urlEncode(resultPage, 'UTF-8');
        requestBody = requestBody + '&requestHost=' + EncodingUtil.urlEncode(requestHost, 'UTF-8');

        if (LCR.CompanyName != null){
            requestBody = requestBody + '&CompanyName=' + EncodingUtil.urlEncode(LCR.CompanyName, 'UTF-8');
        }

        if (LCR.UserTitle != null){
            requestBody = requestBody + '&UserTitle=' + EncodingUtil.urlEncode(LCR.UserTitle, 'UTF-8');
        }

        if (LCR.UserPhone != null){
            requestBody = requestBody + '&UserPhone=' + EncodingUtil.urlEncode(LCR.UserPhone, 'UTF-8');
        }



        if (LCR.CompanyState != null){
            requestBody = requestBody + '&CompanyState=' + EncodingUtil.urlEncode(LCR.CompanyState, 'UTF-8');
        }

        if (LCR.CompanyPostalCode != null){
            requestBody = requestBody + '&CompanyPostalCode=' + EncodingUtil.urlEncode(LCR.CompanyPostalCode, 'UTF-8');
        }


        if (LCR.CompanyPostalCode != null){
            requestBody = requestBody + '&CompanyPostalCode=' + EncodingUtil.urlEncode(LCR.CompanyPostalCode, 'UTF-8');
        }
        if (LCR.CompanyEmployees != null){
            requestBody = requestBody + '&CompanyEmployees=' + EncodingUtil.urlEncode(LCR.CompanyEmployees, 'UTF-8');
        }
        if (LCR.CompanyCountry != null){
            requestBody = requestBody + '&CompanyCountry=' + EncodingUtil.urlEncode(LCR.CompanyCountry, 'UTF-8');
        }
        if (LCR.mcloudFormName != null){
            requestBody = requestBody + '&mcloudFormName=' + EncodingUtil.urlEncode(LCR.mcloudFormName, 'UTF-8');
        }
        if (LCR.LeadSource != null){
            requestBody = requestBody + '&Lead.LeadSource=' + EncodingUtil.urlEncode(LCR.LeadSource, 'UTF-8');
        }
        if (LCR.DriverCampaignId != null){
            requestBody = requestBody + '&DriverCampaignId=' + EncodingUtil.urlEncode(LCR.DriverCampaignId, 'UTF-8');
        }

        system.debug(requestBody);
        return requestBody;
    }

    public class leadCreateRequest {
		@InvocableVariable(required=true label='first name')
		public string UserFirstName;

        @InvocableVariable(required=true label='campaign Id')
		public string FormCampaignId;

        @InvocableVariable(required=true label='last name')
		public string UserLastName;

        @InvocableVariable(required=true label='email')
		public string UserEmail;

		@InvocableVariable(required=false label='company')
		public string CompanyName;

        @InvocableVariable(required=false label='title')
		public string UserTitle;

        @InvocableVariable(required=false label='phone')
		public string UserPhone;

        @InvocableVariable(required=false label='company state')
		public string CompanyState;

        @InvocableVariable(required=false label='company postalCode')
		public string CompanyPostalCode;

        @InvocableVariable(required=false label='company employees')
		public string CompanyEmployees;

        @InvocableVariable(required=false label='company country')
		public string CompanyCountry;

        @InvocableVariable(required=false label='mcloud Form')
		public string mcloudFormName;

        @InvocableVariable(required=false label='lead source')
		public string LeadSource;

        @InvocableVariable(required=false label='driver campaign Id')
		public string DriverCampaignId;

	}


// const formPostBody = {
// 		// UserFirstName: incoming.UserFirstName,
// 		// UserLastName: incoming.UserLastName,
// 		// CompanyName: incoming.CompanyName,
// 		// UserTitle: incoming.UserTitle,
// 		// UserEmail: incoming.UserEmail,
// 		// UserPhone: incoming.UserPhone,
// 		// CompanyState: incoming.CompanyState,
// 		// CompanyPostalCode: incoming.CompanyPostalCode,
// 		// CompanyEmployees: incoming.CompanyEmployees,
// 		// CompanyCountry: incoming.CompanyCountry,
// 		// mcloudFormName: incoming.mcloudFormName,
// 		// 'Lead.LeadSource': incoming['Lead.LeadSource'],
// 		// FormCampaignId: incoming.FormCampaignId,
// 		DriverCampaignId: incoming.DriverCampaignId,
// 		requestPage,
// 		resultPage,
// 		requestHost
// 	};
//      (http://www.salesforce.com&requestpage=/form.html&resultPage=/conf.html&Lead.LeadSource=Qualified+leads&UserFirstName=Ned&UserLastName=Leonard&CompanyName=Enormoco&UserTitle=developer&UserEmail=nleonard%40salesforce.com&UserPhone=5555555555&CompanyState=CA&CompanyPostalCode=94111&CompanyEmployees=5&&CompanyCountry=US&mcloudFormName=GLOB_MAIN_T2L1_OCMS_LCS1&Lead.LeadSource=Organic+Search&FormCampaignId=7010M000000nQr6QAE&DriverCampaignId=70130000000sUVb)
}