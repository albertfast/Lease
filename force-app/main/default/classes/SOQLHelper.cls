// Tüm alanları dinamik olarak bir nesne için alır
public class SOQLHelper {
    public static void getAllFields() {
        // Hangi nesnenin alanlarını almak istiyorsanız onun adını yazın (örneğin: Contact)
        String sobjectType = 'Contact'; 
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectType).getDescribe().fields.getMap();
        
        // Tüm alan isimlerini toplar
        List<String> fieldNames = new List<String>();
        for (String fieldName : fields.keySet()) {
            fieldNames.add(fieldName);
        }
        
        // Alan isimlerini virgülle ayırarak SOQL sorgusuna dahil eder
        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + sobjectType;
        System.debug(query);  // Oluşturulan SOQL sorgusunu gösterir

        // Sorguyu çalıştırır ve sonuçları döner
        List<SObject> results = Database.query(query);
        System.debug(results);
    }
}
