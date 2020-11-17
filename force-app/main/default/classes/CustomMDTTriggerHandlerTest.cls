@isTest
public class CustomMDTTriggerHandlerTest {
    
    private static String lastMethodCalled;

    private static CustomMDTTriggerHandler handler;

    private static String CMDT_QUERY = 'SELECT Execution_Order__c, Class_Name__c '
                                        + 'FROM TriggerExecutionHandler__mdt '
                                        + 'WHERE sObjectType__c = \'TestObject__c\' '
                                        + 'ORDER BY Execution_Order__c';

    static {
        handler = new CustomMDTTriggerHandler();
        handler.firedOnsObjectType = 'TestObject__c';        
        // override its internal trigger detection
        handler.isTriggerExecuting = true;
        
        TriggerExecutionHandler__mdt cmdt = new TriggerExecutionHandler__mdt();
        cmdt.Class_Name__c = 'CustomMDTTriggerHandlerTest.TestHandler';
        cmdt.Execution_Order__c = 0;
        cmdt.sObjectType__c = 'TestObject__c';

        handler.customMetadataResultsMap.put(CMDT_QUERY, new List<TriggerExecutionHandler__mdt>{ cmdt });
    }

    /***************************************
    * unit tests
    ***************************************/

    // contexts tests

    @isTest
    static void testBeforeInsert() {
        beforeInsertMode();
        handler.run();
        System.assertEquals(
            'beforeInsert',
            lastMethodCalled,
            'last method should be beforeInsert'
        );
    }

    @isTest
    static void testBeforeUpdate() {
        beforeUpdateMode();
        handler.run();
        System.assertEquals(
            'beforeUpdate',
            lastMethodCalled,
            'last method should be beforeUpdate'
        );
    }

    @isTest
    static void testBeforeDelete() {
        beforeDeleteMode();
        handler.run();
        System.assertEquals(
            'beforeDelete',
            lastMethodCalled,
            'last method should be beforeDelete'
        );
    }

    @isTest
    static void testAfterInsert() {
        afterInsertMode();
        handler.run();
        System.assertEquals(
            'afterInsert',
            lastMethodCalled,
            'last method should be afterInsert'
        );
    }

    @isTest
    static void testAfterUpdate() {
        afterUpdateMode();
        handler.run();
        System.assertEquals(
            'afterUpdate',
            lastMethodCalled,
            'last method should be afterUpdate'
        );
    }

    @isTest
    static void testAfterDelete() {
        afterDeleteMode();
        handler.run();
        System.assertEquals(
            'afterDelete',
            lastMethodCalled,
            'last method should be afterDelete'
        );
    }

    @isTest
    static void testAfterUndelete() {
        afterUndeleteMode();
        handler.run();
        System.assertEquals(
            'afterUndelete',
            lastMethodCalled,
            'last method should be afterUndelete'
        );
    }

    @isTest
    static void testInvalidHandlerClass() {
        // Replace the custom metadata record with one that has an invalid class name.
        // This should generate a null pointer exception in the CustomMDTTriggerHandler
        TriggerExecutionHandler__mdt cmdt = new TriggerExecutionHandler__mdt();
        cmdt.Class_Name__c = 'Invalid';
        cmdt.Execution_Order__c = 0;
        cmdt.sObjectType__c = 'TestObject__c';

        handler.customMetadataResultsMap.put(CMDT_QUERY, new List<TriggerExecutionHandler__mdt>{ cmdt });

        beforeInsertMode();
        handler.run();
        System.assertEquals(
            null, 
            lastMethodCalled, 
            'last method should not have been set');
    }

    private static void beforeInsertMode() {
        handler.setTriggerContext('before insert', true);
    }

    private static void beforeUpdateMode() {
        handler.setTriggerContext('before update', true);
    }

    private static void beforeDeleteMode() {
        handler.setTriggerContext('before delete', true);
    }

    private static void afterInsertMode() {
        handler.setTriggerContext('after insert', true);
    }

    private static void afterUpdateMode() {
        handler.setTriggerContext('after update', true);
    }

    private static void afterDeleteMode() {
        handler.setTriggerContext('after delete', true);
    }

    private static void afterUndeleteMode() {
        handler.setTriggerContext('after undelete', true);
    }

    public class TestHandler extends TriggerHandler {
        public override void beforeInsert() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'beforeInsert';
        }
    
        public override void beforeUpdate() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
        }
    
        public override void beforeDelete() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'beforeDelete';
        }
    
        public override void afterInsert() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'afterInsert';
        }
    
        public override void afterUpdate() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'afterUpdate';
        }
    
        public override void afterDelete() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'afterDelete';
        }
    
        public override void afterUndelete() {
            CustomMDTTriggerHandlerTest.lastMethodCalled = 'afterUndelete';
        }
      }
}
