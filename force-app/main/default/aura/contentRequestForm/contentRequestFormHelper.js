({
    recordInit : function(component) {
        component.find('frd').getNewRecord(
            'ContentRequest__c',
            null,
            false,
            $A.getCallback( () => {
                console.log('getNewRecord is back');
                component.set('v.targetFields.Source__c', component.get('v.source'));
                console.log(component.get('v.targetFields'));
            })
        );
    }
})