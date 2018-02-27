({
    onContactClick : function(component, event, helper) {
        console.log('onContactClick...');
        var contactId = component.get("v.contactId");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/profile/" + contactId
        });
        urlEvent.fire();
    }
})