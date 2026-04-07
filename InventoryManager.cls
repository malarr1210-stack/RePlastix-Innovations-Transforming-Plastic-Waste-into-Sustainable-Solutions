public class InventoryManager {

    public static void handleLowStock(List<Product__c> products){

        List<Task> taskList = new List<Task>();
        List<Order__c> ordersToUpdate = new List<Order__c>();

        for(Product__c prod : products){

            // 1️⃣ Create Task
            Task t = new Task();
            t.Subject = 'Low Stock Alert for ' + prod.Name;
            t.WhatId = prod.Id;
            t.OwnerId = prod.OwnerId;
            t.Status = 'Not Started';
            t.Priority = 'High';
            taskList.add(t);

            // 2️⃣ Update Order Status
            for(Order__c ord : [
                SELECT Id, Status__c FROM Order__c WHERE Product__c = :prod.Id
            ]){
                ord.Status__c = 'Stock Low';
                ordersToUpdate.add(ord);
            }

            // 3️⃣ Send Email Notification
            sendEmailNotification(prod);
        }

        if(!taskList.isEmpty()){
            insert taskList;
        }

        if(!ordersToUpdate.isEmpty()){
            update ordersToUpdate;
        }
    }

    // 📧 Email Method
    public static void sendEmailNotification(Product__c prod){

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new String[] {'warehouse@replastix.com'});
        mail.setSubject('Stock Replenishment Required');

        mail.setPlainTextBody(
            'Product: ' + prod.Name + '\n' +
            'Stock is below threshold.\n' +
            'Current Stock: ' + prod.Stock__c
        );

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
