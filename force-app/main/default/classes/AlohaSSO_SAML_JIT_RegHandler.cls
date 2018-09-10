/**
 * This class provides logic for inbound just-in-time provisioning of single
 * sign-on users in your Salesforce organization.
 */
global class AlohaSSO_SAML_JIT_RegHandler implements Auth.SamlJitHandler {

    private class JitException extends Exception {}



    private Id getUserId(User u) {

        List<User> userIds = [
                SELECT Id
                FROM User
                WHERE FederationIdentifier = :u.FederationIdentifier
                LIMIT 1
        ];

        if (userIds.size() > 0) {
            return userIds.get(0).Id;
        }
        return null;
    }

    private SSOJIT_Setting__mdt getDefault(){
        list<SSOJIT_Setting__mdt> jits = [select Default_Profile_ID__c, Suffix__c from SSOJIT_Setting__mdt limit 1];
        if (jits.size()>1){
            throw new JitException('More than 1 default profile was found');
        } else if (jits.size()==0){
            throw new JitException('No default profile was found');
        } else {
            return jits[0];
        }
    }


    private void handleUser(
            Boolean create,
            User u,
            Map<String, String> attributes,
            String federationIdentifier,
            Boolean isStandard
    ) {

        if (create) {
            SSOJIT_Setting__mdt defaultJIT = getDefault();
            // default profile is defined in custom metadata
            u.ProfileId = defaultJIT.Default_Profile_ID__c;

            if (attributes.containsKey('User.FederationIdentifier')) {
                system.debug('fedId from User.FederationIdentifier: ' + User.FederationIdentifier);
                u.FederationIdentifier = attributes.get('User.FederationIdentifier');
                u.Username = attributes.get('User.FederationIdentifier').replace('@salesforce.com', '@' + defaultJIT.Suffix__c);
            } else {
                system.debug('fedId from federationIdentifier: ' + federationIdentifier);
                u.FederationIdentifier = federationIdentifier;
                u.Username = federationIdentifier.replace('@salesforce.com', '@' + defaultJIT.Suffix__c);
            }

            system.debug('intended username is ' + u.UserName);

        }


        if (attributes.containsKey('User.Phone')) {
            u.Phone = attributes.get('User.Phone');
        }
        if (attributes.containsKey('User.Email')) {
            u.Email = attributes.get('User.Email');
        }
        if (attributes.containsKey('User.FirstName')) {
            u.FirstName = attributes.get('User.FirstName');
        }
        if (attributes.containsKey('User.LastName')) {
            u.LastName = attributes.get('User.LastName');
        }
        if (attributes.containsKey('User.Title')) {
            u.Title = attributes.get('User.Title');
        }
        if (attributes.containsKey('User.CompanyName')) {
            u.CompanyName = attributes.get('User.CompanyName');
        }
        if (attributes.containsKey('User.AboutMe')) {
            u.AboutMe = attributes.get('User.AboutMe');
        }
        if (attributes.containsKey('User.Street')) {
            u.Street = attributes.get('User.Street');
        }
        if (attributes.containsKey('User.State')) {
            u.State = attributes.get('User.State');
        }
        if (attributes.containsKey('User.City')) {
            u.City = attributes.get('User.City');
        }
        if (attributes.containsKey('User.Zip')) {
            u.PostalCode = attributes.get('User.Zip');
        }
        if (attributes.containsKey('User.Country')) {
            u.Country = attributes.get('User.Country');
        }
        if (attributes.containsKey('User.CallCenter')) {
            u.CallCenterId = attributes.get('User.CallCenter');
        }
        if (attributes.containsKey('User.Manager')) {
            u.ManagerId = attributes.get('User.Manager');
        }
        if (attributes.containsKey('User.MobilePhone')) {
            u.MobilePhone = attributes.get('User.MobilePhone');
        }
        if (attributes.containsKey('User.DelegatedApproverId')) {
            u.DelegatedApproverId = attributes.get('User.DelegatedApproverId');
        }
        if (attributes.containsKey('User.Department')) {
            u.Department = attributes.get('User.Department');
        }
        if (attributes.containsKey('User.Division')) {
            u.Division = attributes.get('User.Division');
        }
        if (attributes.containsKey('User.EmployeeNumber')) {
            u.EmployeeNumber = attributes.get('User.EmployeeNumber');
        }
        if (attributes.containsKey('User.Extension')) {
            u.Extension = attributes.get('User.Extension');
        }
        if (attributes.containsKey('User.Fax')) {
            u.Fax = attributes.get('User.Fax');
        }
        if (attributes.containsKey('User.CommunityNickname')) {
            u.CommunityNickname = attributes.get('User.CommunityNickname');
        }
        if (attributes.containsKey('User.ReceivesAdminInfoEmails')) {
            String ReceivesAdminInfoEmailsVal = attributes.get('User.ReceivesAdminInfoEmails');
            u.ReceivesAdminInfoEmails = '1'.equals(ReceivesAdminInfoEmailsVal)
                                        || Boolean.valueOf(ReceivesAdminInfoEmailsVal);
        }
        if (attributes.containsKey('User.ReceivesInfoEmails')) {
            String ReceivesInfoEmailsVal = attributes.get('User.ReceivesInfoEmails');
            u.ReceivesInfoEmails = '1'.equals(ReceivesInfoEmailsVal)
                                    || Boolean.valueOf(ReceivesInfoEmailsVal);
        }


        String uid = UserInfo.getUserId();
        User currentUser = [
                SELECT
                        LocaleSidKey,
                        LanguageLocaleKey,
                        TimeZoneSidKey,
                        EmailEncodingKey,
                        ProfileId
                FROM User
                WHERE Id = :uid
        ];


        if (attributes.containsKey('User.LocaleSidKey')) {
            u.LocaleSidKey = attributes.get('User.LocaleSidKey');
        } else if (create) {
            u.LocaleSidKey = currentUser.LocaleSidKey;
        }

        if (attributes.containsKey('User.LanguageLocaleKey')) {
            u.LanguageLocaleKey = attributes.get('User.LanguageLocaleKey');
        } else if (create) {
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
        }


        if (attributes.containsKey('User.Alias')) {
            u.Alias = attributes.get('User.Alias');
        } else if (create) {

            String alias = '';

            if (u.FirstName == null) {
                alias = u.LastName;
            } else {
                alias = u.FirstName.charAt(0) + u.LastName;
            }

            if (alias.length() > 5) {
                alias = alias.substring(0, 5);
            }
            u.Alias = alias;
        }


        if (attributes.containsKey('User.TimeZoneSidKey')) {
            u.TimeZoneSidKey = attributes.get('User.TimeZoneSidKey');
        } else if (create) {
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
        }
        if (attributes.containsKey('User.EmailEncodingKey')) {
            u.EmailEncodingKey = attributes.get('User.EmailEncodingKey');
        } else if (create) {
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
        }


        /*
         * If you are updating Contact or Account object fields, you cannot update the following User fields at the same time.
         * If your identity provider sends these User fields as attributes along with Contact
         * or Account fields, you must modify the logic in this class to update either these
         * User fields or the Contact and Account fields.
         */
        if (attributes.containsKey('User.IsActive')) {
            String IsActiveVal = attributes.get('User.IsActive');
            u.IsActive = '1'.equals(IsActiveVal) || Boolean.valueOf(IsActiveVal);
        }

        if (attributes.containsKey('User.ForecastEnabled')) {
            String ForecastEnabledVal = attributes.get('User.ForecastEnabled');
            u.ForecastEnabled = '1'.equals(ForecastEnabledVal) || Boolean.valueOf(ForecastEnabledVal);
        }


        /* We don't want to set Profile except on 'create' and then only to a static value on this Org, so let's keep this stupid simple - JU */
        // if (create) {

        //     if (attributes.containsKey('User.ProfileId')) {

        //         String profileId = attributes.get('User.ProfileId');
        //         Profile p = [
        //                 SELECT Id
        //                 FROM Profile
        //                 WHERE Id = :profileId
        //                 LIMIT 1
        //         ];
        //         u.ProfileId = p.Id;
        //     }
        // } else {
        //    // u.ProfileId = currentUser.ProfileId;
        // }


        if (attributes.containsKey('User.UserRoleId')) {
            String userRoleId = attributes.get('User.UserRoleId');
            UserRole r = [
                    SELECT Id
                    FROM UserRole
                    WHERE Id = :userRoleId
            ];
            u.UserRoleId = r.Id;
        }


       if (create) {
           insert(u);
       } else {
           u.Id = getUserId(u);
           update(u);
       }

    }


    private void handleContact(
            Boolean create,
            String accountId,
            User u,
            Map<String, String> attributes
    ) {

        Contact c;
        Boolean newContact = FALSE;


        if (create) {

            if (attributes.containsKey('User.Contact')) {

                String contactId = attributes.get('User.Contact');
                c = [
                        SELECT Id, AccountId
                        FROM Contact
                        WHERE Id = :contactId
                ];
                u.ContactId = contactId;

            } else {
                c = new Contact();
                newContact = TRUE;
            }

        } else {

            if (attributes.containsKey('User.Contact')) {

                String contactId = attributes.get('User.Contact');
                c = [
                        SELECT Id, AccountId
                        FROM Contact
                        WHERE Id = :contactId
                ];

                if (u.ContactId != c.Id) {
                    throw new JitException('Cannot change User.ContactId');
                }

            } else {
                String contactId = u.ContactId;
                c = [
                        SELECT Id, AccountId
                        FROM Contact
                        WHERE Id = :contactId
                ];
            }

        }


        if (!newContact && c.AccountId != accountId) {
            throw new JitException('Mismatched account: ' + c.AccountId + ', ' + accountId);
        }

        if (attributes.containsKey('Contact.Email')) {
            c.Email = attributes.get('Contact.Email');
        }
        if (attributes.containsKey('Contact.FirstName')) {
            c.FirstName = attributes.get('Contact.FirstName');
        }
        if (attributes.containsKey('Contact.LastName')) {
            c.LastName = attributes.get('Contact.LastName');
        }
        if (attributes.containsKey('Contact.Phone')) {
            c.Phone = attributes.get('Contact.Phone');
        }
        if (attributes.containsKey('Contact.MailingStreet')) {
            c.MailingStreet = attributes.get('Contact.MailingStreet');
        }
        if (attributes.containsKey('Contact.MailingCity')) {
            c.MailingCity = attributes.get('Contact.MailingCity');
        }
        if (attributes.containsKey('Contact.MailingState')) {
            c.MailingState = attributes.get('Contact.MailingState');
        }
        if (attributes.containsKey('Contact.MailingCountry')) {
            c.MailingCountry = attributes.get('Contact.MailingCountry');
        }
        if (attributes.containsKey('Contact.MailingPostalCode')) {
            c.MailingPostalCode = attributes.get('Contact.MailingPostalCode');
        }
        if (attributes.containsKey('Contact.OtherStreet')) {
            c.OtherStreet = attributes.get('Contact.OtherStreet');
        }
        if (attributes.containsKey('Contact.OtherCity')) {
            c.OtherCity = attributes.get('Contact.OtherCity');
        }
        if (attributes.containsKey('Contact.OtherState')) {
            c.OtherState = attributes.get('Contact.OtherState');
        }
        if (attributes.containsKey('Contact.OtherCountry')) {
            c.OtherCountry = attributes.get('Contact.OtherCountry');
        }
        if (attributes.containsKey('Contact.OtherPostalCode')) {
            c.OtherPostalCode = attributes.get('Contact.OtherPostalCode');
        }
        if (attributes.containsKey('Contact.AssistantPhone')) {
            c.AssistantPhone = attributes.get('Contact.AssistantPhone');
        }
        if (attributes.containsKey('Contact.Department')) {
            c.Department = attributes.get('Contact.Department');
        }
        if (attributes.containsKey('Contact.Description')) {
            c.Description = attributes.get('Contact.Description');
        }
        if (attributes.containsKey('Contact.Fax')) {
            c.Fax = attributes.get('Contact.Fax');
        }
        if (attributes.containsKey('Contact.HomePhone')) {
            c.HomePhone = attributes.get('Contact.HomePhone');
        }
        if (attributes.containsKey('Contact.MobilePhone')) {
            c.MobilePhone = attributes.get('Contact.MobilePhone');
        }
        if (attributes.containsKey('Contact.OtherPhone')) {
            c.OtherPhone = attributes.get('Contact.OtherPhone');
        }
        if (attributes.containsKey('Contact.Title')) {
            c.Title = attributes.get('Contact.Title');
        }
        if (attributes.containsKey('Contact.Salutation')) {
            c.Salutation = attributes.get('Contact.Salutation');
        }
        if (attributes.containsKey('Contact.LeadSource')) {
            c.LeadSource = attributes.get('Contact.LeadSource');
        }
        if (attributes.containsKey('Contact.DoNotCall')) {
            String DoNotCallVal = attributes.get('Contact.DoNotCall');
            c.DoNotCall = '1'.equals(DoNotCallVal)
                            || Boolean.valueOf(DoNotCallVal);
        }
        if (attributes.containsKey('Contact.HasOptedOutOfEmail')) {
            String HasOptedOutOfEmailVal = attributes.get('Contact.HasOptedOutOfEmail');
            c.HasOptedOutOfEmail = '1'.equals(HasOptedOutOfEmailVal)
                                    || Boolean.valueOf(HasOptedOutOfEmailVal);
        }
        if (attributes.containsKey('Contact.HasOptedOutOfFax')) {
            String HasOptedOutOfFaxVal = attributes.get('Contact.HasOptedOutOfFax');
            c.HasOptedOutOfFax = '1'.equals(HasOptedOutOfFaxVal)
                                    || Boolean.valueOf(HasOptedOutOfFaxVal);
        }
        if (attributes.containsKey('Contact.Owner')) {
            c.OwnerId = attributes.get('Contact.Owner');
        }
        if (attributes.containsKey('Contact.AssistantName')) {
            c.AssistantName = attributes.get('Contact.AssistantName');
        }
        if (attributes.containsKey('Contact.Birthdate')) {
            c.Birthdate = Date.valueOf(attributes.get('Contact.Birthdate'));
        }

        if (newContact) {
            c.AccountId = accountId;
            insert(c);
            u.ContactId = c.Id;
        } else {
            update(c);
        }
    }


    private String handleAccount(
            Boolean create,
            User u,
            Map<String, String> attributes
    ) {

        Account a;
        Boolean newAccount = FALSE;


        if (create) {

            if (attributes.containsKey('User.Account')) {

                String accountId = attributes.get('User.Account');
                a = [
                        SELECT Id
                        FROM Account
                        WHERE Id = :accountId
                ];

            } else {

                if (attributes.containsKey('User.Contact')) {

                    String contactId = attributes.get('User.Contact');
                    Contact c = [
                            SELECT AccountId
                            FROM Contact
                            WHERE Id = :contactId
                    ];

                    String accountId = c.AccountId;
                    a = [
                            SELECT Id
                            FROM Account
                            WHERE Id = :accountId
                    ];

                } else {
                    a = new Account();
                    newAccount = TRUE;
                }
            }

        } else {

            if (attributes.containsKey('User.Account')) {
                String accountId = attributes.get('User.Account');
                a = [
                        SELECT Id
                        FROM Account
                        WHERE Id = :accountId
                ];

            } else {

                if (attributes.containsKey('User.Contact')) {

                    String contactId = attributes.get('User.Contact');
                    Contact c = [
                            SELECT Id, AccountId
                            FROM Contact
                            WHERE Id = :contactId
                    ];

                    if (u.ContactId != c.Id) {
                        throw new JitException('Cannot change User.ContactId');
                    }

                    String accountId = c.AccountId;
                    a = [
                            SELECT Id
                            FROM Account
                            WHERE Id = :accountId
                    ];

                } else {
                    throw new JitException('Could not find account');
                }

            }

        }


        if (attributes.containsKey('Account.Name')) {
            a.Name = attributes.get('Account.Name');
        }
        if (attributes.containsKey('Account.AccountNumber')) {
            a.AccountNumber = attributes.get('Account.AccountNumber');
        }
        if (attributes.containsKey('Account.Owner')) {
            a.OwnerId = attributes.get('Account.Owner');
        }
        if (attributes.containsKey('Account.BillingStreet')) {
            a.BillingStreet = attributes.get('Account.BillingStreet');
        }
        if (attributes.containsKey('Account.BillingCity')) {
            a.BillingCity = attributes.get('Account.BillingCity');
        }
        if (attributes.containsKey('Account.BillingState')) {
            a.BillingState = attributes.get('Account.BillingState');
        }
        if (attributes.containsKey('Account.BillingCountry')) {
            a.BillingCountry = attributes.get('Account.BillingCountry');
        }
        if (attributes.containsKey('Account.BillingPostalCode')) {
            a.BillingPostalCode = attributes.get('Account.BillingPostalCode');
        }
        if (attributes.containsKey('Account.AnnualRevenue')) {
            a.AnnualRevenue = Integer.valueOf(attributes.get('Account.AnnualRevenue'));
        }
        if (attributes.containsKey('Account.Description')) {
            a.Description = attributes.get('Account.Description');
        }
        if (attributes.containsKey('Account.Fax')) {
            a.Fax = attributes.get('Account.Fax');
        }
        if (attributes.containsKey('Account.NumberOfEmployees')) {
            a.NumberOfEmployees = Integer.valueOf(attributes.get('Account.NumberOfEmployees'));
        }
        if (attributes.containsKey('Account.Phone')) {
            a.Phone = attributes.get('Account.Phone');
        }
        if (attributes.containsKey('Account.ShippingStreet')) {
            a.ShippingStreet = attributes.get('Account.ShippingStreet');
        }
        if (attributes.containsKey('Account.ShippingCity')) {
            a.ShippingCity = attributes.get('Account.ShippingCity');
        }
        if (attributes.containsKey('Account.ShippingState')) {
            a.ShippingState = attributes.get('Account.ShippingState');
        }
        if (attributes.containsKey('Account.ShippingCountry')) {
            a.ShippingCountry = attributes.get('Account.ShippingCountry');
        }
        if (attributes.containsKey('Account.ShippingPostalCode')) {
            a.ShippingPostalCode = attributes.get('Account.ShippingPostalCode');
        }
        if (attributes.containsKey('Account.Sic')) {
            a.Sic = attributes.get('Account.Sic');
        }
        if (attributes.containsKey('Account.TickerSymbol')) {
            a.TickerSymbol = attributes.get('Account.TickerSymbol');
        }
        if (attributes.containsKey('Account.Website')) {
            a.Website = attributes.get('Account.Website');
        }
        if (attributes.containsKey('Account.Industry')) {
            a.Industry = attributes.get('Account.Industry');
        }
        if (attributes.containsKey('Account.Ownership')) {
            a.Ownership = attributes.get('Account.Ownership');
        }
        if (attributes.containsKey('Account.Rating')) {
            a.Rating = attributes.get('Account.Rating');
        }

        if (newAccount) {
            insert(a);
        } else {
            update(a);
        }

        return a.Id;
    }


    private void handleJit(
            Boolean create,
            User u,
            Id samlSsoProviderId,
            Id communityId,
            Id portalId,
            String federationIdentifier,
            Map<String, String> attributes,
            String assertion
    ) {

        if (communityId != null
                || portalId != null) {

            String account = handleAccount(create, u, attributes);
            handleContact(
                    create,
                    account,
                    u,
                    attributes
            );

            handleUser(
                    create,
                    u,
                    attributes,
                    federationIdentifier,
                    FALSE
            );

        } else {
            handleUser(
                    create,
                    u,
                    attributes,
                    federationIdentifier,
                    TRUE
            );
        }
    }


    global User createUser(
            Id samlSsoProviderId,
            Id communityId,
            Id portalId,
            String federationIdentifier,
            Map<String, String> attributes,
            String assertion
    ) {

        User u = new User();
        handleJit(
                TRUE,
                u,
                samlSsoProviderId,
                communityId,
                portalId,
                federationIdentifier,
                attributes,
                assertion
        );
        return u;
    }


    global void updateUser(
            Id userId,
            Id samlSsoProviderId,
            Id communityId,
            Id portalId,
            String federationIdentifier,
            Map<String, String> attributes,
            String assertion
    ) {

        User u = [
                SELECT Id, FederationIdentifier
                FROM User
                WHERE FederationIdentifier = :attributes.get('User.FederationIdentifier')
        ];

        handleJit(
                FALSE,
                u,
                samlSsoProviderId,
                communityId,
                portalId,
                federationIdentifier,
                attributes,
                assertion
        );

    }
}