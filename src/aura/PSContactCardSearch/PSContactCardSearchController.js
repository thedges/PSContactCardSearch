({
	doInit: function(component, event, helper) {
        console.log("doInit called");
      
        helper.initTopicOptions(component);
        helper.initStrengthOptions(component);
        //helper.setRuntimeEnv(component);
    },
    fireFilter : function(component, event, helper) {
        console.log('fireFilter started...');
        helper.executeFilter(component);
    },
    reset: function(component, event, helper) {
        console.log('reset started...');
        component.set('v.name', '');
        component.set('v.selectedTopic', '');
        component.set('v.selectedStrength', '');
    }
})