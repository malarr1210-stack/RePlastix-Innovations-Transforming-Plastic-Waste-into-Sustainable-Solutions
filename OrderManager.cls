public class OrderManager {

    public static void updateOrderStatus(List<Product__c> products){

        List<Order__c> ordersToUpdate = new List<Order__c>();

        for(Product__c prod : products){

            List<Order__c> relatedOrders = [
                SELECT Id, Status__c 
                FROM Order__c 
                WHERE Product__c = :prod.Id
            ];

            for(Order__c ord : relatedOrders){
                ord.Status__c = 'Stock Low';
                ordersToUpdate.add(ord);
            }
        }

        if(!ordersToUpdate.isEmpty()){
            update ordersToUpdate;
        }
    }
}
