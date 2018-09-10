@RestResource(urlMapping='/feedback/*')
global with sharing class feedbackService {

	@HttpPost
	global static string createFeedback(string orgId, string userId, string rating, string comments, string email, string firstname, string lastname){
		Trial_Feedback__c tf = new Trial_Feedback__c();
		tf.Comments__c = comments;
		tf.Name__c = firstname + ' ' + lastname;
		tf.Email__c = email;
		tf.OrgID__c = orgId;
		tf.UserId__c = userId;
		tf.Rating__c = rating;
		system.debug(tf);
		try{
			insert tf;
			return 'Accepted';
		} catch (exception e){
			return e.getMessage();
		}
	}
}