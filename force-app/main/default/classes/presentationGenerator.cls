global class presentationGenerator {

    // get the auth token for google apps
    @RemoteAction
    global static String getAccessToken() {
        list<AuthProvider> auths = [select id, AuthorizeUrl, DefaultScopes from AuthProvider where friendlyName = 'GDrive'];
        system.debug(auths);
        system.assertEquals(1, auths.size(), 'Problem finding the auth provider named GDrive');

        string APId = String.valueOf(auths[0].Id).left(15);
        system.debug(APId);

        string token = Auth.AuthToken.getAccessToken(APId, 'open id connect');
        system.debug(token);
        return token;

    }
}