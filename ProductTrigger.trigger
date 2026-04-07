trigger ProductTrigger on Product__c (after update) {

    List<Product__c> lowStockProducts = new List<Product__c>();

    for(Product__c prod : Trigger.new){
        Product__c oldProd = Trigger.oldMap.get(prod.Id);

        if(prod.Stock__c < prod.Threshold__c &&
           oldProd.Stock__c >= oldProd.Threshold__c){
            lowStockProducts.add(prod);
        }
    }

    if(!lowStockProducts.isEmpty()){
        InventoryManager.handleLowStock(lowStockProducts);
    }
}
