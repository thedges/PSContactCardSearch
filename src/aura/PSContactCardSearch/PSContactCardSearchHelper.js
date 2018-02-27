({
    initTopicOptions: function(component) {
        console.log('helper initTopicOptions started...');
        var action = component.get("c.getTopicOptions");
        
        //Set up the callback
        var self = this;
        action.setCallback(this, function(a) {
            component.set("v.topicOptions", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    initStrengthOptions: function(component) {
        console.log('helper initStrengthOptions started...');
        var action = component.get("c.getStrengthOptions");
        
        //Set up the callback
        var self = this;
        action.setCallback(this, function(a) {
            component.set("v.strengthOptions", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    setRuntimeEnv: function(component) {
        console.log('href=' + location.href);

        var env = "unknown";
        var baseURL = "";
        var pathArray = location.href.split('/');

        if (location.href.includes('one.app')) {
            env = "lightning";
            baseURL = pathArray[0] + '//' + pathArray[2] + '/one/one.app?source=aloha#/sObject/';
        } else if (location.href.includes('/s/')) {
            env = "community";
            baseURL = pathArray[0] + '//' + pathArray[2] + '/' + pathArray[3] + '/s/';
        }

        var envRT = {
            'env': env,
            'baseURL': baseURL
        };
        console.log(JSON.stringify(envRT));

        component.set("v.runtimeEnv", envRT);
    },
    executeFilter: function(component) {
        console.log('helper executeFilter started...');
        var action = component.get("c.queryContacts");
        action.setParams({
            "name": component.get("v.name"),
            "topic": "" + component.get("v.selectedTopic"),
            "strength": "" + component.get("v.selectedStrength")
        });
        console.log(JSON.stringify(action.getParams()));
        //Set up the callback
        var self = this;
        action.setCallback(this, function(a) {
            console.log('query callback!');
            console.log(a.getReturnValue());
            component.set("v.recList", JSON.parse(a.getReturnValue()));
            
            var recs = component.get("v.recList");
            if (recs == null || recs.length <= 0) {
                // fire a toast message to popup on screen for Success
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Search returned zero results.",
                    "duration": 2000,
                    "type": "warning"
                });
                toastEvent.fire();
            } else {
                
            }
            
        });
        $A.enqueueAction(action);
    }
})